
		
	; sprite 1 graphics to expand
	defw sprite_unex_0

	; sprite 2 graphics to expand
	defw sprite_unex_1

	; read block number 1st (right most)
	; read quantity second

	defb %11110110
	defb %11110110
	defb %11110110
	defb %11110110
	defb %11110101
	defb %00010101
	defb %01010000
	defb %10000101
	defb %00001000
	defb %00000000
	defb %00110111
	defb %00000000
	defb %10010101
	defb %00000000
	defb %00110111
	defb %00000000
	defb %01010101
	defb %00001000
	defb %00000101
	defb %00010011
	defb %00000000
	defb %00110111
	defb %00000000
	defb %01110011

	defb %00100100
	defb %00110111
	defb %10000100

	defb %11111111





	; sprites

	; no of sprites
	defb 3

	; colour (hb) and active pause (lb)
	defb %01100001
	; xpos /2 (hb) and ypos /2 (lb)
	; xxxx ypos xxxx xpos
	defb %00011100
	; xmin /2 (hb) and xmax /2 (lb)
	defb %00001110
	; sprite buffer
	defw sprite_buffer_2
	; gfx
	defb sprite_expand_1/256
	; bank count and reset (eg 5 and 5)
	defb %01010101
	; direction
	defb %00000001

	; colour (hb) and active pause (lb)
	defb %01100011
	; xpos /2 (hb) and ypos /2 (lb)
	; xxxx ypos xxxx xpos
	defb %00110011
	; xmin /2 (hb) and xmax /2 (lb)
	defb %00100110
	; sprite buffer
	defw sprite_buffer_3
	; gfx
	defb sprite_expand_2/256
	; bank count and reset (eg 5 and 5)
	defb %01010101
	; direction
	defb %00000001
