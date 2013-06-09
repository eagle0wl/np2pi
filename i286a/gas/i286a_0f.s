@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

	.include 		"i286a.inc"
	.include 		"i286aea.inc"
	.include 		"i286aalu.inc"

	.global i286a_selector
	.global i286a_ea
	.global i286a_a
	.global i286a_memoryread
	.global i286a_memoryread_w
	.global i286a_memorywrite
	.global i286a_memorywrite_w

	.global i286a_localint

	.global i286a_cts

.text
.p2align 2


i286a_cts:		mov		r6, r8
				GETPCF8
				cmp		r0, #0
				beq		cts_0
				cmp		r0, #1
				beq		cts_1
				cmp		r0, #5
				beq		cts_ldall

cts_intr:		sub		r8, r6, #(1 << 16)
				mov		r6, #6
				b		i286a_localint

cts_0:			ldrh	r4, [r9, #CPU_MSW]
				GETPCF8
				tst		r4, #MSW_PE
				and		r12, r0, #(7 << 3)
				beq		cts_intr
				add		pc, pc, r12, lsr #1
				nop
				b		sldt
				b		_str
				b		lldt
				b		_ltr
				b		verr
				b		verw
				b		verr
				b		verw

sldt:			cmp		r0, #0xc0
				bcc		sldtm
				CPUWORK	#2
				R16SRC	r0, r5
				ldrh	r1, [r9, #CPU_LDTR]
				strh	r1, [r5, #CPU_REG]
				mov		pc, r11
sldtm:			CPUWORK	#3
				bl		i286a_ea
				strh	r1, [r9, #CPU_LDTR]
				mov		lr, r11
				b		i286a_memorywrite_w

_str:			cmp		r0, #0xc0
				bcc		_strm
				CPUWORK	#3
				R16SRC	r0, r5
				ldrh	r1, [r9, #CPU_TR]
				strh	r1, [r5, #CPU_REG]
				mov		pc, r11
_strm:			CPUWORK	#6
				bl		i286a_ea
				strh	r1, [r9, #CPU_TR]
				mov		lr, r11
				b		i286a_memorywrite_w

lldt:			cmp		r0, #0xc0
				bcc		lldtm
				CPUWORK	#17
				R16SRC	r0, r5
				ldrh	r0, [r5, #CPU_REG]
				b		lldte
lldtm:			CPUWORK	#19
				bl		i286a_ea
				bl		i286a_memoryread_w
lldte:			strh	r0, [r9, #CPU_LDTR]
				bl		i286a_selector
				mov		r4, r0
				bl		i286a_memoryread_w
				strh	r0, [r9, #(CPU_LDTRC + 0)]
				add		r0, r4, #2
				bl		i286a_memoryread_w
				strh	r0, [r9, #(CPU_LDTRC + 2)]
				add		r0, r4, #4
				bl		i286a_memoryread
				strb	r0, [r9, #(CPU_LDTRC + 4)]
				mov		pc, r11

_ltr:			cmp		r0, #0xc0
				bcc		_ltrm
				CPUWORK	#17
				R16SRC	r0, r5
				ldrh	r0, [r5, #CPU_REG]
				b		_ltre
_ltrm:			CPUWORK	#19
				bl		i286a_ea
				bl		i286a_memoryread_w
_ltre:			strh	r0, [r9, #CPU_TR]
				bl		i286a_selector
				mov		r4, r0
				bl		i286a_memoryread_w
				strh	r0, [r9, #(CPU_TRC + 0)]
				add		r0, r4, #2
				bl		i286a_memoryread_w
				strh	r0, [r9, #(CPU_TRC + 2)]
				add		r0, r4, #4
				bl		i286a_memoryread
				strb	r0, [r9, #(CPU_TRC + 4)]
				mov		pc, r11

verr:			cmp		r0, #0xc0
				bcc		verrm
				CPUWORK	#14
				mov		pc, r11
verrm:			CPUWORK	#16
				bl		i286a_ea
				mov		pc, r11

verw:			cmp		r0, #0xc0
				bcc		verwm
				CPUWORK	#14
				mov		pc, r11
verwm:			CPUWORK	#16
				bl		i286a_ea
				mov		pc, r11


cts_1:			GETPCF8
				and		r12, r0, #(7 << 3)
				add		pc, pc, r12, lsr #1
				nop
				b		sgdt
				b		sidt
				b		lgdt
				b		lidt
				b		smsw
				b		smsw
				b		lmsw
				b		lmsw

sgdt:			cmp		r0, #0xc0
				bcs		cts_intr
				CPUWORK	#11
				bl		i286a_a
				add		r4, r0, #2
				ldrh	r1, [r9, #(CPU_GDTR + 0)]
				add		r0, r0, r6
				bic		r4, r4, #(1 << 16)
				bl		i286a_memorywrite_w
				add		r0, r4, r6
				ldrh	r1, [r9, #(CPU_GDTR + 2)]
				add		r4, r4, #2
				bl		i286a_memorywrite_w
				ldrb	r1, [r9, #(CPU_GDTR + 4)]
				bic		r4, r4, #(1 << 16)
				orr		r1, r1, #0xff00
				add		r0, r4, r6
				mov		lr, r11
				b		i286a_memorywrite_w

sidt:			cmp		r0, #0xc0
				bcs		cts_intr
				CPUWORK	#12
				bl		i286a_a
				add		r4, r0, #2
				ldrh	r1, [r9, #(CPU_IDTR + 0)]
				add		r0, r0, r6
				bic		r4, r4, #(1 << 16)
				bl		i286a_memorywrite_w
				add		r0, r4, r6
				ldrh	r1, [r9, #(CPU_IDTR + 2)]
				add		r4, r4, #2
				bl		i286a_memorywrite_w
				ldrb	r1, [r9, #(CPU_IDTR + 4)]
				bic		r4, r4, #(1 << 16)
				orr		r1, r1, #0xff00
				add		r0, r4, r6
				mov		lr, r11
				b		i286a_memorywrite_w

lgdt:			cmp		r0, #0xc0
				bcs		cts_intr
				CPUWORK	#11
				bl		i286a_a
				add		r4, r0, #2
				add		r0, r0, r6
				bic		r4, r4, #(1 << 16)
				bl		i286a_memoryread_w
				strh	r0, [r9, #(CPU_GDTR + 0)]
				add		r0, r4, r6
				add		r4, r4, #2
				bl		i286a_memoryread_w
				bic		r4, r4, #(1 << 16)
				strh	r0, [r9, #(CPU_GDTR + 2)]
				add		r0, r4, r6
				bl		i286a_memoryread_w
				strh	r0, [r9, #(CPU_GDTR + 4)]
				mov		pc, r11

lidt:			cmp		r0, #0xc0
				bcs		cts_intr
				CPUWORK	#12
				bl		i286a_a
				add		r4, r0, #2
				add		r0, r0, r6
				bic		r4, r4, #(1 << 16)
				bl		i286a_memoryread_w
				strh	r0, [r9, #(CPU_IDTR + 0)]
				add		r0, r4, r6
				add		r4, r4, #2
				bl		i286a_memoryread_w
				bic		r4, r4, #(1 << 16)
				strh	r0, [r9, #(CPU_IDTR + 2)]
				add		r0, r4, r6
				bl		i286a_memoryread_w
				strh	r0, [r9, #(CPU_IDTR + 4)]
				mov		pc, r11

smsw:			cmp		r0, #0xc0
				bcc		smswm
				CPUWORK	#3
				ldrh	r1, [r9, #CPU_MSW]
				R16SRC	r0, r5
				strh	r1, [r5, #CPU_REG]
				mov		pc, r11
smswm:			CPUWORK	#6
				bl		i286a_ea
				strh	r1, [r9, #CPU_MSW]
				mov		lr, r11
				b		i286a_memorywrite_w

lmsw:			ldrh	r6, [r9, #CPU_MSW]
				cmp		r0, #0xc0
				bcc		lmswm
				CPUWORK	#3
				R16SRC	r0, r5
				ldrh	r0, [r5, #CPU_REG]
				and		r6, r6, #MSW_PE
				orr		r0, r6, r0
				strh	r0, [r9, #CPU_MSW]
				mov		pc, r11
lmswm:			CPUWORK	#6
				bl		i286a_ea
				bl		i286a_memoryread_w
				and		r6, r6, #MSW_PE
				orr		r0, r6, r0
				strh	r0, [r9, #CPU_MSW]
				mov		pc, r11


cts_ldall:		cmp		r0, #5
				bne		cts_intr
				add		r6, r9, #0x800
				CPUWORK	#195
				ldrh	r0, [r6, #0x04]			@ MSW
				ldrh	r1, [r6, #0x16]			@ TR
				ldr		r8, [r6, #0x18]			@ IP:flag
		.if 1
				strh	r0, [r9, #CPU_MSW]
				strh	r1, [r9, #CPU_TR]
				bic		r8, r8, #0xf000
		.else
				mov		r2, #3
				strh	r0, [r9, #CPU_MSW]
				strh	r1, [r9, #CPU_TR]
				and		r2, r2, r8, lsr #8
				bic		r8, r8, #0xf000
				and		r2, r2, r2, lsr #1
				strb	r2, [r9, #CPU_TRAP]
		.endif
				ldr		r0, [r6, #0x1c]			@ DS:LDTR
				ldr		r1, [r6, #0x20]			@ CS:SS
				ldr		r2, [r6, #0x24]			@ DI:ES
				mov		r3, r0, lsr #16
				strh	r0, [r9, #CPU_LDTR]
				strh	r3, [r9, #CPU_DS]
				mov		r3, r1, lsr #16
				strh	r1, [r9, #CPU_SS]
				strh	r3, [r9, #CPU_CS]
				mov		r3, r2, lsr #16
				strh	r2, [r9, #CPU_ES]
				strh	r3, [r9, #CPU_DI]

				ldr		r0, [r6, #0x28]			@ BP:SI
				ldr		r1, [r6, #0x2c]			@ BX:SP
				ldr		r2, [r6, #0x30]			@ CX:DX
				ldr		r3, [r6, #0x34]			@ ES:AX
				mov		r12, r0, lsr #16
				strh	r0, [r9, #CPU_SI]
				strh	r12, [r9, #CPU_BP]
				mov		r12, r1, lsr #16
				strh	r1, [r9, #CPU_SP]
				strh	r12, [r9, #CPU_BX]
				mov		r12, r2, lsr #16
				strh	r2, [r9, #CPU_DX]
				strh	r12, [r9, #CPU_CX]
				mov		r0, r3, lsr #16
				strh	r3, [r9, #CPU_AX]

				ldrb	r1, [r6, #0x38]			@ ES
				ldr		r2, [r6, #0x3c]			@ CS
				ldrh	r3, [r6, #0x42]			@ SS
				ldrb	r4, [r6, #0x44]			@ SS
				ldr		r5, [r6, #0x48]			@ DS
				orr		r0, r0, r1, lsl #16
				bic		r2, r2, #(0xff << 24)
				orr		r3, r3, r4, lsl #16
				bic		r5, r5, #(0xff << 24)
				str		r0, [r9, #CPU_ES_BASE]
				str		r2, [r9, #CPU_CS_BASE]
				str		r3, [r9, #CPU_SS_BASE]
				str		r5, [r9, #CPU_DS_BASE]
				str		r3, [r9, #CPU_SS_FIX]
				str		r5, [r9, #CPU_DS_FIX]

				ldrh	r0, [r6, #0x4e]			@ GDTR.base
				ldr		r1, [r6, #0x50]			@ GDTR.limit:ar:base24
				ldr		r2, [r6, #0x54]			@ LDTRC.ar:base24:base
				ldr		r3, [r6, #0x58]			@ IDTR.base:LDTRC.limit
				mov		r4, r1, lsr #16
				strh	r4, [r9, #(CPU_GDTR + 0)]
				strh	r0, [r9, #(CPU_GDTR + 2)]
				strh	r1, [r9, #(CPU_GDTR + 4)]
				mov		r4, r2, lsr #16
				strh	r3, [r9, #(CPU_LDTRC + 0)]
				strh	r2, [r9, #(CPU_LDTRC + 2)]
				strh	r4, [r9, #(CPU_LDTRC + 4)]

				ldr		r0, [r6, #0x5c]			@ IDTR.limit:ar:base24
				ldr		r1, [r6, #0x60]			@ TRC.ar:base24:base
				ldrh	r2, [r6, #0x64]			@ TRC.limit
				mov		r3, r3, lsr #16
				mov		r4, r0, lsr #16
				strh	r4, [r9, #(CPU_IDTR + 0)]
				strh	r3, [r9, #(CPU_IDTR + 2)]
				strh	r0, [r9, #(CPU_IDTR + 4)]
				mov		r4, r1, lsr #16
				strh	r2, [r9, #(CPU_TRC + 0)]
				strh	r1, [r9, #(CPU_TRC + 2)]
				strh	r4, [r9, #(CPU_TRC + 4)]
				I286IRQCHECKTERM


	.section	.note.GNU-stack,"",%progbits
