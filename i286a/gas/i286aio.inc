@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

@ ---- cgwindow

	.global cgwindow

.equ CGW_LOW				, 		0
.equ CGW_HIGH			, 		4
.equ CGW_WRITABLE		, 		8


@ ---- dmac

	.global dmac

@ DMACH_adrs		equ		0
@ DMACH_leng		equ		4
@ DMACH_adrsorg		equ		6
@ DMACH_lengorg		equ		8
@ DMACH_action		equ		10
@ DMACH_outproc		equ		12
@ DMACH_inproc		equ		16
@ DMACH_extproc		equ		20
@ DMACH_mode		equ		24
@ DMACH_sreq		equ		25
@ DMACH_ready		equ		26
@ DMACH_mask		equ		27
.equ DMACH_SIZE			, 		28

@ dmac_dmach		equ		0
@ dmac_lh			equ		(DMACH_SIZE * 4) + 0
@ dmac_work			equ		(DMACH_SIZE * 4) + 4
.equ DMAC_WORKING		, 		(DMACH_SIZE * 4) + 5
@ dmac_mask			equ		(DMACH_SIZE * 4) + 6
@ dmac_stat			equ		(DMACH_SIZE * 4) + 7
@ dmac_devices		equ		(DMACH_SIZE * 4) + 8
@ dmac_device		equ		(DMACH_SIZE * 4) + 12


@ ---- egc

	.global egc

@ egc_access		equ		0
@ egc_fgbg			equ		2
@ egc_ope			equ		4
@ egc_fg			equ		6
@ egc_mask			equ		8
@ egc_bg			equ		10
.equ EGC_SFT				, 		12
@ egc_leng			equ		14
@ egc_lastvram		equ		16
@ egc_patreg		equ		24
@ egc_fgc			equ		32
@ egc_bgc			equ		40
@							and more..


@ ---- gdc

	.global gdcs

@ gdcs_access		equ		0
@ gdcs_disp			equ		1
.equ GDCS_TEXTDISP		, 		2
.equ GDCS_MSWACC			, 		3
.equ GDCS_GRPHDISP		, 		4
@ gdcs_palchange	equ		5
@ gdcs_mode2		equ		6


@ ---- grcg

	.global grcg

@ grcg_counter		equ		0
@ grcg_mode			equ		4
.equ GRCG_MODEREG		, 		6
.equ GRCG_TILE			, 		8
@ grcg_gdcwithgrcg	equ		16
@ grcg_chip			equ		20


@ ---- pic

	.global pic

@ PI_icw			equ		0
.equ PI_IMR				, 		4
@ PI_isr			equ		5
@ PI_irr			equ		6
@ PI_ocw3			equ		7
@ PI_pry			equ		8
@ PI_writeicw		equ		9
@ PI_padding		equ		10
.equ PI_SIZE				, 		12

.equ PIC_MASTER			, 		0
.equ PIC_SLAVE			, 		PI_SIZE

.macro NOINTREXIT
			tst		r8, #I_FLAG
			moveq	pc, r11
			ldr		r2, [r0, #(PIC_MASTER + PI_IMR)]
			mov		r12, #(0xff << 24)
			ldr		r3, [r0, #(PIC_SLAVE + PI_IMR)]
			eor		r0, r12, r2, lsl #24
			tst		r0, r2, lsl #8
			eoreq	r0, r12, r3, lsl #24
			tsteq	r0, r3, lsl #8
			moveq	pc, r11
	.endm

.macro PICEXISTINTR
			ldr		r2, [r0, #(PIC_MASTER + PI_IMR)]
			mov		r12, #(0xff << 24)
			ldr		r3, [r0, #(PIC_SLAVE + PI_IMR)]
			eor		r0, r12, r2, lsl #24
			tst		r0, r2, lsl #8
			eoreq	r0, r12, r3, lsl #24
			tsteq	r0, r3, lsl #8
	.endm


	.section	.note.GNU-stack,"",%progbits
