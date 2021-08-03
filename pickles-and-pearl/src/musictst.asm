org $8000

		jp go

		; music
		include "../resources/pnpmusicpasmo.asm"
			
go:
	; put stack at top of 32k before $c000
	ld sp,$bfff     

	xor a
	call playmusic

	call initiate_im2_interrupts

lp1:

ld bc,63486         ; keyboard row 1-5/joystick port 2.
		in a,(c)            ; see what keys are pressed.
		rra                 ; outermost bit = key 1.
		jr nc,playfx        ; if carry then no key pressed
		
		xor a
		ld (keypressed),a
		jr lp1

playfx:
		ld a,(keypressed)
		and 255
		jr nz,lp1

		ld a,(SelectedSoundEffect)
		inc a
		cp 6
		jr nz,playfx2
		ld a,1
playfx2:
		ld (SelectedSoundEffect),a
		ld c,2
		ld b,0          ;Full volume.
		call PLY_AKM_PLAYSOUNDEFFECT
		ld a,1
		ld (keypressed),a
	
		jr lp1

SelectedSoundEffect: db 0                       ;The selected sound effect (>=1). The code increases the counter first, so setting 0 is fine.       
keypressed: db 0



	

;     ****************************************
;     procedure : initiate_im2_interrupts
;     function  : set up the interrup handler
;                 to play music every 1/50th

;     ****************************************
initiate_im2_interrupts:

; setup the 128 entry vector table
	di

	ld            hl, im2table
	ld            de, im2table+1
	ld            bc, 256

	; setup the i register (the high byte of the table)
	ld            a, h
	ld            i, a

	; set the first entries in the table to $fc
	ld            a, $bc
	ld            (hl), a

	; copy to all the remaining 256 bytes
	ldir

	; setup im2 mode
	im            2
	ei

	ret

	; on entry: a contains song number
	;initializes the music.
	;initializes the sound effects.

playmusic:

	ld hl,SOUNDEFFECTS_SOUNDEFFECTS
	call PLY_AKM_INITSOUNDEFFECTS

	ld hl,PNP_START
	xor a                   ;subsong 0.
	call PLY_AKM_INIT

	ret 

; this routine now needs to be at a specific address (remember we only have from $fcfc to $fe00 else we will overwrite our table)
			;org           $fcfc
			org           $bcbc

; basically nothing
im2routine:   
			push          af
			push          hl
			push          bc
			push          de
			push          ix
			push          iy
			exx
			ex af,af'
			push          af
			push          hl
			push          bc
			push          de

			call PLY_AKM_PLAY

			pop           de
			pop           bc
			pop           hl
			pop           af
			ex af,af'
			exx
			pop           iy
			pop           ix
			pop           de
			pop           bc
			pop           hl
			pop           af

			ei
			reti

; make sure this is on a 256 byte boundary
			org           $be00
im2table:
			defs          257

; tell assembler to start at 8000h
end 08000h