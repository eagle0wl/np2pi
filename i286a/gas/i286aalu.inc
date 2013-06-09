@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

.macro ADD8	d, s
			mov		r1, \s, lsl #24
			adds	r1, r1, \d, lsl #24
			orrvs	r8, r8, #O_FLAG
			mov		r1, r1, lsr #24
			bicvc	r8, r8, #O_FLAG
			eor		r12, r1, \s
			ldrb	r2, [r10, r1]
			eor		r12, r12, \d
			addcs	r2, r2, #C_FLAG
			and		r12, r12, #A_FLAG
			orr		r2, r2, r12
			bic		r8, r8, #0xff
			add		r8, r8, r2
	.endm

.macro OR8		d, s
			orr		r1, \d, \s
			bic		r8, r8, #O_FLAG
			ldrb	r12, [r10, r1]
			bic		r8, r8, #0xff
			orr		r8, r12, r8
	.endm

.macro ADC8	d, s
			and		r1, r8, #C_FLAG
			add		r1, r1, \s
			add		r1, r1, \d
			bic		r8, r8, #O_FLAG
			eor		r12, r1, \d
			eor		r2, r1, \s
			and		r2, r12, r2
			eor		r12, r12, \s
			and		r2, r2, #0x80
			and		r12, r12, #A_FLAG
			orr		r8, r8, r2, lsl #4
			ldrb	r2, [r10, r1]
			bic		r8, r8, #0xff
			orr		r2, r12, r2
			orr		r8, r2, r8
	.endm

.macro SBB8	d, s
			and		r12, r8, #C_FLAG
			sub		r1, \d, \s
			bic		r8, r8, #O_FLAG
			sub		r1, r1, r12
			eor		r12, \s, \d
			eor		r2, r1, \d
			and		r2, r12, r2
			eor		r12, r1, r12
			and		r2, r2, #0x80
			and		r12, r12, #A_FLAG
			orr		r8, r8, r2, lsl #4
			mov		r2, r1, lsl #(32 - 9)
			ldrb	r2, [r10, r2, lsr #(32 - 9)]
			bic		r8, r8, #0xff
			orr		r2, r12, r2
			orr		r8, r2, r8
	.endm

.macro AND8	d, s
			and		r1, \d, \s
			bic		r8, r8, #O_FLAG
			ldrb	r12, [r10, r1]
			bic		r8, r8, #0xff
			orr		r8, r12, r8
	.endm

.macro SUB8	d, s
			mov		r1, \d, lsl #24
			subs	r1, r1, \s, lsl #24
			orrvs	r8, r8, #O_FLAG
			mov		r1, r1, lsr #24
			bicvc	r8, r8, #O_FLAG
			eor		r12, r1, \s
			ldrb	r2, [r10, r1]
			eor		r12, r12, \d
			addcc	r2, r2, #C_FLAG
			and		r12, r12, #A_FLAG
			orr		r2, r2, r12
			bic		r8, r8, #0xff
			add		r8, r8, r2
	.endm

.macro XOR8	d, s
			eor		r1, \d, \s
			bic		r8, r8, #O_FLAG
			ldrb	r12, [r10, r1]
			bic		r8, r8, #0xff
			orr		r8, r12, r8
	.endm

.macro ADD16	d, s
			mov		r1, \s, lsl #16
			adds	r1, r1, \d, lsl #16
			orrvs	r8, r8, #O_FLAG
			mov		r1, r1, lsr #16
			bicvc	r8, r8, #O_FLAG
			and		r3, r1, #0xff
			eor		r12, r1, \d
			ldrb	r2, [r10, r3]
			eor		r12, r12, \s
			and		r2, r2, #P_FLAG
			addcs	r2, r2, #C_FLAG
			addeq	r2, r2, #Z_FLAG
			addmi	r2, r2, #S_FLAG
			and		r12, r12, #A_FLAG
			bic		r8, r8, #0xff
			orr		r3, r2, r12
			add		r8, r3, r8
	.endm

.macro OR16	d, s
			orr		r1, \d, \s
			bic		r8, r8, #O_FLAG
			and		r2, r1, #0xff
			ldrb	r12, [r10, r2]
			bic		r8, r8, #0xff
			and		r12, r12, #P_FLAG
			movs	r2, r1, lsl #16
			addeq	r12, r12, #Z_FLAG
			addmi	r12, r12, #S_FLAG
			orr		r8, r12, r8
	.endm

.macro ADC16	d, s
			and		r1, r8, #C_FLAG
			add		r1, r1, \s
			add		r1, r1, \d
			bic		r8, r8, #O_FLAG
			eor		r12, r1, \d
			eor		r2, r1, \s
			and		r2, r12, r2
			eor		r12, r12, \s
			and		r2, r2, #0x8000
			and		r12, r12, #A_FLAG
			orr		r8, r8, r2, lsr #4
			and		r2, r1, #0xff
			movs	r3, r1, lsl #16
			addeq	r12, r12, #Z_FLAG
			addmi	r12, r12, #S_FLAG
			ldrb	r2, [r10, r2]
			bic		r8, r8, #0xff
			and		r2, r2, #P_FLAG
			orr		r2, r12, r2
			orr		r8, r2, r8
			tst		r1, #0x10000
			orrne	r8, r8, #C_FLAG
	.endm

.macro SBB16	d, s
			and		r12, r8, #C_FLAG
			sub		r1, \d, \s
			bic		r8, r8, #0xff
			subs	r1, r1, r12
			addmi	r8, r8, #C_FLAG
			eor		r12, \s, \d
			eor		r2, r1, \d
			bic		r8, r8, #O_FLAG
			and		r2, r12, r2
			eor		r12, r1, r12
			and		r3, r1, #0xff
			and		r2, r2, #0x8000
			ldrb	r3, [r10, r3]
			orr		r8, r8, r2, lsr #4
			and		r2, r3, #P_FLAG
			and		r12, r12, #A_FLAG
			movs	r3, r1, lsl #16
			addeq	r12, r12, #Z_FLAG
			addmi	r12, r12, #S_FLAG
			orr		r2, r12, r2
			orr		r8, r2, r8
	.endm

.macro AND16	d, s
			and		r1, \d, \s
			bic		r8, r8, #O_FLAG
			and		r2, r1, #0xff
			ldrb	r12, [r10, r2]
			bic		r8, r8, #0xff
			and		r12, r12, #P_FLAG
			movs	r2, r1, lsl #16
			addeq	r12, r12, #Z_FLAG
			addmi	r12, r12, #S_FLAG
			orr		r8, r12, r8
	.endm

.macro SUB16	d, s
			mov		r1, \d, lsl #16
			subs	r1, r1, \s, lsl #16
			orrvs	r8, r8, #O_FLAG
			mov		r1, r1, lsr #16
			bicvc	r8, r8, #O_FLAG
			and		r3, r1, #0xff
			eor		r12, r1, \d
			ldrb	r2, [r10, r3]
			eor		r12, r12, \s
			and		r2, r2, #P_FLAG
			addcc	r2, r2, #C_FLAG
			addeq	r2, r2, #Z_FLAG
			addmi	r2, r2, #S_FLAG
			and		r12, r12, #A_FLAG
			bic		r8, r8, #0xff
			orr		r3, r2, r12
			add		r8, r3, r8
	.endm

.macro XOR16	d, s
			eor		r1, \d, \s
			bic		r8, r8, #O_FLAG
			and		r2, r1, #0xff
			ldrb	r12, [r10, r2]
			bic		r8, r8, #0xff
			and		r12, r12, #P_FLAG
			movs	r2, r1, lsl #16
			addeq	r12, r12, #Z_FLAG
			addmi	r12, r12, #S_FLAG
			orr		r8, r12, r8
	.endm

.macro INC8	s
			add		r1, \s, #1
			bic		r8, r8, #O_FLAG
			eor		r12, r1, \s
			bic		r8, r8, #(0xff - C_FLAG)
			and		r2, r12, r1
			and		r12, r12, #A_FLAG
			and		r3, r1, #0xff
			tst		r2, #0x80
			orrne	r8, r8, #O_FLAG
			ldrb	r2, [r10, r3]
			orr		r8, r8, r12
			orr		r8, r8, r2
	.endm

.macro INC16	s
			add		r1, \s, #1
			bic		r8, r8, #O_FLAG
			eor		r12, r1, \s
			bic		r8, r8, #(0xff - C_FLAG)
			and		r2, r12, r1
			and		r12, r12, #A_FLAG
			and		r3, r1, #0xff
			tst		r2, #0x8000
			orrne	r8, r8, #O_FLAG
			ldrb	r2, [r10, r3]
			movs	r3, r1, lsl #16
			orreq	r12, r12, #Z_FLAG
			orrmi	r12, r12, #S_FLAG
			and		r2, r2, #P_FLAG
			orr		r8, r8, r12
			orr		r8, r8, r2
	.endm

.macro DEC8	s
			sub		r1, \s, #1
			bic		r8, r8, #O_FLAG
			eor		r12, r1, \s
			bic		r8, r8, #(0xff - C_FLAG)
			and		r2, r12, \s
			and		r12, r12, #A_FLAG
			and		r3, r1, #0xff
			tst		r2, #0x80
			orrne	r8, r8, #O_FLAG
			ldrb	r2, [r10, r3]
			orr		r8, r8, r12
			orr		r8, r8, r2
	.endm

.macro DEC16	s
			sub		r1, \s, #1
			bic		r8, r8, #O_FLAG
			eor		r12, r1, \s
			bic		r8, r8, #(0xff - C_FLAG)
			and		r2, r12, \s
			and		r12, r12, #A_FLAG
			and		r3, r1, #0xff
			tst		r2, #0x8000
			orrne	r8, r8, #O_FLAG
			ldrb	r2, [r10, r3]
			movs	r3, r1, lsl #16
			orreq	r12, r12, #Z_FLAG
			orrmi	r12, r12, #S_FLAG
			and		r2, r2, #P_FLAG
			orr		r8, r8, r12
			orr		r8, r8, r2
	.endm


.macro NOT8	s
			mvn		r1, \s
	.endm

.macro NOT16	s
			mvn		r1, \s
	.endm


.macro NEG8	s
			rsb		r1, \s, #0
			bic		r8, r8, #O_FLAG
			and		r12, r1, \s
			eor		r2, r1, \s
			bic		r8, r8, #0xff
			and		r12, r12, #0x80
			and		r2, r2, #A_FLAG
			orr		r8, r8, r12, lsl #4
			mov		r12, r1, lsl #(32 - 9)
			orr		r8, r8, r2
			ldrb	r2, [r10, r12, lsr #(32 - 9)]
			orr		r8, r2, r8
	.endm

.macro NEG16	s
			bic		r8, r8, #0xff
			rsbs	r1, \s, #0
			addmi	r8, r8, #C_FLAG
			and		r12, r1, \s
			bic		r8, r8, #O_FLAG
			eor		r2, r1, \s
			and		r12, r12, #0x8000
			and		r2, r2, #A_FLAG
			orr		r8, r8, r12, lsr #4
			and		r12, r1, #0xff
			orr		r8, r8, r2
			ldrb	r2, [r10, r12]
			and		r2, r2, #P_FLAG
			orr		r8, r2, r8
			movs	r12, r1, lsl #16
			orreq	r8, r8, #Z_FLAG
			orrmi	r8, r8, #S_FLAG
	.endm


.macro MUL8	d, s
			mul		r1, \d, \s
			movs	r12, r1, lsr #8
			biceq	r8, r8, #O_FLAG
			biceq	r8, r8, #C_FLAG
			orrne	r8, r8, #O_FLAG
			orrne	r8, r8, #C_FLAG
	.endm

.macro MUL16	d, s
			mul		r1, \d, \s
			movs	r12, r1, lsr #16
			biceq	r8, r8, #O_FLAG
			biceq	r8, r8, #C_FLAG
			orrne	r8, r8, #O_FLAG
			orrne	r8, r8, #C_FLAG
	.endm

.macro IMUL8	d, s
			mov		r1, \d, lsl #24
			mov		r12, \s, lsl #24
			mov		r1, r1, asr #24
			mov		r12, r12, asr #24
			mul		r1, r12, r1
			add		r12, r1, #0x80
			movs	r12, r12, lsr #8
			biceq	r8, r8, #O_FLAG
			biceq	r8, r8, #C_FLAG
			orrne	r8, r8, #O_FLAG
			orrne	r8, r8, #C_FLAG
	.endm

.macro IMUL16	d, s
			mov		r1, \d, lsl #16
			mov		r12, \s, lsl #16
			mov		r1, r1, asr #16
			mov		r12, r12, asr #16
			mul		r1, r12, r1
			add		r12, r1, #0x8000
			movs	r12, r12, lsr #16
			biceq	r8, r8, #O_FLAG
			biceq	r8, r8, #C_FLAG
			orrne	r8, r8, #O_FLAG
			orrne	r8, r8, #C_FLAG
	.endm

.macro REGPUSH	_r, clk
			CPUWORK	\clk
			ldrh	r0, [r9, #CPU_SP]
			ldrh	r1, [r9, \_r]
			ldr		r2, [r9, #CPU_SS_BASE]
			sub		r0, r0, #2
			mov		r3, r0, lsl #16
			strh	r0, [r9, #CPU_SP]
			add		r0, r2, r3, lsr #16
			mov		lr, r11
			b		i286a_memorywrite_w
	.endm

.macro POP		clk
			ldrh	r1, [r9, #CPU_SP]
			ldr		r0, [r9, #CPU_SS_BASE]
			CPUWORK	\clk
			add		r2, r1, #2
			add		r0, r1, r0
			strh	r2, [r9, #CPU_SP]
			bl		i286a_memoryread_w
	.endm

.macro REGPOP	_r, clk
			POP		\clk
			strh	r0, [r9, \_r]
			mov		pc, r11
	.endm


	.section	.note.GNU-stack,"",%progbits
