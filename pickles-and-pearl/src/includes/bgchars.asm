
	; ASM source file created by SevenuP v1.20
	; SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

	;GRAPHIC DATA:
	;Pixel Size:      ( 16,  16)
	;Char Size:       (  2,   2)
	;Sort Priorities: Char line, X char, Y char
	;Data Outputted:  Gfx+Attr
	;Interleave:      Frames
	;Mask:            No

	; block
	defb   0, 250, 252, 250, 252, 250, 252, 250  ; char block [0, 0]
	defb   0, 255, 255, 255, 255, 255, 255, 255  ; char block [1, 0]
	defb   0, 255, 255, 255, 255, 255, 255, 255  ; char block [0, 1]
	defb   0, 253, 254, 253, 254, 253, 254, 253  ; char block [1, 1]

	; Step
	defb   0, 255, 255, 255, 255, 255, 255, 255  ; char block [0, 0]
	defb   0, 248, 252, 254, 254, 254, 254, 254  ; char block [1, 0]
	defb 255, 255, 255, 255, 255, 255, 255, 255  ; char block [0, 1]
	defb 254, 254, 254, 254, 254, 254, 254, 254  ; char block [1, 1]
	; StepBody:

	defb   0, 255, 255, 255, 255, 255, 255, 255  ; char block [0, 0]
	defb   0, 255, 255, 255, 255, 255, 255, 255  ; char block [1, 0]
	defb 255, 255, 255, 255, 255, 255, 255, 255  ; char block [0, 1]
	defb 255, 255, 255, 255, 255, 255, 255, 255  ; char block [1, 1]
	;Grass:

	defb   0, 109,  69, 229, 255, 255, 239, 239  ; char block [0, 0]
	defb  54, 164,  62, 254, 255, 239, 239, 239  ; char block [1, 0]
	defb 239, 253,  41, 175, 174, 174, 239, 255  ; char block [0, 1]
	defb 239, 254, 190, 182, 180, 183, 247, 255  ; char block [1, 1]

	;Earth:

	defb   0, 124, 126, 126, 126, 126,  62,   0  ; char block [0, 0]
	defb 255, 131, 129, 129, 129, 129, 193, 255  ; char block [1, 0]
	defb 255, 131, 129, 129, 129, 129, 193, 255  ; char block [0, 1]
	defb   0, 124, 126, 126, 126, 126,  62,   0  ; char block [1, 1]

	;Fence1:

	defb  87,  55,  87,  55,  87,  55,  87,  55  ; char block [0, 0]
	defb 239, 111, 125, 125, 255, 247, 247, 247  ; char block [1, 0]
	defb  95,  63,  95,  63,  87,  55,  87,  55  ; char block [0, 1]
	defb 127, 127, 127, 125, 109, 109, 109, 239  ; char block [1, 1]

	; Sky:

	defs 32,255

	; Tunnel
	defb  28,  14,   7,   3,   1,   0,   0,   0  ; char block [0, 0]
	defb   0,   0,   0, 128, 192, 224, 112,  56  ; char block [1, 0]
	defb   0,   0,   0, 128, 192, 224, 112,  56  ; char block [0, 1]
	defb  28,  14,   7,   3,   1,   0,   0,   0  ; char block [1, 1]

	; Fence Block
	defb   0,  63,  87,  55,  87,  55,  93,   0  ; char block [0, 0]
	defb   0, 110, 124, 124, 254, 246, 246,   0  ; char block [1, 0]
	defb  85,  42,  95,  63,  87,  55,  87,  55  ; char block [0, 1]
	defb  85,  42, 127, 125, 109, 109, 109, 239  ; char block [1, 1]

	; Cave Wall

	defb   0,   0,   0,   0,   0,  32,   0,   0  ; char block [0, 0]
	defb   0,   0, 128,   0,   0,   2,   0,   0  ; char block [1, 0]
	defb   0,   0,  16,   0,   0,   0,   0,   0  ; char block [0, 1]
	defb   0,   0,   0,   0,   0,   0,  32,   0  ; char block [1, 1]

	; Cage
	defb  28,  14,   7,   3,   1,   0,   0,   0  ; char block [0, 0]
	defb 122, 124, 122, 124, 122, 124, 122, 124  ; char block [1, 0]
	defb   0,   0,   0, 128, 192, 224, 112,  56  ; char block [0, 1]
	defb 122, 124, 122, 124, 122, 124, 122, 124  ; char block [1, 1]


