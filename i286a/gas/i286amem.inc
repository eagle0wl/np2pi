@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0
.altmacro

.equ USE_HIMEM			, 		0x110000

.equ VRAM_STEP			, 		0x100000
.equ VRAM_B				, 		0x0a8000
.equ VRAM_R				, 		0x0b0000
.equ VRAM_G				, 		0x0b8000
.equ VRAM_E				, 		0x0e0000

.equ FONT_ADRS			, 		0x110000
.equ ITF_ADRS			, 		0x1f8000


	.section	.note.GNU-stack,"",%progbits
