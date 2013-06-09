@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

.equ VRAM_STEP			, 		0x100000
.equ VRAM_B				, 		0x0a8000
.equ VRAM_R				, 		0x0b0000
.equ VRAM_G				, 		0x0b8000
.equ VRAM_E				, 		0x0e0000

.equ SURFACE_WIDTH		, 		640
.equ SURFACE_HEIGHT		, 		480
.equ SURFACE_SIZE		, 		(SURFACE_WIDTH * SURFACE_HEIGHT)

.equ NC_UPD72020			, 		0x00
@ NC_DISPSYNC		equ		&01
@ NC_RASTER			equ		&02
@ NC_realpal		equ		&03
@ NC_LCD_MODE		equ		&04
@ NC_skipline		equ		&05
@ NC_skiplight		equ		&06
				@ and more...

@ DS_text_vbp		equ		&00
@ DS_textymax		equ		&04
.equ DS_GRPH_VBP			, 		0x08
.equ DS_GRPHYMAX			, 		0x0c
@ DS_scrnxpos		equ		&10
@ DS_scrnxmax		equ		&14
@ DS_scrnxextend	equ		&18
@ DS_scrnymax		equ		&1c
@ DS_textvad		equ		&20
.equ DS_GRPHVAD			, 		0x24

.equ GDCCMD_MAX			, 		32

@ GDC_SYNC			equ		0
@ GDC_ZOOM			equ		8
.equ GDC_CSRFORM			, 		9
.equ GDC_SCROLL			, 		12
@ GDC_TEXTW			equ		20
.equ GDC_PITCH			, 		28
@ GDC_LPEN			equ		29
@ GDC_VECTW			equ		32
@ GDC_CSRW			equ		43
@ GDC_MASK			equ		46
@ GDC_CSRR			equ		48
@ GDC_WRITE			equ		53
@ GDC_CODE			equ		54
@ GDC_TERMDATA		equ		56

.equ GD_PARA				, 		0x000
@ GD_fifo			equ		&100
@ GD_cnt			equ		(&100 + (GDCCMD_MAX * 2))
@ GD_ptr			equ		(&102 + (GDCCMD_MAX * 2))
@ GD_rcv			equ		(&103 + (GDCCMD_MAX * 2))
@ GD_snd			equ		(&104 + (GDCCMD_MAX * 2))
@ GD_cmd			equ		(&105 + (GDCCMD_MAX * 2))
@ GD_paracb			equ		(&106 + (GDCCMD_MAX * 2))
@ GD_reserved		equ		(&107 + (GDCCMD_MAX * 2))
.equ GD_SIZE				, 		(0x108 + (GDCCMD_MAX * 2))

.equ G_MASTER			, 		(GD_SIZE * -1)
.equ G_SLAVE				, 		0
.equ G_MODE1				, 		(GD_SIZE + 0x00)
@ G_mode2			equ		(GD_SIZE + &01)
.equ G_CLOCK				, 		(GD_SIZE + 0x02)
@ G_crt15khz		equ		(GD_SIZE + &03)
@ G_m_drawing		equ		(GD_SIZE + &04)
@ G_s_drawing		equ		(GD_SIZE + &05)
@ G_vsync			equ		(GD_SIZE + &06)
@ G_vsyncint		equ		(GD_SIZE + &07)
@ G_display			equ		(GD_SIZE + &08)
@ G_bitac			equ		(GD_SIZE + &09)
@ G_analog			equ		(GD_SIZE + &0c)
@ G_palnum			equ		(GD_SIZE + &10)
@ G_degpal			equ		(GD_SIZE + &14)
@ G_anapal			equ		(GD_SIZE + &18)


	.include 	"i286a.inc"

	.global np2cfg
	.global i286acore
	.global np2_vram
	.global dsync
	.global vramupdate
	.global renewal_line
	.global gdc

	.global grph_table0
	.global makegrph_initialize
	.global makegrph

.section .rodata
.p2align 2

grph_table0:		.long 	0x00000000
				.long 	0x01000000
				.long 	0x00010000
				.long 	0x01010000
				.long 	0x00000100
				.long 	0x01000100
				.long 	0x00010100
				.long 	0x01010100
				.long 	0x00000001
				.long 	0x01000001
				.long 	0x00010001
				.long 	0x01010001
				.long 	0x00000101
				.long 	0x01000101
				.long 	0x00010101
				.long 	0x01010101


.text
.p2align 2

makegrph_initialize:
				mov		pc, lr


	@ r8 = mem
	@ r9 = vc
	@ r10 = out
	@ r11 = grph_table0
	@ tmp r2, r3, r4, r5, r12

.macro GRPHDATASET
				add		r3, r8, #(VRAM_R - VRAM_B)
				ldrb	r2, [r8, r9, lsr #17]
				ldrb	r3, [r3, r9, lsr #17]
				add		r8, r8, #(VRAM_G - VRAM_B)
				and		r12, r2, #0xf0
				and		r2, r2, #0x0f
				ldr		r4, [r11, r12, lsr #2]			@ 0
				ldr		r5, [r11, r2, lsl #2]			@ 0
				and		r12, r3, #0xf0					@ 1
				and		r3, r3, #0x0f					@ 1
				ldr		r12, [r11, r12, lsr #2]			@ 1
				ldr		r3, [r11, r3, lsl #2]			@ 1
				ldrb	r2, [r8, r9, lsr #17]
				orr		r4, r4, r12, lsl #1				@ 1
				orr		r5, r5, r3, lsl #1				@ 1
				add		r8, r8, #(VRAM_E - VRAM_G)
				and		r12, r2, #0xf0					@ 2
				and		r2, r2, #0x0f					@ 2
				ldr		r12, [r11, r12, lsr #2]			@ 2
				ldrb	r3, [r8, r9, lsr #17]
				ldr		r2, [r11, r2, lsl #2]			@ 2
				orr		r4, r4, r12, lsl #2				@ 2
				and		r12, r3, #0xf0					@ 3
				and		r3, r3, #0x0f					@ 3
				ldr		r12, [r11, r12, lsr #2]			@ 3
				ldr		r3, [r11, r3, lsl #2]			@ 3
				orr		r5, r5, r2, lsl #2				@ 2
				orr		r4, r4, r12, lsl #3				@ 3
				orr		r5, r5, r3, lsl #3				@ 3
				sub		r8, r8, #(VRAM_E - VRAM_B)
				str		r4, [r10, #-8]
				str		r5, [r10, #-4]
	.endm


@ ----

	@ r0 = remain:0:pitch (10:7:15)
	@ r1 = mg.vm
	@ r6 = liney:gdc.mode1:mul:mulorg:dsync.grphymax:0 (9:1:5:5:9:3)
	@ r7 = vramupdate
	@ r8 = mem
	@ r9 = vc:0:flag:bit (15:1:8:8)
	@ r10 = out
	@ r11 = grph_table0
	@ tmp r2, r3 / r4, r5, r12 (GRPHDATASET)
	@ input - r2 = pos r3 = gdc

gp_all:			orr		r9, r9, r12, lsl #(1 + 17)	@ (vad << 17)
				mov		r12, r12, lsr #(4 + 16)		@ remain
				orr		r0, r0, r12, lsl #22		@ (remain << 22)
gpa_lineylp1:	and		r12, r6, #(0x1f << 12)		@ mul !
				orr		r6, r6, r12, lsl #5
gpa_lineylp2:	add		r1, r1, #640
				tst		r6, #(1 << 23)
				tstne	r6, #(1 << 22)
				bne		gpa_lineyed
				sub		r10, r1, #640
gpa_pixlp:		add		r10, r10, #8
				GRPHDATASET
				add		r9, r9, #(1 << 17)
				cmp		r10, r1
				bcc		gpa_pixlp
				ldr		r2, gp_renewline
				sub		r9, r9, #(80 << 17)
				@
				ldrb	r3, [r2, r6, lsr #23]
				bic		r9, r9, #(3 << 8)
				@
				orr		r3, r3, r9
				strb	r3, [r2, r6, lsr #23]
gpa_lineyed:		add		r6, r6, #(1 << 23)
				cmp		r6, r6, lsl #20
				bcs		makegrph_ed
				sub		r0, r0, #(1 << 22)
				movs	r12, r0, lsr #22
				beq		gpa_break
				tst		r6, #(0x1f << 17)
				subne	r6, r6, #(1 << 17)
				bne		gpa_lineylp2
				add		r9, r9, r0, lsl #17
				b		gpa_lineylp1
gpa_break:		ldr		r3, gp_gdc
				and		r9, r9, #255
				bic		r6, r6, #(0x1f << 17)
				mov		pc, lr

gp_indirty:		orr		r9, r9, r12, lsl #(1 + 17)	@ (vad << 17)
				mov		r12, r12, lsr #(4 + 16)		@ remain
				orr		r0, r0, r12, lsl #22		@ (remain << 22)
gpi_lineylp1:	and		r12, r6, #(0x1f << 12)		@ mul !
				orr		r6, r6, r12, lsl #5
gpi_lineylp2:	add		r1, r1, #640
				tst		r6, #(1 << 23)
				tstne	r6, #(1 << 22)
				bne		gpi_lineyed
				ldrb	r2, [r7, r9, lsr #17]
				sub		r10, r1, #640
gpi_pixlp:		add		r10, r10, #8
				ands	r2, r2, r9
				beq		gpi_pixnt
				orr		r9, r9, r2, lsl #8
				GRPHDATASET
gpi_pixnt:		add		r9, r9, #(1 << 17)
				cmp		r10, r1
				ldrccb	r2, [r7, r9, lsr #17]
				bcc		gpi_pixlp
				sub		r9, r9, #(80 << 17)
				ldr		r2, gp_renewline				@ prepare
				ands	r10, r9, #(3 << 8)
				beq		gpi_lineyed
				ldrb	r3, [r2, r6, lsr #23]
				bic		r9, r9, #(3 << 8)
				@
				orr		r3, r3, r10, lsr #8
				strb	r3, [r2, r6, lsr #23]
gpi_lineyed:		add		r6, r6, #(1 << 23)
				cmp		r6, r6, lsl #20
				bcs		makegrph_ed
				sub		r0, r0, #(1 << 22)
				movs	r12, r0, lsr #22
				beq		gpi_break
				tst		r6, #(0x1f << 17)
				subne	r6, r6, #(1 << 17)
				bne		gpi_lineylp2
				add		r9, r9, r0, lsl #17
				b		gpi_lineylp1
gpi_break:		ldr		r3, gp_gdc
				and		r9, r9, #255
				bic		r6, r6, #(0x1f << 17)
				mov		pc, lr


makegrph:		stmdb	sp!, {r4 - r11, lr}
				ldr		r4, gp_dsync
				ldr		r7, gp_vramupdate
				ldr		r8, gp_vmem
				ldr		r2, [r4, #DS_GRPHVAD]
				ands	r0, r0, #1
				addne	r8, r8, #VRAM_STEP
				addne	r2, r2, #SURFACE_SIZE
				ldr		r3, gp_gdc
				ldr		r11, gp_gtable0
				mov		r9, #1
				ldrb	r5, [r3, #G_CLOCK]
				mov		r9, r9, lsl r0
				ldrb	r0, [r3, #(G_SLAVE + GD_PARA + GDC_PITCH)]
				tst		r5, #0x80
				moveq	r0, r0, lsl #1
				and		r0, r0, #0xfe				@ mg.pitch
				ldr		r6, [r4, #DS_GRPH_VBP]
				ldrb	r12, [r3, #G_MODE1]
				ldrb	r5, [r3, #(G_SLAVE + GD_PARA + GDC_CSRFORM)]
				mov		r6, r6, lsl #23				@ mg.liney << 23
				and		r12, r12, #0x10
				orr		r6, r6, r12, lsl #(22 - 4)	@ gdc.mode1:bit4 << 22
				and		r5, r5, #0x1f
				ldr		r12, [r4, #DS_GRPHYMAX]
				orr		r6, r6, r5, lsl #12			@ mg.lr << 12
				ldr		r5, gp_np2vram
				orr		r6, r6, r12, lsl #3			@ dsync.grphymax << 3
				cmp		r1, #0
				add		r1, r5, r2
				bne		mg_alp
mg_ilp:			ldr		r12, [r3, #(G_SLAVE + GD_PARA + GDC_SCROLL + 0)]
				bl		gp_indirty
				ldr		r12, [r3, #(G_SLAVE + GD_PARA + GDC_SCROLL + 4)]
				bl		gp_indirty
				ldr		r12, gp_np2cfg
				ldrb	r12, [r12, #NC_UPD72020]
				cmp		r12, #0
				bne		mg_ilp
				ldr		r12, [r3, #(G_SLAVE + GD_PARA + GDC_SCROLL + 8)]
				bl		gp_indirty
				ldr		r12, [r3, #(G_SLAVE + GD_PARA + GDC_SCROLL + 12)]
				bl		gp_indirty
				b		mg_ilp
mg_alp:			ldr		r12, [r3, #(G_SLAVE + GD_PARA + GDC_SCROLL + 0)]
				bl		gp_all
				ldr		r12, [r3, #(G_SLAVE + GD_PARA + GDC_SCROLL + 4)]
				bl		gp_all
				ldr		r12, gp_np2cfg
				ldrb	r12, [r12, #NC_UPD72020]
				cmp		r12, #0
				bne		mg_alp
				ldr		r12, [r3, #(G_SLAVE + GD_PARA + GDC_SCROLL + 8)]
				bl		gp_all
				ldr		r12, [r3, #(G_SLAVE + GD_PARA + GDC_SCROLL + 12)]
				bl		gp_all
				b		mg_alp

makegrph_ed:		and		r3, r9, #255
				sub		r8, r7, #4
				orr		r3, r3, r3, lsl #8
				mov		r4, #0
				orr		r3, r3, r3, lsl #16
mg_updclear:		ldr		r12, [r7, r4]
				add		r4, r4, #4
				cmp		r4, #0x8000
				bic		r12, r12, r3
				str		r12, [r8, r4]
				bcc		mg_updclear
				ldmia	sp!, {r4 - r11, pc}

gp_dsync:		.long 	dsync
gp_vramupdate:	.long 	vramupdate
gp_vmem:			.long 	i286acore + CPU_SIZE + VRAM_B
gp_gdc:			.long 	gdc - G_MASTER
gp_gtable0:		.long 	grph_table0
gp_np2vram:		.long 	np2_vram
gp_renewline:	.long 	renewal_line
gp_np2cfg:		.long 	np2cfg


	.section	.note.GNU-stack,"",%progbits
