
		
		; sprite 1 graphics to expand
		defw sprite_unex_0

		; sprite 2 graphics to expand
		defw sprite_unex_1

		; read block number 1st (right most)
		; read quantity second
	defb %11010110
	defb %00010000
	defb %11010110
	defb %00010000
	defb %11010110
	defb %00010111
	defb %11010110
	defb %00010111
	defb %10000101
	defb %01001000
	defb %00010000
	defb %01000101
	defb %00001000
	defb %01110101
	defb %00010000
	defb %00010101
	defb %00001000
	defb %10100101
	defb %00010000
	defb %11010101
	defb %00010000
	defb %11010011
	defb %00010000
	defb %11110100
	defb %11111111


	; sprites

	; sprites

	; no of sprites
	defb 2

	; colour (hb) and active pause (lb)
	defb %01100001
	; xpos /2 (hb) and ypos /2 (lb)
	; xxxx ypos xxxx xpos
	defb %00011010
	; xmin /2 (hb) and xmax /2 (lb)
	defb %10011110
	; sprite buffer
	defw sprite_buffer_2
	; gfx
	defb sprite_expand_1/256
	; bank count and reset (eg 5 and 5)
	defb %01010101
	; direction
	defb %00000001



