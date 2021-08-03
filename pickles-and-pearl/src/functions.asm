
key_b equ 0
key_h equ 1
key_y equ 2
key_6 equ 3
key_5 equ 4
key_t equ 5
key_g equ 6
key_v equ 7
key_n equ 8
key_j equ 9
key_u equ 10
key_7 equ 11
key_4 equ 12
key_r equ 13
key_f equ 14
key_c equ 15
key_m equ 16
key_k equ 17
key_i equ 18
key_8 equ 19
key_3 equ 20
key_e equ 21
key_d equ 22
key_x equ 23
key_symbol equ 24
key_l equ 25
key_o equ 26
key_9 equ 27
key_2 equ 28
key_w equ 29
key_s equ 30
key_z equ 31
key_space equ 32
key_enter equ 33
key_p equ 34
key_0 equ 35
key_1 equ 36
key_q equ 37
key_a equ 38
key_shift equ 39

;   title:  1000.15 calculate_screen_address
;   date:   24/11/2006
;   author: r.l.pearmain

;   description:
;       calculate screen address into hl

;   on entry:
;      hl=string address
;   on exit


calculate_screen_address

	; calculate display address

	ld   a,(ypostemp)
	ld   l,a
	ld   a,(xpostemp)

	ld   h,screentable/256

	add   a,(hl)

	inc  h
	ld   h,(hl)
	ld   l,a

	ret


calculate_attribute_address


	; for the y position, get the offset (y*32) for the number of rows
	ld hl,row_number_lookup
	ld a,(ypostemp)
	rl a
	add a,l
	ld l,a
	ld e,(hl)
	inc l
	ld a,58h
	ld d,(hl)
	add a,d
	ld d,a

	; de has row address, so add xpos
	ld a,(xpostemp)
	add a,e
	ld e,a

	ex de,hl

	ret

;   title:  1000.12 draw_string
;   date:   06/11/2006
;   author: r.l.pearmain

;   on entry:
;      de=string address
;   on exit


draw_string


	ld a,(xpostemp)
	ld l,a
	ld a,(ypostemp)
	ld h,a
	push hl

	; read xpos from string
	ld a,(de)
	ld (xpostemp),a
	inc de

	; read ypos from string

	ld a,(de)
	ld (ypostemp),a
	inc de

	; read colour from  string

	ld a,(de)
	ld (color),a
	inc de

	call draw_string_chars

	pop hl
	ld a,l
	ld (xpostemp),a
	ld a,h
	ld (ypostemp),a

	ret


;   title:  1000.13 draw_string_chars
;   date:   06/11/2006
;   author: r.l.pearmain

;   on entry:
;      de=string address
;   on exit

draw_string_chars

	; read char
	ld a,(de)
	and 127

	; calculate char gfx address

	push de

	ld hl,font

	sub 32              ; example a=65 'a'-32 = 33
	ld e,a              ; so de = 33
	ld d,0

	;	* by 8
	rl e                ; 33 * 8 = 264
	rl d
	rl e
	rl d
	rl e
	rl d

	add hl,de          ; hl = font + 264
	ex de,hl           ; de now has the gfx address of the char

	; call 1000.8 draw_char

	call calculate_screen_address
	call draw_char_to_screen

	call calculate_attribute_address
	ld a,(color)
	ld (hl),a

	; increase xpos

	ld a,(xpostemp)
	inc a
	and 31
	ld (xpostemp),a

	pop de

	xor a
	ld a,(de)
	and 128
	ret nz

	inc de             ; next char

	jp draw_string_chars

draw_char_to_screen:

				ld b,8
dcts1:
				ld a,(de)
				ld (hl),a
				inc de
				inc h
				djnz dcts1


				ret

draw_blank_char_to_screen:

				xor a
				ld b,8
dbcts1:

				ld (hl),a
				inc de
				inc h
				djnz dbcts1


				ret

;   title:  1000.14 draw_string_multiple
;   date:   07/11/2006
;   author: r.l.pearmain

;   description:
;       print multiple strings
;       finally terminated with 128

;   on entry:
;      de=string address
;   on exit

draw_string_multiple

	call draw_string

	; read next char
	inc de
	ld a,(de)

	; is it a terminator
	and 128

	; yes, then end
	ret nz

	; else draw next string
	jp draw_string_multiple

;   title:  2000.1 key_wait
;   date:   28/10/2006
;   author: r.l.pearmain / david webb
;   description:

;       wait until any key is pressed

;   on entry:



key_wait

	xor a

	; read the entire keyboard
	in a,(0feh)
	cpl
	and 1fh

	; if key not pressed then check

	jr z, key_wait

	ret

;   title:  2000.2 key_wait
;   date:   28/10/2006
;   author: r.l.pearmain / david webb
;   description:

;       test all keys and find the one that is pressed

;   on entry:

;   on exit:

;      if key pressed d = key code (see key code reference)
;      if no key pressed d = 0ffh
;      if more than one key is pressed, zero flag reset

key_find

	ld de,0ff2fh    ; d=0ffh (no key pressed), e=02fh (initial key value)
	ld bc,0fefeh    ; bc=port address for each half row

k_f_1
	; read a half row
	in a,(c)
	cpl
	and 1fh

	; jump if no key pressed
	jr z,k_f_3

	; test for multipress
	inc d
	ret nz           ; return if multipress

	; calculate key value
	ld h,a
	ld a,e
k_f_2
	sub 8
	srl h
	jr nc,k_f_2

	; 2nd test for multipress

	ret nz

	; store key value in d
	ld d,a

	; test the other 7 rows
k_f_3

	dec e
	rlc b
	jr c,k_f_1

	; set zero flag
	cp a
	ret z

;   title:  2000.3 key_test
;   date:   28/10/2006
;   author: r.l.pearmain / david webb
;   description:

;       test a supplied key to see if it is pressed

;   on entry:

;       a=key code (see key code reference)
;   on exit:

;      if key pressed carry reset

key_test

	ld c,a                       ; e.g a 00100110 26 [ key bit position 100 (4) half row 110 (6) ]

	; b=16-address line number

	and 7                        ; e.g a = 110 (6)
	inc a                        ; e.g a = 111 (7)
	ld b,a                       ; e.g b = 7

	; c=data line no+1
	; e.g. c=5-int(c/8)

	; shift 3 times to the right
	srl c                        ; e.g. a = 00100110 to
	srl c
	srl c                        ; e.g. a = 00000100 (4)

	; subtract from 5

	ld a,5
	sub c
	ld c,a                       ; e.g. c = 1, so we only need to rotate input 1 times to get if
								;      pressed or not

	; calculate hi byte of port address

	ld a,0feh
k_t_1
	rrca
	djnz k_t_1                  ; e.g. 0feh = 11111110 rotate 7 times = 11111101 (0fdh)

	; read half row
	in a,(0feh)                 ; e.g. read the line with a-g (0fdh)

	; put required key bit into carry
k_t_2
	rra
	dec c
	jr nz,k_t_2                 ; e.g. keep rotating 1 times

	ccf                         ; ensure 1 = pressed ( i.e. c = 0 ensure it is 1)

	ret

;   title:  2000.4 key_string_lookup
;   date:   06/11/2006
;   author: r.l.pearmain
;   description:

;       return address of string based on key press

;   on entry:

;       a=key code (see key code reference)
;   on exit:

;      de=key string address

key_string_lookup

	ld hl,key_string_table


	rlca                     ; 2 bytes per address

	ld e,a
	ld d,0
	add hl,de
	ld e,(hl)
	inc hl
	ld d,(hl)

	ret

;   title:  2000.5 key_wait_unique
;   date:   06/11/2006
;   author: r.l.pearmain
;   description:

;       return key code (see key code reference)
;       that is not the same as the last key
;       pressed

;   on entry:

;	none

;   on exit:

;      a=key code

;  main function
key_wait_unique

	; get key press
	call key_find

	; retry if either no keypress or multiple keys, reset last key to none (ff)
	jr nz,k_w_u_1
	inc d
	jr z,k_w_u_1
	dec d

	jr k_w_u_2

;    reset key
k_w_u_1
	ld a,0ffh
	ld (k_w_u_lastkey),a

	jr key_wait_unique

k_w_u_2
	; compare keypress to the last key pressed
	ld a,(k_w_u_lastkey)
	ld l,a

	ld a,d
	cp l

	; if the same key pressed try again
	jr z,key_wait_unique

	ld a,d                    ; store key press in lastkey
	ld (k_w_u_lastkey),a

	ret

k_w_u_lastkey:
	defb 0

;   title:  2000.6 key_redefine_check_unique
;   date:   07/11/2006
;   author: r.l.pearmain
;   description:

;   checks keys store to ensure it doesnt already exist

;   on entry:

;       a=key code

;   on exit:

;      nz if key ok

key_redefine_check_unique

	ld c,a
	ld de,key_store

	; keys to check = 5
	ld b,5
k_r_c_u_1

	; is key pressed found
	ld a,(de)
	cp c
	ret z

		

	; check next key
	inc de

	; any keys left to check?
	djnz k_r_c_u_1

	push bc
	ld c,2
			ld b,0          ;full volume.
			ld a,4
			call PLY_AKM_PLAYSOUNDEFFECT
		pop bc
	ld a,c

	ret

;   title:  2000.7 key_redefine
;   date:   07/11/2006
;   author: r.l.pearmain
;   description:

;   redefine all 5 keys

;   on entry:

;       none

;   on exit:

;      5 unique keys defined

key_redefine

	; reset keys
	ld hl,key_store
	ld (hl),0ffh
	ld de,key_store+1
	ld bc,4
	ldir
	; point x,y to the first screen key

	ld a,(key_redefine_xpos)
	ld (xpostemp),a
	ld a,(key_redefine_ypos)
	ld (ypostemp),a
	ld a,(key_redefine_color)
	ld (color),a


	ld de,key_store

	; keys to define = 4
	ld b,3

k_r_1

	push bc
	push de

k_r_2
	; example for redefine
	call key_wait_unique
	call key_redefine_check_unique
	jr z,k_r_2

	push af
	call key_string_lookup
	call draw_string_chars
	pop af

	pop de

	ld (de),a
	inc de

	; next row line by 2
	ld a,(ypostemp)
	inc a
	inc a
	ld (ypostemp),a

	ld a,(key_redefine_xpos)
	ld (xpostemp),a

	pop bc

	; any more keys to define
	djnz k_r_1

	ret

draw_window:

	ld a,(de)
	ld (xpostemp),a
	inc de
	ld a,(de)
	ld (ypostemp),a
	inc de
	ld a,(de)
	ld (widthtemp),a
	inc de
	ld a,(de)
	ld (heighttemp),a

	call window

	ret



window:

	ld a,(heighttemp)
	ld b,a
w1:
	push bc

	ld a,(xpostemp)
	push af

	ld a,(widthtemp)
	ld b,a
w2:

	push bc
	call calculate_screen_address
	push hl
	call draw_blank_char_to_screen
	pop hl
	call calculate_attribute_address
	xor a
	ld (hl),a

	ld a,(xpostemp)
	inc a
	ld (xpostemp),a
	pop bc
	djnz w2

	pop af
	ld (xpostemp),a

	ld a,(ypostemp)
	inc a
	ld (ypostemp),a

	pop bc

	djnz w1

	ret

cls:
	ld hl,4000h
	ld de,4001h
	ld (hl),0
	ld bc,17ffh
	ldir
	
	ld hl,5800h
	ld de,5801h
	ld (hl),7
	ld bc,2ffh
	ldir
	
	ret

key_redefine_xpos:
	defb 17
key_redefine_ypos:
	defb 8
key_redefine_color:
	defb %01000101

xpostemp: defb 0
ypostemp: defb 0
color: defb 0
widthtemp: defb 0
heighttemp: defb 0


;   keys used by game = up,down,left,right,fire
key_store:
	defb 01ah
	defb 022h
	defb 020h
	defb 01eh
	defb 0ffh
	; strings to display by redefine function
key_strings:

key_string_1:             defb '1'+128
key_string_2:             defb '2'+128
key_string_3:             defb '3'+128
key_string_4:             defb '4'+128
key_string_5:             defb '5'+128
key_string_6:             defb '6'+128
key_string_7:             defb '7'+128
key_string_8:             defb '8'+128
key_string_9:             defb '9'+128
key_string_0:             defb '0'+128
key_string_a:             defb 'A'+128
key_string_b:             defb 'B'+128
key_string_c:             defb 'C'+128
key_string_d:             defb 'D'+128
key_string_e:             defb 'E'+128
key_string_f:             defb 'F'+128
key_string_g:             defb 'G'+128
key_string_h:             defb 'H'+128
key_string_i:             defb 'I'+128
key_string_j:             defb 'J'+128
key_string_k:             defb 'K'+128
key_string_l:             defb 'L'+128
key_string_m:             defb 'M'+128
key_string_n:             defb 'N'+128
key_string_o:             defb 'O'+128
key_string_p:             defb 'P'+128
key_string_q:             defb 'Q'+128
key_string_r:             defb 'R'+128
key_string_s:             defb 'S'+128
key_string_t:             defb 'T'+128
key_string_u:             defb 'U'+128
key_string_v:             defb 'V'+128
key_string_w:             defb 'W'+128
key_string_x:             defb 'X'+128
key_string_y:             defb 'Y'+128
key_string_z:             defb 'Z'+128
key_string_enter:         defb 'ENTE','R'+128
key_string_shift:         defb 'SHIF','T'+128
key_string_symbol:        defb 'SYMBO','L'+128
key_string_space:         defb 'SPAC','E'+128

;   look up the string to display
;   based on key number
key_string_table:

	defw key_string_b                ; 0
	defw key_string_h                ; 1
	defw key_string_y                ; 2
	defw key_string_6                ; 3
	defw key_string_5                ; 4
	defw key_string_t                ; 5
	defw key_string_g                ; 6
	defw key_string_v                ; 7
	defw key_string_n                ; 8
	defw key_string_j                ; 9
	defw key_string_u                ; 10
	defw key_string_7                ; 11
	defw key_string_4                ; 12
	defw key_string_r                ; 13
	defw key_string_f                ; 14
	defw key_string_c                ; 15
	defw key_string_m                ; 16
	defw key_string_k                ; 17
	defw key_string_i                ; 18
	defw key_string_8                ; 19
	defw key_string_3                ; 20
	defw key_string_e                ; 21
	defw key_string_d                ; 22
	defw key_string_x                ; 23
	defw key_string_symbol           ; 24
	defw key_string_l                ; 25
	defw key_string_o                ; 26
	defw key_string_9                ; 27
	defw key_string_2                ; 28
	defw key_string_w                ; 29
	defw key_string_s                ; 30
	defw key_string_z                ; 31
	defw key_string_space            ; 32
	defw key_string_enter            ; 33
	defw key_string_p                ; 34
	defw key_string_0                ; 35
	defw key_string_1                ; 36
	defw key_string_q                ; 37
	defw key_string_a                ; 38
	defw key_string_shift            ; 39




