; ASM source file created by SevenuP v1.20
; SevenuP (C) Copyright 2002-2006 by Jaime Tejedor Gomez, aka Metalbrain

;GRAPHIC DATA:
;Pixel Size:      ( 32,  24)
;Char Size:       (  4,   3)
;Frames:             4
;Sort Priorities: Mask, Char line, Y char, X char, Frame number
;Data Outputted:  Gfx
;Interleave:      Sprite
;Mask:            Yes, before graphic

PEARLR2I:
	DEFB	255,  0,143,112,  0,207,  0,130
	DEFB	  0,152,  0,140,  0,128,  0,128
	DEFB	  0,128,  0,128,  0,128,  0,128
	DEFB	  0,128,128, 64,128, 64,192, 32
	DEFB	224, 24,  0,231,  0,185,  0,142
	DEFB	128, 96,224, 29,240, 11,240,  8
	DEFB	255,  0,  0,255,  0,  0,  0,  0
	DEFB	  0,  7,  0, 15,  0,  0,  0, 14
	DEFB	  0, 15,  0,  7,  0, 16,  0, 64
	DEFB	  0, 51,  0,  7,  0,119,  0,  3
	DEFB	  0, 16,  0,224,  0,  0,  0, 64
	DEFB	  0,224,  0,200,  0,183,  7,  8
	DEFB	255,  0,  0,255,  0, 36,  0,  0
	DEFB	  0,188,  0,222,  0,  0,  0, 82
	DEFB	  0,222,  0,222,  0,  0,  0,112
	DEFB	  0,116,  0,142,  0,222,  0,204
	DEFB	  0,  0,  0,127,  3, 12,  1, 50
	DEFB	  0,221,  0,237,  0, 99,  1,142
	DEFB	255,  0,127,128, 63,192, 63, 64
	DEFB	 63, 64, 63, 64, 63, 64, 63, 64
	DEFB	 63, 64, 63, 64, 63,192, 63, 64
	DEFB	 63,192, 63, 64, 63,192, 63, 64
	DEFB	 63,192,127,128,255,  0,255,  0
	DEFB	255,  0,255,  0,255,  0,255,  0
	DEFB	255,  0,227, 28,192, 51,192, 32
	DEFB	192, 38,192, 35,192, 32,192, 32
	DEFB	192, 32,192, 32,192, 32,192, 32
	DEFB	192, 32,224, 16,224, 16,240,  8
	DEFB	248,  6,192, 57,192, 46,192, 35
	DEFB	224, 24,248,  7,252,  2,252,  2
	DEFB	255,  0,192, 63,  0,192,  0,128
	DEFB	  0,  1,  0,  3,  0,  0,  0,  3
	DEFB	  0,  3,  0,  1,  0,  4,  0, 16
	DEFB	  0, 12,  0,  1,  0, 29,  0,  0
	DEFB	  0,  4,  0,248,  0, 64,  0,144
	DEFB	  0, 56,  0,114,  0,237,  1,  2
	DEFB	255,  0,  0,255,  0,  9,  0,  0
	DEFB	  0,239,  0,247,  0,  0,  0,148
	DEFB	  0,247,  0,247,  0,  0,  0, 28
	DEFB	  0,221,  0,227,  0,247,  0,243
	DEFB	  0,  0,  0, 31,  0,  3,  0, 12
	DEFB	  0, 55,  0, 59,  0,216,192, 35
	DEFB	255,  0, 31,224, 15, 48, 15, 16
	DEFB	 15, 16, 15,144, 15, 16, 15,144
	DEFB	 15,144, 15,144, 15, 48, 15, 16
	DEFB	 15, 48, 15,144, 15,176, 15, 16
	DEFB	 15, 48, 31,224,255,  0,127,128
	DEFB	 63, 64, 63, 64, 63,192,127,128
	DEFB	255,  0,248,  7,240, 12,240,  8
	DEFB	240,  9,240,  8,240,  8,240,  8
	DEFB	240,  8,240,  8,240,  8,240,  8
	DEFB	240,  8,248,  4,248,  4,252,  2
	DEFB	254,  1,240, 14,240, 11,240,  8
	DEFB	248,  6,254,  1,255,  0,255,  0
	DEFB	255,  0,240, 15,  0,240,  0, 32
	DEFB	  0,128,  0,192,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  1,  0,  4
	DEFB	  0,  3,  0,  0,  0,  7,  0,  0
	DEFB	  0,129,  0,126,  0,144,  0,228
	DEFB	  0, 14,  0,220,  0,187,  0,128
	DEFB	255,  0,  0,255,  0,  2,  0,  0
	DEFB	  0,123,  0,253,  0,  0,  0,229
	DEFB	  0,253,  0,125,  0,  0,  0,  7
	DEFB	  0, 55,  0,120,  0,125,  0, 60
	DEFB	  0,  0,  0,  7,  0,  0,  0,  3
	DEFB	  0, 13,  0,142,  0,118,112,136
	DEFB	255,  0,  7,248,  3, 76,  3,  4
	DEFB	  3,196,  3,228,  3,  4,  3, 36
	DEFB	  3,228,  3,228,  3, 12,  3,  4
	DEFB	  3, 76,  3,228,  3,236,  3,196
	DEFB	  3, 12,  7,248, 63,192, 31, 32
	DEFB	 15,208, 15,208, 15, 48, 31,224
	DEFB	255,  0,254,  1,252,  3,252,  2
	DEFB	252,  2,252,  2,252,  2,252,  2
	DEFB	252,  2,252,  2,252,  2,252,  2
	DEFB	252,  2,254,  1,254,  1,255,  0
	DEFB	255,  0,252,  3,252,  2,252,  2
	DEFB	254,  1,255,  0,255,  0,255,  0
	DEFB	255,  0, 60,195,  0, 60,  0,  8
	DEFB	  0, 96,  0, 48,  0,  0,  0,  0
	DEFB	  0,  0,  0,  0,  0,  0,  0,  1
	DEFB	  0,  0,  0,  0,  0,  1,  0,128
	DEFB	128, 96,  0,159,  0,228,  0, 57
	DEFB	  0,131,128,119,192, 46,192, 32
	DEFB	255,  0,  0,255,  0,  0,  0,  0
	DEFB	  0, 30,  0, 63,  0,  0,  0, 57
	DEFB	  0, 63,  0, 31,  0, 64,  0,  1
	DEFB	  0,205,  0, 30,  0,223,  0, 15
	DEFB	  0, 64,  0,129,  0,  0,  0,  0
	DEFB	  0,131,  0, 35,  0,221, 28, 34
	DEFB	255,  0,  1,254,  0,147,  0,  1
	DEFB	  0,241,  0,121,  0,  1,  0, 73
	DEFB	  0,121,  0,121,  0,  3,  0,193
	DEFB	  0,211,  0, 57,  0,123,  0, 49
	DEFB	  0,  3,  1,254, 15, 48,  7,200
	DEFB	  3,116,  3,180,  3,140,  7, 56