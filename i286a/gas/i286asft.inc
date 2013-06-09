@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

.macro ROL8	s
			mov		r12, \s, lsr #7
			add		r1, r12, \s, lsl #1
			bic		r8, r8, #C_FLAG
			eor		r2, r1, \s
			orr		r8, r12, r8
			and		r2, r2, #0x80
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r2, lsl #4
	.endm

.macro ROR8	s
			and		r12, \s, #1
			mov		r1, \s, lsr #1
			add		r1, r1, r12, lsl #7
			bic		r8, r8, #C_FLAG
			eor		r2, r1, \s
			orr		r8, r12, r8
			and		r2, r2, #0x80
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r2, lsl #4
	.endm

.macro RCL8	s
			and		r12, r8, #1
			add		r1, r12, \s, lsl #1
			bic		r8, r8, #C_FLAG
			orr		r8, r8, \s, lsr #7
			eor		r2, r1, \s
			and		r2, r2, #0x80
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r2, lsl #4
	.endm

.macro RCR8	s
			and		r12, r8, #1
			mov		r1, \s, lsr #1
			add		r1, r1, r12, lsl #7
			bic		r8, r8, #C_FLAG
			and		r2, \s, #1
			orr		r8, r2, r8
			eor		r2, r1, \s
			and		r2, r2, #0x80
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r2, lsl #4
	.endm

.macro SHL8	s
			mov		r1, \s, lsl #1
			eor		r12, r1, \s
			and		r12, r12, #0x80
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r12, lsl #4
			ldrb	r12, [r10, r1]
			bic		r8, r8, #0xff
			orr		r12, r12, #A_FLAG
			orr		r8, r12, r8
	.endm

.macro SHR8	s
			mov		r1, \s, lsr #1
			and		r12, \s, #0x80
			and		r2, \s, #1
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r12, lsl #4
			ldrb	r12, [r10, r1]
			bic		r8, r8, #0xff
			orr		r12, r2, r12
			orr		r12, r12, #A_FLAG
			orr		r8, r12, r8
	.endm

.macro SAR8	s
			and		r12, \s, #0x80
			add		r1, r12, \s, lsr #1
			and		r2, \s, #1
			ldrb	r12, [r10, r1]
			bic		r8, r8, #O_FLAG
			bic		r8, r8, #0xff
			orr		r12, r2, r12
			orr		r12, r12, #A_FLAG
			orr		r8, r12, r8
	.endm


.macro ROL16	s
			mov		r12, \s, lsr #15
			add		r1, r12, \s, lsl #1
			bic		r8, r8, #C_FLAG
			eor		r2, r1, \s
			orr		r8, r12, r8
			and		r2, r2, #0x8000
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r2, lsr #4
	.endm

.macro ROR16	s
			and		r12, \s, #1
			mov		r1, \s, lsr #1
			add		r1, r1, r12, lsl #15
			bic		r8, r8, #C_FLAG
			eor		r2, r1, \s
			orr		r8, r12, r8
			and		r2, r2, #0x8000
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r2, lsr #4
	.endm

.macro RCL16	s
			and		r12, r8, #1
			add		r1, r12, \s, lsl #1
			bic		r8, r8, #C_FLAG
			orr		r8, r8, \s, lsr #15
			eor		r2, r1, \s
			and		r2, r2, #0x8000
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r2, lsr #4
	.endm

.macro RCR16	s
			and		r12, r8, #1
			mov		r1, \s, lsr #1
			add		r1, r1, r12, lsl #15
			bic		r8, r8, #C_FLAG
			and		r2, \s, #1
			orr		r8, r2, r8
			eor		r2, r1, \s
			and		r2, r2, #0x8000
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r2, lsr #4
	.endm

.macro SHL16	s
			mov		r1, \s, lsl #1
			eor		r12, r1, \s
			and		r12, r12, #0x8000
			bic		r8, r8, #O_FLAG
			and		r2, r1, #0xff
			orr		r8, r8, r12, lsr #4
			ldrb	r12, [r10, r2]
			bic		r8, r8, #0xff
			and		r12, r12, #P_FLAG
			orr		r8, r8, r1, lsr #16
			orr		r12, r12, #A_FLAG
			orr		r8, r12, r8
			movs	r2, r1, lsl #16
			orreq	r8, r8, #Z_FLAG
			orrmi	r8, r8, #S_FLAG
	.endm

.macro SHR16	s
			mov		r1, \s, lsr #1
			and		r12, \s, #0x8000
			and		r2, \s, #1
			bic		r8, r8, #O_FLAG
			and		r3, r1, #0xff
			orr		r8, r8, r12, lsr #4
			ldrb	r12, [r10, r3]
			bic		r8, r8, #0xff
			and		r12, r12, #P_FLAG
			orr		r12, r2, r12
			orr		r12, r12, #A_FLAG
			orr		r8, r12, r8
			movs	r2, r1, lsl #16
			orreq	r8, r8, #Z_FLAG
			orrmi	r8, r8, #S_FLAG
	.endm

.macro SAR16	s
			and		r12, \s, #0x8000
			add		r1, r12, \s, lsr #1
			and		r2, \s, #1
			and		r3, r1, #0xff
			bic		r8, r8, #O_FLAG
			ldrb	r12, [r10, r3]
			bic		r8, r8, #0xff
			and		r12, r12, #P_FLAG
			orr		r12, r2, r12
			orr		r12, r12, #A_FLAG
			orr		r8, r12, r8
			movs	r2, r1, lsl #16
			orreq	r8, r8, #Z_FLAG
			orrmi	r8, r8, #S_FLAG
	.endm


.macro ROL8CL	s, cl
			rsb		r1, \cl, #0
			and		r1, r1, #7
			orr		r12, \s, \s, lsl #8
			mov		r3, r12, lsr r1
			and		r1, r3, #0xff
			and		r12, r1, #1
			bic		r8, r8, #C_FLAG
			orr		r8, r8, r12
			eor		r12, r12, r1, lsr #7
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r12, lsl #11
	.endm

.macro ROR8CL	s, cl
			and		r1, \cl, #7
			orr		r12, \s, \s, lsl #8
			mov		r3, r12, lsr r1
			and		r1, r3, #0xff
			bic		r8, r8, #C_FLAG
			orr		r8, r8, r1, lsr #7
			eor		r12, r1, r1, lsl #1
			and		r12, r12, #0x80
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r12, lsl #4
	.endm

.macro RCL8CL	s, cl
			mov		r1, \cl
LOCAL label_1
label_1:	subs	r1, r1, #9
			bcs		label_1
			rsb		r1, r1, #0
			and		r12, r8, #1
			orr		r12, \s, r12, lsl #8
			orr		r12, r12, r12, lsl #9
			mov		r3, r12, lsr r1
			and		r1, r3, #0xff
			and		r12, r3, #0x100
			bic		r8, r8, #C_FLAG
			orr		r8, r8, r12, lsr #8
			eor		r12, r3, r3, lsr #1
			and		r12, r12, #0x80
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r12, lsl #4
	.endm

.macro RCR8CL	s, cl
			mov		r1, \cl
LOCAL label_1
label_1:	subs	r1, r1, #9
			bcs		label_1
			add		r1, r1, #9
			and		r12, r8, #1
			orr		r12, \s, r12, lsl #8
			orr		r12, r12, r12, lsl #9
			mov		r3, r12, lsr r1
			and		r1, r3, #0xff
			and		r12, r3, #0x100
			bic		r8, r8, #C_FLAG
			orr		r8, r8, r12, lsr #8
			eor		r12, r3, r3, lsl #1
			and		r12, r12, #0x80
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r12, lsl #4
	.endm

.macro SHL8CL	s, cl
			mov		r1, \s, lsl \cl
			bic		r8, r8, #O_FLAG
			eor		r12, r1, r1, lsr #1
			and		r12, r12, #0x80
			orr		r8, r8, r12, lsl #4
			mov		r2, r1, lsl #(32 - 9)
			ldrb	r12, [r10, r2, lsr #(32 - 9)]
			bic		r8, r8, #0xff
			orr		r12, r12, #A_FLAG
			orr		r8, r12, r8
	.endm

.macro SHR8CL	s, cl
			sub		r12, \cl, #1
			bic		r8, r8, #0xff
			mov		r1, \s, lsr r12
			and		r12, r1, #1
			mov		r1, \s, lsr \cl
			orr		r8, r8, r12
			and		r12, r1, #0x40
			bic		r8, r8, #O_FLAG
			orr		r8, r8, r12, lsl #5
			ldrb	r12, [r10, r1]
			orr		r12, r12, #A_FLAG
			orr		r8, r12, r8
	.endm

.macro SAR8CL	s, cl
			mov		r1, \s, lsl #24
			mov		r1, r1, asr #24
			sub		r12, \cl, #1
			bic		r8, r8, #0xff
			mov		r1, r1, asr r12
			and		r12, r1, #1
			mov		r1, r1, asr #1
			orr		r8, r8, r12
			and		r1, r1, #0xff
			bic		r8, r8, #O_FLAG
			ldrb	r12, [r10, r1]
			orr		r12, r12, #A_FLAG
			orr		r8, r12, r8
	.endm


.macro ROL16CL	s, cl
			cmp		\cl, #1
			eoreq	r1, \s, \s, lsl #1
			andeq	r1, r1, #0x8000
			biceq	r8, r8, #O_FLAG
			orreq	r8, r8, r1, lsr #4
			and		r1, \cl, #15
			orr		r12, \s, \s, lsl #16
			mov		r3, r12, lsl r1
			mov		r1, r3, lsr #16
			and		r12, r1, #1
			bic		r8, r8, #C_FLAG
			orr		r8, r8, r12
	.endm

.macro ROR16CL	s, cl
			cmp		\cl, #1
			eoreq	r1, \s, \s, lsl #15
			andeq	r1, r1, #0x8000
			biceq	r8, r8, #O_FLAG
			orreq	r8, r8, r1, lsr #4
			rsb		r3, \cl, #0
			and		r1, r3, #15
			orr		r12, \s, \s, lsl #16
			mov		r3, r12, lsl r1
			mov		r1, r3, lsr #16
			bic		r8, r8, #C_FLAG
			orr		r8, r8, r1, lsr #15
	.endm

.macro RCL16CL	s, cl
			cmp		\cl, #1
			eoreq	r1, \s, \s, lsl #1
			andeq	r1, r1, #0x8000
			biceq	r8, r8, #O_FLAG
			orreq	r8, r8, r1, lsr #4
			mov		r1, \cl
			cmp		r1, #17
			subcs	r1, r1, #17
			and		r12, r8, #1
			orr		r3, \s, r12, lsl #16
			mov		r12, r3, lsl r1
			rsb		r1, r1, #17
			mov		r3, r3, lsr r1
			orr		r1, r3, r12
			and		r12, r1, #0x10000
			bic		r8, r8, #C_FLAG
			orr		r8, r8, r12, lsr #16
	.endm

.macro RCR16CL	s, cl
			cmp		\cl, #1
			eoreq	r1, r8, \s, lsr #15
			andeq	r1, r1, #1
			biceq	r8, r8, #O_FLAG
			orreq	r8, r8, r1, lsl #11
			mov		r1, \cl
			cmp		r1, #17
			subcs	r1, r1, #17
			and		r3, r8, #1
			orr		r12, \s, r3, lsl #16
			mov		r3, r12, lsr r1
			rsb		r1, r1, #17
			mov		r12, r12, lsl r1
			orr		r1, r12, r3
			and		r12, r1, #0x10000
			bic		r8, r8, #C_FLAG
			orr		r8, r8, r12, lsr #16
	.endm

.macro SHL16CL	s, cl
			bic		r8, r8, #O_FLAG
			cmp		\cl, #1
			eoreq	r1, \s, \s, lsl #1
			andeq	r1, r1, #0x8000
			orreq	r8, r8, r1, lsr #4
			mov		r1, \s, lsl \cl
			and		r2, r1, #0xff
			ldrb	r12, [r10, r2]
			bic		r8, r8, #0xff
			and		r12, r12, #P_FLAG
			orr		r8, r12, r8
			movs	r2, r1, lsl #16
			orreq	r8, r8, #Z_FLAG
			orrmi	r8, r8, #S_FLAG
			and		r2, r1, #0x10000
			orr		r8, r8, r2, lsr #16
	.endm

.macro SHR16CL	s, cl
			bic		r8, r8, #O_FLAG
			cmp		\cl, #1
			andeq	r1, \s, #0x8000
			orreq	r8, r8, r1, lsr #4
			sub		r12, \cl, #1
			bic		r8, r8, #0xff
			mov		r1, \s, lsr r12
			and		r12, r1, #1
			mov		r1, r1, lsr #1
			orr		r8, r8, r12
			and		r2, r1, #0xff
			ldrb	r12, [r10, r2]
			and		r12, r12, #P_FLAG
			orr		r8, r12, r8
			movs	r2, r1, lsl #16
			orreq	r8, r8, #Z_FLAG
			orrmi	r8, r8, #S_FLAG
	.endm

.macro SAR16CL	s, cl
			mov		r1, \s, lsl #16
			mov		r1, r1, asr #16
			sub		r12, \cl, #1
			bic		r8, r8, #0xff
			mov		r1, r1, asr r12
			and		r12, r1, #1
			mov		r1, r1, asr #1
			orr		r8, r8, r12
			and		r2, r1, #0xff
			bic		r8, r8, #O_FLAG
			ldrb	r12, [r10, r2]
			and		r12, r12, #P_FLAG
			orr		r8, r12, r8
			movs	r2, r1, lsl #16
			orreq	r8, r8, #Z_FLAG
			orrmi	r8, r8, #S_FLAG
	.endm


	.section	.note.GNU-stack,"",%progbits
