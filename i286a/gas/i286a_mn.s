@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

	.include 		"i286a.inc"
	.include 		"i286aea.inc"
	.include 		"i286aalu.inc"
	.include 		"i286aop.inc"
	.include 		"i286aio.inc"

	.global i286acore
	.global iflags
	.global i286a_localint
	.global i286a_trapint
	.global i286a_selector
	.global i286a_ea
	.global i286a_lea
	.global i286a_a

	.global i286a_memoryread
	.global i286a_memoryread_w
	.global i286a_memorywrite
	.global i286a_memorywrite_w

	.global iocore_inp8
	.global iocore_inp16
	.global iocore_out8
	.global iocore_out16

	.global dmax86
	.global biosfunc

	.global i286a_cts

	.global i286aop80
	.global i286aop81
	.global i286aop83

	.global i286asft8_1
	.global i286asft16_1
	.global i286asft8_cl
	.global i286asft8_d8
	.global i286asft16_cl
	.global i286asft16_d8

	.global i286aopf6
	.global i286aopf7

	.global i286aopfe
	.global i286aopff

	.global i286a_rep_insb
	.global i286a_rep_insw
	.global i286a_rep_outsb
	.global i286a_rep_outsw
	.global i286a_rep_movsb
	.global i286a_rep_movsw
	.global i286a_rep_lodsb
	.global i286a_rep_lodsw
	.global i286a_rep_stosb
	.global i286a_rep_stosw
	.global i286a_repe_cmpsb
	.global i286a_repe_cmpsw
	.global i286a_repne_cmpsb
	.global i286a_repne_cmpsw
	.global i286a_repe_scasb
	.global i286a_repe_scasw
	.global i286a_repne_scasb
	.global i286a_repne_scasw

	.global i286a
	.global i286a_step
	.global optbl1

.text
.p2align 2

add_ea_r8:		OP_EA_R8	ADD8, #2, #7
add_ea_r16:		OP_EA_R16	ADD16, #2, #7
add_r8_ea:		OP_R8_EA	ADD8, #2, #7
add_r16_ea:		OP_R16_EA	ADD16, #2, #7
add_al_d8:		OP_AL_D8	ADD8, #3
add_ax_d16:		OP_AX_D16	ADD16, #3
push_es:			REGPUSH		#CPU_ES, #3
pop_es:			SEGPOP		#CPU_ES, #CPU_ES_BASE, #5

or_ea_r8:		OP_EA_R8	OR8, #2, #7
or_ea_r16:		OP_EA_R16	OR16, #2, #7
or_r8_ea:		OP_R8_EA	OR8, #2, #7
or_r16_ea:		OP_R16_EA	OR16, #2, #7
or_al_d8:		OP_AL_D8	OR8, #3
or_ax_d16:		OP_AX_D16	OR16, #3
push_cs:			REGPUSH		#CPU_CS, #3
@ ope0f

adc_ea_r8:		OP_EA_R8	ADC8, #2, #7
adc_ea_r16:		OP_EA_R16	ADC16, #2, #7
adc_r8_ea:		OP_R8_EA	ADC8, #2, #7
adc_r16_ea:		OP_R16_EA	ADC16, #2, #7
adc_al_d8:		OP_AL_D8	ADC8, #3
adc_ax_d16:		OP_AX_D16	ADC16, #3
push_ss:			REGPUSH		#CPU_SS, #3
@ pop_ss

sbb_ea_r8:		OP_EA_R8	SBB8, #2, #7
sbb_ea_r16:		OP_EA_R16	SBB16, #2, #7
sbb_r8_ea:		OP_R8_EA	SBB8, #2, #7
sbb_r16_ea:		OP_R16_EA	SBB16, #2, #7
sbb_al_d8:		OP_AL_D8	SBB8, #3
sbb_ax_d16:		OP_AX_D16	SBB16, #3
push_ds:			REGPUSH		#CPU_DS, #3
@ pop_ds		SEGPOPFIX	#CPU_DS, #CPU_DS_BASE, #CPU_DS_FIX, #5

and_ea_r8:		OP_EA_R8	AND8, #2, #7
and_ea_r16:		OP_EA_R16	AND16, #2, #7
and_r8_ea:		OP_R8_EA	AND8, #2, #7
and_r16_ea:		OP_R16_EA	AND16, #2, #7
and_al_d8:		OP_AL_D8	AND8, #3
and_ax_d16:		OP_AX_D16	AND16, #3
@ segprefix_es		!
@ daa			*

sub_ea_r8:		OP_EA_R8	SUB8, #2, #7
sub_ea_r16:		OP_EA_R16	SUB16, #2, #7
sub_r8_ea:		OP_R8_EA	SUB8, #2, #7
sub_r16_ea:		OP_R16_EA	SUB16, #2, #7
sub_al_d8:		OP_AL_D8	SUB8, #3
sub_ax_d16:		OP_AX_D16	SUB16, #3
@ segprefix_cs		!
@ das			*

xor_ea_r8:		OP_EA_R8	XOR8, #2, #7
xor_ea_r16:		OP_EA_R16	XOR16, #2, #7
xor_r8_ea:		OP_R8_EA	XOR8, #2, #7
xor_r16_ea:		OP_R16_EA	XOR16, #2, #7
xor_al_d8:		OP_AL_D8	XOR8, #3
xor_ax_d16:		OP_AX_D16	XOR16, #3
@ segprefix_ss		!
@ aaa			*

cmp_ea_r8:		S_EA_R8		SUB8, #2, #6
cmp_ea_r16:		S_EA_R16	SUB16, #2, #6
cmp_r8_ea:		S_R8_EA		SUB8, #2, #6
cmp_r16_ea:		S_R16_EA	SUB16, #2, #6
cmp_al_d8:		S_AL_D8		SUB8, #3
cmp_ax_d16:		S_AX_D16	SUB16, #3
@ segprefix_ds		!
@ aas			*

inc_ax:			OP_INC16	#CPU_AX, #2
inc_cx:			OP_INC16	#CPU_CX, #2
inc_dx:			OP_INC16	#CPU_DX, #2
inc_bx:			OP_INC16	#CPU_BX, #2
inc_sp:			OP_INC16	#CPU_SP, #2
inc_bp:			OP_INC16	#CPU_BP, #2
inc_si:			OP_INC16	#CPU_SI, #2
inc_di:			OP_INC16	#CPU_DI, #2
dec_ax:			OP_DEC16	#CPU_AX, #2
dec_cx:			OP_DEC16	#CPU_CX, #2
dec_dx:			OP_DEC16	#CPU_DX, #2
dec_bx:			OP_DEC16	#CPU_BX, #2
dec_sp:			OP_DEC16	#CPU_SP, #2
dec_bp:			OP_DEC16	#CPU_BP, #2
dec_si:			OP_DEC16	#CPU_SI, #2
dec_di:			OP_DEC16	#CPU_DI, #2

push_ax:			REGPUSH		#CPU_AX, #3
push_cx:			REGPUSH		#CPU_CX, #3
push_dx:			REGPUSH		#CPU_DX, #3
push_bx:			REGPUSH		#CPU_BX, #3
push_sp:			SP_PUSH		#3
push_bp:			REGPUSH		#CPU_BP, #3
push_si:			REGPUSH		#CPU_SI, #3
push_di:			REGPUSH		#CPU_DI, #3
pop_ax:			REGPOP		#CPU_AX, #5
pop_cx:			REGPOP		#CPU_CX, #5
pop_dx:			REGPOP		#CPU_DX, #5
pop_bx:			REGPOP		#CPU_BX, #5
pop_sp:			SP_POP		#5
pop_bp:			REGPOP		#CPU_BP, #5
pop_si:			REGPOP		#CPU_SI, #5
pop_di:			REGPOP		#CPU_DI, #5

@ pusha			*
@ popa			*
@ bound			+
@ arpl			+
@ push_d16		*
@ imul_r_ea_d16	+
@ push_d8		*
@ imul_r_ea_d8	+
@ insb			*
@ insw			*
@ outsb			*
@ outsw			*

jo_short:		JMPNE		#O_FLAG, #3, #7
jno_short:		JMPEQ		#O_FLAG, #3, #7
jc_short:		JMPNE		#C_FLAG, #3, #7
jnc_short:		JMPEQ		#C_FLAG, #3, #7
jz_short:		JMPNE		#Z_FLAG, #3, #7
jnz_short:		JMPEQ		#Z_FLAG, #3, #7
jna_short:		JMPNE		#(Z_FLAG + C_FLAG), #3, #7
ja_short:		JMPEQ		#(Z_FLAG + C_FLAG), #3, #7
js_short:		JMPNE		#S_FLAG, #3, #7
jns_short:		JMPEQ		#S_FLAG, #3, #7
jp_short:		JMPNE		#P_FLAG, #3, #7
jnp_short:		JMPEQ		#P_FLAG, #3, #7
@ jl_short		+
@ jnl_short		+
@ jle_short		+
@ jnle_short	+

@ calc_ea8_i8	+
@ calc_ea16_i16	+
@ calc_ea16_i8	+
test_ea_r8:		S_EA_R8		AND8, #2, #6
test_ea_r16:		S_EA_R16	AND16, #2, #6
@ xchg_ea_r8	*
@ xchg_ea_r16	*
@ mov_ea_r8		*
@ mov_ea_r16	*
@ mov_r8_ea		*
@ mov_r16_ea	*
@ mov_ea_seg	+
@ lea_r16_ea	+
@ mov_seg_ea		!
@ pop_ea		*

@ nop
xchg_ax_cx:		XCHG_AX		#CPU_CX, #3
xchg_ax_dx:		XCHG_AX		#CPU_DX, #3
xchg_ax_bx:		XCHG_AX		#CPU_BX, #3
xchg_ax_sp:		XCHG_AX		#CPU_SP, #3
xchg_ax_bp:		XCHG_AX		#CPU_BP, #3
xchg_ax_si:		XCHG_AX		#CPU_SI, #3
xchg_ax_di:		XCHG_AX		#CPU_DI, #3
@ cbw			*
@ cwd			*
@ call_far		*
@ wait			*
@ pushf			*
@ popf				!
@ sahf			*
@ lahf			*

@ mov_al_m8		*
@ mov_ax_m16	*
@ mov_m8_al		*
@ mov_m16_ax	*
@ movsb			*
@ movsw			*
@ cmpsb			*
@ cmpsw			*
test_al_d8:		S_AL_D8		AND8, #3
test_ax_d16:		S_AX_D16	AND16, #3
@ stosb			*
@ stosw			*
@ lodsb			*
@ lodsw			*
@ scasb			*
@ scasw			*

mov_al_imm:		MOVIMM8		#CPU_AL, #2
mov_cl_imm:		MOVIMM8		#CPU_CL, #2
mov_dl_imm:		MOVIMM8		#CPU_DL, #2
mov_bl_imm:		MOVIMM8		#CPU_BL, #2
mov_ah_imm:		MOVIMM8		#CPU_AH, #2
mov_ch_imm:		MOVIMM8		#CPU_CH, #2
mov_dh_imm:		MOVIMM8		#CPU_DH, #2
mov_bh_imm:		MOVIMM8		#CPU_BH, #2
mov_ax_imm:		MOVIMM16	#CPU_AX, #2
mov_cx_imm:		MOVIMM16	#CPU_CX, #2
mov_dx_imm:		MOVIMM16	#CPU_DX, #2
mov_bx_imm:		MOVIMM16	#CPU_BX, #2
mov_sp_imm:		MOVIMM16	#CPU_SP, #2
mov_bp_imm:		MOVIMM16	#CPU_BP, #2
mov_si_imm:		MOVIMM16	#CPU_SI, #2
mov_di_imm:		MOVIMM16	#CPU_DI, #2

@ shift_ea8_d8
@ shift_ea16_d8
@ ret_near_d16	+
@ ret_near		+
@ les_r16_ea	+
@ lds_r16_ea	+
@ mov_ea8_d8	*
@ mov_ea16_d16	*
@ enter
@ leave			+
@ ret_far_d16	+
@ ret_far		+
@ int_03		+
@ int_d8		+
@ into			+
@ iret				!

@ shift_ea8_1
@ shift_ea16_1
@ shift_ea8_cl
@ shift_ea16_cl
@ aam			+
@ aad			*
@ setalc		*
@ xlat			*
@ esc			*

@ loopnz		*
@ loopz			*
@ loop			*
@ jcxz			*
@ in_al_d8		*
@ in_ax_d8		*
@ out_d8_al		*
@ out_d8_ax		*
@ call_near		*
@ jmp_near		*
@ jmp_far		*
jmp_short:		JMPS	#7
@ in_al_dx		*
@ in_ax_dx		*
@ out_dx_al		*
@ out_dx_ax		*

@ lock			*
@ repne				!
@ repe				!
@ hlt			+
@ cmc			*
@ ope0xf6
@ ope0xf7
@ clc			*
@ stc			*
@ cli			*
@ sti				!
@ cld			*
@ std			*
@ ope0xfe
@ ope0xff


@ ----

reserved:		mov		r6, #6
				sub		r8, r8, #(1 << 16)
				b		i286a_localint

pop_ss:			SEGPOPFIX	#CPU_SS, #CPU_SS_BASE, #CPU_SS_FIX, #5
				NEXT_OPCODE

pop_ds:			SEGPOPFIX	#CPU_DS, #CPU_DS_BASE, #CPU_DS_FIX, #5
				mov		pc, r11

daa:				ldrb	r0, [r9, #CPU_AL]
				bic		r8, r8, #O_FLAG
				CPUWORK	#3
				eor		r2, r0, #0x80
				tst		r8, #A_FLAG
				bne		daalo2
				and		r1, r0, #0x0f
				cmp		r1, #10
				bcc		daahi
				orr		r8, r8, #A_FLAG
daalo2:			add		r0, r0, #6
				orr		r8, r8, r0, lsr #8
				and		r0, r0, #0xff
daahi:			tst		r8, #C_FLAG
				bne		daahi2
				cmp		r0, #0xa0
				bcc		daaflg
				orr		r8, r8, #C_FLAG
daahi2:			add		r0, r0, #0x60
				and		r0, r0, #0xff
daaflg:			strb	r0, [r9, #CPU_AL]
				ldrb	r1, [r10, r0]
				bic		r8, r8, #(0xff - A_FLAG - C_FLAG)
				and		r2, r0, r2
				orr		r8, r1, r8
				tst		r2, #0x80
				addne	r8, r8, #O_FLAG
				mov		pc, r11

das:				CPUWORK	#3
				ldrb	r0, [r9, #CPU_AL]
				tst		r8, #C_FLAG
				bne		dashi2
				cmp		r0, #0x9a
				bcc		daslo
				orr		r8, r8, #C_FLAG
dashi2:			sub		r0, r0, #0x60
				and		r0, r0, #0xff
daslo:			tst		r8, #A_FLAG
				bne		daslo2
				and		r1, r0, #0x0f
				cmp		r1, #10
				bcc		dasflg
				orr		r8, r8, #A_FLAG
daslo2:			sub		r0, r0, #6
				orr		r8, r8, r0, lsr #31
				and		r0, r0, #0xff
dasflg:			ldrb	r1, [r10, r0]
				strb	r0, [r9, #CPU_AL]
				bic		r8, r8, #(0xff - A_FLAG - C_FLAG)
				orr		r8, r1, r8
				mov		pc, r11

aaa:				CPUWORK	#3
				ldrh	r0, [r9, #CPU_AX]
				tst		r8, #A_FLAG
				bic		r8, r8, #(A_FLAG + C_FLAG)
				bne		aaa1
				and		r1, r0, #0xf
				cmp		r1, #10
				bcc		aaa2
aaa1:			orr		r8, r8, #(A_FLAG + C_FLAG)
				add		r0, r0, #6
				add		r0, r0, #0x100
aaa2:			bic		r0, r0, #0xf0
				strh	r0, [r9, #CPU_AX]
				mov		pc, r11

aas:				CPUWORK	#3
				ldrh	r0, [r9, #CPU_AX]
				tst		r8, #A_FLAG
				bic		r8, r8, #(A_FLAG + C_FLAG)
				bne		aas1
				and		r1, r0, #0xf
				cmp		r1, #10
				movcc	pc, r11
aas1:			orr		r8, r8, #(A_FLAG + C_FLAG)
				sub		r0, r0, #6
				sub		r0, r0, #0x100
				strh	r0, [r9, #CPU_AX]
				mov		pc, r11


pusha:			ldrh	r4, [r9, #CPU_SP]
				ldr		r5, [r9, #CPU_SS_BASE]
				CPUWORK	#17
				mov		r6, r4
				mov		r4, r4, lsl #16
				sub		r4, r4, #(2 << 16)
				ldrh	r1, [r9, #CPU_AX]
				add		r0, r5, r4, lsr #16
				bl		i286a_memorywrite_w
				sub		r4, r4, #(2 << 16)
				ldrh	r1, [r9, #CPU_CX]
				add		r0, r5, r4, lsr #16
				bl		i286a_memorywrite_w
				sub		r4, r4, #(2 << 16)
				ldrh	r1, [r9, #CPU_DX]
				add		r0, r5, r4, lsr #16
				bl		i286a_memorywrite_w
				sub		r4, r4, #(2 << 16)
				ldrh	r1, [r9, #CPU_BX]
				add		r0, r5, r4, lsr #16
				bl		i286a_memorywrite_w
				mov		r1, r6
				sub		r4, r4, #(2 << 16)
				add		r0, r5, r4, lsr #16
				bl		i286a_memorywrite_w
				sub		r4, r4, #(2 << 16)
				ldrh	r1, [r9, #CPU_BP]
				add		r0, r5, r4, lsr #16
				bl		i286a_memorywrite_w
				sub		r4, r4, #(2 << 16)
				ldrh	r1, [r9, #CPU_SI]
				add		r0, r5, r4, lsr #16
				bl		i286a_memorywrite_w
				sub		r4, r4, #(2 << 16)
				ldrh	r1, [r9, #CPU_DI]
				add		r0, r5, r4, lsr #16
				bl		i286a_memorywrite_w
				mov		r0, r4, lsr #16
				strh	r0, [r9, #CPU_SP]
				mov		pc, r11

popa:			ldrh	r1, [r9, #CPU_SP]
				ldr		r5, [r9, #CPU_SS_BASE]
				CPUWORK	#19
				mov		r4, r1, lsl #16
				add		r0, r5, r1
				bl		i286a_memoryread_w
				add		r4, r4, #(2 << 16)
				strh	r0, [r9, #CPU_DI]
				add		r0, r5, r4, lsr #16
				bl		i286a_memoryread_w
				add		r4, r4, #(2 << 16)
				strh	r0, [r9, #CPU_SI]
				add		r0, r5, r4, lsr #16
				bl		i286a_memoryread_w
				add		r4, r4, #(4 << 16)
				strh	r0, [r9, #CPU_BP]
				add		r0, r5, r4, lsr #16
				bl		i286a_memoryread_w
				add		r4, r4, #(2 << 16)
				strh	r0, [r9, #CPU_BX]
				add		r0, r5, r4, lsr #16
				bl		i286a_memoryread_w
				add		r4, r4, #(2 << 16)
				strh	r0, [r9, #CPU_DX]
				add		r0, r5, r4, lsr #16
				bl		i286a_memoryread_w
				add		r4, r4, #(2 << 16)
				strh	r0, [r9, #CPU_CX]
				add		r0, r5, r4, lsr #16
				bl		i286a_memoryread_w
				add		r4, r4, #(2 << 16)
				strh	r0, [r9, #CPU_AX]
				mov		r0, r4, lsr #16
				strh	r0, [r9, #CPU_SP]
				mov		pc, r11

bound:			GETPCF8
				cmp		r0, #0xc0
				bcs		bndreg
				R16DST	r0, r12
				CPUWORK	#13
				ldrh	r5, [r12, #CPU_REG]
				bl		i286a_a
				add		r4, r0, #2
				add		r0, r0, r6
				bl		i286a_memoryread_w
				cmp		r5, r0
				bcc		bndout
				bic		r4, r4, #(1 << 16)
				add		r0, r4, r6
				bl		i286a_memoryread_w
				cmp		r5, r0
				movls	pc, r11
bndout:			mov		r6, #5
				b		i286a_localint
bndreg:			mov		r6, #6
				sub		r8, r8, #(2 << 16)
				b		i286a_localint

push_d16:		CPUWORK	#3
				GETPC16
				ldrh	r2, [r9, #CPU_SP]
				ldr		r3, [r9, #CPU_SS_BASE]
				mov		r1, r0
				subs	r2, r2, #2
				addcc	r2, r2, #0x10000
				strh	r2, [r9, #CPU_SP]
				add		r0, r2, r3
				mov		lr, r11
				b		i286a_memorywrite_w

imul_r_ea_d16:	REG16EA	r6, #21, #24
				mov		r4, r0, lsl #16
				GETPC16
				mov		r0, r0, lsl #16
				mov		r4, r4, asr #16
				mov		r0, r0, asr #16
				mul		r1, r0, r4
				add		r12, r1, #0x8000
				strh	r1, [r6, #CPU_REG]
				movs	r12, r12, lsr #16
				biceq	r8, r8, #O_FLAG
				biceq	r8, r8, #C_FLAG
				orrne	r8, r8, #O_FLAG
				orrne	r8, r8, #C_FLAG
				mov		pc, r11

push_d8:			CPUWORK	#3
				GETPCF8
				ldrh	r2, [r9, #CPU_SP]
				ldr		r3, [r9, #CPU_SS_BASE]
				mov		r0, r0, lsl #24
				subs	r2, r2, #2
				addcc	r2, r2, #0x10000
				mov		r1, r0, asr #24
				strh	r2, [r9, #CPU_SP]
				add		r0, r2, r3
				mov		lr, r11
				b		i286a_memorywrite_w

imul_r_ea_d8:	REG16EA	r6, #21, #24
				mov		r4, r0, lsl #16
				GETPC8
				mov		r0, r0, lsl #24
				mov		r4, r4, asr #16
				mov		r0, r0, asr #24
				mul		r1, r0, r4
				add		r12, r1, #0x8000
				strh	r1, [r6, #CPU_REG]
				movs	r12, r12, lsr #16
				biceq	r8, r8, #O_FLAG
				biceq	r8, r8, #C_FLAG
				orrne	r8, r8, #O_FLAG
				orrne	r8, r8, #C_FLAG
				mov		pc, r11

insb:			CPUWORK	#5
				ldrh	r0, [r9, #CPU_DX]
				CPUSV
				bl		iocore_inp8
				ldrh	r2, [r9, #CPU_DI]
				ldr		r3, [r9, #CPU_ES_BASE]
				CPULD
				mov		r1, r0
				add		r0, r3, r2
				tst		r8, #D_FLAG
				addeq	r2, r2, #1
				subne	r2, r2, #1
				mov		lr, r11
				strh	r2, [r9, #CPU_DI]
				b		i286a_memorywrite

insw:			CPUWORK	#5
				ldrh	r0, [r9, #CPU_DX]
				CPUSV
				bl		iocore_inp16
				ldrh	r2, [r9, #CPU_DI]
				ldr		r3, [r9, #CPU_ES_BASE]
				CPULD
				mov		r1, r0
				add		r0, r3, r2
				tst		r8, #D_FLAG
				addeq	r2, r2, #2
				subne	r2, r2, #2
				mov		lr, r11
				strh	r2, [r9, #CPU_DI]
				b		i286a_memorywrite_w

outsb:			CPUWORK	#3
				ldrh	r1, [r9, #CPU_SI]
				ldr		r2, [r9, #CPU_DS_FIX]
				tst		r8, #D_FLAG
				addeq	r3, r1, #1
				subne	r3, r1, #1
				add		r0, r2, r1
				strh	r3, [r9, #CPU_SI]
				bl		i286a_memoryread
				mov		r1, r0
				ldr		r0, [r9, #CPU_DX]
				CPUSV
				bl		iocore_out8
				CPULD
				mov		pc, r11

outsw:			CPUWORK	#3
				ldrh	r1, [r9, #CPU_SI]
				ldr		r2, [r9, #CPU_DS_FIX]
				tst		r8, #D_FLAG
				addeq	r3, r1, #2
				subne	r3, r1, #2
				add		r0, r2, r1
				strh	r3, [r9, #CPU_SI]
				bl		i286a_memoryread_w
				mov		r1, r0
				ldr		r0, [r9, #CPU_DX]
				CPUSV
				bl		iocore_out16
				CPULD
				mov		pc, r11

jle_short:		tst		r8, #Z_FLAG
				bne		jmps
jl_short:		eor		r0, r8, r8, lsr #4
				tst		r0, #S_FLAG
				bne		jmps
nojmps:			CPUWORK	#3
				add		r8, r8, #(1 << 16)
				mov		pc, r11

jnle_short:		tst		r8, #Z_FLAG
				bne		nojmps
jnl_short:		eor		r0, r8, r8, lsr #4
				tst		r0, #S_FLAG
				bne		nojmps
jmps:			JMPS	#7


xchg_ea_r8:		EAREG8	r6
				cmp		r0, #0xc0
				bcc		xchgear8_1
				R8SRC	r0, r2
				ldrb	r0, [r6, #CPU_REG]
				ldrb	r1, [r2, #CPU_REG]
				CPUWORK	#3
				strb	r0, [r2, #CPU_REG]
				strb	r1, [r6, #CPU_REG]
				mov		pc, r11
xchgear8_1:		bl		i286a_ea
				cmp		r0, #I286_MEMWRITEMAX
				bcs		xchgear8_2
				ldrb	r1, [r6, #CPU_REG]
				ldrb	r4, [r9, r0]
				CPUWORK	#5
				strb	r1, [r9, r0]
				strb	r4, [r6, #CPU_REG]
				mov		pc, r11
xchgear8_2:		mov		r5, r0
				bl		i286a_memoryread
				ldrb	r1, [r6, #CPU_REG]
				strb	r0, [r6, #CPU_REG]
				CPUWORK	#5
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite

xchg_ea_r16:		EAREG16	r6
				cmp		r0, #0xc0
				bcc		xchgear16_1
				R16SRC	r0, r2
				ldrh	r0, [r6, #CPU_REG]
				ldrh	r1, [r2, #CPU_REG]
				CPUWORK	#3
				strh	r0, [r2, #CPU_REG]
				strh	r1, [r6, #CPU_REG]
				mov		pc, r11
xchgear16_1:		bl		i286a_ea
				ACCWORD	r0, xchgear16_2
				ldrh	r1, [r6, #CPU_REG]
				ldrh	r4, [r9, r0]
				CPUWORK	#5
				strh	r1, [r9, r0]
				strh	r4, [r6, #CPU_REG]
				mov		pc, r11
xchgear16_2:		mov		r5, r0
				bl		i286a_memoryread_w
				ldrh	r1, [r6, #CPU_REG]
				strh	r0, [r6, #CPU_REG]
				CPUWORK	#5
				mov		r0, r5
				mov		lr, r11
				b		i286a_memorywrite_w

mov_ea_r8:		EAREG8	r6
				cmp		r0, #0xc0
				bcc		movear8_1
				ldrb	r1, [r6, #CPU_REG]
				R8SRC	r0, r2
				CPUWORK	#3
				strb	r1, [r2, #CPU_REG]
				mov		pc, r11
movear8_1:		CPUWORK	#5
				bl		i286a_ea
				ldrb	r1, [r6, #CPU_REG]
				mov		lr, r11
				b		i286a_memorywrite

mov_ea_r16:		EAREG16	r6
				cmp		r0, #0xc0
				bcc		movear16_1
				ldrh	r1, [r6, #CPU_REG]
				R16SRC	r0, r2
				CPUWORK	#3
				strh	r1, [r2, #CPU_REG]
				mov		pc, r11
movear16_1:		CPUWORK	#5
				bl		i286a_ea
				ldrh	r1, [r6, #CPU_REG]
				mov		lr, r11
				b		i286a_memorywrite_w

mov_r8_ea:		REG8EA	r6, #2, #5
				strb	r0, [r6, #CPU_REG]
				mov		pc, r11

mov_r16_ea:		REG16EA	r6, #2, #5
				strh	r0, [r6, #CPU_REG]
				mov		pc, r11

mov_ea_seg:		GETPCF8
				and		r1, r0, #(3 << 3)
				add		r1, r9, r1, lsr #2
				ldrh	r6, [r1, #CPU_SEG]
				cmp		r0, #0xc0
				bcc		measegm
				R16SRC	r0, r2
				CPUWORK	#2
				strh	r6, [r2, #CPU_REG]
				mov		pc, r11
measegm:			CPUWORK	#3
				bl		i286a_ea
				mov		r1, r6
				mov		lr, r11
				b		i286a_memorywrite_w

lea_r16_ea:		CPUWORK	#3
				GETPCF8
				cmp		r0, #0xc0
				bcs		leareg
				R16DST	r0, r6
				bl		i286a_lea
				strh	r0, [r6, #CPU_REG]
				mov		pc, r11
leareg:			mov		r6, #6
				sub		r8, r8, #(2 << 16)
				b		i286a_localint

mov_seg_ea:		ldrb	r6, [r9, #CPU_MSW]
				GETPCF8
				adr		r2, msegea_tbl
				and		r1, r0, #(3 << 3)
				tst		r6, #MSW_PE
				orrne	r1, r1, #(4 << 3)
				mov		r6, r8
				ldr		r2, [r2, r1, lsr #1]
				cmp		r0, #0xc0
				bcc		msegeam
				R16SRC	r0, r4
				CPUWORK	#2
				ldrh	r0, [r4, #CPU_REG]
				mov		pc, r2
msegeam:			str		r2, [sp, #-4]!
				CPUWORK	#5
				bl		i286a_ea
				ldr		lr, [sp], #4
				b		i286a_memoryread_w
msegea_tbl:		.long 	msegea_es
				.long 	msegea_cs
				.long 	msegea_ss
				.long 	msegea_ds
				.long 	msegea_es_p
				.long 	msegea_cs
				.long 	msegea_ss_p
				.long 	msegea_ds_p
msegea_es:		mov		r1, r0, lsl #4
				strh	r0, [r9, #CPU_ES]
				str		r1, [r9, #CPU_ES_BASE]
				mov		pc, r11
msegea_ds:		mov		r1, r0, lsl #4
				strh	r0, [r9, #CPU_DS]
				str		r1, [r9, #CPU_DS_BASE]
				str		r1, [r9, #CPU_DS_FIX]
				mov		pc, r11
msegea_ss:		mov		r1, r0, lsl #4
				strh	r0, [r9, #CPU_SS]
				str		r1, [r9, #CPU_SS_BASE]
				str		r1, [r9, #CPU_SS_FIX]
				NEXT_OPCODE

msegea_es_p:		strh	r0, [r9, #CPU_ES]
				bl		i286a_selector
				str		r0, [r9, #CPU_ES_BASE]
				mov		pc, r11
msegea_ds_p:		strh	r0, [r9, #CPU_DS]
				bl		i286a_selector
				str		r0, [r9, #CPU_DS_BASE]
				str		r0, [r9, #CPU_DS_FIX]
				mov		pc, r11
msegea_ss_p:		strh	r0, [r9, #CPU_SS]
				bl		i286a_selector
				str		r0, [r9, #CPU_SS_BASE]
				str		r0, [r9, #CPU_SS_FIX]
				NEXT_OPCODE

msegea_cs:		sub		r8, r6, #(2 << 16)
				mov		r6, #6
				b		i286a_localint


pop_ea:			POP		#5
				mov		r6, r0
				GETPCF8
				cmp		r0, #0xc0
				bcs		popreg
				bl		i286a_ea
				mov		r1, r6
				mov		lr, r11
				b		i286a_memorywrite_w
popreg:			R16SRC	r0, r1
				strh	r4, [r1, #CPU_REG]
				mov		pc, r11


nopandbios:		sub		r0, r8, #(1 << 16)
				CPUWORK	#3
			@;	ldr		r5, [r9, #CPU_CS_BASE]
				add		r0, r5, r0, lsr #16
				cmp		r0, #0x0f8000
				movcc	pc, r11
				cmp		r0, #0x100000
				movcs	pc, r11
				CPUSV
				bl		biosfunc
				CPULD
				ldrh	r0, [r9, #CPU_ES]
				ldrh	r1, [r9, #CPU_CS]
				ldrh	r2, [r9, #CPU_SS]
				ldrh	r3, [r9, #CPU_DS]
				mov		r0, r0, lsl #4
				mov		r1, r1, lsl #4
				mov		r2, r2, lsl #4
				mov		r3, r3, lsl #4
				str		r0, [r9, #CPU_ES_BASE]
				str		r1, [r9, #CPU_CS_BASE]
				str		r2, [r9, #CPU_SS_BASE]
				str		r3, [r9, #CPU_DS_BASE]
				str		r2, [r9, #CPU_SS_FIX]
				str		r3, [r9, #CPU_DS_FIX]
				mov		pc, r11

cbw:				ldrb	r0, [r9, #CPU_AL]
				CPUWORK	#2
				mov		r1, r0, lsl #24
				mov		r0, r1, asr #31
				strb	r0, [r9, #CPU_AH]
				mov		pc, r11

cwd:				ldrb	r0, [r9, #CPU_AH]
				CPUWORK	#2
				mov		r1, r0, lsl #24
				mov		r0, r1, asr #31
				strh	r0, [r9, #CPU_DX]
				mov		pc, r11

call_far:		CPUWORK	#13
				ldrh	r4, [r9, #CPU_SP]
				ldrh	r1, [r9, #CPU_CS]
				ldr		r5, [r9, #CPU_SS_BASE]
				mov		r4, r4, lsl #16
				sub		r4, r4, #(2 << 16)
				add		r0, r5, r4, lsr #16
				bl		i286a_memorywrite_w			@ cs
				sub		r4, r4, #(2 << 16)
				add		r12, r8, #(4 << 16)
				mov		r4, r4, lsr #16
				mov		r1, r12, lsr #16
				add		r0, r4, r5
				ldr		r5, [r9, #CPU_CS_BASE]
				bl		i286a_memorywrite_w			@ ip
				strh	r4, [r9, #CPU_SP]
				add		r0, r5, r8, lsr #16
				bl		i286a_memoryread_w			@ newip
				add		r8, r8, #(2 << 16)
				mov		r4, r0, lsl #16
				add		r0, r5, r8, lsr #16
				ldrb	r5, [r9, #CPU_MSW]
				bl		i286a_memoryread_w
				strh	r0, [r9, #CPU_CS]
				tst		r5, #MSW_PE
				moveq	r0, r0, lsl #4
				blne	i286a_selector
				str		r0, [r9, #CPU_CS_BASE]
				mov		r0, r8, lsl #16
				orr		r8, r4, r0, lsr #16
				mov		pc, r11

wait:			CPUWORK	#2
				mov		pc, r11

pushf:			CPUWORK	#3
				ldrh	r3, [r9, #CPU_SP]
				ldr		r2, [r9, #CPU_SS_BASE]
				mov		r1, r8
				subs	r3, r3, #2
				addcc	r3, r3, #0x10000
				strh	r3, [r9, #CPU_SP]
				add		r0, r3, r2
				mov		lr, r11
				b		i286a_memorywrite_w

popf:			POP		#5
		.if 1
				mov		r8, r8, lsr #16
				bic		r1, r0, #0xf000					@ i286
				and		r2, r0, #(I_FLAG + T_FLAG)
				orr		r8, r1, r8, lsl #16
				cmp		r2, #(I_FLAG + T_FLAG)
				beq		popf_withirq
		.else
				mov		r2, #3
				mov		r8, r8, lsr #16
				and		r2, r2, r0, lsr #8
				bic		r1, r0, #0xf000					@ i286
				ands	r2, r2, r2, lsr #1
				orr		r8, r1, r8, lsl #16
				strb	r2, [r9, #CPU_TRAP]
				bne		popf_withirq
		.endif
				ldr		r0, popf_pic
				NOINTREXIT
popf_withirq:	I286IRQCHECKTERM
popf_pic:		.long 	pic

sahf:			ldrb	r0, [r9, #CPU_AH]
				CPUWORK	#2
				bic		r8, r8, #0xff
				orr		r8, r8, r0
				mov		pc, r11

lahf:			CPUWORK	#2
				strb	r8, [r9, #CPU_AH]
				mov		pc, r11


mov_al_m8:		CPUWORK	#5
				ldr		r6, [r9, #CPU_DS_FIX]
				GETPC16
				add		r0, r0, r6
				bl		i286a_memoryread
				strb	r0, [r9, #CPU_AL]
				mov		pc, r11

mov_ax_m16:		CPUWORK	#5
				ldr		r6, [r9, #CPU_DS_FIX]
				GETPC16
				add		r0, r0, r6
				bl		i286a_memoryread_w
				strh	r0, [r9, #CPU_AX]
				mov		pc, r11

mov_m8_al:		CPUWORK	#5
				ldr		r6, [r9, #CPU_DS_FIX]
				GETPC16
				ldrb	r1, [r9, #CPU_AL]
				add		r0, r0, r6
				mov		lr, r11
				b		i286a_memorywrite

mov_m16_ax:		CPUWORK	#5
				ldr		r6, [r9, #CPU_DS_FIX]
				GETPC16
				ldrh	r1, [r9, #CPU_AX]
				add		r0, r0, r6
				mov		lr, r11
				b		i286a_memorywrite_w

movsb:			CPUWORK	#5
				ldrh	r6, [r9, #CPU_SI]
				ldr		r0, [r9, #CPU_DS_FIX]
				tst		r8, #D_FLAG
				moveq	r4, #1
				movne	r4, #-1
				add		r0, r6, r0
				bl		i286a_memoryread
				ldrh	r3, [r9, #CPU_DI]
				ldr		r2, [r9, #CPU_ES_BASE]
				add		r6, r6, r4
				mov		r1, r0
				add		r0, r3, r2
				add		r3, r3, r4
				strh	r6, [r9, #CPU_SI]
				strh	r3, [r9, #CPU_DI]
				mov		lr, r11
				b		i286a_memorywrite

movsw:			CPUWORK	#5
				ldrh	r6, [r9, #CPU_SI]
				ldr		r0, [r9, #CPU_DS_FIX]
				tst		r8, #D_FLAG
				moveq	r4, #2
				movne	r4, #-2
				add		r0, r6, r0
				bl		i286a_memoryread_w
				ldrh	r3, [r9, #CPU_DI]
				ldr		r2, [r9, #CPU_ES_BASE]
				add		r6, r6, r4
				mov		r1, r0
				add		r0, r3, r2
				add		r3, r3, r4
				strh	r6, [r9, #CPU_SI]
				strh	r3, [r9, #CPU_DI]
				mov		lr, r11
				b		i286a_memorywrite_w

cmpsb:			ldrh	r5, [r9, #CPU_SI]
				ldr		r0, [r9, #CPU_DS_FIX]
				ldr		r4, [r9, #CPU_ES_BASE]
				CPUWORK	#8
				add		r0, r0, r5
				bl		i286a_memoryread
				ldrh	r3, [r9, #CPU_DI]
				mov		r6, r0
				and		r12, r8, #D_FLAG
				mov		r12, r12, lsr #(10 - 1)
				add		r0, r3, r4
				rsb		r2, r12, #1
				add		r5, r2, r5
				add		r3, r2, r3
				strh	r5, [r9, #CPU_SI]
				strh	r3, [r9, #CPU_DI]
				bl		i286a_memoryread
				SUB8	r6, r0
				mov		pc, r11

cmpsw:			ldrh	r5, [r9, #CPU_SI]
				ldr		r0, [r9, #CPU_DS_FIX]
				ldr		r4, [r9, #CPU_ES_BASE]
				CPUWORK	#8
				add		r0, r0, r5
				bl		i286a_memoryread_w
				ldrh	r3, [r9, #CPU_DI]
				mov		r6, r0
				and		r12, r8, #D_FLAG
				mov		r12, r12, lsr #(10 - 2)
				add		r0, r3, r4
				rsb		r2, r12, #2
				add		r5, r2, r5
				add		r3, r2, r3
				strh	r5, [r9, #CPU_SI]
				strh	r3, [r9, #CPU_DI]
				bl		i286a_memoryread_w
				SUB16	r6, r0
				mov		pc, r11

stosb:			CPUWORK	#3
				ldrb	r1, [r9, #CPU_AL]
				ldrh	r2, [r9, #CPU_DI]
				ldr		r0, [r9, #CPU_ES_BASE]
				tst		r8, #D_FLAG
				addeq	r3, r2, #1
				subne	r3, r2, #1
				add		r0, r2, r0
				strh	r3, [r9, #CPU_DI]
				mov		lr, r11
				b		i286a_memorywrite

stosw:			CPUWORK	#3
				ldrh	r1, [r9, #CPU_AX]
				ldrh	r2, [r9, #CPU_DI]
				ldr		r0, [r9, #CPU_ES_BASE]
				tst		r8, #D_FLAG
				addeq	r3, r2, #2
				subne	r3, r2, #2
				add		r0, r2, r0
				strh	r3, [r9, #CPU_DI]
				mov		lr, r11
				b		i286a_memorywrite_w

lodsb:			CPUWORK	#5
				ldrh	r5, [r9, #CPU_SI]
				ldr		r0, [r9, #CPU_DS_FIX]
				tst		r8, #D_FLAG
				addeq	r6, r5, #1
				subne	r6, r5, #1
				add		r0, r5, r0
				bl		i286a_memoryread
				strb	r0, [r9, #CPU_AL]
				strh	r6, [r9, #CPU_SI]
				mov		pc, r11

lodsw:			CPUWORK	#5
				ldrh	r5, [r9, #CPU_SI]
				ldr		r0, [r9, #CPU_DS_FIX]
				tst		r8, #D_FLAG
				addeq	r6, r5, #2
				subne	r6, r5, #2
				add		r0, r5, r0
				bl		i286a_memoryread_w
				strh	r0, [r9, #CPU_AX]
				strh	r6, [r9, #CPU_SI]
				mov		pc, r11

scasb:			CPUWORK	#7
				ldrh	r5, [r9, #CPU_DI]
				ldr		r0, [r9, #CPU_ES_BASE]
				tst		r8, #D_FLAG
				addeq	r6, r5, #1
				subne	r6, r5, #1
				add		r0, r5, r0
				bl		i286a_memoryread
				ldrb	r5, [r9, #CPU_AL]
				strh	r6, [r9, #CPU_DI]
				SUB8	r5, r0
				mov		pc, r11

scasw:			CPUWORK	#7
				ldrh	r5, [r9, #CPU_DI]
				ldr		r0, [r9, #CPU_ES_BASE]
				tst		r8, #D_FLAG
				addeq	r6, r5, #2
				subne	r6, r5, #2
				add		r0, r5, r0
				bl		i286a_memoryread_w
				ldrh	r5, [r9, #CPU_AX]
				strh	r6, [r9, #CPU_DI]
				SUB16	r5, r0
				mov		pc, r11


ret_near_d16:	GETPC16
				ldrh	r1, [r9, #CPU_SP]
				ldr		r2, [r9, #CPU_SS_BASE]
				CPUWORK	#11
				add		r3, r0, r1
				add		r0, r1, r2
				add		r3, r3, #2
				strh	r3, [r9, #CPU_SP]
				bl		i286a_memoryread_w
				mov		r8, r8, lsl #16
				mov		r8, r8, lsr #16
				orr		r8, r8, r0, lsl #16
				mov		pc, r11

ret_near:		CPUWORK	#11
				ldrh	r1, [r9, #CPU_SP]
				ldr		r0, [r9, #CPU_SS_BASE]
				mov		r8, r8, lsl #16
				add		r2, r1, #2
				add		r0, r1, r0
				strh	r2, [r9, #CPU_SP]
				mov		r8, r8, lsr #16
				bl		i286a_memoryread_w
				orr		r8, r8, r0, lsl #16
				mov		pc, r11

les_r16_ea:		GETPCF8
				cmp		r0, #0xc0
				bcs		lr16_r
				CPUWORK	#3
				R16DST	r0, r5
				bl		i286a_a
				add		r4, r0, #2
				add		r0, r0, r6
				bic		r4, r4, #(1 << 16)
				bl		i286a_memoryread_w
				strh	r0, [r5, #CPU_REG]
				add		r0, r4, r6
				ldrb	r4, [r9, #CPU_MSW]
				bl		i286a_memoryread_w
				strh	r0, [r9, #CPU_ES]
				tst		r4, #MSW_PE
				moveq	r0, r0, lsl #4
				blne	i286a_selector
				str		r0, [r9, #CPU_ES_BASE]
				mov		pc, r11
lr16_r:			mov		r6, #6
				sub		r8, r8, #(2 << 16)
				b		i286a_localint

lds_r16_ea:		GETPCF8
				cmp		r0, #0xc0
				bcs		lr16_r
				CPUWORK	#3
				R16DST	r0, r5
				bl		i286a_a
				add		r4, r0, #2
				add		r0, r0, r6
				bic		r4, r4, #(1 << 16)
				bl		i286a_memoryread_w
				strh	r0, [r5, #CPU_REG]
				add		r0, r4, r6
				ldrb	r4, [r9, #CPU_MSW]
				bl		i286a_memoryread_w
				strh	r0, [r9, #CPU_DS]
				tst		r4, #MSW_PE
				moveq	r0, r0, lsl #4
				blne	i286a_selector
				str		r0, [r9, #CPU_DS_BASE]
				str		r0, [r9, #CPU_DS_FIX]
				mov		pc, r11

mov_ea8_d8:		GETPCF8
				cmp		r0, #0xc0
				bcs		med8_r
				CPUWORK	#3
				bl		i286a_ea
				mov		r4, r0
				GETPCF8
				mov		r1, r0
				mov		r0, r4
				mov		lr, r11
				b		i286a_memorywrite
med8_r:			CPUWORK	#2
				R8DST	r0, r4
				GETPCF8
				strb	r0, [r4, #CPU_REG]
				mov		pc, r11

mov_ea16_d16:	GETPCF8
				cmp		r0, #0xc0
				bcs		med16_r
				CPUWORK	#3
				bl		i286a_ea
				mov		r4, r0
				GETPC16
				mov		r1, r0
				mov		r0, r4
				mov		lr, r11
				b		i286a_memorywrite_w
med16_r:			CPUWORK	#2
				R16DST	r0, r4
				GETPC16
				strh	r0, [r4, #CPU_REG]
				mov		pc, r11

enter:			ldrh	r4, [r9, #CPU_SP]
				ldrh	r5, [r9, #CPU_BP]
				ldr		r0, [r9, #CPU_SS_BASE]
				subs	r4, r4, #2
				addcc	r4, r4, #0x10000
				mov		r1, r5
				add		r0, r4, r0
				bl		i286a_memorywrite_w
				GETPC16
				mov		r6, r0
				GETPC8
				ands	r0, r0, #0x1f
				bne		enterlv1
				CPUWORK	#11
				sub		r0, r4, r6
				strh	r4, [r9, #CPU_BP]
				strh	r0, [r9, #CPU_SP]
				mov		pc, r11
enterlv1:		cmp		r0, #1
				bne		enterlv2
				CPUWORK	#15
				strh	r4, [r9, #CPU_BP]
				ldr		r0, [r9, #CPU_SS_BASE]
				mov		r1, r4
				subs	r4, r4, #2
				addcc	r4, r4, #0x10000
				add		r0, r4, r0
				sub		r2, r4, r6
				mov		lr, r11
				strh	r2, [r9, #CPU_SP]
				bl		i286a_memorywrite_w
enterlv2:		mov		r1, r0, lsl #2
				add		r1, r1, #(12 + 4)
				CPUWORK	r1
				strh	r4, [r9, #CPU_BP]
				str		r11, [sp, #-4]!
				mov		r4, r4, lsl #16
				sub		r2, r4, r0, lsl #17
				sub		r2, r4, #(2 << 16)
				mov		r2, r2, lsr #16
				sub		r3, r2, r6
				strh	r3, [r9, #CPU_SP]
				mov		r6, r0
				ldr		r11, [r9, #CPU_SS_BASE]
				mov		r1, r5
				mov		r5, r5, lsl #16
				add		r0, r11, r2
				bl		i286a_memorywrite_w
entlv2lp:		sub		r5, r5, #(2 << 16)
				sub		r4, r4, #(2 << 16)
				add		r0, r11, r5, lsr #16
				bl		i286a_memoryread_w
				mov		r1, r0
				add		r0, r11, r4
				bl		i286a_memorywrite_w
				subs	r6, r6, #1
				bne		entlv2lp
				ldr		pc, [sp], #4

leave:			ldrh	r1, [r9, #CPU_BP]
				ldr		r0, [r9, #CPU_SS_BASE]
				CPUWORK	#5
				add		r4, r1, #2
				add		r0, r0, r1
				bl		i286a_memoryread_w
				strh	r4, [r9, #CPU_SP]
				strh	r0, [r9, #CPU_BP]
				mov		pc, r11

ret_far_d16:		GETPC16
				ldrh	r4, [r9, #CPU_SP]
				ldr		r5, [r9, #CPU_SS_BASE]
				mov		r6, r0
				CPUWORK	#15
				add		r0, r5, r4
				add		r4, r4, #2
				bl		i286a_memoryread_w
				mov		r8, r8, lsl #16
				mov		r8, r8, lsr #16
				orr		r8, r8, r0, lsl #16
				bic		r4, r4, #(1 << 16)
				add		r0, r4, r5
				add		r4, r4, #2
				bl		i286a_memoryread_w
				add		r4, r6, r4
				ldrb	r1, [r9, #CPU_MSW]
				strh	r4, [r9, #CPU_SP]
				strh	r0, [r9, #CPU_CS]
				tst		r1, #MSW_PE
				moveq	r0, r0, lsl #4
				blne	i286a_selector
				str		r0, [r9, #CPU_CS_BASE]
				mov		pc, r11

ret_far:			ldrh	r1, [r9, #CPU_SP]
				ldr		r5, [r9, #CPU_SS_BASE]
				CPUWORK	#15
				add		r4, r1, #2
				add		r0, r5, r1
				bl		i286a_memoryread_w
				mov		r8, r8, lsl #16
				mov		r8, r8, lsr #16
				orr		r8, r8, r0, lsl #16
				bic		r4, r4, #(1 << 16)
				add		r0, r4, r5
				add		r4, r4, #2
				bl		i286a_memoryread_w
				ldrb	r1, [r9, #CPU_MSW]
				strh	r4, [r9, #CPU_SP]
				strh	r0, [r9, #CPU_CS]
				tst		r1, #MSW_PE
				moveq	r0, r0, lsl #4
				blne	i286a_selector
				str		r0, [r9, #CPU_CS_BASE]
				mov		pc, r11

int_03:			CPUWORK	#3
				mov		r6, #3
				b		i286a_localint

int_d8:			CPUWORK	#3
				GETPCF8
				mov		r6, r0
				b		i286a_localint

into:			CPUWORK	#4
				tst		r8, #O_FLAG
				moveq	pc, r11
				mov		r6, #4
				b		i286a_localint

iret:			ldrh	r1, [r9, #CPU_SP]
				ldr		r5, [r9, #CPU_SS_BASE]
				CPUWORK	#31
				add		r4, r1, #2
				add		r0, r5, r1
				bl		i286a_memoryread_w
				bic		r4, r4, #(1 << 16)
				mov		r8, r0, lsl #16
				add		r0, r4, r5
				add		r4, r4, #2
				bl		i286a_memoryread_w
				mov		r1, r0, lsl #4
				strh	r0, [r9, #CPU_CS]
				str		r1, [r9, #CPU_CS_BASE]
				bic		r4, r4, #(1 << 16)
				add		r0, r4, r5
				add		r4, r4, #2
				bl		i286a_memoryread_w
				strh	r4, [r9, #CPU_SP]
		.if 1
				bic		r1, r0, #0xf000
				and		r2, r0, #(I_FLAG + T_FLAG)
				orr		r8, r1, r8
				cmp		r2, #(I_FLAG + T_FLAG)
				beq		iret_withirq
		.else
				mov		r2, #3
				bic		r1, r0, #0xf000					@ i286
				and		r2, r2, r0, lsr #8
				orr		r8, r1, r8
				ands	r2, r2, r2, lsr #1
				strb	r2, [r9, #CPU_TRAP]
				bne		iret_withirq
		.endif
				ldr		r0, iret_pic
				NOINTREXIT
iret_withirq:	I286IRQCHECKTERM
iret_pic:		.long 	pic


aam:				CPUWORK	#16
				GETPCF8
				movs	r0, r0, lsl #7
				beq		aamzero
				ldrb	r1, [r9, #CPU_AL]
				mov		r2, #0x80
				mov		r3, #0
aamlp:			cmp		r1, r0
				subcs	r1, r1, r0
				orrcs	r3, r2, r3
				mov		r0, r0, lsr #1
				movs	r2, r2, lsr #1
				bne		aamlp
				ldrb	r2, [r10, r1]
				add		r1, r1, r3, lsl #8
				bic		r8, r8, #(S_FLAG + Z_FLAG + P_FLAG)
				movs	r3, r1, lsl #16
				orreq	r8, r8, #Z_FLAG
				orrmi	r8, r8, #S_FLAG
				and		r2, r2, #P_FLAG
				orr		r8, r2, r8
				strh	r1, [r9, #CPU_AX]
				mov		pc, r11
aamzero:			sub		r8, r8, #(2 << 16)
				mov		r6, #0
				b		i286a_localint

aad:				ldrh	r6, [r9, #CPU_AX]
				GETPCF8
				mov		r2, r6, lsr #8
				mla		r3, r2, r0, r6
				bic		r8, r8, #(S_FLAG + Z_FLAG + P_FLAG)
				and		r1, r3, #0xff
				ldrb	r2, [r1, r10]
				strh	r1, [r9, #CPU_AX]
				CPUWORK	#14
				orr		r8, r2, r8
				mov		pc, r11

setalc:			CPUWORK	#2
				mov		r0, r8, lsr #31
				mov		r0, r0, asr #31
				strb	r0, [r9, #CPU_AL]
				mov		pc, r11

xlat:			ldrb	r0, [r9, #CPU_AL]
				ldrh	r1, [r9, #CPU_BX]
				ldr		r2, [r9, #CPU_DS_FIX]
				CPUWORK	#5
				add		r0, r1, r0
				bic		r0, r0, #(1 << 16)
				add		r0, r2, r0
				bl		i286a_memoryread
				strb	r0, [r9, #CPU_AL]
				mov		pc, r11

esc:				CPUWORK	#2
				GETPCF8
				cmp		r0, #0xc0
				movcs	pc, r11
				mov		lr, r11
				b		i286a_ea


loopnz:			ldrh	r0, [r9, #CPU_CX]
				@
				@
				subs	r0, r0, #1
				strh	r0, [r9, #CPU_CX]
				beq		lpnznoj
				tst		r8, #Z_FLAG
				bne		lpnznoj
				JMPS	#8
lpnznoj:			CPUWORK	#4
				add		r8, r8, #(1 << 16)
				mov		pc, r11

loopz:			ldrh	r0, [r9, #CPU_CX]
				@
				@
				subs	r0, r0, #1
				strh	r0, [r9, #CPU_CX]
				beq		lpznoj
				tst		r8, #Z_FLAG
				beq		lpznoj
				JMPS	#8
lpznoj:			CPUWORK	#4
				add		r8, r8, #(1 << 16)
				mov		pc, r11

loop:			ldrh	r0, [r9, #CPU_CX]
				@
				@
				subs	r0, r0, #1
				strh	r0, [r9, #CPU_CX]
				beq		lpnoj
				JMPS	#8
lpnoj:			CPUWORK	#4
				add		r8, r8, #(1 << 16)
				mov		pc, r11

jcxz:			ldrh	r0, [r9, #CPU_CX]
				@
				@
				cmp		r0, #0
				beq		jcxzj
				CPUWORK	#4
				add		r8, r8, #(1 << 16)
				mov		pc, r11
jcxzj:			JMPS	#8

in_al_d8:		GETPCF8
				CPUWORK	#5
				add		r3, r5, r8, lsr #16
				CPUSV
				str		r3, [r9, #CPU_INPUT]
				bl		iocore_inp8
				CPULD
				mov		r3, #0
				strb	r0, [r9, #CPU_AL]
				str		r3, [r9, #CPU_INPUT]
				mov		pc, r11

in_ax_d8:		CPUWORK	#5
				GETPCF8
				CPUSV
				bl		iocore_inp16
				CPULD
				strh	r0, [r9, #CPU_AX]
				mov		pc, r11

out_d8_al:		CPUWORK	#3
				GETPCF8
				ldrb	r1, [r9, #CPU_AL]
				CPUSV
				bl		iocore_out8
				CPULD
				mov		pc, r11

out_d8_ax:		CPUWORK	#3
				GETPCF8
				ldrh	r1, [r9, #CPU_AX]
				CPUSV
				bl		iocore_out16
				CPULD
				mov		pc, r11

call_near:		GETPC16
				ldrh	r2, [r9, #CPU_SP]
				ldr		r3, [r9, #CPU_SS_BASE]
				CPUWORK	#7
				sub		r1, r2, #2
				mov		r2, r1, lsl #16
				strh	r1, [r9, #CPU_SP]
				mov		r1, r8, lsr #16
				add		r8, r8, r0, lsl #16
				add		r0, r3, r2, lsr #16
				mov		lr, r11
				b		i286a_memorywrite_w

jmp_near:		ldr		r4, [r9, #CPU_CS_BASE]
				add		r5, r8, #(2 << 16)
				CPUWORK	#7
				add		r0, r4, r8, lsr #16
				bl		i286a_memoryread_w
				add		r8, r5, r0, lsl #16
				mov		pc, r11

jmp_far:			CPUWORK	#11
				ldr		r4, [r9, #CPU_CS_BASE]
				add		r5, r8, #(2 << 16)
				mov		r6, r8, lsl #16
				add		r0, r4, r8, lsr #16
				bl		i286a_memoryread_w
				mov		r8, r0, lsl #16
				add		r0, r4, r5, lsr #16
				bl		i286a_memoryread_w
				ldrb	r1, [r9, #CPU_MSW]
				add		r8, r8, r6, lsr #16
				strh	r0, [r9, #CPU_CS]
				tst		r1, #MSW_PE
				moveq	r0, r0, lsl #4
				blne	i286a_selector
				str		r0, [r9, #CPU_CS_BASE]
				mov		pc, r11

in_al_dx:		CPUWORK	#5
				ldrh	r0, [r9, #CPU_DX]
				CPUSV
				bl		iocore_inp8
				CPULD
				strb	r0, [r9, #CPU_AL]
				mov		pc, r11

in_ax_dx:		CPUWORK	#5
				ldrh	r0, [r9, #CPU_DX]
				CPUSV
				bl		iocore_inp16
				CPULD
				strh	r0, [r9, #CPU_AX]
				mov		pc, r11

out_dx_al:		CPUWORK	#3
				ldrb	r1, [r9, #CPU_AL]
				ldrh	r0, [r9, #CPU_DX]
				CPUSV
				bl		iocore_out8
				CPULD
				mov		pc, r11

out_dx_ax:		CPUWORK	#3
				ldrh	r1, [r9, #CPU_AX]
				ldrh	r0, [r9, #CPU_DX]
				CPUSV
				bl		iocore_out16
				CPULD
				mov		pc, r11


lock:			CPUWORK	#2
				mov		pc, r11

hlt:				CREMSET	#-1
				sub		r8, r8, #(1 << 16)
				mov		pc, r11

cmc:				CPUWORK	#2
				eor		r8, r8, #C_FLAG
				mov		pc, r11

clc:				CPUWORK	#2
				bic		r8, r8, #C_FLAG
				mov		pc, r11

stc:				CPUWORK	#2
				orr		r8, r8, #C_FLAG
				mov		pc, r11

cli:				CPUWORK	#2
		.if 1
				bic		r8, r8, #I_FLAG
		.else
				mov		r0, #0
				bic		r8, r8, #I_FLAG
				strb	r0, [r9, #CPU_TRAP]
		.endif
				mov		pc, r11

sti:				CPUWORK	#2
				tst		r8, #I_FLAG
				bne		sti_noirq
sti_set:			orr		r8, r8, #I_FLAG
		.if 1
				ldr		r0, sti_pic
				tst		r8, #T_FLAG
				bne		sti_withirq
		.else
				mov		r1, #(T_FLAG >> 8)
				ands	r1, r1, r8, lsr #8
				ldr		r0, sti_pic
				strneb	r1, [r9, #CPU_TRAP]
				bne		sti_withirq
		.endif
				PICEXISTINTR
				bne		sti_withirq
sti_noirq:		NEXT_OPCODE
sti_pic:			.long 	pic
sti_withirq:		REMAIN_ADJUST	#1

cld:				CPUWORK	#2
				bic		r8, r8, #D_FLAG
				mov		pc, r11

std:				CPUWORK	#2
				orr		r8, r8, #D_FLAG
				mov		pc, r11


@ ---- cpu execute

i286a_step:		stmdb	sp!, {r4 - r11, lr}
				ldr		r9, ias_r9
				ldr		r10, ias_r10
				@
				ldr		r5, [r9, #CPU_CS_BASE]
				CPULD

				adr		r4, optbl1
				add		r0, r5, r8, lsr #16
				bl		i286a_memoryread
				ldr		r1, [r4, r0, lsl #2]
				add		r8, r8, #(1 << 16)
				mov		r11, pc
				mov		pc, r1

				bl		dmax86
				CPUSV
				ldmia	sp!, {r4 - r11, pc}


i286a:			stmdb	sp!, {r4 - r11, lr}
				ldr		r9, ias_r9
				ldr		r2, ias_r1
				ldr		r10, ias_r10
				CPULD
				ldr		r5, [r9, #CPU_CS_BASE]
				ldrb	r1, [r2, #DMAC_WORKING]
				and		r0, r8, #(I_FLAG + T_FLAG)
				cmp		r0, #(I_FLAG + T_FLAG)
				beq		i286awithtrap
				cmp		r1, #0
				bne		i286awithdma
i286a_lp:		adr		r4, optbl1
				add		r0, r5, r8, lsr #16
				GETR0
				ldr		r1, [r4, r0, lsl #2]
				add		r8, r8, #(1 << 16)
				mov		r11, pc
				mov		pc, r1
				CPUDBGL
				cmp		r7, #0
				ldrgt	r5, [r9, #CPU_CS_BASE]
				bgt		i286a_lp
				CPUSV
				ldmia	sp!, {r4 - r11, pc}

ias_r9:			.long 	i286acore + CPU_SIZE
ias_r1:			.long 	dmac
ias_r10:			.long 	iflags

i286awithdma:	adr		r4, optbl1
				add		r0, r5, r8, lsr #16
				GETR0
				ldr		r1, [r4, r0, lsl #2]
				add		r8, r8, #(1 << 16)
				mov		r11, pc
				mov		pc, r1
				bl		dmax86
				CPUDBGL
				cmp		r7, #0
				ldrgt	r5, [r9, #CPU_CS_BASE]
				bgt		i286awithdma
				CPUSV
				ldmia	sp!, {r4 - r11, pc}

i286awithtrap:	adr		r4, optbl1
				add		r0, r5, r8, lsr #16
				GETR0
				ldr		r1, [r4, r0, lsl #2]
				add		r8, r8, #(1 << 16)
				mov		r11, pc
				mov		pc, r1
				bl		dmax86
				and		r0, r8, #(I_FLAG + T_FLAG)
				cmp		r0, #(I_FLAG + T_FLAG)
				bleq	i286a_trapint
				CPUSV
				ldmia	sp!, {r4 - r11, pc}

optbl1:			.long 	add_ea_r8			@ 00
				.long 	add_ea_r16
				.long 	add_r8_ea
				.long 	add_r16_ea
				.long 	add_al_d8
				.long 	add_ax_d16
				.long 	push_es
				.long 	pop_es
				.long 	or_ea_r8
				.long 	or_ea_r16
				.long 	or_r8_ea
				.long 	or_r16_ea
				.long 	or_al_d8
				.long 	or_ax_d16
				.long 	push_cs
				.long 	i286a_cts

				.long 	adc_ea_r8			@ 10
				.long 	adc_ea_r16
				.long 	adc_r8_ea
				.long 	adc_r16_ea
				.long 	adc_al_d8
				.long 	adc_ax_d16
				.long 	push_ss
				.long 	pop_ss
				.long 	sbb_ea_r8
				.long 	sbb_ea_r16
				.long 	sbb_r8_ea
				.long 	sbb_r16_ea
				.long 	sbb_al_d8
				.long 	sbb_ax_d16
				.long 	push_ds
				.long 	pop_ds

				.long 	and_ea_r8			@ 20
				.long 	and_ea_r16
				.long 	and_r8_ea
				.long 	and_r16_ea
				.long 	and_al_d8
				.long 	and_ax_d16
				.long 		segprefix_es
				.long 		daa
				.long 	sub_ea_r8
				.long 	sub_ea_r16
				.long 	sub_r8_ea
				.long 	sub_r16_ea
				.long 	sub_al_d8
				.long 	sub_ax_d16
				.long 		segprefix_cs
				.long 		das

				.long 	xor_ea_r8			@ 30
				.long 	xor_ea_r16
				.long 	xor_r8_ea
				.long 	xor_r16_ea
				.long 	xor_al_d8
				.long 	xor_ax_d16
				.long 		segprefix_ss
				.long 		aaa
				.long 	cmp_ea_r8
				.long 	cmp_ea_r16
				.long 	cmp_r8_ea
				.long 	cmp_r16_ea
				.long 	cmp_al_d8
				.long 	cmp_ax_d16
				.long 		segprefix_ds
				.long 		aas

				.long 	inc_ax				@ 40
				.long 	inc_cx
				.long 	inc_dx
				.long 	inc_bx
				.long 	inc_sp
				.long 	inc_bp
				.long 	inc_si
				.long 	inc_di
				.long 	dec_ax
				.long 	dec_cx
				.long 	dec_dx
				.long 	dec_bx
				.long 	dec_sp
				.long 	dec_bp
				.long 	dec_si
				.long 	dec_di

				.long 	push_ax				@ 50
				.long 	push_cx
				.long 	push_dx
				.long 	push_bx
				.long 	push_sp
				.long 	push_bp
				.long 	push_si
				.long 	push_di
				.long 	pop_ax
				.long 	pop_cx
				.long 	pop_dx
				.long 	pop_bx
				.long 	pop_sp
				.long 	pop_bp
				.long 	pop_si
				.long 	pop_di

				.long 	pusha				@ 60
				.long 	popa
				.long 		bound
				.long 	reserved			@ arpl(reserved)
				.long 	reserved
				.long 	reserved
				.long 	reserved
				.long 	reserved
				.long 		push_d16
				.long 		imul_r_ea_d16
				.long 		push_d8
				.long 		imul_r_ea_d8
				.long 		insb
				.long 		insw
				.long 	outsb
				.long 	outsw

				.long 	jo_short			@ 70
				.long 	jno_short
				.long 	jc_short
				.long 	jnc_short
				.long 	jz_short
				.long 	jnz_short
				.long 	jna_short
				.long 	ja_short
				.long 	js_short
				.long 	jns_short
				.long 	jp_short
				.long 	jnp_short
				.long 		jl_short
				.long 		jnl_short
				.long 		jle_short
				.long 		jnle_short

				.long 	i286aop80			@ 80
				.long 	i286aop81
				.long 	i286aop80
				.long 	i286aop83
				.long 	test_ea_r8
				.long 	test_ea_r16
				.long 	xchg_ea_r8
				.long 	xchg_ea_r16
				.long 	mov_ea_r8
				.long 	mov_ea_r16
				.long 	mov_r8_ea
				.long 	mov_r16_ea
				.long 		mov_ea_seg
				.long 		lea_r16_ea
				.long 		mov_seg_ea
				.long 		pop_ea

				.long 	nopandbios			@ 90
				.long 	xchg_ax_cx
				.long 	xchg_ax_dx
				.long 	xchg_ax_bx
				.long 	xchg_ax_sp
				.long 	xchg_ax_bp
				.long 	xchg_ax_si
				.long 	xchg_ax_di
				.long 	cbw
				.long 	cwd
				.long 	call_far
				.long 	wait
				.long 		pushf
				.long 		popf
				.long 	sahf
				.long 	lahf

				.long 	mov_al_m8			@ a0
				.long 	mov_ax_m16
				.long 	mov_m8_al
				.long 	mov_m16_ax
				.long 	movsb
				.long 	movsw
				.long 		cmpsb
				.long 		cmpsw
				.long 	test_al_d8
				.long 	test_ax_d16
				.long 	stosb
				.long 	stosw
				.long 	lodsb
				.long 	lodsw
				.long 	scasb
				.long 	scasw

				.long 	mov_al_imm			@ b0
				.long 	mov_cl_imm
				.long 	mov_dl_imm
				.long 	mov_bl_imm
				.long 	mov_ah_imm
				.long 	mov_ch_imm
				.long 	mov_dh_imm
				.long 	mov_bh_imm
				.long 	mov_ax_imm
				.long 	mov_cx_imm
				.long 	mov_dx_imm
				.long 	mov_bx_imm
				.long 	mov_sp_imm
				.long 	mov_bp_imm
				.long 	mov_si_imm
				.long 	mov_di_imm

				.long 	i286asft8_d8		@ c0
				.long 	i286asft16_d8
				.long 		ret_near_d16
				.long 	ret_near
				.long 			les_r16_ea
				.long 			lds_r16_ea
				.long 		mov_ea8_d8
				.long 		mov_ea16_d16
				.long 	enter
				.long 	leave
				.long 		ret_far_d16
				.long 	ret_far
				.long 	int_03
				.long 	int_d8
				.long 	into
				.long 		iret

				.long 	i286asft8_1			@ d0
				.long 	i286asft16_1
				.long 	i286asft8_cl
				.long 	i286asft16_cl
				.long 		aam
				.long 		aad
				.long 		setalc
				.long 		xlat
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc

				.long 	loopnz				@ e0
				.long 	loopz
				.long 	loop
				.long 	jcxz
				.long 		in_al_d8
				.long 		in_ax_d8
				.long 	out_d8_al
				.long 	out_d8_ax
				.long 	call_near
				.long 	jmp_near
				.long 	jmp_far
				.long 	jmp_short
				.long 		in_al_dx
				.long 		in_ax_dx
				.long 	out_dx_al
				.long 	out_dx_ax

				.long 	lock				@ f0
				.long 	lock
				.long 		repne
				.long 		repe
				.long 	hlt
				.long 	cmc
				.long 		i286aopf6
				.long 		i286aopf7
				.long 	clc
				.long 	stc
				.long 	cli
				.long 		sti
				.long 	cld
				.long 	std
				.long 	i286aopfe
				.long 		i286aopff


.macro SEGPREFIX	b
			ldr		r1, [r9, \b]
			ldrb	r6, [r9, #CPU_PREFIX]
		@;	ldr		r5, [r9, #CPU_CS_BASE]
			add		r0, r5, r8, lsr #16
			str		r1, [r9, #CPU_SS_FIX]
			str		r1, [r9, #CPU_DS_FIX]
			cmp		r6, #0
			streq	r11, [sp, #-4]!
			adreq	r11, prefix1_remove
			add		r6, r6, #1
			cmp		r6, #MAX_PREFIX
			bcs		prefix_fault
			GETR0
			ldr		r1, [r4, r0, lsl #2]
			add		r8, r8, #(1 << 16)
			strb	r6, [r9, #CPU_PREFIX]
			mov		pc, r1
	.endm

segprefix_es:	SEGPREFIX	#CPU_ES_BASE
segprefix_cs:	SEGPREFIX	#CPU_CS_BASE
segprefix_ss:	SEGPREFIX	#CPU_SS_BASE
segprefix_ds:	SEGPREFIX	#CPU_DS_BASE

prefix_fault:	sub		r8, r8, #((MAX_PREFIX - 1) << 16)
				mov		r6, #6
				mov		r11, pc
				b		i286a_localint
prefix1_remove:	ldr		r0, [r9, #CPU_SS_BASE]
				ldr		r1, [r9, #CPU_DS_BASE]
				mov		r2, #0
				str		r0, [r9, #CPU_SS_FIX]
				str		r1, [r9, #CPU_DS_FIX]
				strb	r2, [r9, #CPU_PREFIX]
				ldr		pc, [sp], #4


@ ---- repne

repne:			ldrb	r6, [r9, #CPU_PREFIX]
				adr		r4, optblne
			@;	ldr		r5, [r9, #CPU_CS_BASE]
				add		r0, r5, r8, lsr #16
				cmp		r6, #0
				streq	r11, [sp, #-4]!
				adreq	r11, prefix1_remove
				add		r6, r6, #1
				cmp		r6, #MAX_PREFIX
				bcs		prefix_fault
				GETR0
				ldr		r1, [r4, r0, lsl #2]
				add		r8, r8, #(1 << 16)
				strb	r6, [r9, #CPU_PREFIX]
				mov		pc, r1

optblne:			.long 	add_ea_r8			@ 00
				.long 	add_ea_r16
				.long 	add_r8_ea
				.long 	add_r16_ea
				.long 	add_al_d8
				.long 	add_ax_d16
				.long 	push_es
				.long 	pop_es
				.long 	or_ea_r8
				.long 	or_ea_r16
				.long 	or_r8_ea
				.long 	or_r16_ea
				.long 	or_al_d8
				.long 	or_ax_d16
				.long 	push_cs
				.long 	i286a_cts

				.long 	adc_ea_r8			@ 10
				.long 	adc_ea_r16
				.long 	adc_r8_ea
				.long 	adc_r16_ea
				.long 	adc_al_d8
				.long 	adc_ax_d16
				.long 	push_ss
				.long 	pop_ss
				.long 	sbb_ea_r8
				.long 	sbb_ea_r16
				.long 	sbb_r8_ea
				.long 	sbb_r16_ea
				.long 	sbb_al_d8
				.long 	sbb_ax_d16
				.long 	push_ds
				.long 	pop_ds

				.long 	and_ea_r8			@ 20
				.long 	and_ea_r16
				.long 	and_r8_ea
				.long 	and_r16_ea
				.long 	and_al_d8
				.long 	and_ax_d16
				.long 	segprefix_es
				.long 	daa
				.long 	sub_ea_r8
				.long 	sub_ea_r16
				.long 	sub_r8_ea
				.long 	sub_r16_ea
				.long 	sub_al_d8
				.long 	sub_ax_d16
				.long 	segprefix_cs
				.long 	das

				.long 	xor_ea_r8			@ 30
				.long 	xor_ea_r16
				.long 	xor_r8_ea
				.long 	xor_r16_ea
				.long 	xor_al_d8
				.long 	xor_ax_d16
				.long 	segprefix_ss
				.long 	aaa
				.long 	cmp_ea_r8
				.long 	cmp_ea_r16
				.long 	cmp_r8_ea
				.long 	cmp_r16_ea
				.long 	cmp_al_d8
				.long 	cmp_ax_d16
				.long 	segprefix_ds
				.long 	aas

				.long 	inc_ax				@ 40
				.long 	inc_cx
				.long 	inc_dx
				.long 	inc_bx
				.long 	inc_sp
				.long 	inc_bp
				.long 	inc_si
				.long 	inc_di
				.long 	dec_ax
				.long 	dec_cx
				.long 	dec_dx
				.long 	dec_bx
				.long 	dec_sp
				.long 	dec_bp
				.long 	dec_si
				.long 	dec_di

				.long 	push_ax				@ 50
				.long 	push_cx
				.long 	push_dx
				.long 	push_bx
				.long 	push_sp
				.long 	push_bp
				.long 	push_si
				.long 	push_di
				.long 	pop_ax
				.long 	pop_cx
				.long 	pop_dx
				.long 	pop_bx
				.long 	pop_sp
				.long 	pop_bp
				.long 	pop_si
				.long 	pop_di

				.long 	pusha				@ 60
				.long 	popa
				.long 	bound
				.long 	reserved			@ arpl(reserved)
				.long 	reserved
				.long 	reserved
				.long 	reserved
				.long 	reserved
				.long 	push_d16
				.long 	imul_r_ea_d16
				.long 	push_d8
				.long 	imul_r_ea_d8
				.long 		i286a_rep_insb
				.long 		i286a_rep_insw
				.long 		i286a_rep_outsb
				.long 		i286a_rep_outsw

				.long 	jo_short			@ 70
				.long 	jno_short
				.long 	jc_short
				.long 	jnc_short
				.long 	jz_short
				.long 	jnz_short
				.long 	jna_short
				.long 	ja_short
				.long 	js_short
				.long 	jns_short
				.long 	jp_short
				.long 	jnp_short
				.long 	jl_short
				.long 	jnl_short
				.long 	jle_short
				.long 	jnle_short

				.long 	i286aop80			@ 80
				.long 	i286aop81
				.long 	i286aop80
				.long 	i286aop83
				.long 	test_ea_r8
				.long 	test_ea_r16
				.long 	xchg_ea_r8
				.long 	xchg_ea_r16
				.long 	mov_ea_r8
				.long 	mov_ea_r16
				.long 	mov_r8_ea
				.long 	mov_r16_ea
				.long 	mov_ea_seg
				.long 	lea_r16_ea
				.long 	mov_seg_ea
				.long 	pop_ea

				.long 	nopandbios			@ 90
				.long 	xchg_ax_cx
				.long 	xchg_ax_dx
				.long 	xchg_ax_bx
				.long 	xchg_ax_sp
				.long 	xchg_ax_bp
				.long 	xchg_ax_si
				.long 	xchg_ax_di
				.long 	cbw
				.long 	cwd
				.long 	call_far
				.long 	wait
				.long 	pushf
				.long 	popf
				.long 	sahf
				.long 	lahf

				.long 	mov_al_m8			@ a0
				.long 	mov_ax_m16
				.long 	mov_m8_al
				.long 	mov_m16_ax
				.long 	i286a_rep_movsb
				.long 	i286a_rep_movsw
				.long 		i286a_repne_cmpsb
				.long 		i286a_repne_cmpsw
				.long 	test_al_d8
				.long 	test_ax_d16
				.long 		i286a_rep_stosb
				.long 		i286a_rep_stosw
				.long 		i286a_rep_lodsb
				.long 		i286a_rep_lodsw
				.long 		i286a_repne_scasb
				.long 		i286a_repne_scasw

				.long 	mov_al_imm			@ b0
				.long 	mov_cl_imm
				.long 	mov_dl_imm
				.long 	mov_bl_imm
				.long 	mov_ah_imm
				.long 	mov_ch_imm
				.long 	mov_dh_imm
				.long 	mov_bh_imm
				.long 	mov_ax_imm
				.long 	mov_cx_imm
				.long 	mov_dx_imm
				.long 	mov_bx_imm
				.long 	mov_sp_imm
				.long 	mov_bp_imm
				.long 	mov_si_imm
				.long 	mov_di_imm

				.long 	i286asft8_d8		@ c0
				.long 	i286asft16_d8
				.long 	ret_near_d16
				.long 	ret_near
				.long 	les_r16_ea
				.long 	lds_r16_ea
				.long 	mov_ea8_d8
				.long 	mov_ea16_d16
				.long 	enter
				.long 	leave
				.long 	ret_far_d16
				.long 	ret_far
				.long 	int_03
				.long 	int_d8
				.long 	into
				.long 	iret

				.long 	i286asft8_1			@ d0
				.long 	i286asft16_1
				.long 	i286asft8_cl
				.long 	i286asft16_cl
				.long 	aam
				.long 	aad
				.long 	setalc
				.long 	xlat
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc

				.long 	loopnz				@ e0
				.long 	loopz
				.long 	loop
				.long 	jcxz
				.long 	in_al_d8
				.long 	in_ax_d8
				.long 	out_d8_al
				.long 	out_d8_ax
				.long 	call_near
				.long 	jmp_near
				.long 	jmp_far
				.long 	jmp_short
				.long 	in_al_dx
				.long 	in_ax_dx
				.long 	out_dx_al
				.long 	out_dx_ax

				.long 	lock				@ f0
				.long 	lock
				.long 	repne
				.long 	repe
				.long 	hlt
				.long 	cmc
				.long 	i286aopf6
				.long 	i286aopf7
				.long 	clc
				.long 	stc
				.long 	cli
				.long 	sti
				.long 	cld
				.long 	std
				.long 	i286aopfe
				.long 	i286aopff

@ ---- repe

repe:			ldrb	r6, [r9, #CPU_PREFIX]
				adr		r4, optble
			@;	ldr		r5, [r9, #CPU_CS_BASE]
				add		r0, r5, r8, lsr #16
				cmp		r6, #0
				streq	r11, [sp, #-4]!
				adreq	r11, prefix2_remove
				add		r6, r6, #1
				cmp		r6, #MAX_PREFIX
				bcs		prefix_fault
				GETR0
				ldr		r1, [r4, r0, lsl #2]
				add		r8, r8, #(1 << 16)
				strb	r6, [r9, #CPU_PREFIX]
				mov		pc, r1

prefix2_remove:	ldr		r0, [r9, #CPU_SS_BASE]
				ldr		r1, [r9, #CPU_DS_BASE]
				mov		r2, #0
				str		r0, [r9, #CPU_SS_FIX]
				str		r1, [r9, #CPU_DS_FIX]
				strb	r2, [r9, #CPU_PREFIX]
				ldr		pc, [sp], #4

optble:			.long 	add_ea_r8			@ 00
				.long 	add_ea_r16
				.long 	add_r8_ea
				.long 	add_r16_ea
				.long 	add_al_d8
				.long 	add_ax_d16
				.long 	push_es
				.long 	pop_es
				.long 	or_ea_r8
				.long 	or_ea_r16
				.long 	or_r8_ea
				.long 	or_r16_ea
				.long 	or_al_d8
				.long 	or_ax_d16
				.long 	push_cs
				.long 	i286a_cts

				.long 	adc_ea_r8			@ 10
				.long 	adc_ea_r16
				.long 	adc_r8_ea
				.long 	adc_r16_ea
				.long 	adc_al_d8
				.long 	adc_ax_d16
				.long 	push_ss
				.long 	pop_ss
				.long 	sbb_ea_r8
				.long 	sbb_ea_r16
				.long 	sbb_r8_ea
				.long 	sbb_r16_ea
				.long 	sbb_al_d8
				.long 	sbb_ax_d16
				.long 	push_ds
				.long 	pop_ds

				.long 	and_ea_r8			@ 20
				.long 	and_ea_r16
				.long 	and_r8_ea
				.long 	and_r16_ea
				.long 	and_al_d8
				.long 	and_ax_d16
				.long 	segprefix_es
				.long 	daa
				.long 	sub_ea_r8
				.long 	sub_ea_r16
				.long 	sub_r8_ea
				.long 	sub_r16_ea
				.long 	sub_al_d8
				.long 	sub_ax_d16
				.long 	segprefix_cs
				.long 	das

				.long 	xor_ea_r8			@ 30
				.long 	xor_ea_r16
				.long 	xor_r8_ea
				.long 	xor_r16_ea
				.long 	xor_al_d8
				.long 	xor_ax_d16
				.long 	segprefix_ss
				.long 	aaa
				.long 	cmp_ea_r8
				.long 	cmp_ea_r16
				.long 	cmp_r8_ea
				.long 	cmp_r16_ea
				.long 	cmp_al_d8
				.long 	cmp_ax_d16
				.long 	segprefix_ds
				.long 	aas

				.long 	inc_ax				@ 40
				.long 	inc_cx
				.long 	inc_dx
				.long 	inc_bx
				.long 	inc_sp
				.long 	inc_bp
				.long 	inc_si
				.long 	inc_di
				.long 	dec_ax
				.long 	dec_cx
				.long 	dec_dx
				.long 	dec_bx
				.long 	dec_sp
				.long 	dec_bp
				.long 	dec_si
				.long 	dec_di

				.long 	push_ax				@ 50
				.long 	push_cx
				.long 	push_dx
				.long 	push_bx
				.long 	push_sp
				.long 	push_bp
				.long 	push_si
				.long 	push_di
				.long 	pop_ax
				.long 	pop_cx
				.long 	pop_dx
				.long 	pop_bx
				.long 	pop_sp
				.long 	pop_bp
				.long 	pop_si
				.long 	pop_di

				.long 	pusha				@ 60
				.long 	popa
				.long 	bound
				.long 	reserved			@ arpl(reserved)
				.long 	reserved
				.long 	reserved
				.long 	reserved
				.long 	reserved
				.long 	push_d16
				.long 	imul_r_ea_d16
				.long 	push_d8
				.long 	imul_r_ea_d8
				.long 		i286a_rep_insb
				.long 		i286a_rep_insw
				.long 		i286a_rep_outsb
				.long 		i286a_rep_outsw

				.long 	jo_short			@ 70
				.long 	jno_short
				.long 	jc_short
				.long 	jnc_short
				.long 	jz_short
				.long 	jnz_short
				.long 	jna_short
				.long 	ja_short
				.long 	js_short
				.long 	jns_short
				.long 	jp_short
				.long 	jnp_short
				.long 	jl_short
				.long 	jnl_short
				.long 	jle_short
				.long 	jnle_short

				.long 	i286aop80			@ 80
				.long 	i286aop81
				.long 	i286aop80
				.long 	i286aop83
				.long 	test_ea_r8
				.long 	test_ea_r16
				.long 	xchg_ea_r8
				.long 	xchg_ea_r16
				.long 	mov_ea_r8
				.long 	mov_ea_r16
				.long 	mov_r8_ea
				.long 	mov_r16_ea
				.long 	mov_ea_seg
				.long 	lea_r16_ea
				.long 	mov_seg_ea
				.long 	pop_ea

				.long 	nopandbios			@ 90
				.long 	xchg_ax_cx
				.long 	xchg_ax_dx
				.long 	xchg_ax_bx
				.long 	xchg_ax_sp
				.long 	xchg_ax_bp
				.long 	xchg_ax_si
				.long 	xchg_ax_di
				.long 	cbw
				.long 	cwd
				.long 	call_far
				.long 	wait
				.long 	pushf
				.long 	popf
				.long 	sahf
				.long 	lahf

				.long 	mov_al_m8			@ a0
				.long 	mov_ax_m16
				.long 	mov_m8_al
				.long 	mov_m16_ax
				.long 	i286a_rep_movsb
				.long 	i286a_rep_movsw
				.long 		i286a_repe_cmpsb
				.long 		i286a_repe_cmpsw
				.long 	test_al_d8
				.long 	test_ax_d16
				.long 		i286a_rep_stosb
				.long 		i286a_rep_stosw
				.long 		i286a_rep_lodsb
				.long 		i286a_rep_lodsw
				.long 		i286a_repe_scasb
				.long 		i286a_repe_scasw

				.long 	mov_al_imm			@ b0
				.long 	mov_cl_imm
				.long 	mov_dl_imm
				.long 	mov_bl_imm
				.long 	mov_ah_imm
				.long 	mov_ch_imm
				.long 	mov_dh_imm
				.long 	mov_bh_imm
				.long 	mov_ax_imm
				.long 	mov_cx_imm
				.long 	mov_dx_imm
				.long 	mov_bx_imm
				.long 	mov_sp_imm
				.long 	mov_bp_imm
				.long 	mov_si_imm
				.long 	mov_di_imm

				.long 	i286asft8_d8		@ c0
				.long 	i286asft16_d8
				.long 	ret_near_d16
				.long 	ret_near
				.long 	les_r16_ea
				.long 	lds_r16_ea
				.long 	mov_ea8_d8
				.long 	mov_ea16_d16
				.long 	enter
				.long 	leave
				.long 	ret_far_d16
				.long 	ret_far
				.long 	int_03
				.long 	int_d8
				.long 	into
				.long 	iret

				.long 	i286asft8_1			@ d0
				.long 	i286asft16_1
				.long 	i286asft8_cl
				.long 	i286asft16_cl
				.long 	aam
				.long 	aad
				.long 	setalc
				.long 	xlat
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc
				.long 	esc

				.long 	loopnz				@ e0
				.long 	loopz
				.long 	loop
				.long 	jcxz
				.long 	in_al_d8
				.long 	in_ax_d8
				.long 	out_d8_al
				.long 	out_d8_ax
				.long 	call_near
				.long 	jmp_near
				.long 	jmp_far
				.long 	jmp_short
				.long 	in_al_dx
				.long 	in_ax_dx
				.long 	out_dx_al
				.long 	out_dx_ax

				.long 	lock				@ f0
				.long 	lock
				.long 	repne
				.long 	repe
				.long 	hlt
				.long 	cmc
				.long 	i286aopf6
				.long 	i286aopf7
				.long 	clc
				.long 	stc
				.long 	cli
				.long 	sti
				.long 	cld
				.long 	std
				.long 	i286aopfe
				.long 	i286aopff


	.section	.note.GNU-stack,"",%progbits
