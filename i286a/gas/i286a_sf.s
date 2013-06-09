@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

	.include 		"i286a.inc"
	.include 		"i286aea.inc"
	.include 		"i286asft.inc"

	.global i286a_ea
	.global i286a_memoryread
	.global i286a_memoryread_w
	.global i286a_memorywrite
	.global i286a_memorywrite_w

	.global i286asft8_1
	.global i286asft16_1
	.global i286asft8_cl
	.global i286asft8_d8
	.global i286asft16_cl
	.global i286asft16_d8

.text
.p2align 2

i286asft8_1:		GETPCF8
				and		r6, r0, #(7 << 3)
				cmp		r0, #0xc0
				bcc		sft8m
				CPUWORK	#2
				R8SRC	r0, r5
				add		r5, r5, #CPU_REG
				adr		r1, sft_reg8
				ldrb	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft8m:			CPUWORK	#7
				bl		i286a_ea
				cmp		r0, #I286_MEMWRITEMAX
				bcs		sft8e
				add		r5, r9, r0
				adr		r1, sft_reg8
				ldrb	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft8e:			mov		r5, r0
				bl		i286a_memoryread
				adr		r1, sft_ext8
				ldr		pc, [r1, r6, lsr #1]

sft_reg8:		.long 	rol_r8_1
				.long 	ror_r8_1
				.long 	rcl_r8_1
				.long 	rcr_r8_1
				.long 	shl_r8_1
				.long 	shr_r8_1
				.long 	shl_r8_1
				.long 	sar_r8_1

sft_ext8:		.long 	rol_e8_1
				.long 	ror_e8_1
				.long 	rcl_e8_1
				.long 	rcr_e8_1
				.long 	shl_e8_1
				.long 	shr_e8_1
				.long 	shl_e8_1
				.long 	sar_e8_1

rol_r8_1:		ROL8	r4
				strb	r1, [r5]
				mov		pc, r11
ror_r8_1:		ROR8	r4
				strb	r1, [r5]
				mov		pc, r11
rcl_r8_1:		RCL8	r4
				strb	r1, [r5]
				mov		pc, r11
rcr_r8_1:		RCR8	r4
				strb	r1, [r5]
				mov		pc, r11
shl_r8_1:		SHL8	r4
				strb	r1, [r5]
				mov		pc, r11
shr_r8_1:		SHR8	r4
				strb	r1, [r5]
				mov		pc, r11
sar_r8_1:		SAR8	r4
				strb	r1, [r5]
				mov		pc, r11

rol_e8_1:		ROL8	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
ror_e8_1:		ROR8	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
rcl_e8_1:		RCL8	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
rcr_e8_1:		RCR8	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
shl_e8_1:		SHL8	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
shr_e8_1:		SHR8	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
sar_e8_1:		SAR8	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite


@ ----

i286asft16_1:	GETPCF8
				and		r6, r0, #(7 << 3)
				cmp		r0, #0xc0
				bcc		sft16m
				CPUWORK	#2
				R16SRC	r0, r5
				add		r5, r5, #CPU_REG
				adr		r1, sft_reg16
				ldrh	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft16m:			CPUWORK	#7
				bl		i286a_ea
				ACCWORD	r0, sft16e
				add		r5, r9, r0
				adr		r1, sft_reg16
				ldrh	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft16e:			mov		r5, r0
				bl		i286a_memoryread_w
				adr		r1, sft_ext16
				ldr		pc, [r1, r6, lsr #1]

sft_reg16:		.long 	rol_r16_1
				.long 	ror_r16_1
				.long 	rcl_r16_1
				.long 	rcr_r16_1
				.long 	shl_r16_1
				.long 	shr_r16_1
				.long 	shl_r16_1
				.long 	sar_r16_1

sft_ext16:		.long 	rol_e16_1
				.long 	ror_e16_1
				.long 	rcl_e16_1
				.long 	rcr_e16_1
				.long 	shl_e16_1
				.long 	shr_e16_1
				.long 	shl_e16_1
				.long 	sar_e16_1

rol_r16_1:		ROL16	r4
				strh	r1, [r5]
				mov		pc, r11
ror_r16_1:		ROR16	r4
				strh	r1, [r5]
				mov		pc, r11
rcl_r16_1:		RCL16	r4
				strh	r1, [r5]
				mov		pc, r11
rcr_r16_1:		RCR16	r4
				strh	r1, [r5]
				mov		pc, r11
shl_r16_1:		SHL16	r4
				strh	r1, [r5]
				mov		pc, r11
shr_r16_1:		SHR16	r4
				strh	r1, [r5]
				mov		pc, r11
sar_r16_1:		SAR16	r4
				strh	r1, [r5]
				mov		pc, r11

rol_e16_1:		ROL16	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
ror_e16_1:		ROR16	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
rcl_e16_1:		RCL16	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
rcr_e16_1:		RCR16	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
shl_e16_1:		SHL16	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
shr_e16_1:		SHR16	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
sar_e16_1:		SAR16	r0
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w


@ ----

i286asft8_cl:	GETPCF8
				and		r6, r0, #(7 << 3)
				cmp		r0, #0xc0
				bcc		sft8clm
				CPUWORK	#2
				R8SRC	r0, r5
				ldrb	r0, [r9, #CPU_CL]
				ands	r0, r0, #0x1f
				moveq	pc, r11
				add		r5, r5, #CPU_REG
				adr		r1, sft_reg8cl
				ldrb	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft8clm:			CPUWORK	#7
				bl		i286a_ea
				cmp		r0, #I286_MEMWRITEMAX
				bcs		sft8cle
				add		r5, r9, r0
				ldrb	r0, [r9, #CPU_CL]
				ands	r0, r0, #0x1f
				moveq	pc, r11
				adr		r1, sft_reg8cl
				ldrb	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft8cle:			ldrb	r4, [r9, #CPU_CL]
				ands	r4, r4, #0x1f
				moveq	pc, r11
				mov		r5, r0
				bl		i286a_memoryread
				adr		r1, sft_ext8cl
				ldr		pc, [r1, r6, lsr #1]

i286asft8_d8:	GETPCF8
				and		r6, r0, #(7 << 3)
				cmp		r0, #0xc0
				bcc		sft8d8m
				CPUWORK	#2
				R8SRC	r0, r5
				GETPC8
				ands	r0, r0, #0x1f
				moveq	pc, r11
				add		r5, r5, #CPU_REG
				adr		r1, sft_reg8cl
				ldrb	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft8d8m:			CPUWORK	#7
				bl		i286a_ea
				cmp		r0, #I286_MEMWRITEMAX
				bcs		sft8d8e
				add		r5, r9, r0
				GETPC8
				ands	r0, r0, #0x1f
				moveq	pc, r11
				adr		r1, sft_reg8cl
				ldrb	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft8d8e:			mov		r5, r0
				GETPC8
				ands	r4, r0, #0x1f
				moveq	pc, r11
				mov		r0, r5
				bl		i286a_memoryread
				adr		r1, sft_ext8cl
				ldr		pc, [r1, r6, lsr #1]

sft_reg8cl:		.long 	rol_r8_cl
				.long 	ror_r8_cl
				.long 	rcl_r8_cl
				.long 	rcr_r8_cl
				.long 	shl_r8_cl
				.long 	shr_r8_cl
				.long 	shl_r8_cl
				.long 	sar_r8_cl

sft_ext8cl:		.long 	rol_e8_cl
				.long 	ror_e8_cl
				.long 	rcl_e8_cl
				.long 	rcr_e8_cl
				.long 	shl_e8_cl
				.long 	shr_e8_cl
				.long 	shl_e8_cl
				.long 	sar_e8_cl

rol_r8_cl:		ROL8CL	r4, r0
				strb	r1, [r5]
				mov		pc, r11
ror_r8_cl:		ROR8CL	r4, r0
				strb	r1, [r5]
				mov		pc, r11
rcl_r8_cl:		RCL8CL	r4, r0
				strb	r1, [r5]
				mov		pc, r11
rcr_r8_cl:		RCR8CL	r4, r0
				strb	r1, [r5]
				mov		pc, r11
shl_r8_cl:		SHL8CL	r4, r0
				strb	r1, [r5]
				mov		pc, r11
shr_r8_cl:		SHR8CL	r4, r0
				strb	r1, [r5]
				mov		pc, r11
sar_r8_cl:		SAR8CL	r4, r0
				strb	r1, [r5]
				mov		pc, r11

rol_e8_cl:		ROL8CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
ror_e8_cl:		ROR8CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
rcl_e8_cl:		RCL8CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
rcr_e8_cl:		RCR8CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
shl_e8_cl:		SHL8CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
shr_e8_cl:		SHR8CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite
sar_e8_cl:		SAR8CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite


@ ----

i286asft16_cl:	GETPCF8
				and		r6, r0, #(7 << 3)
				cmp		r0, #0xc0
				bcc		sft16clm
				CPUWORK	#5
				R16SRC	r0, r5
				ldrb	r0, [r9, #CPU_CL]
				ands	r0, r0, #0x1f
				moveq	pc, r11
				CPUWORK	r0
				add		r5, r5, #CPU_REG
				adr		r1, sft_reg16cl
				ldrh	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft16clm:		CPUWORK	#8
				bl		i286a_ea
				ACCWORD	r0, sft16cle
				add		r5, r9, r0
				ldrb	r0, [r9, #CPU_CL]
				ands	r0, r0, #0x1f
				moveq	pc, r11
				CPUWORK	r0
				adr		r1, sft_reg16cl
				ldrh	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft16cle:		ldrb	r4, [r9, #CPU_CL]
				ands	r4, r4, #0x1f
				moveq	pc, r11
				CPUWORK	r4
				mov		r5, r0
				bl		i286a_memoryread_w
				adr		r1, sft_ext16cl
				ldr		pc, [r1, r6, lsr #1]

i286asft16_d8:	GETPCF8
				and		r6, r0, #(7 << 3)
				cmp		r0, #0xc0
				bcc		sft16d8m
				CPUWORK	#5
				R16SRC	r0, r5
				GETPC8
				ands	r0, r0, #0x1f
				moveq	pc, r11
				CPUWORK	r0
				add		r5, r5, #CPU_REG
				adr		r1, sft_reg16cl
				ldrh	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft16d8m:		CPUWORK	#8
				bl		i286a_ea
				ACCWORD	r0, sft16d8e
				add		r5, r9, r0
				GETPC8
				ands	r0, r0, #0x1f
				moveq	pc, r11
				CPUWORK	r0
				adr		r1, sft_reg16cl
				ldrh	r4, [r5]
				ldr		pc, [r1, r6, lsr #1]
sft16d8e:		mov		r5, r0
				GETPC8
				ands	r4, r0, #0x1f
				moveq	pc, r11
				CPUWORK	r4
				mov		r0, r5
				bl		i286a_memoryread_w
				adr		r1, sft_ext16cl
				ldr		pc, [r1, r6, lsr #1]

sft_reg16cl:		.long 	rol_r16_cl
				.long 	ror_r16_cl
				.long 	rcl_r16_cl
				.long 	rcr_r16_cl
				.long 	shl_r16_cl
				.long 	shr_r16_cl
				.long 	shl_r16_cl
				.long 	sar_r16_cl

sft_ext16cl:		.long 	rol_e16_cl
				.long 	ror_e16_cl
				.long 	rcl_e16_cl
				.long 	rcr_e16_cl
				.long 	shl_e16_cl
				.long 	shr_e16_cl
				.long 	shl_e16_cl
				.long 	sar_e16_cl

rol_r16_cl:		ROL16CL	r4, r0
				strh	r1, [r5]
				mov		pc, r11
ror_r16_cl:		ROR16CL	r4, r0
				strh	r1, [r5]
				mov		pc, r11
rcl_r16_cl:		RCL16CL	r4, r0
				strh	r1, [r5]
				mov		pc, r11
rcr_r16_cl:		RCR16CL	r4, r0
				strh	r1, [r5]
				mov		pc, r11
shl_r16_cl:		SHL16CL	r4, r0
				strh	r1, [r5]
				mov		pc, r11
shr_r16_cl:		SHR16CL	r4, r0
				strh	r1, [r5]
				mov		pc, r11
sar_r16_cl:		SAR16CL	r4, r0
				strh	r1, [r5]
				mov		pc, r11

rol_e16_cl:		ROL16CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
ror_e16_cl:		ROR16CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
rcl_e16_cl:		RCL16CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
rcr_e16_cl:		RCR16CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
shl_e16_cl:		SHL16CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
shr_e16_cl:		SHR16CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w
sar_e16_cl:		SAR16CL	r0, r4
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w


	.section	.note.GNU-stack,"",%progbits
