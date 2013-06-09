@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

	.include 		"i286a.inc"
	.include 		"i286aea.inc"
	.include 		"i286aalu.inc"
	.include 		"i286aop.inc"

	.global i286a_ea
	.global i286a_memoryread
	.global i286a_memoryread_w
	.global i286a_memorywrite
	.global i286a_memorywrite_w
	.global i286a_localint

	.global __aeabi_uidivmod
	.global __aeabi_idivmod

	.global i286aopf6
	.global i286aopf7

.text
.p2align 2

i286aopf6:		GETPCF8
				and		r12, r0, #(7 << 3)
				adr		r1, opef6tbl
				ldr		pc, [r1, r12, lsr #1]
opef6tbl:		.long 	test_ea_d8
				.long 	test_ea_d8
				.long 	not_ea8
				.long 	neg_ea8
				.long 	mul_ea8
				.long 	imul_ea8
				.long 	div_ea8
				.long 	idiv_ea8

test_ea_d8:		cmp		r0, #0xc0
				bcc		test8m
				CPUWORK	#2
				R8SRC	r0, r5
				ldrb	r4, [r5, #CPU_REG]
				GETPC8
				AND8	r4, r0
				mov		pc, r11
test8m:			CPUWORK	#6
				bl		i286a_ea
				cmp		r0, #I286_MEMWRITEMAX
				bcs		test8e
				ldrb	r4, [r9, r0]
				GETPC8
				AND8	r4, r0
				mov		pc, r11
test8e:			bl		i286a_memoryread
				mov		r4, r0
				GETPC8
				AND8	r4, r0
				mov		pc, r11

not_ea8:			OP_EA8	NOT8, #2, #7
neg_ea8:			OP_EA8	NEG8, #2, #7

mul_ea8:			cmp		r0, #0xc0
				bcc		mul8m
				CPUWORK	#13
				R8SRC	r0, r5
				ldrb	r0, [r9, #CPU_AL]
				ldrb	r4, [r5, #CPU_REG]
				MUL8	r0, r4
				strh	r1, [r9, #CPU_AX]
				mov		pc, r11
mul8m:			CPUWORK	#16
				bl		i286a_ea
				bl		i286a_memoryread
				ldrb	r4, [r9, #CPU_AL]
				MUL8	r0, r4
				strh	r1, [r9, #CPU_AX]
				mov		pc, r11

imul_ea8:		cmp		r0, #0xc0
				bcc		imul8m
				CPUWORK	#13
				R8SRC	r0, r5
				ldrb	r0, [r9, #CPU_AL]
				ldrb	r4, [r5, #CPU_REG]
				IMUL8	r0, r4
				strh	r1, [r9, #CPU_AX]
				mov		pc, r11
imul8m:			CPUWORK	#16
				bl		i286a_ea
				bl		i286a_memoryread
				ldrb	r4, [r9, #CPU_AL]				@ ldrsb
				IMUL8	r0, r4
				strh	r1, [r9, #CPU_AX]
				mov		pc, r11

div_ea8:			mov		r6, r8
				cmp		r0, #0xc0
				bcc		div8m
				CPUWORK	#14
				R8SRC	r0, r5
				ldrb	r0, [r5, #CPU_REG]
				b		div8e
div8m:			CPUWORK	#17
				bl		i286a_ea
				bl		i286a_memoryread
div8e:			cmp		r0, #0
				beq		div8intr
				mov		r1, r0
				ldrh	r0, [r9, #CPU_AX]
				cmp		r0, r1, lsl #8
				bcs		div8intr			@ (tmp >= ((UINT16)src << 8))
				bl		__aeabi_uidivmod
				strb	r0, [r9, #CPU_AL]
				strb	r1, [r9, #CPU_AH]
				mov		pc, r11

div8intr:		sub		r8, r6, #(2 << 16)
				mov		r6, #0
				b		i286a_localint

idiv_ea8:		mov		r6, r8
				cmp		r0, #0xc0
				bcc		idiv8m
				CPUWORK	#17
				R8SRC	r0, r5
				ldrb	r0, [r5, #CPU_REG]
				b		idiv8e
idiv8m:			CPUWORK	#20
				bl		i286a_ea
				bl		i286a_memoryread
idiv8e:			movs	r0, r0, lsl #24
				beq		div8intr
				mov		r1, r0, asr #24
				ldrsh	r0, [r9, #CPU_AX]
				bl		__aeabi_idivmod
				add		r2, r0, #0x80
				movs	r2, r2, lsr #24
				bne		div8intr
				strb	r0, [r9, #CPU_AL]
				strb	r1, [r9, #CPU_AH]
				mov		pc, r11


@ ----

i286aopf7:		GETPCF8
				and		r12, r0, #(7 << 3)
				adr		r1, opef7tbl
				ldr		pc, [r1, r12, lsr #1]
opef7tbl:		.long 	test_ea_d16
				.long 	test_ea_d16
				.long 	not_ea16
				.long 	neg_ea16
				.long 	mul_ea16
				.long 	imul_ea16
				.long 	div_ea16
				.long 	idiv_ea16

test_ea_d16:		cmp		r0, #0xc0
				bcc		test16m
				CPUWORK	#2
				R16SRC	r0, r5
				ldrh	r4, [r5, #CPU_REG]
				GETPC16
				AND16	r4, r0
				mov		pc, r11
test16m:			CPUWORK	#6
				bl		i286a_ea
				tst		r0, #1
				bne		test16e
				cmp		r0, #I286_MEMWRITEMAX
				bcs		test16e
				ldrh	r4, [r9, r0]
				GETPC16
				AND16	r4, r0
				mov		pc, r11
test16e:			bl		i286a_memoryread_w
				mov		r4, r0
				GETPC16
				AND16	r4, r0
				mov		pc, r11

not_ea16:		OP_EA16	NOT16, #2, #7
neg_ea16:		OP_EA16	NEG16, #2, #7

mul_ea16:		cmp		r0, #0xc0
				bcc		mul16m
				CPUWORK	#21
				R16SRC	r0, r5
				ldrh	r0, [r9, #CPU_AX]
				ldrh	r4, [r5, #CPU_REG]
				MUL16	r0, r4
				mov		r0, r1, lsr #16
				strh	r1, [r9, #CPU_AX]
				strh	r0, [r9, #CPU_DX]
				mov		pc, r11
mul16m:			CPUWORK	#24
				bl		i286a_ea
				bl		i286a_memoryread_w
				ldrh	r4, [r9, #CPU_AX]
				MUL16	r0, r4
				mov		r0, r1, lsr #16
				strh	r1, [r9, #CPU_AX]
				strh	r0, [r9, #CPU_DX]
				mov		pc, r11

imul_ea16:		cmp		r0, #0xc0
				bcc		imul16m
				CPUWORK	#21
				R16SRC	r0, r5
				ldrh	r0, [r9, #CPU_AX]
				ldrh	r4, [r5, #CPU_REG]
				IMUL16	r0, r4
				mov		r0, r1, lsr #16
				strh	r1, [r9, #CPU_AX]
				strh	r0, [r9, #CPU_DX]
				mov		pc, r11
imul16m:			CPUWORK	#24
				bl		i286a_ea
				bl		i286a_memoryread_w
				ldrh	r4, [r9, #CPU_AX]				@ ldrsh?
				IMUL16	r0, r4
				mov		r0, r1, lsr #16
				strh	r1, [r9, #CPU_AX]
				strh	r0, [r9, #CPU_DX]
				mov		pc, r11

div_ea16:		mov		r6, r8
				cmp		r0, #0xc0
				bcc		div16m
				CPUWORK	#22
				R16SRC	r0, r5
				ldrh	r0, [r5, #CPU_REG]
				b		div16e
div16m:			CPUWORK	#25
				bl		i286a_ea
				bl		i286a_memoryread_w
div16e:			cmp		r0, #0
				beq		div16intr
				mov		r1, r0
				ldrh	r2, [r9, #CPU_DX]
				ldrh	r0, [r9, #CPU_AX]
				cmp		r2, r1
				bcs		div16intr
				add		r0, r0, r2, lsl #16
				bl		__aeabi_uidivmod
				strh	r0, [r9, #CPU_AX]
				strh	r1, [r9, #CPU_DX]
				mov		pc, r11

div16intr:		sub		r8, r6, #(2 << 16)
				mov		r6, #0
				b		i286a_localint

idiv_ea16:		mov		r6, r8
				cmp		r0, #0xc0
				bcc		idiv16m
				CPUWORK	#25
				R16SRC	r0, r5
				ldrh	r0, [r5, #CPU_REG]
				b		idiv16e
idiv16m:			CPUWORK	#28
				bl		i286a_ea
				bl		i286a_memoryread_w
idiv16e:			movs	r1, r0, lsl #16
				beq		div16intr
				ldrh	r2, [r9, #CPU_DX]
				ldrh	r0, [r9, #CPU_AX]
				mov		r1, r1, asr #16
				add		r0, r0, r2, lsl #16
				bl		__aeabi_idivmod
				add		r2, r0, #0x8000
				movs	r2, r2, lsr #16
				bne		div16intr
				strh	r0, [r9, #CPU_AX]
				strh	r1, [r9, #CPU_DX]
				mov		pc, r11


	.section	.note.GNU-stack,"",%progbits
