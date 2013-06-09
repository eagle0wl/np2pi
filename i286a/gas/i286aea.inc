@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

.macro GETPC8
			ldr		r0, [r9, #CPU_CS_BASE]
			add		r0, r0, r8, lsr #16
			bl		i286a_memoryread
			add		r8, r8, #(1 << 16)
	.endm

.macro GETPC16
			ldr		r0, [r9, #CPU_CS_BASE]
			add		r0, r0, r8, lsr #16
			bl		i286a_memoryread_w
			add		r8, r8, #(2 << 16)
	.endm


.macro GETR0
			cmp		r0, #I286_MEMWRITEMAX
			ldrccb	r0, [r0, r9]
			blcs	i286a_memoryread
	.endm

.macro GETPCF8
			add		r0, r5, r8, lsr #16
			cmp		r0, #I286_MEMWRITEMAX
			ldrccb	r0, [r0, r9]
			blcs	i286a_memoryread
			add		r8, r8, #(1 << 16)
	.endm

.macro GETPCF16
			add		r0, r5, r8, lsr #16
			bl		i286a_memoryread_w
			add		r8, r8, #(2 << 16)
	.endm


.macro R8SRC	op, out
			and		\out, \op, #3
			tst		\op, #(1 << 2)
			add		\out, r9, \out, lsl #1
			addne	\out, \out, #1
	.endm

.macro R8DST	op, out
			and		\out, \op, #(6 << 2)
			tst		\op, #(1 << 5)
			add		\out, r9, \out, lsr #2
			addne	\out, \out, #1
	.endm


.macro EAREG8	src
			add		r0, r5, r8, lsr #16
			GETR0
			and		\src, r0, #(6 << 2)
			add		r8, r8, #(1 << 16)
			add		\src, r9, \src, lsr #2
			tst		r0, #(1 << 5)
			addne	\src, \src, #1
	.endm

.macro REG8EA	dst, _regclk, memclk
			add		r0, r5, r8, lsr #16
			GETR0
			add		r8, r8, #(1 << 16)
			R8DST	r0, \dst
			cmp		r0, #0xc0
LOCAL label_1
			bcc		label_1
			CPUWORK	\_regclk
			R8SRC	r0, r12
			ldrb	r0, [r12, #CPU_REG]
LOCAL label_2
			b		label_2
label_1:	CPUWORK	\memclk
			bl		i286a_ea
			bl		i286a_memoryread
label_2:
	.endm


.macro R16SRC	op, out
			and		\out, \op, #7
			add		\out, r9, \out, lsl #1
	.endm

.macro R16DST	op, out
			and		\out, \op, #(7 << 3)
			add		\out, r9, \out, lsr #2
	.endm

.macro EAREG16	src
			add		r0, r5, r8, lsr #16
			GETR0
			and		\src, r0, #(7 << 3)
			add		r8, r8, #(1 << 16)
			add		\src, r9, \src, lsr #2
	.endm

.macro REG16EA	dst, _regclk, memclk
			add		r0, r5, r8, lsr #16
			GETR0
			and		\dst, r0, #(7 << 3)
			add		r8, r8, #(1 << 16)
			add		\dst, r9, \dst, lsr #2
			cmp		r0, #0xc0
LOCAL label_1
			bcc		label_1
			CPUWORK	\_regclk
			R16SRC	r0, r12
			ldrh	r0, [r12, #CPU_REG]
LOCAL label_2
			b		label_2
label_1:	CPUWORK	\memclk
			bl		i286a_ea
			bl		i286a_memoryread_w
label_2:
	.endm


	.section	.note.GNU-stack,"",%progbits
