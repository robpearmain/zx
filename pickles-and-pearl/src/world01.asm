

	org sprites

	; ****************************************************************************

	; sprites

	; only move vertically 1 char, but give illusion of horizonal smoothness
	; in gfx
	;sprites:

	;       player
	;       ======

	defb 1                 ; 0  active/pause before move to reset to
	defb 6                 ; 1  xpos
	defb 0                 ; 2  ypos
	defb 12                ; 3  anim frame offset
	defb 0                 ; 4  move counter (reset when=4)
	defb 0                 ; 5  ymove
	defb 3                 ; 6  height
	defb -1                ; 7  direction (1=right,-1 left)
	defb 1                 ; 8  move offset (ro)
	defb 0                 ; 9 anim offset (ro)
	defb 30                ; 10 xmax
	defb 0                 ; 11 xmin
	defw sprite_buffer_1   ; 12 sprite buffer
	defb player_gfx/256   ; 14 bank
	defb 06h                ; 15 bank difference to add/subtract (e.g difference between bank2 (bc00) and bank1 (b100) = 3k (768 bytes, 96 chars)
							; 96 = 12*8 (4 for each frame left and right)
	defb 5                 ; 16 counter to change bank, i.e. frame of animation
	defb 4                 ; 17 reset value for bank change
	defb 48                ; 18 image frame difference to add on max/min (12 chars * 4 frames) when
						;    changing direction
	defb %01000101         ; 19 colour

	;enemy_sprites:

	defs sprite_size*7,0



	org keystocollect

				defb 8      ; number of keys
	; screen, x, y, enabled
	;keystocollect:
	; Need to change to Screen,X,Y,Enabled,Lock Screen,X,Y,Locked/Unlocked
	; So we could have 32 Key/Door combinations per world
	; Then we copy to area 8000-c000 so we can update during game

				defb 0,15,10,1,1,10,10,1
				defb 0,17,10,1,0,0,0,0
				defb 0,19,10,1,0,0,0,0
				defb 0,21,10,1,0,0,0,0

				defb 1,6,16,1,0,0,0,0
				defb 1,8,18,1,0,0,0,0
				defb 1,10,16,1,0,0,0,0
				defb 1,12,18,1,0,0,0,0
	; ****************************************************************************
	; graphics (background)

	; 1k (128 chars)
	org bg_chars

			include "includes/bgchars.asm"

	org bg_chars_attrs


			include "includes/bgattrs.asm"

	org blox

			defb $00
			defb $01,$02,$03,$04
			defb $05,$06,$07,$08
			defb $09,$0a,$0b,$0c+128
			defb $0d+128,$0e+128,$0f+128,$10
			defb $11,$12,$13,$14
			defb $15,$16,$17,$18
			defb $19,$1a,$1b,$1c
			defb $1d,$1e,$1f,$20
			defb $21,$22,$23,$24
			defb $25,$26,$27,$28
			defb $29+128,$2a,$2b+128,$2c


			;    player can jump up 2 blocks.
			;    always have blocks 2 spaces apart on height
			; can jump 3 blocks and up 1

			; you cannot jump  4 accross 2 up,
			; you can jump 3 accross 2 up, but not 3 up
			; you can jump 3 accross






	; 768 * 7 = 5376 = $1500
	org update_buffer

			defs 768*6

	org scratch
	;scratch: 
		defs 8,0

	;keygfx:

		defb %11111111
		defb %11000011
		defb %10011001
		defb %10111101
		defb %10111101
		defb %10011001
		defb %11000011
		defb %11111111

		defb %11111111
		defb %11100111
		defb %11011011
		defb %11011011
		defb %11011011
		defb %11011011
		defb %11100111
		defb %11111111

		defb %11111111
		defb %11100111
		defb %11100111
		defb %11100111
		defb %11100111
		defb %11100111
		defb %11100111
		defb %11111111

		defb %11111111
		defb %11100111
		defb %11011011
		defb %11011011
		defb %11011011
		defb %11011011
		defb %11100111
		defb %11111111



		

		; storage area for expanded sprite
	; sprite is stored as a 3x3 image with mask, and is expanded to 4 shifted 4x3 images
	org sprite_expand_1
	
				defs 300h
				defs 300h
				defs 300h
				defs 300h
	org sprite_expand_2
	
				defs 300h
				defs 300h
				defs 300h
				defs 300h

	org screens
	include "includes/screens01.asm"

	defb 'END OF SCREENS'