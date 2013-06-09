@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

.equ I286_MEMREADMAX		, 		0xa4000
.equ I286_MEMWRITEMAX	, 		0xa0000

.equ C_FLAG				, 		0x0001
.equ P_FLAG				, 		0x0004
.equ A_FLAG				, 		0x0010
.equ Z_FLAG				, 		0x0040
.equ S_FLAG				, 		0x0080
.equ T_FLAG				, 		0x0100
.equ I_FLAG				, 		0x0200
.equ D_FLAG				, 		0x0400
.equ O_FLAG				, 		0x0800

.equ MSW_PE				, 		0x0001
.equ MSW_MP				, 		0x0002
.equ MSW_EM				, 		0x0004
.equ MSW_TS				, 		0x0008

.equ CPU_SIZE			, 		(104 + 32)
.equ CPU_STAT			, 		(0 - CPU_SIZE)
.equ CPU_EXT				, 		(104 - CPU_SIZE)

.equ CPU_REG				, 		CPU_STAT + 0
.equ CPU_SEG				, 		CPU_STAT + 16
.equ CPU_ES_BASE			, 		CPU_STAT + 28
.equ CPU_CS_BASE			, 		CPU_STAT + 32
.equ CPU_SS_BASE			, 		CPU_STAT + 36
.equ CPU_DS_BASE			, 		CPU_STAT + 40
.equ CPU_SS_FIX			, 		CPU_STAT + 44
.equ CPU_DS_FIX			, 		CPU_STAT + 48
.equ CPU_ADRSMASK		, 		CPU_STAT + 52
.equ CPU_PREFIX			, 		CPU_STAT + 56
@ cpu_resetreq		equ		CPU_STAT + 57
.equ CPU_GDTR			, 		CPU_STAT + 58
.equ CPU_MSW				, 		CPU_STAT + 64
.equ CPU_IDTR			, 		CPU_STAT + 66
.equ CPU_LDTR			, 		CPU_STAT + 72
.equ CPU_LDTRC			, 		CPU_STAT + 74
.equ CPU_TR				, 		CPU_STAT + 80
.equ CPU_TRC				, 		CPU_STAT + 82
@ cpu_type			equ		CPU_STAT + 88
.equ CPU_ITFBANK			, 		CPU_STAT + 89
@ cpu_ram_d0		equ		CPU_STAT + 90
.equ CPU_REMAINCLOCK		, 		CPU_STAT + 92
.equ CPU_BASECLOCK		, 		CPU_STAT + 96
@ cpu_clock			equ		CPU_STAT + 100
@ cpu_stat_size		equ		104

.equ CPU_AL				, 		CPU_STAT + 0
.equ CPU_AH				, 		CPU_STAT + 1
.equ CPU_CL				, 		CPU_STAT + 2
.equ CPU_CH				, 		CPU_STAT + 3
.equ CPU_DL				, 		CPU_STAT + 4
.equ CPU_DH				, 		CPU_STAT + 5
.equ CPU_BL				, 		CPU_STAT + 6
.equ CPU_BH				, 		CPU_STAT + 7

.equ CPU_AX				, 		CPU_STAT + 0
.equ CPU_CX				, 		CPU_STAT + 2
.equ CPU_DX				, 		CPU_STAT + 4
.equ CPU_BX				, 		CPU_STAT + 6
.equ CPU_SP				, 		CPU_STAT + 8
.equ CPU_BP				, 		CPU_STAT + 10
.equ CPU_SI				, 		CPU_STAT + 12
.equ CPU_DI				, 		CPU_STAT + 14
.equ CPU_ES				, 		CPU_STAT + 16
.equ CPU_CS				, 		CPU_STAT + 18
.equ CPU_SS				, 		CPU_STAT + 20
.equ CPU_DS				, 		CPU_STAT + 22
.equ CPU_FLAG			, 		CPU_STAT + 24
.equ CPU_IP				, 		CPU_STAT + 26


.equ CPU_EXTMEM			, 		CPU_EXT + 0
.equ CPU_EXTMEMSIZE		, 		CPU_EXT + 4
.equ CPU_EMS				, 		CPU_EXT + 8
.equ CPU_INPUT			, 		CPU_EXT + 24
.equ MEMWAIT_TRAM		, 		CPU_EXT + 28
.equ MEMWAIT_VRAM		, 		CPU_EXT + 29
.equ MEMWAIT_GRCG		, 		CPU_EXT + 30
@ cpu_ext_size		equ		32

.equ MAX_PREFIX			, 		8



.macro CPUDBGS
		@;	str		r7, [r9, #CPU_REMAINCLOCK]
	.endm

.macro CPUDBGL
		@;	ldr		r7, [r9, #CPU_REMAINCLOCK]
	.endm


.macro CPUSVC
			str		r7, [r9, #CPU_REMAINCLOCK]
	.endm

.macro CPULDC
			ldr		r7, [r9, #CPU_REMAINCLOCK]
	.endm

.macro CPUSVF
			str		r8, [r9, #CPU_FLAG]
	.endm

.macro CPULDF
			ldr		r8, [r9, #CPU_FLAG]
	.endm

.macro CPUSV
		CPUSVF
		CPUSVC
	.endm

.macro CPULD
		CPULDF
		CPULDC
	.endm


.macro CPUWORK	clock
			CPUDBGL
			sub		r7, r7, \clock
			CPUDBGS
	.endm

.macro CPUWKS	clock
			CPUDBGL
			subs	r7, r7, \clock
			CPUDBGS
	.endm

.macro CREMSET	clock
			mov		r7, \clock
			CPUDBGS
	.endm

.macro NEXT_OPCODE
			CPUDBGL
			cmp		r7, #1
			movge	pc, r11
			ldr		r0, [r9, #CPU_BASECLOCK]
			rsb		r1, r7, #1
			mov		r7, #1
			add		r0, r0, r1
			str		r0, [r9, #CPU_BASECLOCK]
			CPUDBGS
			mov		pc, r11
	.endm

.macro REMAIN_ADJUST	clk
			CPUDBGL
			cmp		r7, \clk
			moveq	pc, r11
			ldr		r0, [r9, #CPU_BASECLOCK]
			rsb		r1, r7, \clk
			mov		r7, \clk
			add		r0, r0, r1
			str		r0, [r9, #CPU_BASECLOCK]
			CPUDBGS
			mov		pc, r11
	.endm

.macro I286IRQCHECKTERM
			CPUDBGL
			cmp		r7, #0
			movle	pc, r11
			ldr		r0, [r9, #CPU_BASECLOCK]
			mov		r1, r7
			mov		r7, #0
			sub		r0, r0, r1
			str		r0, [r9, #CPU_BASECLOCK]
			CPUDBGS
			mov		pc, r11
	.endm

.macro ACCWORD	_r, l
			tst		\_r, #1
			bne		\l
			cmp		\_r, #I286_MEMWRITEMAX
			bcs		\l
	.endm


	.section	.note.GNU-stack,"",%progbits
