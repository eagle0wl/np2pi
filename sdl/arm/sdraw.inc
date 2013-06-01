@ This file was created from a .asm file
@  using the ads2gas.pl script.
	.equ DO1STROUNDING, 0

.equ NP2PALS_TXT		, 		10
.equ NP2PALS_GRPH	, 		16

.equ NP2PAL_TEXT		, 		0
.equ NP2PAL_SKIP		, 		NP2PALS_TXT
.equ NP2PAL_GRPH		, 		(NP2PAL_SKIP + NP2PALS_GRPH)
.equ NP2PAL_TEXT2	, 		(NP2PAL_GRPH + NP2PALS_GRPH)

.equ SURFACE_WIDTH	, 		640

.equ S_HDRSIZE		, 		32
.equ S_SRC			, 		(0 - S_HDRSIZE)
.equ S_SRC2			, 		(4 - S_HDRSIZE)
.equ S_DST			, 		(8 - S_HDRSIZE)
.equ S_WIDTH			, 		(12 - S_HDRSIZE)
.equ S_XBYTES		, 		(16 - S_HDRSIZE)
.equ S_Y				, 		(20 - S_HDRSIZE)
.equ S_XALIGN		, 		(24 - S_HDRSIZE)
.equ S_YALIGN		, 		(28 - S_HDRSIZE)
.equ S_DIRTY			, 		(32 - S_HDRSIZE)


	.section	.note.GNU-stack,"",%progbits
