
	
		; sprite 1 graphics to expand
		defw sprite_unex_0

		; sprite 2 graphics to expand
		defw sprite_unex_1

		; read block number 1st (right most)
		; read quantity second

	; 2019: xxxx is zero based, so 0=1,15=16 blocks
	; yyyy is the zero based tile

	; xxxxyyyy

	defb %00100000
	defb %11000110
	defb %00010000
	defb %11010110
	defb %00010000
	defb %11010110
	defb %00010000
	defb %11010110
	defb %00010000
	defb %11010101
	defb %00010000
	defb %11010101
	defb %00010000
	defb %11010101
	defb %00010000
	defb %10110101
	defb %00001000
	defb %00000101
	defb %00010000
	defb %00000001
	defb %00000010
	defb %00000001
	defb %10100011
	defb %11110100
	defb %11111111


	; sprites

	; no of sprites  (including player)
	defb 3

	; colour (hb) and active pause (lb)
	defb %01010001
	; xpos /2 (hb) and ypos /2 (lb)
	defb %00011011
	; xmin /2 (hb) and xmax /2 (lb)
	defb %00001110
	; sprite buffer
	defw sprite_buffer_2
	; gfx
	defb sprite_expand_1/256
	; bank count and reset (eg 5 and 5)
	; so the pause between animation fames
	defb %01010101
	; direction (1 or -1)
	defb %00000001

	; colour (hb) and active pause (lb)
	defb %01010101
	; xpos /2 (hb) and ypos /2 (lb)
	defb %01111011
	; xmin /2 (hb) and xmax /2 (lb)
	defb %00001110
	; sprite buffer
	defw sprite_buffer_3
	; gfx
	defb sprite_expand_2/256
	; bank count and reset (eg 5 and 5)
	; so the pause between animation fames
	defb %01010101
	; direction (1 or -1)
	defb %00000001