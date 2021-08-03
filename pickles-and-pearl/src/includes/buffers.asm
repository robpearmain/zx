;       ****************************
;       buffers.asm
;       -----------

;       10 buffers to be used by the sprites syste,

;       contains the colours for each attribute of the back buffer
;       these are rendered to the attribute display


;       contains colour of last drawn sprite chars
;sprite_colour_buffer:         defs 768,0

; the main buffer, cleared every loop to tell what needs updating
; if it is 0 then the char is ignored
update_buffer:                defs 768,0

; the background buffer, read only, contains characters in that appear on the background.
; if bit 7 is set then it is drawn in the foreground
bg_buffer:                   defs 768,0

;       note: it is best to fill with colour of sprites, less flicker
back_colour_buffer:           defs 768,%01000001

; char buffer for each sprite, up to 6

; sprite buffer 1 is used by the player
sprite_buffer_1:             defs 768,0

; others are used by sprites (1-5)
sprite_buffer_2:             defs 768,0

sprite_buffer_3:             defs 768,0
;sprite_buffer_4:             defs 768,0

