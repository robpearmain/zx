;       colour test

;       test39.asm
;       28/08/2019

;       note: last working test38.asm

;       done:

;       horizontal sprites that are masked with background
;       restore colours on change
;       background blocks + 128 means they are in the foreground
;       level renderer
;       player control and proper arc jump
;       added expand functionality so that sprites can be expanded out
;       pass in a 3x3 x 4 frames (2 x left, 2 x right) and it will expand them to the 3k equivalent

;       added new cat graphics
;       moved memory around, removed need for blank char saving 1k
;       move more memory around
;       added expand functions
;       added compressed level block data
;       added decompress to one sprite, need to do others
;       added level functions, now have compessed levels and sprites
;       collision detection on other sprites
;       menu + key redefine
;       have keys to collect
;       create different screens for map
;       add main game menus
;       add level name functions
;       add hud

;       fixed bugs where when you went straight back to the screen to came from
;       it positioned you incorrectly (ix)

;       fixed bug where key used xpostemp and randomly corrupted the backbuffer

;       to do:

;       add a blox offset for each screen, i.e. number to add on to each block to allow different
;       screens to contain more than the base 16 blox.

;       add game over sequence
;       add end of game sequence
;       create remaining screens
;       create front screen gfx
;       fix player graphics eye
;       fix player graphics to expand like the others (easier to maintain and reuse for pickles)

;       2019

;    ay sound and fx
;    restructure of code into folders and includes

          ; attribute colors
          paper_black	          equ	%00000000
          paper_blue	          equ	%00001000
          paper_red	               equ	%00010000
          paper_magenta	          equ	%00011000
          paper_green	          equ	%00100000
          paper_cyan	          equ  %00101000
          paper_yellow	          equ	%00110000
          paper_white	          equ  %00111000

          ink_black	               equ	%00000000
          ink_blue	               equ	%00000001
          ink_red	               equ	%00000010
          ink_magenta	          equ  %00000011
          ink_green	               equ  %00000100
          ink_cyan	               equ	%00000101
          ink_yellow	          equ  %00000110
          ink_white	               equ  %00000111

          attr_bright              equ %01000000
          attr_flash               equ %10000000

          attributes               equ 5800h

          sprite_size              equ 20
          sprite_frame_size        equ 12  ; total chars per frame
          sprite_width             equ 3
          sprite_height            equ 2
                    
          totalkeystocollect       equ 8
          totalkeystocollectcol1   equ 0
          totalkeystocollectcol2   equ 8


          org $8000

          jp go

           ; music
          include "../resources/pnpmusicpasmo.asm"

          include "includes/screens.asm"
          include "includes/variables.asm"
         
          include "includes/strings.asm"
font:
          include "includes/arcdfont.asm"

             
go:
          
     xor a                    ;    set a = 0
     out (0feh),a             ;    output to border

     ld a,1                   ;    on startup set music on
     ld (musicon),a

     xor a
     call playmusic

     call initiate_im2_interrupts

begin:
         
     call cls
     call menu

     cp key_2
     jr nz,b1

     call redefine
     jr begin

b1:
     cp key_1
     jr z,start

     cp key_m
     jr nz,begin

     ld a,(musicon)
     xor 1
     ld (musicon),a

     ; if we want silent music then create a looped silence as a song

     jr begin
          
start:

     xor a
     call playmusic

     call startnewgame

main_loop:

     xor a
     ld (collided),a

     ; draw any change cells to the screen
     call blit_update_buffer

     ; clear out the buffer
     call clear_update_buffer

     ; move the player
     call move_player

     ; then move the sprites (1 of which is the player)
     call move_sprites

     ; display keys to collect
     call showkeys

     ld a,(energy)
     and 255
     jr z,endoflife

     ld a,(collided)
     and 255
     jr z,main_loop

     call decreaseenergy

     ld a,(energy)
     and 255
     jr z,endoflife

     jr main_loop

endoflife:

   
     ld c,2
     ld b,0          ;full volume.
     ld a,5
     call PLY_AKM_PLAYSOUNDEFFECT

     ld a,(lives+3)
     dec a
     ld (lives+3),a
     cp '0'-1
     jp z,begin

     call newlife

     jp main_loop

newlife:
    call getplayerstatus

     xor a
     ld (jump),a
     ld (sprites+5),a
     ld a,(player_xpos_onscreen)
     ld (sprites+1),a
     ld a,(player_ypos_onscreen)
     ld (sprites+2),a

     call setup_screen
     call resetenergy

     ld de,items_left
     call draw_string
     ld de,items
     call draw_string

     xor a

     ret

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
     ld            a, $fc
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

     ; level will be 0,1,2 etc
     ; look up in levels to find the start address
     ; of the level data and return in de
getscreen:

     ld a,(currentscreen)
     ld hl,screens
     rl a
     ld l,a
     ld e,(hl)
     inc hl
     ld d,(hl)

     ret

initiateplayer:

     ; copy sprites initial positin
     ld de,sprites
     ld hl,playerinitiatepositions
     ld bc,sprite_size
     ldir

     ret

saveplayerstatus:

     ; copy sprites initial positin
     ld de,playeronscreenpos
     ld hl,sprites
     ld bc,sprite_size
     ldir

     ret

getplayerstatus:

     ; copy sprites initial positin
     ld de,sprites
     ld hl,playeronscreenpos
     ld bc,sprite_size
     ldir

     ret



startnewgame:

     call initiateplayer

     ld a,'9'
     ld (lives+3),a

     xor a
     ld (jump),a
     ld (sprites+5),a

     xor a
     ld (currentscreen),a

     call resetkeystocollect

     call setup_screen

     ld de,items_left
     call draw_string_multiple

     ld de,items
     call draw_string_multiple
     call resetenergy


     ; move the player
     call move_player

     ; then move the sprites (1 of which is the player)
     call move_sprites

     call blit_update_buffer
     ; display keys to collect
     call showkeys

     ret

resetenergy:
     ld a,30
     ld (energy),a
     ld hl,attributes+768-31
     ld a,paper_green+ink_white+attr_bright
     ld b,30
su1:
     ld (hl),a
     inc l
     djnz su1

     ld de,energy_message
     call draw_string_multiple
     ld de,lives_message
     call draw_string_multiple
     ld de,lives
     call draw_string_multiple

     ret

menu:
     ld de,menu_window
     call draw_window

     ld de,menu_message
     call draw_string_multiple
     
me1:
     call key_wait_unique

     cp key_1              ; 1
     ret z

     cp key_2              ; 2
     ret z

     cp key_m              ; m
     ret z
     
     jr me1

redefine:

     ld de,menu_window
     call draw_window

     ld de,redefine_message
     call draw_string_multiple

     call key_redefine

     ret

move_player:
     ld ix,sprites

     ; check to see if player is jumping
     ; if so, remove all control from user

     ld a,(jump)
     and 255
     jp nz,jumping

     ;  stop player moving
     ld (ix+7),0

     ; check right key
     ld a,(key_store+1)
     call key_test
     call c,mpr

     ; check left key
     ld a,(key_store)
     call key_test
     call c,mpl

     ; check jump key
     ld a,(key_store+2)
     call key_test
     jp c,jumpstart

     ; check player is moving
     ; if we are moving left or right,
     ; return so that player is animated
     ld a,(ix+7)
     and 255
     ret nz

     ; stop animation
     ; force bank switch to stop
     ; by setting to maximum on each pass
     ld a,(ix+17)
     ld (ix+16),a

     ret

mpl:
     ld ix,sprites

     ; direction = -1
     ld (ix+7),-1

     ; offset for graphics = 48 (4 frames)
     ld (ix+18),48

     call checkscreenleft

     ret


checkscreenleft

     ld a,(ix+4)
     cp 0
     ret nz

     ld a,(ix+1)
     cp 0
     ret nz

csl1:
     ld (ix+1),28 ; set xpos to 28
     ld (ix+4),4  ; set anim frame to 4

     ld a,(currentscreen)
     dec a
     ld (currentscreen),a

     call setup_screen

     ret

checkscreendown

     ld a,(ix+2)
     cp 18
     ret nz

     ld (ix+2),0 ; set xpos to 28


     ld a,(currentscreen)
     add a,4
     ld (currentscreen),a
     call setup_screen

     ret

mpr:

     ; direction = 1
     ld (ix+7),1

     ; offset for graphics = 0 (beginning of player frames)
     ld (ix+18),0

     call checkscreenright

     ret

            
checkscreenright:

     ld a,(ix+1)
     cp 28
     ret c

     cp 29
     jr z,csr1

     ; if 29, is anim frame to edge of screen
     ld a,(ix+4)
     cp 3
     ret nz

csr1:
     ld (ix+1),0  ; xpos
     ld (ix+4),4  ; set anim frame to 0
     ld a,(currentscreen)
     inc a
     ld (currentscreen),a

     call setup_screen

     ret

jumpstart:
     call amionplatform

     ld a,e            ; if we are not on a platform
     and 1             ; then we can't jump
     ret nz


     ; only allow player to jump if he is on a platform
     ld c,2
     ld b,0          ;full volume.
     ld a,4
          
     call PLY_AKM_PLAYSOUNDEFFECT

jumping:
     ld a,(ix+7)         ; if we are moving left or right
     and 255             ; we want to animate
     jr nz,jump2

     ; stop animation if not moving left or right
     ld a,(ix+17)
     ld (ix+16),a

jump2:
          ; increase jump flag until we hit 16 then end
     ld a,(jump)
     inc a
     and 15
     ld (jump),a

     ; if we have hit 0, that's the end so quit
     ret z

     ;   lookup and get the jump pattern byte

     ld hl,jumppattern
     add a,l
     ld l,a
     ld a,(hl)

     ; the amount to add to y position for player
     ld (ix+5),a

     ; as there are 16 steps to the jump, if we are
     ; above 7 then logically we are on decent of the jump arc

     ld a,(jump)
     and %11111000

     jr z,testup

     ;   on decent, check if we have hit a platform
     call amionplatform


     ld a,e            ; if we have not hit a platform
     and 1
     jr nz,testleftorright

     ; if we have hit a platform, reset jump so
     ; jump has ended

     xor a
     ld (jump),a
     ld (ix+5),a

     ret

testup:   
     ld a,(ix+2)
     cp $ff

     jr z,checkscreenup
     call amihittingblock

     ld a,e
     and 1
     jr nz,testleftorright

     xor a
     ld (jump),a
     ld (ix+5),a

     call decreaseenergy

     ret

checkscreenup:

     ld (ix+2),15 ;     bohhom of screen

     ld a,(currentscreen)
     sub 4                ; 4 screens up
     ld (currentscreen),a

     call setup_screen

     ret

testleftorright:

     ld a,(ix+7)
     cp 1
     jr nz,testleft
     call checkscreenright
     ret

testleft:
     call checkscreenleft
     ret

; move all sprites including player

move_sprites:
     ld ix,sprites
     ld a,(totalsprites)
ms1:
     ex af,af'

     ;  is sprite active, if not go to next sprite
     ld a,(ix+0)
     and 255
     jp z,get_next_sprite

bank_decrease:
     ; decrease bank chsnge time
     ld a,(ix+16)
     dec a
     ld (ix+16),a
     jr nz,move_decrease

     ; bank counter allows the 2 frame animation
bank_counter_reset:

     ; reset bank counter to bank counter reset value
     ld a,(ix+17)
     ld (ix+16),a

     ; switch bank by adding the bank offset value
     ld a,(ix+14)
     add a,(ix+15)
     ld (ix+14),a

     ; negate the bank offset value for next time we switch
     ld a,(ix+15)
     neg
     ld (ix+15),a

move_decrease:

     ; decrease move counter
     ld a,(ix+8)
     dec a
     jr z,move_counter_reset

     ; not time to move, so store away value
     ld (ix+8),a
     jp get_next_sprite

move_counter_reset:

     ; ix+0 doubles as both active (>0) and reset for movement counter
     ld a,(ix+0)

     ;  reset movement counter
     ld (ix+8),a

     ; first check if we are currently dealing with the player
     ; if so we need to check if he is jumping

     ; get current sprite (af' contains the counter for all sprites
     ex af,af'
     ld e,a
     ex af,af'

     ;  are we on sprite 1, player, if not just check to see if sprite is on a platform
     ld a,(totalsprites)

     cp e
     jr nz,check_sprite_is_on_platform

     ; if we are the player, check to see if we are jumping, so don't check if we are falling
     ld a,(jump)
     and 255
     jr nz,sprite_can_move

check_sprite_is_on_platform:
     ; first check if we are on a platform

     call amionplatform

     ld a,e
     and 1
     jr z,sprite_can_move

     ; if not on plaform, move the sprite down 1 row
     ; must do this before moving
     call remove_sprite

     ld a,(ix+2)
     inc a
     ld (ix+2),a

     ; check for screen below
     call checkscreendown

     jp sprite_can_be_drawn

sprite_can_move:

     ; must do this before moving
     call remove_sprite

     ; add any vertical movement, even if not time to move
     ; to get fast fall from platform
     ld a,(ix+2)
     add a,(ix+5)
     ld (ix+2),a

     ; get move counter and add direction (either -1 or 1)
     ld a,(ix+4)
     add a,(ix+7)

     ; if we are now "-1" then move sprite left.
     jp m,move_sprite_left

     ; if we are now "4" then move right
     cp 4
     jr z,move_sprite_right

     ; trim off -1 or 4 to get 0 to 3
     and 3
     ld (ix+4),a

     jp calculate_correct_sprite_frame

     ; move counter has hit "4" so time to change column.

move_sprite_right:

     ; move offset now reset
     xor a
     ld (ix+4),a

     ; get xpos, and check if we have hit the max
     ld a,(ix+1)
     cp (ix+10)     ; max
     ;jr nz,move_sprite_right_check_obstructions
     jr z,move_sprite_right_hit_maximum
     ; we have not hit the max

     ; check the bottom right character to see if it is solid

     ld bc,0204h
     call get_player_buffer_address

     ; is it a foreground block
     xor a
     ld a,(hl)
     and 128
     jr nz,move_sprite_right_ok

     ; need to put check in for background types by checking the flash attribute
     push hl        
     ld de,back_colour_buffer-bg_buffer
     add hl,de
     ld a,(hl)
     pop hl              

     ; is it solid, if so, ok
     and 128

     jr z,move_sprite_right_ok

move_sprite_right_hit_maximum:
     ; are we dealing with the player?
     ex af,af'
     ld e,a
     ex af,af'

     ld a,(totalsprites)
     cp e
     ld a,3           ; correct move offset for smooth movement
     jr z,sprite_store_right_move_position        ; if player, just stay where we are

     ; reverse sprite, as we have hit an obstruction before hitting max
     ld a,(ix+7)
     neg
     ld (ix+7),a
               ; set graphics offset to 48 (4 x 12 chars) for
     ; left facing version

     ; frames 0-3 for right facing at 2 pixel shifts
     ; 4-7 for left facing at 2 pixel shifts
     ; bank has same but different animation frame
     ld a,48
     ld (ix+18),a

     ld a,2           ; correct offset for smooth movements

sprite_store_right_move_position:
     ld (ix+4),a
     jr calculate_correct_sprite_frame

move_sprite_right_ok:
     ld a,(ix+1)
     inc a
     ld (ix+1),a

     jr calculate_correct_sprite_frame

     ; sprite is ok to move left
move_sprite_left:
     ; move offset now reset (to 3 for left)
     ; as (ix+4) use to calculate frames for
     ; 2 pixel offsets
     ld a,3
     ld (ix+4),a

     ; have we hit the minimum?
     ld a,(ix+1)
     cp (ix+11)
     jr z,move_sprite_left_hit_minimum

     ; get the bottom left character
     ld bc,02ffh
     call get_player_buffer_address

     ; if foreground, ignore
     xor a
     ld a,(hl)
     and 128
     jr nz,move_sprite_left_ok

     ; need to put check in for background types by checking the flash attribute
     push hl
     ld de,back_colour_buffer-bg_buffer
     add hl,de
     ld a,(hl)
     pop hl

     ; is it solid, if so, ok
     and 128

     jr z,move_sprite_left_ok

move_sprite_left_hit_minimum

     ; is this spriute the player
     ex af,af'
     ld e,a
     ex af,af'

     ;  are we on sprite 1, player
     ld a,(totalsprites)
     cp e         ; as we are counting total_sprites, the first will be total_srites
     ld a,0                   ; offset for smooth movement (not xor a to preserve flags)
     jr z,sprite_store_left_move_position

     ; reverse sprite direction
     ld a,(ix+7)
     neg
     ld (ix+7),a

     ; set to right chars
     xor a        ; 48 = 12 chars * 4 frames
     ld (ix+18),a

     ld a,1      ; offset for smooth movement

sprite_store_left_move_position:

     ld (ix+4),a

     jr calculate_correct_sprite_frame

move_sprite_left_ok:
     ld a,(ix+1)
     dec a
     ld (ix+1),a

;        work out the frame
calculate_correct_sprite_frame:
     xor a
     ld b,(ix+4)           ; move offset
ccsf_lp
     add a,sprite_frame_size
     djnz ccsf_lp

     ; store the offset when it comes to drawing
     ld (ix+9),a

sprite_can_be_drawn:
     call draw_sprite

get_next_sprite:
     ld de,sprite_size
     add ix,de

     ; check collision
     ld a,(totalsprites)
     ld e,a
     ex af,af'

     ; if not player, check for collision
     cp 1
     jr z,nxt1
         
     push af
     call collide
     pop af

nxt1:
     dec a
     jp nz,ms1

     ret

     ; based on the player x,y position get address

     ; bc = y,x offset to add on
     ; exit: hl = address

get_player_buffer_address:
     ld hl,row_number_lookup
     ld a,(ix+2)
     add a,b    ; offset for height
     rl a
     add a,l
     ld l,a
     ld e,(hl)
     inc l
     ld d,(hl)

     ; de has row address, so add xpos
     ld a,(ix+1)
     add a,c
     add a,e
     ld e,a

     ; de now has the correct offset

     ld hl,bg_buffer
     add hl,de

     ret

amihittingblock:
     ld bc,00000h    ; 1 chars up, 0 accross
     call get_player_buffer_address

     ; is it a foreground block, if so, ok
     xor a
     ld e,a
     ld a,(hl)
     and 128
     jr nz,amhb01

     ; need to put check in for background types by checking the flash attribute
     push hl
     ld de,back_colour_buffer-bg_buffer
     add hl,de
     ld a,(hl)
     pop hl

     ; is it solid, if so, ok
     and 128
     ret nz

amhb01
     ; no space, so check further along

     ; check 2 spaces along
     inc hl
     inc hl

     ld a,(hl)
     and 128
     jr nz,amhb02

     ; need to put check in for background types by checking the flash attribute
     push hl
     ld de,back_colour_buffer-bg_buffer
     add hl,de
     ld a,(hl)
     pop hl

     ; is it solid, if so, ok
     and 128
     ret nz

amhb02:
     ;check 3 spaces along
     inc hl

     ld a,(hl)
     and 128
     jr nz,amhb03

     ; need to put check in for background types by checking the flash attribute
     push hl
     ld de,back_colour_buffer-bg_buffer
     add hl,de
     ld a,(hl)
     pop hl

     ; is it solid, if so, ok
     and 128
     ret nz
amhb03:
     ; set e to "yes"
     ld e,1

     ret

; check to see if sprite is on a platform
amionplatform:


          ld bc,0300h    ; 3 chars down, 0 accross
          call get_player_buffer_address

          ; is it a foreground block, if so, ok
          xor a
          ld e,a
          ld a,(hl)
          and 128
          jr nz,ami01

          ; need to put check in for background types by checking the flash attribute
          push hl
          ld de,back_colour_buffer-bg_buffer
          add hl,de
          ld a,(hl)
          pop hl

          ; is it solid, if so, ok
          and 128
          ret nz

ami01
          ; no space, so check further along

          ; check 2 spaces along
          inc hl
          inc hl

          ld a,(hl)
          and 128
          jr nz,ami02

          ; need to put check in for background types by checking the flash attribute
          push hl
          ld de,back_colour_buffer-bg_buffer
          add hl,de
          ld a,(hl)
          pop hl

          ; is it solid, if so, ok
          and 128
          ret nz

ami02:
          ;check 3 spaces along
          inc hl

          ld a,(hl)
          and 128
          jr nz,ami03

          ; need to put check in for background types by checking the flash attribute
          push hl
          ld de,back_colour_buffer-bg_buffer
          add hl,de
          ld a,(hl)
          pop hl

          ; is it solid, if so, ok
          and 128
          ret nz
ami03:
          ; set e to "yes"
          ld e,1


          ret

; ****************************************************************************

; draw_sprite
; ===========

; a sprite is defined in characters (e.g. 1,2,3,4) which are pos to the
; graphics character for a sprite.

; draw_sprite does not render anything to the screen, it simply writes to the
; correct cells in the sprite's buffer with the defined values, and tells the
; update_buffer which cells to re-render

; before calling the functions, a couple of memory variables need to be set

; spr_addr = the sprite chars to draw
; spr_buffer_addr = the sprite buffer to write to

; do this by writing to memory directly.

; e.g. ld hl,sprite1
;      ld (spr_addr+1),hl

; ****************************************************************************
draw_sprite:
            ; reset carry
            xor a

            ld a,(ix+2)
            ld (ypostemp),a
            ld a,(ix+1)
            ld (xpostemp),a

            ; replaced before calling function
spr_addr:
             ld a,1
             ld (ds_char+1),a

            ;  we build up sprite in columns
            ld a,4
            ld b,a

            ;  x columns accross
ds_1
            push bc

            ; rows
            ld a,(ix+6)
            ld b,a

ds_2
            push bc

            ; for the y position, get the offset (y*32) for the number of rows
            ld hl,row_number_lookup
            ld a,(ypostemp)
            rl a
            add a,l
            ld l,a
            ld e,(hl)
            inc l
            ld d,(hl)

            ; de has row address, so add xpos
            ld a,(xpostemp)
            add a,e
            ld e,a

            ; de now has the offset for the cell

            ; tell the update buffer that this cell needs updating
            ld hl,update_buffer
            add hl,de

            ld (hl),1

;            ld a,(ix+19)
;            ld hl,sprite_colour_buffer
;            add hl,de
;            ld (hl),a

            ; we need to write the correct mask char into the sprite buffer
             ; replaced before calling function
spr_buffer_addr
            ld l,(ix+12)
            ld h,(ix+13)
                    ; e.g. sprite_buffer_1
            add hl,de

            ; hl has the correct char address in sprite buffer
ds_4

            ; write the char to the sprite's buffer
ds_char:

            ld a,0
            add a,(ix+18)
            add a,(ix+9)
            ld (hl),a

            ld a,(ds_char+1)
            inc a
            ld (ds_char+1),a
ds_5
            ; get next char (e.g. bottom left)
            inc de

            ; get loop for rows back
            pop bc

            ; increase the row
            ld a,(ypostemp)
            inc a
            ld (ypostemp),a

            ; loop to next row
            djnz ds_2

            ;    next column, so reset ypos
            ld a,(ix+2)
            ld (ypostemp),a


            ; increase xpos

            ld a,(xpostemp)
            inc a
            and 31
            ld (xpostemp),a

            pop bc

            ;   loop for all columns
            djnz ds_1

            ; the sprite buffer now contains the correct chars to render
            ; and the update buffer has flagged the relevant cells to re-render

            ret


; ****************************************************************************

; blit_update_buffer
; ==================

; check each cell in the update buffer.  if set to "1" then draw the background
; char and all sprite chars for that char to the screen

; background is written directly, sprite chars are masked



blit_update_buffer:

          ; 768 chars to check (16 * 32)

          ld hl,update_buffer+767
          ld bc,768
bb1:
          ; if zero, no update need to skip to next char
          ld a,(hl)
          and 255
          jp z,bb2

          ; if "1" then we need to draw
bb3:



          push hl       ; position in update buffer
          push bc       ; counter

          dec bc        ; decrease the counter


          push bc       ; store again
          push hl       ; store update postiton again


          ; background char
          ; ---------------

          ; first we get the memory difference between the background
          ; buffer and the update buffer - 1

          ld de,bg_buffer-update_buffer


          add hl,de          ; hl now points to the correct char in the background buffer

          ld a,(hl)          ; get background char
          ex af,af'          ; store away.  we will check later to see if background is drawn in front

          ; mask off foreground/background indicator
          ld a,(hl)
          and 127


          ; multiply by 8 to get start address (up to 127 background chars)
          ld e,a
          ld d,0

          rl e
          rl d
          rl e
          rl d
          rl e
          rl d

          ld hl,bg_chars
          add hl,de          ; hl now points to the correct graphic
                             ; for the background character

;          ld de,(screen_address)
          ld de,scratch

          ;    de now = graphics address
          ;    hl now = screen address


          ex de,hl
          ; draw the background character
          call draw_char

          pop hl        ; hl now = position in update buffer
          pop bc        ; bc = counter


          ex af,af'     ; if char is in the foreground skip drawing
          and 128       ; sprites to give the appearence of foreground
          jr nz,bb6
          

          ; sprites char
          ; ---------------

          ;  draw the sprite characters for this cell through 1-8
          ;  each is 768 bytes apart

          ; de = first buffer (there are 8)
          ld de,sprite_buffer_1-update_buffer

          ld ix,sprites

          ld a,(totalsprites)
cells_a
          ex af,af'      ; store away as a loop counter

          add hl,de      ; hl now = char in sprite buffer

          push hl

          ld a,(hl)      ; if no char, ignore and move to
                         ; next sprite
          and 255
          jr z,cells_b

          dec a
          ld e,a         ; calculate start of graphic
          ld d,0

          ; * 16 per masked char
          rl e
          rl d
          rl e
          rl d
          rl e
          rl d
          rl e
          rl d

          ; get the image bank for this sprite
          ld h,(ix+14)
          ld l,0

          add hl,de

          ;  hl has graphics address

          ;  get the screen address for this character square

          ;    bc is 1-768, we want 0-767

          ld de,scratch


          ex de,hl

          push bc
          call draw_char_masked
          pop bc


cells_b
          pop hl

          ld de,sprite_size
          add ix,de

          ld de,768


          ex af,af'
          dec a
          jr nz,cells_a

          ld hl,scratch

          ; get cell screen address
          ; looks at lookup table (scr_lookup) and returns the screen address of the cell

          push hl
          ld hl,scr_lookup
          add hl,bc
          add hl,bc

          ld e,(hl)
          inc l
          ld d,(hl)
          pop hl


          ex de,hl


          call blit_char


          ;  a now contains the background colour

          ld hl,back_colour_buffer
          add hl,bc

          ld a,(hl)                    ; or the main colour
          and 127 ; remove flash

          ld hl,attributes
          add hl,bc
          ld (hl),a

bb6:
          pop bc
          pop hl

bb2:
          dec hl
          dec bc

          ld a,b
          or c
          jp nz,bb1

          ret


; ****************************************************************************

; draw_char_masked
; ================

; draw 8 rows (1 char) to the screen by masking first.

; for each line:

; read the mask
; and this with the contents of the screen
; read the graphic byte
; or this with the contents of the screen

; as we are writing to scratch memory, no need to use "inc h" for next
; 256 char line

; ****************************************************************************
draw_char_masked:

          ld a,(de)
          and (hl)
          ld (hl),a
          inc e
          ld a,(de)
          or (hl)
          ld (hl),a
          inc e
          inc l
          ld a,(de)
          and (hl)
          ld (hl),a
          inc e
          ld a,(de)
          or (hl)
          ld (hl),a
          inc e
          inc l
          ld a,(de)
          and (hl)
          ld (hl),a
          inc e
          ld a,(de)
          or (hl)
          ld (hl),a
          inc e
          inc l
          ld a,(de)
          and (hl)
          ld (hl),a
          inc e
          ld a,(de)
          or (hl)
          ld (hl),a
          inc e
          inc l
          ld a,(de)
          and (hl)
          ld (hl),a
          inc e
          ld a,(de)
          or (hl)
          ld (hl),a
          inc e
          inc l
          ld a,(de)
          and (hl)
          ld (hl),a
          inc e
          ld a,(de)
          or (hl)
          ld (hl),a
          inc e
          inc l
          ld a,(de)
          and (hl)
          ld (hl),a
          inc e
          ld a,(de)
          or (hl)
          ld (hl),a
          inc e
          inc l
          ld a,(de)
          and (hl)
          ld (hl),a
          inc e
          ld a,(de)
          or (hl)
          ld (hl),a

          ret

; as we are writing to scratch memory, no need to use "inc h" for next
; 256 char line
draw_char:

          ld a,(de)
          ld (hl),a
          inc l
          inc e
          ld a,(de)
          ld (hl),a
          inc l
          inc e
          ld a,(de)
          ld (hl),a
          inc l
          inc e
          ld a,(de)
          ld (hl),a
          inc l
          inc e
          ld a,(de)
          ld (hl),a
          inc l
          inc e
          ld a,(de)
          ld (hl),a
          inc l
          inc e
          ld a,(de)
          ld (hl),a
          inc l
          inc e
          ld a,(de)
          ld (hl),a

          ret
; write to screen
blit_char

         ld a,(de)
         ld (hl),a
         inc e
         inc h
         ld a,(de)
         ld (hl),a
         inc e
         inc h
         ld a,(de)
         ld (hl),a
         inc e
         inc h
         ld a,(de)
         ld (hl),a
         inc e
         inc h
         ld a,(de)
         ld (hl),a
         inc e
         inc h
         ld a,(de)
         ld (hl),a
         inc e
         inc h
         ld a,(de)
         ld (hl),a
         inc e
         inc h
         ld a,(de)
         ld (hl),a

         ret

clear_update_buffer

          ld hl,update_buffer
          ld de,update_buffer+1
          ld (hl),0
          ld bc,767
          ldir

          ret


; ****************************************************************************

; draw_background
; ===============

; called when first drawing the screen on a new level.  goes through each
; background cell and draws it to the screen

; ****************************************************************************
draw_background

          ; the last byte in bg_buffer
          ld hl,bg_buffer+767-128

          ; but 768 bytes to process
          ld bc,768-128

dbft_1

          push bc
          push hl
          ; mask off foreground/background indicator
          ld a,(hl)
          and 127

          ld e,a
          ld d,0

          ; multiply by 8 to get start address (up to 127 background chars)
          rl e
          rl d
          rl e
          rl d
          rl e
          rl d

          ld hl,bg_chars
          add hl,de

          push hl

          ;    bc is 1-768, we want 0-767
          dec bc
          ld hl,scr_lookup
          add hl,bc
          add hl,bc

          ld e,(hl)
          inc l
          ld d,(hl)

          pop hl

          ex de,hl

          ; a has char
          ; hl has screen address
          ; de has graphic address

          call blit_char

          ; get attribute from background and copy to foreground

          ld hl,back_colour_buffer
          add hl,bc
          and 127                 ; remove flash
          ld a,(hl)

          ld hl,attributes
          add hl,bc
          and 127
          ld (hl),a

          pop hl

          dec hl

          pop bc


          dec bc
          ld a,c
          or b


          jr nz,dbft_1


          ret

; ****************************************************************************

; remove_sprite
; ==============

; similar to draw_sprite except rather than writing the chars for the sprite
; to the sprite's buffer, a zero is written instead.  update_buffer is
; updated to say that the char needs to be redrawn

; before calling the functions,a memory variable needa to be set

; rs_spr_buffer_addr = the sprite buffer to write to

; do this by writing to memory directly.

; e.g. ld hl,sprite_buffer_7
;      ld (rs_spr_buffer_addr+1),hl

; ****************************************************************************
remove_sprite:

            ld a,(ix+2)
            ld (ypostemp),a
            ld a,(ix+1)
            ld (xpostemp),a


            ;  we build up sprite in columns
            ld a,4
            ld b,a

            ;  x columns accross
rs_1
            push bc

            ; rows
            ld a,(ix+6)
            ld b,a

rs_2
            push bc


            ; for the y position, get the offset (y*32) for the number of rows
            ld hl,row_number_lookup
            ld a,(ypostemp)
            rl a
            add a,l
            ld l,a
            ld e,(hl)
            inc l
            ld d,(hl)

            ; de has row address, so add xpos
            ld a,(xpostemp)
            add a,e
            ld e,a

            ; de now has the offset for the cell

            ; tell the update buffer that this cell needs updating
            ld hl,update_buffer
            add hl,de

            ld (hl),1

            ld hl,back_colour_buffer
            add hl,de
            and 127 ; remove flash
            ld a,(hl)

;            ld hl,sprite_colour_buffer
;            add hl,de
;           ld (hl),a

            ; we need to write the correct mask char into the sprite buffer
             ; replaced before calling function

            ld l,(ix+12)
            ld h,(ix+13)
                    ; e.g. sprite_buffer_1
            add hl,de

            ; hl has the correct char address in sprite buffer
rs_4

            ld (hl),0
rs_5

            ; get loop for rows back
            pop bc

            ; increase the row
            ld a,(ypostemp)
            inc a
            ld (ypostemp),a

            ; loop to next row
            djnz rs_2

            ;    next column, so reset ypos
            ld a,(ix+2)
            ld (ypostemp),a

            ; increase xpos

            ld a,(xpostemp)
            inc a
            ld (xpostemp),a

            pop bc

            ;   loop for all columns
            djnz rs_1

            ; the sprite buffer now contains the correct chars to render
            ; and the update buffer has flagged the relevant cells to re-render

          ret




draw_screen_compressed:
           ld hl,0
           ld (dl_xpos),hl



dlc_1:
           ld a,(de)
           cp 255
           ret z

           ld a,(de)
           and 15
           ld (dl_block),a

           ld a,(de)
           rra
           rra
           rra
           rra
           and 15

           ; repeater stored as 0-15 which means 1 to 16 repeats
           inc a



           ld b,a
dlc_2:
           push bc

           ld a,(dl_block)

           call draw_block

dlc_3:
           ld a,(dl_xpos)
           inc a
           inc a
           ld (dl_xpos),a
           and 31
           jr nz,dlc_4

           xor a
           ld (dl_xpos),a
           ld a,(dl_ypos)
           inc a
           inc a
           ld (dl_ypos),a

dlc_4:
           pop bc
           djnz dlc_2


           inc de

           jr dlc_1

           ret

; de contains screen data
setup_screen

             call saveplayerstatus


             ; save the last known position of the player so that we cn
             ; put them back here if they lose a life
             ld a,(sprites+1)
             ld (player_xpos_onscreen),a
             ld a,(sprites+2)
             ld (player_ypos_onscreen),a

             ; get pointer to screen data
             call getscreen

             ; get level name
             ld hl,level_name+3
             ld b,24
sus1:
             ld a,(de)
             ld (hl),a
             inc de
             inc hl
             djnz sus1

             ;  expand first sprite
             ld a,(de)
             ld l,a
             inc de
             ld a,(de)
             ld h,a
             ld (unexs),hl
             ld hl,sprite_expand_1
             ld (unexd),hl
             inc de

             push de
             call expand
             pop de

             ; expand 2nd sprite
             ld a,(de)
             ld l,a
             inc de
             ld a,(de)
             ld h,a
             ld (unexs),hl
             ld hl,sprite_expand_2
             ld (unexd),hl
             inc de

             push de
             call expand

             ; clear all buffers
             ld de,bg_buffer+1
             ld hl,bg_buffer
             ld (hl),0
             ld bc,767*6 ; 2 Buffers and 3 sprites (5 would need * 8)
             ldir

             ; clear back colour buffer
             ;ld de,back_colour_buffer+1
             ;ld hl,back_colour_buffer
             ;ld (hl),0 ; %01000101
             ;ld bc,767
             ;ldir

             ; draw screen to screen
             pop de
             call draw_screen_compressed

             ; uncompress sprite data for this screen
             inc de
             ld a,(de)
             and 255
             jr z,screencont
             ld ix,enemy_sprites
             call decompress_screen_sprites

screencont:
             call draw_background

             ; clear out the update buffer for the first time
             call clear_update_buffer

             ;ld hl,attributes+640

             ;ld de,attributes+641
             ;ld (hl),paper_cyan+ink_black+attr_bright
             ;ld bc,31
             ;ldir

             ;ld de,level_name
             ;call draw_string_multiple


             ret

; ***************************
; draw_block

; draw a block to the screen (16 * 10)
; ***************************

draw_block:
           ; find address of block (held in a)
           ; get the 4 chars and draw them to bg_buffer and colours

           push de     ; current address in screen

           ld hl,blox  ; where the definitions for the blocks are stored

           ; get block number and multiply by 4
           rl a
           rl a

           ld l,a      ; hl = blox + (4*id)

           push hl     ; store blox address
           ex de,hl    ; de = blox address
           push de

           xor a
           ld hl,row_number_lookup
           ld a,(dl_ypos)
           rl a
           add a,l
           ld l,a
           ld e,(hl)
           inc l
           ld d,(hl)

          ; de has row address, so add xpos
           ld a,(dl_xpos)
           add a,e
           ld e,a

          ; de now has the correct offset

           ld hl,bg_buffer
           add hl,de

           pop de   ; de = blox addresss

           push hl  ; bg_buffer address
           push de

           ld bc,32

           ld a,(de)   ;      block id
           ld (hl),a
           inc de
           inc hl
           ld a,(de)   ;      block id
           ld (hl),a
           dec hl
           inc de
           add hl,bc
           ld a,(de)   ;      block id
           ld (hl),a
           inc de
           inc hl
           ld a,(de)   ;      block id
           ld (hl),a

           pop de
           pop hl


           ld bc,back_colour_buffer-bg_buffer
           add hl,bc


           ; hl now has colour

           ld bc,bg_chars_attrs

           ld a,(de)
           and 127
           ld c,a

           ld a,(bc)
           ld (hl),a
           inc hl
           inc bc

           ld a,(bc)
           ld (hl),a
           dec hl
           inc bc

           push de
           ld de,32
           add hl,de
           pop de

           ld a,(bc)
           ld (hl),a
           inc hl
           inc bc

           ld a,(bc)
           ld (hl),a

           pop hl
           pop de

           ret





;           defw 04002h

            include "functions.asm"



  ;  **************************************
  ;  *                                    *
  ;  * expand                             *
  ;  *                                    *
  ;  * this function takes the 2 frame 2  *
  ;  * byte (3x3) graphic pointed by de   *
  ;  * and expands it to 2k with all the  *
  ;  * white space etc needed             *
  ;  *                                    *
  ;  **************************************




;         expand 72 bytes per frame into the draw area (2k)

;         on entry, unexd will be the start + 9 to allow a blank character at 1 the top
;         this will expand

;         147
;         258
;         369

;         into

;         0000
;         1470
;         2580
;         3690

;         and then the next 7 frames
;         of 2


expand:


          ld hl,(unexd)    ; hl = unexpanded destination (starts with +8 offset)
                            ; store in chars as columns, rows

          ld de,(unexs)  ; de = unexpanded source (gfx)

          ld b,4           ; left1 and 2, right 1 and 2
ex5:

          push bc

          ld b,4       ; repeat 4 times (1 for each 2 pixel horizontal pixel movement)

ex3:
          push bc
          push de

; **********************
; expand
; **********************

; first frame, straight copy and add right hand blank column.
; 4 frames, l1, l2, r1, r2 = 16 times

          ld b,3      ;  3 chars
ex2:
          push bc
          ld b,48     ; 24 lines * mask
ex1:
          ld a,(de)
          ld (hl),a
          inc hl
          inc de
          djnz ex1

          pop bc
          djnz ex2

          ld b,24
ex4:
          ld (hl),255
          inc hl
          ld (hl),0
          inc hl

          djnz ex4

          pop de
          pop bc

          djnz ex3

          pop bc

          push hl
          ld hl,144
          add hl,de
          ex de,hl

          pop hl
          djnz ex5



; **********************
; shift
; **********************


          ;    all done, now shift each of the bytes right (the difficult bit to work out as they are stored as columns)
          ld hl,(unexd)
          ld de,192
          add hl,de

          ld b,4
shbb:
          push bc
          push hl

          ld de,48

          ld a,2
          ld (shcol),a

          ld b,3         ; frames
shaa:
          push bc
          push hl

          ld b,24        ; 1 column = 3 * 8 = 24 pixel rows (then add blank at end)
sh1:
          push hl
          push bc

          ; make sure left hand side is blank (mask 128)
          ld a,(hl)
          or 128
          ld (shbit),a

          call rotate_bytes

          pop bc
          pop hl

          inc hl                             ; move to the next row

          push hl
          push bc

          ; make sure left hand side is blank 0
          xor a
          ld (shbit),a

          call rotate_bytes

          pop bc
          pop hl

          inc hl                             ; move to the next line

                                     ; because it is stored in columns, the next horizonal byte
                                     ; is 32 bytes on as it is stored in columns

          djnz sh1


          pop hl

          ; move to next frame
          ld bc,192
          add hl,bc

          pop bc

          ; increase rotation by 2
          xor a
          ld a,(shcol)
          add a,2
          ld (shcol),a


          djnz shaa


          pop hl

          ld bc,768
          add hl,bc

          pop bc

          djnz shbb


  ret


rotate_bytes:

          ld a,(shcol)   ; the amount of times to shift the bytes
          ld b,a
sh5:
          push hl
          push bc

          ld b,4         ; 4 columns in row4
sh2:
          ld a,(shbit)   ; will be either %10000000 or %00000000
          ld c,a

; c holds the bit if after shifting it exits
          ld a,(hl)      ; get graphic byte (e.g %00111101)
          and 1          ; leave the lowest bit (e.g. %00000001)
          rrc a          ; rotate right and carry (e.g. a = %10000000)
          ld (shbit),a    ; shbit stores a 128 or a 0 (e.g. %10000000)

          ld a,(hl)       ; get the byte to shift
          rr a            ; rotate right
          and %01111111   ; remove the left hand bit
          or c            ; add on the shifted bit

sh2c
          ld (hl),a       ; put back into the graphic

          add hl,de                          ;   next line byte (48 bytes after this one, 1 column)

          djnz sh2        ; repeat for all the columns


          pop bc
          pop hl

          djnz sh5        ; repeat for the number of times it needs rotating

          ret
; 5.3k left

decompress_screen_sprites:

  ; get number of sprites
  ld a,(de)

  ld (totalsprites),a

  and 254
  ret z

  ld b,a
  inc de

dls:
  push bc
  ; count down
  ld a,(de)
  and 15
  ld (ix+0),a

  ; colour
  call loadleft
  ld (ix+19),a

  inc de

  ; xpos
  ld a,(de)
  rla
  and 31
  ld (ix+1),a

  ; ypos
  ld a,(de)
  call loadleft
  rla
  and 31
  ld (ix+2),a

  ld (ix+3),12
  ld (ix+4),0
  ld (ix+5),0
  ld (ix+6),3
  ld (ix+8),1
  ld (ix+9),0
  ld (ix+15),6
  ld (ix+18),0

  inc de

  ld a,(de)   ; max
  rla
  and 31
  ld (ix + 10),a

  call loadleft
  rla
  and 31
  ld (ix+11),a ; min

  inc de

  ld a,(de)
  ld (ix+12),a
  inc de
  ld a,(de)
  ld (ix+13),a
  inc de
  ld a,(de)
  ld (ix+14),a
  inc de

  ld a,(de)
  and 15
  ld (ix+16),a
  call loadleft
  ld (ix+17),a

  inc de

  ld a,(de)
  ld (ix+7),a

  inc de

  ld bc,sprite_size
  add ix,bc

  pop bc
  djnz dls

ret

loadleft:

    ld a,(de)
    rra
    rra
    rra
    rra
    and 15

ret

collide:

     ; to accurately do this we need to

     ; TODO: 

     ; Get x pos (0-31) and multiply and add anim frame to get exact x (0-192)
     ; Do the same with the sprite
     ; then do a width check (24 pixels of the sprite)

     ; Do the same with the height

     ld a,(sprites+1)      ;      player xpos
     sub (ix+1)                ;      subtract sprite x pos
     add a,3;      add width of sprite-1 (e.g 15)

     cp 4  ; is a = width+width-1 e.g. (16+16-1 = 31)

     ret nc                       ; if no match then no x col

     ld a,(sprites+2)
     sub (ix+2)                 ; Sprite Y Pos
     add a,3
     cp 4

     ret nc

     ld a,1
     ld (collided),a

     ret


showkeys:

             ld hl,keystocollect


             ld b,totalkeystocollectcol1*10+totalkeystocollectcol2
sk1:
             push bc


             ld a,1
             ld (gotkey),a

             ld a,(currentscreen)
             ld e,a

             ld a,(hl)
             cp e                            ; is it on this screen
             jr nz,sk2


             push hl
             ; put key on screen
             inc hl
             ld a,(hl)
             ld (keyxpostemp),a
             inc hl
             ld a,(hl)
             ld (keyypostemp),a
             inc hl

             ; is it enabled
             ld a,(hl)
             and 255
             jr nz,sk4


             pop hl
             jr sk2


sk4:
             ; for the y position, get the offset (y*32) for the number of rows
            ld hl,row_number_lookup
            ld a,(keyypostemp)
            rl a
            add a,l
            ld l,a
            ld e,(hl)
            inc l
            ld d,(hl)

            ; de has row address, so add xpos
            ld a,(keyxpostemp)
            add a,e
            ld e,a

            ; de now has the offset for the cell

            ld hl,sprite_buffer_1
            add hl,de
            ld a,(hl)
            and 255
            jr z,sk3

            ; tell it to redraw
            ld hl,update_buffer
            add hl,de
            ld (hl),1

            pop hl

            ld bc,3
            add hl,bc
            ld (hl),0
            sbc hl,bc


            push hl



            call updateitemsdisplay

          
            ld c,2
            ld b,0          ;full volume.
            ld a,3
            call PLY_AKM_PLAYSOUNDEFFECT

            ld a,(keyslefttocollect)
            dec a
            ld (keyslefttocollect),a

            jr z,sk5


            ld de,items
            call draw_string


            jr sk3
sk5

 ;           call dissolve

            pop hl
            pop bc

            jp begin

sk3:

            call drawkey


            pop hl





sk2:
             pop bc
             ld de,4
             add hl,de


             djnz sk1

             ld a,(lastcol)
             inc a
             and 7
             ld (lastcol),a


             ret




updateitemsdisplay:


             ld a,(items+4)
             dec a
             ld (items+4),a
             cp '0'-1
             jr nz,uid1

             ld a,'9'
             ld (items+4),a

             ld a,(items+3)
             dec a
             ld (items+3),a

             cp '0'
             jr nz,uid1
             ld a,' '
             ld (items+3),a

uid1:
             ret

endofgame:
             jr endofgame

drawkey:

            ; draw to screen
            ld hl,back_colour_buffer
            add hl,de
            ld a,(hl)
            and %11000111

            push de
            ld e,a

            ld a,(lastcol)
            rla
            rla
            rla

            or e


            pop de
            ld hl,attributes
            add hl,de


            ld (hl),a

            ld   a,(keyypostemp)
            ld   l,a
            ld   a,(keyxpostemp)

            ld   h,screentable/256

            add   a,(hl)

            inc  h
            ld   h,(hl)
            ld   l,a
            ld a,(lastcol)
            and %00000011

            rla           ; * 2
            rla           ; * 4
            rla           ; * 8

            ld de,keygfx
            ld e,a

            call draw_char_to_screen

            ret

resetkeystocollect:

             ld a,totalkeystocollectcol1*10+totalkeystocollectcol2
             ld (keyslefttocollect),a

             ld a,'0'+totalkeystocollectcol1
             ld (items+3),a
             ld a,'0'+totalkeystocollectcol2
             ld (items+4),a

             ld hl,keystocollect+3
             ld de,4
             ld b,totalkeystocollectcol1*10+totalkeystocollectcol2
rktc1:
             ld (hl),1
             add hl,de

             djnz rktc1

             ret
             

decreaseenergy:


     ld c,2
     ld b,0          ;full volume.
     ld a,2
     call PLY_AKM_PLAYSOUNDEFFECT

    ld a,(energy)
    dec a
    ld (energy),a

       
    ld hl,attributes+768-30
    ld e,a
    ld d,0
    add hl,de
    ld (hl),paper_black+ink_white+attr_bright


    ret


sprite_unex_0:
              include "graphics/dogr01i.asm"         ; 144 bytes
              include "graphics/dogl01i.asm"         ; 144 bytes
              include "graphics/dogr02i.asm"         ; 144 bytes
              include "graphics/dogl02i.asm"         ; 144 bytes

sprite_unex_1:
              
              include "graphics/blocr01.asm"         ; 144 bytes
              include "graphics/blocl01.asm"         ; 144 bytes
              include "graphics/blocr02.asm"         ; 144 bytes
              include "graphics/blocl02.asm"         ; 144 bytes
              




org 0a700h
scratch: 
     defs 8,0

keygfx:

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

org 0a800h
screens:

       defw screen0
       defw screen1
       defw screen2
       defw screen3
       defw screen4
       defw screen5
       defw screen6
       defw screen7
       defw screen8
       defw screen9
       defw screen10
       defw screen11
       defw screen12
       defw screen13
       defw screen14
       defw screen15
       defw screen16

       defw screen17
       defw screen18
       defw screen19
       defw screen20
       defw screen21
       defw screen22
       defw screen23
       defw screen24
       defw screen25
       defw screen26
       defw screen27
       defw screen28
       defw screen29
       defw screen30
       defw screen31


; hi bytes of screen
org 0a900h
     screentable

     defb 00h,20h,40h,60h,80h,0a0h,0c0h,0e0h
     defb 00h,20h,40h,60h,80h,0a0h,0c0h,0e0h
     defb 00h,20h,40h,60h,80h,0a0h,0c0h,0e0h

; lo bytes of screen
org 0aa00h

     defb 40h,40h,40h,40h,40h,40h,40h,40h
     defb 48h,48h,48h,48h,48h,48h,48h,48h
     defb 50h,50h,50h,50h,50h,50h,50h,50h

; storage area for expanded sprite
; sprite is stored as a 3x3 image with mask, and is expanded to 4 shifted 4x3 images
org 0ab00h
sprite_expand_1
               defs 300h
               defs 300h
               defs 300h
               defs 300h
sprite_expand_2
               defs 300h
               defs 300h
               defs 300h
               defs 300h
org 0c300h
; ****************************************************************************

; sprites

; only move vertically 1 char, but give illusion of horizonal smoothness
; in gfx
sprites:

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

enemy_sprites:

defs sprite_size*7,0

org 0c400h

; screen, x, y, enabled
keystocollect:
              defb 0,15,10,1
              defb 0,17,10,1
              defb 0,19,10,1
              defb 0,21,10,1

              defb 1,6,16,1
              defb 1,8,18,1
              defb 1,10,16,1
              defb 1,12,18,1




; ****************************************************************************
; graphics (background)

; 1k (128 chars)
org 0c500h
bg_chars:

        include "includes/bgchars.asm"

org 0c900h
bg_chars_attrs:


        include "includes/bgattrs.asm"


org 0ca00h
blox:
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


; ****************************************************************************
; graphics (masked)

; the graphics are stored as characters, mask then graphic line.  therefore,
; each character uses 16 bytes (8 mask, 8 char).

; the graphics are exported from 7up, in the following order

; sort priorities: mask, char line, y char, x char
; attributes:      no attributes
; mask:            yes, mask before

; 4k (256 chars)
; ****************************************************************************

; bank 0
org 0cb00h
player_gfx:
include "graphics/pearlr1i.asm"
include "graphics/pearll1i.asm"

; bank 1
org 0d100h
include "graphics/pearlr2i.asm"
include "graphics/pearll2i.asm"


; ****************************************************************************

; lookup tables
; =============

; this section contains all the lookup tables used by the application
; ****************************************************************************


; 1k for addresses (768*2 bytes)
          org 0d700h

; each character block (0-767) has it's address (2 byte) stored here
scr_lookup:
          include "includes/address.asm"

          org 0dd00h
; when calculating the offset, use this row number (used to convert row to offset)
row_number_lookup

          defw 0000h
          defw 0020h
          defw 0040h
          defw 0060h

          defw 0080h
          defw 00a0h
          defw 00c0h
          defw 00e0h

          defw 0100h
          defw 0120h
          defw 0140h
          defw 0160h

          defw 0180h
          defw 01a0h
          defw 01c0h
          defw 01e0h

          defw 0200h
          defw 0220h
          defw 0240h
          defw 0260h

          defw 0280h
          defw 02a0h
          defw 02c0h
          defw 02e0h

          org 0dd80h
jumppattern:
;                this works, any alteration breaks it, i don't know why yet
defb            -1,-1,-1,-1,-1,-1,0,0,0,0,0,1,1,1,0,0,0

; allow 256 bytes at ramtop, and then 5k for all the buffers
org 0de00h

     include "includes/buffers.asm"

; this routine now needs to be at a specific address (remember we only have from $fcfc to $fe00 else we will overwrite our table)
              org           $fcfc
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
              org           $fe00
im2table:
              defs          257

; tell assembler to start at 8000h
end 08000h