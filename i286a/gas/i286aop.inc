@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

.macro OP_EA_R8	alu, _regclk, memclk
			EAREG8	r12
			ldrb	r6, [r12, #CPU_REG]
			cmp		r0, #0xc0
LOCAL label_1
			bcc		label_1
			R8SRC	r0, r5
			CPUWORK	\_regclk
			ldrb	r4, [r5, #CPU_REG]
			\alu	r4, r6
			strb	r1, [r5, #CPU_REG]
			mov		pc, r11
label_1:	CPUWORK	\memclk
			bl		i286a_ea
			cmp		r0, #I286_MEMWRITEMAX
LOCAL label_2
			bcs		label_2
			ldrb	r4, [r9, r0]
			\alu	r4, r6
			strb	r1, [r9, r0]
			mov		pc, r11
label_2:	mov		r5, r0
			bl		i286a_memoryread
			\alu	r0, r6
			mov		r0, r5
			mov		lr, r11
			b		i286a_memorywrite
	.endm

.macro OP_EA_R16	alu, _regclk, memclk
			EAREG16	r12
			ldrh	r6, [r12, #CPU_REG]
			cmp		r0, #0xc0
LOCAL label_1
			bcc		label_1
			CPUWORK	\_regclk
			R16SRC	r0, r5
			ldrh	r4, [r5, #CPU_REG]
			\alu	r4, r6
			strh	r1, [r5, #CPU_REG]
			mov		pc, r11
label_1:	CPUWORK	\memclk
			bl		i286a_ea
LOCAL label_2
			ACCWORD	r0, label_2
			ldrh	r4, [r9, r0]
			\alu	r4, r6
			strh	r1, [r9, r0]
			mov		pc, r11
label_2:	mov		r5, r0
			bl		i286a_memoryread_w
			\alu	r0, r6
			mov		r0, r5
			mov		lr, r11
			b		i286a_memorywrite_w
	.endm

.macro OP_R8_EA	alu, _regclk, memclk
			REG8EA	r6, \_regclk, \memclk
			ldrb	r4, [r6, #CPU_REG]
			\alu	r4, r0
			strb	r1, [r6, #CPU_REG]
			mov		pc, r11
	.endm

.macro OP_R16_EA	alu, _regclk, memclk
			REG16EA	r6, \_regclk, \memclk
			ldrh	r4, [r6, #CPU_REG]
			\alu	r4, r0
			strh	r1, [r6, #CPU_REG]
			mov		pc, r11
	.endm

.macro OP_AL_D8	alu, clk
			CPUWORK	\clk
			GETPCF8
			ldrb	r4, [r9, #CPU_AL]
			\alu	r4, r0
			strb	r1, [r9, #CPU_AL]
			mov		pc, r11
	.endm

.macro OP_AX_D16	alu, clk
			CPUWORK	\clk
			GETPC16
			ldrh	r4, [r9, #CPU_AX]
			\alu	r4, r0
			strh	r1, [r9, #CPU_AX]
			mov		pc, r11
	.endm


.macro S_EA_R8		alu, _regclk, memclk
			EAREG8	r12
			ldrb	r6, [r12, #CPU_REG]
			cmp		r0, #0xc0
LOCAL label_1
			bcc		label_1
			CPUWORK	\_regclk
			R8SRC	r0, r5
			ldrb	r4, [r5, #CPU_REG]
			\alu	r4, r6
			mov		pc, r11
label_1:	CPUWORK	\memclk
			bl		i286a_ea
			cmp		r0, #I286_MEMWRITEMAX
LOCAL label_2
			bcs		label_2
			ldrb	r4, [r9, r0]
			\alu	r4, r6
			mov		pc, r11
label_2:	bl		i286a_memoryread
			\alu	r0, r6
			mov		pc, r11
	.endm

.macro S_EA_R16	alu, _regclk, memclk
			EAREG16	r12
			ldrh	r6, [r12, #CPU_REG]
			cmp		r0, #0xc0
LOCAL label_1
			bcc		label_1
			CPUWORK	\_regclk
			R16SRC	r0, r5
			ldrh	r4, [r5, #CPU_REG]
			\alu	r4, r6
			mov		pc, r11
label_1:	CPUWORK	\memclk
			bl		i286a_ea
LOCAL label_2
			ACCWORD	r0, label_2
			ldrh	r4, [r9, r0]
			\alu	r4, r6
			mov		pc, r11
label_2:	bl		i286a_memoryread_w
			\alu	r0, r6
			mov		pc, r11
	.endm

.macro S_R8_EA		alu, _regclk, memclk
			REG8EA	r6, \_regclk, \memclk
			ldrb	r4, [r6, #CPU_REG]
			\alu	r4, r0
			mov		pc, r11
	.endm

.macro S_R16_EA	alu, _regclk, memclk
			REG16EA	r6, \_regclk, \memclk
			ldrh	r4, [r6, #CPU_REG]
			\alu	r4, r0
			mov		pc, r11
	.endm

.macro S_AL_D8		alu, clk
			CPUWORK	\clk
			GETPC8
			ldrb	r4, [r9, #CPU_AL]
			\alu	r4, r0
			mov		pc, r11
	.endm

.macro S_AX_D16	alu, clk
			CPUWORK	\clk
			GETPC16
			ldrh	r4, [r9, #CPU_AX]
			\alu	r4, r0
			mov		pc, r11
	.endm


.macro OP_EA8		alu, _regclk, memclk
			cmp		r0, #0xc0
LOCAL label_1
			bcc		label_1
			CPUWORK	\_regclk
			R8SRC	r0, r5
			ldrb	r4, [r5, #CPU_REG]
			\alu	r4
			strb	r1, [r5, #CPU_REG]
			mov		pc, r11
label_1:	CPUWORK	\memclk
			bl		i286a_ea
			cmp		r0, #I286_MEMWRITEMAX
LOCAL label_2
			bcs		label_2
			ldrb	r4, [r9, r0]
			\alu	r4
			strb	r1, [r9, r0]
			mov		pc, r11
label_2:	mov		r5, r0
			bl		i286a_memoryread
			\alu	r0
			mov		r0, r5
			mov		lr, r11
			b		i286a_memorywrite
	.endm

.macro OP_EA16		alu, _regclk, memclk
			cmp		r0, #0xc0
LOCAL label_1
			bcc		label_1
			CPUWORK	\_regclk
			R16SRC	r0, r5
			ldrh	r4, [r5, #CPU_REG]
			\alu	r4
			strh	r1, [r5, #CPU_REG]
			mov		pc, r11
label_1:	CPUWORK	\memclk
			bl		i286a_ea
LOCAL label_2
			ACCWORD	r0, label_2
			ldrh	r4, [r9, r0]
			\alu	r4
			strh	r1, [r9, r0]
			mov		pc, r11
label_2:	mov		r5, r0
			bl		i286a_memoryread_w
			\alu	r0
			mov		r0, r5
			mov		lr, r11
			b		i286a_memorywrite_w
	.endm


.macro OP_INC16	_r, clk
			CPUWORK	\clk
			ldrh	r2, [r9, \_r]
			INC16	r2
			strh	r1, [r9, \_r]
			mov		pc, r11
	.endm

.macro OP_DEC16	_r, clk
			CPUWORK	\clk
			ldrh	r2, [r9, \_r]
			DEC16	r2
			strh	r1, [r9, \_r]
			mov		pc, r11
	.endm

.macro XCHG_AX		_r, clk
			ldrh	r0, [r9, #CPU_AX]
			ldrh	r1, [r9, \_r]
			CPUWORK	\clk
			strh	r0, [r9, \_r]
			strh	r1, [r9, #CPU_AX]
			mov		pc, r11
	.endm


.macro MOVIMM8		_r, clk
			GETPCF8
			CPUWORK	\clk
			strb	r0, [r9, \_r]
			mov		pc, r11
	.endm

.macro MOVIMM16	_r, clk
			GETPCF16
			CPUWORK	\clk
			strh	r0, [r9, \_r]
			mov		pc, r11
	.endm


.macro SP_PUSH		clk
			ldrh	r1, [r9, #CPU_SP]
			ldr		r2, [r9, #CPU_SS_BASE]
			CPUWORK	\clk
			sub		r0, r1, #2
			mov		r3, r0, lsl #16
			strh	r0, [r9, #CPU_SP]
			add		r0, r2, r3, lsr #16
			mov		lr, r11
			b		i286a_memorywrite_w
	.endm

.macro SP_POP		clk
			CPUWORK	\clk
			ldrh	r0, [r9, #CPU_SP]
			ldr		r1, [r9, #CPU_SS_BASE]
			add		r0, r1, r0
			bl		i286a_memoryread_w
			strh	r0, [r9, #CPU_SP]
			mov		pc, r11
	.endm

.macro SEGPOP		s, b, clk
			ldrh	r6, [r9, #CPU_MSW]
			POP		\clk
			strh	r0, [r9, \s]
			tst		r6, #MSW_PE
			moveq	r0, r0, lsl #4
			blne	i286a_selector
			str		r0, [r9, \b]
			mov		pc, r11
	.endm

.macro SEGPOPFIX	s, b, f, clk
			ldrh	r6, [r9, #CPU_MSW]
			POP		\clk
			strh	r0, [r9, \s]
			tst		r6, #MSW_PE
			moveq	r0, r0, lsl #4
			blne	i286a_selector
			str		r0, [r9, \b]
			str		r0, [r9, \f]
	.endm


.macro JMPS		jmpclk
			CPUWORK	\jmpclk
		@;	ldr		r5, [r9, #CPU_CS_BASE]
			add		r0, r5, r8, lsr #16
			GETR0
			mov		r1, r0, lsl #24
			add		r8, r8, #(1 << 16)
			mov		r0, r1, asr #8
			add		r8, r0, r8
			mov		pc, r11
	.endm

.macro JMPNE		f, nojclk, jmpclk
			tst		r8, \f
LOCAL label_1
			bne		label_1
			CPUWORK	\nojclk
			add		r8, r8, #(1 << 16)
			mov		pc, r11
label_1:	JMPS	\jmpclk
	.endm

.macro JMPEQ		f, nojclk, jmpclk
			tst		r8, \f
LOCAL label_1
			beq		label_1
			CPUWORK	\nojclk
			add		r8, r8, #(1 << 16)
			mov		pc, r11
label_1:	JMPS	\jmpclk
	.endm


	.section	.note.GNU-stack,"",%progbits
