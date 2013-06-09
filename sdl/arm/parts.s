@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

	.global __randseed
	.global rand_setseed
	.global rand_get
	.global AdjustAfterMultiply
	.global AdjustBeforeDivision
	.global sjis2jis
	.global jis2sjis
	.global satuation_s16
	.global satuation_s16x


.data
.p2align 2

__randseed:		.long 	1


.text
.p2align 2

rand_setseed:	ldr		r1, prandseed
				str		r0, [r1]
				mov		pc, lr
rand_get:		ldr		r1, prandseed
				ldr		r2, randdcd1
				ldr		r3, randdcd2
				ldr		r0, [r1]
				mla		r2, r0, r2, r3
				mov		r0, r2, asr #16
				str		r2, [r1]
				mov		pc, lr
prandseed:		.long 	__randseed
randdcd1:		.long 	0x343fd
randdcd2:		.long 	0x269ec3

AdjustAfterMultiply:
				and		r0, r0, #255
				mov		r1, #205				@ îÕàÕÇ™0-255Ç»ÇÃÇ≈ê∏ìxí·Çµ
				mul		r1, r0, r1
				mov		r1, r1, lsr #11
				sub		r0, r0, r1, lsl #1
		.if 1
				add		r0, r0, r1, lsl #3
		.else
				sub		r0, r0, r1, lsl #3
				add		r0, r0, r1, lsl #4
		.endif
				mov		pc, lr

AdjustBeforeDivision:
				and		r1, r0, #0xf0
				and		r0, r0, #15
				add		r0, r0, r1, lsr #3
				add		r0, r0, r1, lsr #1
				mov		pc, lr

sjis2jis:		and		r1, r0, #255
				sub		r1, r1, r1, lsr #7
				mov		r1, r1, lsl	#23
				adds	r1, r1, #(0x62 << 23)
				subpl	r1, r1, #(0xa2 << 23)
				mov		r2, #0x1f00
				orr		r2, r2, #0x21
				add		r1, r2, r1, lsr #23
				and		r0, r0, #0x3f00
				add		r0, r1, r0, lsl #1
				mov		pc, lr

jis2sjis:		and		r1, r0, #0x7f00
				and		r0, r0, #0x7f
				tst		r1, #0x100
				addeq	r0, r0, #0x5e
				cmp		r0, #0x60
				addcs	r0, r0, #1
				add		r0, r0, #0x1f
				add		r1, r1, #0x2100
				mov		r1, r1, lsr #1
				and		r1, r1, #0xff00
				eor		r1, r1, #0xa000
				orr		r0, r0, r1
				mov		pc, lr

satuation_s16:	movs	r2, r2, lsr #2
				moveq	pc, lr
				stmdb	sp!, {r4, lr}
				ldr		lr, dcd_ffff8000
				mov		r12, #0x7f00
				orr		r12, r12, #0x7f
ss16_lp:			ldr		r3, [r1], #4
				ldr		r4, [r1], #4
				cmp		r3, r12
				movgt	r3, r12
				cmple	r3, lr
				movlt	r3, lr
				mov		r3, r3, lsl #16
				cmp		r4, r12
				movgt	r4, r12
				cmple	r4, lr
				movlt	r4, lr
				mov		r4, r4, lsl #16
				add		r3, r4, r3, lsr #16
				str		r3, [r0], #4
				subs	r2, r2, #1
				bne		ss16_lp
				ldmia	sp!, {r4, pc}
dcd_ffff8000:	.long 	0xffff8000

satuation_s16x:	movs	r2, r2, lsr #2
				moveq	pc, lr
				stmdb	sp!, {r4, lr}
				ldr		lr, dcd_ffff8000
				mov		r12, #0x7f00
				orr		r12, r12, #0x7f
ss16x_lp:		ldr		r3, [r1], #4
				ldr		r4, [r1], #4
				cmp		r3, r12
				movgt	r3, r12
				cmple	r3, lr
				movlt	r3, lr
				mov		r3, r3, lsl #16
				cmp		r4, r12
				movgt	r4, r12
				cmple	r4, lr
				movlt	r4, lr
				mov		r4, r4, lsl #16
				subs	r2, r2, #1
				add		r3, r3, r4, lsr #16
				str		r3, [r0], #4
				bne		ss16x_lp
				ldmia	sp!, {r4, pc}


	.section	.note.GNU-stack,"",%progbits
