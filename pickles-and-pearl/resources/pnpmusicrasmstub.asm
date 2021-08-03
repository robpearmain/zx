;No need to put a ORG or anything.

;Declare the hardware (check the player source for the flag to declare.
;CPC'ers don't need to add anything, CPC is default).
PLY_AKM_HARDWARE_SPECTRUM = 1

;If sound effects, declares the SFX flag. Once again,
;check the player source to know what flag to declare.
PLY_AKM_MANAGE_SOUND_EFFECTS = 1     ;Remove the line if no SFX!

include "PlayerAkm.asm"        ;This is the AKm player.
include "pnpmusic.asm"          ;This is the music.
include "SoundEffects.asm"     ;SFX, if you have some.