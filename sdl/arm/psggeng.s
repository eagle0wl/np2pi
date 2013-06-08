@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

.equ PSGFREQPADBIT	, 		12
.equ PSGADDEDBIT		, 		3
.equ PSGADDEDCNT		, 		(1 << PSGADDEDBIT)

.equ PSGENV_INC		, 		15
.equ PSGENV_ONESHOT	, 		16
.equ PSGENV_LASTON	, 		32
.equ PSGENV_ONECYCLE	, 		64

.equ T_FREQ			, 		0
.equ T_COUNT			, 		4
.equ T_PVOL			, 		8
.equ T_PUCHI			, 		12
.equ T_PAN			, 		14
.equ T_SIZE			, 		16

.equ P_TONE			, 		0
.equ P_NOISE			, 		48
.equ PN_FREQ			, 		48
.equ PN_COUNT		, 		52
.equ PN_BASE			, 		56
.equ P_REG			, 		60
.equ P_ENVCNT		, 		76
.equ P_ENVMAX		, 		78
.equ P_MIXER			, 		80
.equ P_ENVMODE		, 		81
.equ P_ENVVOL		, 		82
.equ P_ENVVOLCNT		, 		83
.equ P_EVOL			, 		84
.equ P_PUCHICOUNT	, 		88

.equ C_VOLUME		, 		0
.equ C_VOLTBL		, 		64
.equ C_RATE			, 		128
.equ C_BASE			, 		132
.equ C_PUCHIDEC		, 		136

.equ CD_BIT31		, 		0x80000000

@ r0	psggen
@ r1	Offset
@ r2	Counter
@ r3	Temporary Register
@ r4	Temporary Register
@ r5	Temporary Register
@ r6	Temporary Register
@ r7	L
@ r8	R
@ r9	noise
@ r10	mixer
@ r11	psgcfg Fix
@ r12	Temporary Register
@ lr	envcnt?

	.global __randseed
	.global psggencfg

	.global psggen_getpcm

.text
.p2align 2


.macro PSGCALC	o, t, n
			ldr		r12, [r0, #(\o + T_PVOL)]
			tst		r10, \t
			mov		r3, #0
			ldr		r12, [r12]
LOCAL label_n
			beq		label_n
			cmp		r12, #0
LOCAL label_ed
			beq		label_ed
			ldr		r4, [r0, #(\o + T_COUNT)]
			ldr		r5, [r0, #(\o + T_FREQ)]
			tst		r10, \n
LOCAL label_tn
			bne		label_tn
			mov		r6, #PSGADDEDCNT
LOCAL label_tlp
label_tlp:	adds	r4, r4, r5
			addpl	r3, r3, r12
			submi	r3, r3, r12
			subs	r6, r6, #1
			bne		label_tlp
			str		r4, [r0, #(\o + T_COUNT)]
			ldrb	r6, [r0, #(\o + T_PAN)]
LOCAL label_pan
			b		label_pan
label_tn:	add		r6, r9, #1
LOCAL label_tnlp
label_tnlp:	add		r4, r4, r5
			tst		r4, r6
			addpl	r3, r3, r12
			submi	r3, r3, r12
			mov		r6, r6, lsl #1
			tst		r6, #(1 << PSGADDEDCNT)
			beq		label_tnlp
			str		r4, [r0, #(\o + T_COUNT)]
			ldrb	r6, [r0, #(\o + T_PAN)]
			b		label_pan
label_n:	cmp		r12, #0
			beq		label_ed
			tst		r10, \n
LOCAL label_nmn
			bne		label_nmn
			ldrb	r4, [r0, #(\o + T_PUCHI)]
			ldrb	r6, [r0, #(\o + T_PAN)]
			subs	r4, r4, #1
			strcsb	r4, [r0, #(\o + T_PUCHI)]
			addcs	r3, r3, r12, lsl #PSGADDEDBIT
			b		label_pan
label_nmn:	mov		r4, #(1 << (32 - PSGADDEDCNT))
			ldrb	r6, [r0, #(\o + T_PAN)]
LOCAL label_nlp
label_nlp:	tst		r4, r9
			addeq	r3, r3, r12
			subne	r3, r3, r12
			movs	r4, r4, lsl #1
			bne		label_nlp
label_pan:	tst		r6, #1
			addeq	r7, r7, r3
			tst		r6, #2
			addeq	r8, r8, r3
label_ed:
	.endm


psggen_getpcm:
				ldrb	r12, [r0, #P_MIXER]
				tst		r12, #0x3f
				bne		countcheck
				ldr		r3, [r0, #P_PUCHICOUNT]
				cmp		r2, r3
				movcs	r2, r3
				sub		r3, r3, r2
				str		r3, [r0, #P_PUCHICOUNT]
countcheck:		cmp		r2, #0
				moveq	pc, lr

				stmdb	sp!, {r4 - r11, lr}
				ldr		r11, psgvoltbl
				ldrh	lr, [r0, #P_ENVCNT]

psgmake_lp:		ldr		r10, [r0, #P_MIXER]
				cmp		lr, #0
				beq		makenoise
				subs	lr, lr, #1
				bne		makenoise
				bic		r10, r10, #(255 << 16)
				subs	r10, r10, #(1 << 24)
				bcs		calcenvnext
				tst		r10, #(PSGENV_ONESHOT << 8)
				beq		calcenvcyc
				tst		r10, #(PSGENV_LASTON << 8)
				ldreq	r6, [r11]
				ldrne	r6, [r11, #(15 * 4)]
				orrne	r10, r10, #(15 << 16)
				b		calcenvvstr
calcenvcyc:		bic		r10, r10, #(240 << 24)
				tst		r10, #(PSGENV_ONECYCLE << 8)
				eoreq	r10, r10, #(PSGENV_INC << 8)
calcenvnext:		ldrh	lr, [r0, #P_ENVMAX]
				eor		r3, r10, r10, lsr #16
				and		r3, r3, #(15 << 8)
				ldr		r6, [r11, r3, lsr #(8 - 2)]
				orr		r10, r10, r3, lsl #8
calcenvvstr:		str		r6, [r0, #P_EVOL]
calcenvstr:		str		r10, [r0, #P_MIXER]

makenoise:		tst		r10, #0x38
				beq		makesamp
				ldr		r6, [r0, #PN_FREQ]
				ldr		r7, [r0, #PN_COUNT]
				ldr		r8, [r0, #PN_BASE]
				mov		r9, #0
				mov		r3, #PSGADDEDCNT
mknoise_lp:		subs	r7, r7, r6
				bcc		updatenoise
updatenoiseret:	add		r9, r8, r9, lsl #1
				subs	r3, r3, #1
				bne		mknoise_lp
				str		r7, [r0, #PN_COUNT]

makesamp:		mov		r7, #0
				mov		r8, #0

psgcalc0:		PSGCALC	(T_SIZE * 0), #0x01, #0x08
psgcalc1:		PSGCALC	(T_SIZE * 1), #0x02, #0x10
psgcalc2:		PSGCALC	(T_SIZE * 2), #0x04, #0x20

				ldr		r4, [r1]
				ldr		r3, [r1, #4]
				subs	r2, r2, #1
				add		r4, r4, r7
				str		r4, [r1], #4
				add		r3, r3, r8
				str		r3, [r1], #4
				bne		psgmake_lp
				strh	lr, [r0, #P_ENVCNT]
				ldmia	sp!, {r4 - r11, pc}
psgvoltbl:		.long 	psggencfg + C_VOLUME

updatenoise:		ldr		r4, randdcd
				ldr		r8, [r4]
				ldr		r12, randdcd1
				mul		r12, r8, r12
				ldr		r8, randdcd2
				add		r8, r8, r12
				str		r8, [r4]
				and		r8, r8, #(1 << (32 - PSGADDEDCNT))
				str		r8, [r0, #PN_BASE]
				b		updatenoiseret
randdcd:			.long 	__randseed
randdcd1:		.long 	0x343fd
randdcd2:		.long 	0x269ec3


	.section	.note.GNU-stack,"",%progbits
