@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0

.equ FMDIV_BITS		, 		8
.equ FMDIV_ENT		, 		(1 << FMDIV_BITS)
.equ FMVOL_SFTBIT	, 		4

.equ SIN_BITS		, 		8
.equ EVC_BITS		, 		7
.equ ENV_BITS		, 		16
.equ KF_BITS			, 		6
.equ FREQ_BITS		, 		20
.equ ENVTBL_BIT		, 		14
.equ SINTBL_BIT		, 		14

.equ TL_BITS			, 		(FREQ_BITS+2)
.equ OPM_OUTSB		, 		(TL_BITS + 2 - 16)

.equ SIN_ENT			, 		(1 << SIN_BITS)
.equ EVC_ENT			, 		(1 << EVC_BITS)

.equ EC_ATTACK		, 		0
.equ EC_DECAY		, 		(EVC_ENT << ENV_BITS)
.equ EC_OFF			, 		((2 * EVC_ENT) << ENV_BITS)

.equ EM_ATTACK		, 		4
.equ EM_DECAY1		, 		3
.equ EM_DECAY2		, 		2
.equ EM_RELEASE		, 		1
.equ EM_OFF			, 		0



@ s_detune1			equ		0
.equ S1_TOTALLEVEL		, 		4
.equ S1_DECAYLEVEL		, 		8
@ s_attack			equ		12
@ s_decay1			equ		16
@ s_decay2			equ		20
@ s_release			equ		24
.equ S1_FREQ_CNT			, 		28
.equ S1_FREQ_INC			, 		32
@ s_multiple		equ		36
@ s_keyscale		equ		40
.equ S1_ENV_MODE			, 		41
@ s_envraito		equ		42
@ s_ssgeg1			equ		43
.equ S1_ENV_CNT			, 		44
.equ S1_ENV_END			, 		48
.equ S1_ENV_INC			, 		52
@ s_env_inc_attack	equ		56
.equ S1_ENVINCDECAY1		, 		60
.equ S1_ENVINCDECAY2		, 		64
@ s_env_inc_release	equ		68
.equ S_SIZE				, 		72

@ C_algorithm		equ		(S_SIZE * 4 + 0)
.equ C_FEEDBACK			, 		(S_SIZE * 4 + 1)
.equ C_PLAYING			, 		(S_SIZE * 4 + 2)
.equ C_OUTSLOT			, 		(S_SIZE * 4 + 3)
.equ C_OP1FB				, 		(S_SIZE * 4 + 4)
.equ C_CONNECT1			, 		(S_SIZE * 4 + 8)
.equ C_CONNECT3			, 		(S_SIZE * 4 + 12)
.equ C_CONNECT2			, 		(S_SIZE * 4 + 16)
.equ C_CONNECT4			, 		(S_SIZE * 4 + 20)
@ C_keynote			equ		(S_SIZE * 4 + 24)
@ C_keyfunc			equ		(S_SIZE * 4 + 40)
@ C_kcode			equ		(S_SIZE * 4 + 44)
@ C_pan				equ		(S_SIZE * 4 + 48)
@ C_extop			equ		(S_SIZE * 4 + 49)
@ C_stereo			equ		(S_SIZE * 4 + 50)
@ C_padding2		equ		(S_SIZE * 4 + 51)
.equ C_SIZE				, 		(S_SIZE * 4 + 52)

.equ G_PLAYCHANNELS		, 		0
.equ G_PLAYING			, 		4
.equ G_FEEDBACK2			, 		8
.equ G_FEEDBACK3			, 		12
.equ G_FEEDBACK4			, 		16
.equ G_OUTDL				, 		20
.equ G_OUTDC				, 		24
.equ G_OUTDR				, 		28
.equ G_CALCREMAIN		, 		32
@ G_keyreg			equ		36

.equ T_ORG				, 		24
.equ T_CALC1024			, 		(0 - T_ORG)
.equ T_FMVOL				, 		(4 - T_ORG)
.equ T_ratebit			, 		(8 - T_ORG)
.equ T_vr_en				, 		(12 - T_ORG)
.equ T_vr_l				, 		(16 - T_ORG)
.equ T_vr_r				, 		(20 - T_ORG)
.equ T_sintable			, 		(24 - T_ORG)
.equ T_envtable			, 		(24 - T_ORG + SIN_ENT * 4)
.equ T_envcurve			, 		(24 - T_ORG + SIN_ENT * 4 + EVC_ENT * 4)

	.global opnch
	.global opngen
	.global opncfg

	.global opngen_getpcm
	.global opngen_getpcmvr

.text
.p2align 2

@ r0	Temporary Register
@ r1	Offset
@ r2	Counter
@ r3	Temporary Register
@ r4	Temporary Register
@ r5	channel counter
@ r6	OPNCH
@ r7	OPNCH base
@ r8	L
@ r9	R
@ r10	opngen Fix
@ r11	opncfg Fix
@ r12	Temporary Register

.macro SLTFREQ label,	o, upd
\label:		ldr		r3, [r6, #(\o + S1_ENV_INC)]	@ calc env
			ldr		r4, [r6, #(\o + S1_ENV_CNT)]
			ldr		r12, [r6, #(\o + S1_ENV_END)]
			@
			add		r3, r3, r4
			cmp		r3, r12
			bcs		\upd
	.endm

.macro SLTOUT label,	o, fd, cn
\label:		mov		r4, r3, lsr #ENV_BITS
			subs	r12, r4, #EVC_ENT
			addcc	r12, r11, #T_envcurve			@ r12 = opntbl.envcurve
			ldr		r0, [r6, #(\o + S1_TOTALLEVEL)]
			ldrcc	r12, [r12, r4, lsl #2]
			str		r3, [r6, #(\o + S1_ENV_CNT)]
			ldr		r4, [r6, #(\o + S1_FREQ_CNT)]
			ldr		r3, [r6, #(\o + S1_FREQ_INC)]	@ freq
			subs	r0, r0, r12
			ldr		r12, [r10, \fd]
			add		r3, r3, r4
			str		r3, [r6, #(\o + S1_FREQ_CNT)]
			bls		ed\label
			add		r3, r3, r12
			add		r0, r11, r0, lsl #2
			mov		r3, r3, lsl #(32 - FREQ_BITS)
			add		r12, r11, #T_sintable		@ r12 = opntbl.sintable
			mov		r3, r3, lsr #(32 - SIN_BITS)
			ldr		r4, [r6, \cn]
			ldr		r0, [r0, #T_envtable]
			ldr		r3, [r12, r3, lsl #2]
			ldr		r12, [r4]
			mul		r0, r3, r0
			@
			add		r12, r12, r0, asr #(ENVTBL_BIT + SINTBL_BIT - TL_BITS)
			str		r12, [r4]
ed\label:
	.endm


.macro SLTUPD label,	r, o, m
\label:		ldrb	r3, [r6, #(\o + S1_ENV_MODE)]
			@
			@
			sub		r3, r3, #1
			cmp		r3, #EM_ATTACK
			addcc	pc, pc, r3, lsl #2
			b		off\label					@ EM_OFF
			b		rel\label					@ EM_RELEASE
			b		dc2\label					@ EM_DECAY2
			b		dc1\label					@ EM_DECAY1
att\label:	strb	r3, [r6, #(\o + S1_ENV_MODE)]
			ldr		r0, [r6, #(\o + S1_DECAYLEVEL)]
			ldr		r4, [r6, #(\o + S1_ENVINCDECAY1)]
			mov		r3, #EC_DECAY
			str		r0, [r6, #(\o + S1_ENV_END)]
			str		r4, [r6, #(\o + S1_ENV_INC)]
			b		\r
dc1\label:	strb	r3, [r6, #(\o + S1_ENV_MODE)]
			mov		r0, #EC_OFF
			ldr		r4, [r6, #(\o + S1_ENVINCDECAY2)]
			ldr		r3, [r6, #(\o + S1_DECAYLEVEL)]
			str		r0, [r6, #(\o + S1_ENV_END)]
			str		r4, [r6, #(\o + S1_ENV_INC)]
			b		\r
rel\label:	strb	r3, [r6, #(\o + S1_ENV_MODE)]
dc2\label:	add		r3, r12, #1
			ldrb	r4, [r6, #C_PLAYING]
			mov		r0, #0
			str		r3, [r6, #(\o + S1_ENV_END)]
			str		r0, [r6, #(\o + S1_ENV_INC)]
			and		r4, r4, \m
			strb	r4, [r6, #C_PLAYING]
off\label:	mov		r3, #EC_OFF
			b		\r
	.endm


opngen_getpcm:
opngen_getpcmvr:
				cmp		r2, #0
				moveq	pc, lr
				ldr		r12, dcd_opngen
				ldr		r3, [r12, #G_PLAYING]
				cmp		r3, #0
				moveq	pc, lr

				stmdb	sp!, {r4 - r11, lr}
				ldr		r7, dcd_opnch
				mov		r10, r12
				ldr		r11, dcd_opncfg
				ldr		lr, [r10, #G_CALCREMAIN]
				ldr		r3, [r10, #G_OUTDL]
				ldr		r4, [r10, #G_OUTDR]
getpcm_lp:		rsb		r0, lr, #0
				mul		r8, r0, r3
				mul		r9, r0, r4
				add		lr, lr, #FMDIV_ENT
mksmp_lp:		mov		r12, #0
				str		r12, [r10, #G_OUTDL]
				str		r12, [r10, #G_OUTDC]
				str		r12, [r10, #G_OUTDR]
				ldr		r5, [r10, #G_PLAYCHANNELS]
				sub		r5, r12, r5, lsl #8
				mov		r6, r7
slotcalc_lp:		ldrb	r0, [r6, #C_PLAYING]
				ldrb	r12, [r6, #C_OUTSLOT]
				tst		r0, r12
				beq		slot5calc
				add		r5, r5, #1

				mov		r12, #0
				str		r12, [r10, #G_FEEDBACK2]
				str		r12, [r10, #G_FEEDBACK3]
				str		r12, [r10, #G_FEEDBACK4]

	SLTFREQ slot1calc, 	0, slot1update
s1calcenv:		mov		r12, r3, lsr #ENV_BITS
				subs	r4, r12, #EVC_ENT
				addcc	r4, r11, #T_envcurve		@ r4 = opntbl.envcurve
				ldr		r0, [r6, #S1_TOTALLEVEL]
				ldrcc	r4, [r4, r12, lsl #2]
				str		r3, [r6, #S1_ENV_CNT]
				ldr		r12, [r6, #S1_FREQ_CNT]
				ldr		r3, [r6, #S1_FREQ_INC]		@ freq
				subs	r0, r0, r4
				ldrb	r4, [r6, #C_FEEDBACK]
				add		r3, r3, r12
				str		r3, [r6, #S1_FREQ_CNT]
				bls		slot2calc
				ldr		r12, [r6, #C_OP1FB]
				cmp		r4, #0
				addne	r3, r3, r12, asr r4			@ back!
				add		r4, r11, #T_sintable		@ r1 = opntbl.sintable
				mov		r3, r3, lsl #(32 - FREQ_BITS)
				add		r0, r11, r0, lsl #2
				mov		r3, r3, lsr #(32 - SIN_BITS)
				ldr		r0, [r0, #T_envtable]
				ldr		r3, [r4, r3, lsl #2]
				ldr		r4, [r6, #C_CONNECT1]
				mul		r0, r3, r0
				mov		r3, r0, asr #(ENVTBL_BIT + SINTBL_BIT - TL_BITS)
				strne	r3, [r6, #C_OP1FB]
				addne	r3, r3, r12
				subne	r3, r3, r3, asr #31			@ adjust....
				movne	r3, r3, asr #1
				cmp		r4, #0
				ldrne	r0, [r4]
				streq	r3, [r10, #G_FEEDBACK2]
				streq	r3, [r10, #G_FEEDBACK3]
				streq	r3, [r10, #G_FEEDBACK4]
				addne	r0, r0, r3
				strne	r0, [r4]

	SLTFREQ slot2calc, 	(S_SIZE * 1), slot2update
	SLTOUT s2calcenv, 	(S_SIZE * 1), #G_FEEDBACK2, #C_CONNECT2

	SLTFREQ slot3calc, 	(S_SIZE * 2), slot3update
	SLTOUT s3calcenv, 	(S_SIZE * 2), #G_FEEDBACK3, #C_CONNECT3

	SLTFREQ slot4calc, 	(S_SIZE * 3), slot4update
	SLTOUT s4calcenv, 	(S_SIZE * 3), #G_FEEDBACK4, #C_CONNECT4

slot5calc:		add		r6, r6, #C_SIZE
				adds	r5, r5, #256
				bcc		slotcalc_lp
				ldr		r0, [r10, #G_OUTDC]
				ldr		r3, [r10, #G_OUTDL]
				ldr		r4, [r10, #G_OUTDR]
				ldr		r12, [r11, #T_CALC1024]
				add		r3, r3, r0
				add		r4, r4, r0
				mov		r3, r3, asr #FMVOL_SFTBIT
				mov		r4, r4, asr #FMVOL_SFTBIT
				subs	lr, lr, r12
				addle	r12, lr, r12
				mla		r8, r12, r3, r8
				mla		r9, r12, r4, r9
				bgt		mksmp_lp
				ldr		r0, [r11, #T_FMVOL]
				mov		r8, r8, asr #FMDIV_BITS
				mov		r9, r9, asr #FMDIV_BITS
				mul		r8, r0, r8
				ldr		r12, [r1]
				mul		r9, r0, r9
				ldr		r0, [r1, #4]
				add		r12, r12, r8, asr #(OPM_OUTSB + FMDIV_BITS + 1 + 6 - FMVOL_SFTBIT - 8)
				str		r12, [r1], #4
				add		r0, r0, r9, asr #(OPM_OUTSB + FMDIV_BITS + 1 + 6 - FMVOL_SFTBIT - 8)
				str		r0, [r1], #4
				subs	r2, r2, #1
				bne		getpcm_lp
				str		r3, [r10, #G_OUTDL]
				str		r4, [r10, #G_OUTDR]
				str		lr, [r10, #G_CALCREMAIN]
				strb	r5, [r10, #G_PLAYING]
				ldmia	sp!, {r4 - r11, pc}

dcd_opngen:		.long 	opngen
dcd_opnch:		.long 	opnch
dcd_opncfg:		.long 	opncfg + T_ORG

	SLTUPD slot1update, 	s1calcenv, (S_SIZE * 0), #0xfe
	SLTUPD slot2update, 	s2calcenv, (S_SIZE * 1), #0xfd
	SLTUPD slot3update, 	s3calcenv, (S_SIZE * 2), #0xfb
	SLTUPD slot4update, 	s4calcenv, (S_SIZE * 3), #0xf7


	.section	.note.GNU-stack,"",%progbits
