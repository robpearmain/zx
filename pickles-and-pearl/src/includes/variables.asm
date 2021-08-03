keyxpostemp: defb 0
keyypostemp: defb 0

gotkey:      defb 0
lastcol:     defb 0

energy:      defb 0



keyslefttocollect:
	defb 0

totalsprites:
	defb 0

dl_xpos:  defb 0
dl_ypos:  defb 0
dl_block: defb 0
jump:     defb 0

shcol:    defb 0
shbit:    defb 0
shand:    defb 0
unexs:    defw 0
unexd:    defw 0

collided:
		defb 0

player_xpos_onscreen:
			defb 0
player_ypos_onscreen:
			defb 0


currentworld:
			defb 0

currentscreen:
			defb 0

musicon:
			defb 0


playeronscreenpos:

	defs sprite_size,0

playerinitiatepositions:

	;       player
	;       ======

	defb 1                 ; 0  active/pause before move to reset to
	defb 3                 ; 1  xpos
	defb 13                 ; 2  ypos
	defb 12                ; 3  anim frame offset
	defb 4                 ; 4  move counter (reset when=4)
	defb 0                 ; 5  ymove
	defb 3                 ; 6  height
	defb 1                ; 7  direction (1=right,-1 left)
	defb 1                 ; 8  move offset (ro)
	defb 0                 ; 9 anim offset (ro)
	defb 32                ; 10 xmax
	defb 0                 ; 11 xmin
	defw sprite_buffer_1   ; 12 sprite buffer
	defb player_gfx/256   ; 14 bank
	defb 06h                ; 15 bank difference to add/subtract (e.g difference between bank2 (bc00) and bank1 (b100) = 3k (768 bytes, 96 chars)
							; 96 = 12*8 (4 for each frame left and right)
	defb 5                 ; 16 counter to change bank, i.e. frame of animation
	defb 4                 ; 17 reset value for bank change
	defb 0                ; 18 image frame difference to add on max/min (12 chars * 4 frames) when
						;    changing direction
	defb %01000101         ; 19 colour
