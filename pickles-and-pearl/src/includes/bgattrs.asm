	; block
	defb   2+128,   2+128
	defb   2+128,   2+128
	; step
	defb   7+128,   7+128
	defb   7,   7
	; step body
	defb   7+128,   7+128
	defb   7,   7

	; grass
	defb  68,  68
	defb   4,   4

	; earth
	defb  22+128,  41+128
	defb  41+128,  22+128

	; fence1
	defb  70,  70
	defb  70,  70

	; sky
	defb %01000101
	defb %01000101
	defb %01000101
	defb %01000101

	; Tunnel
	defb 69,69,69,69

	; Fence Block
	defb 70+128,70+128,%00000110,%00000110

	; Cave Wall
	defb 7,7,7,7

	; Cage
	;defb   0,  79
	;defb   0,  79

	defb 69,19,69,19
