# Pickles and Pearl

Update 2nd August 2021

This code has been built to run in VSCode, and be built on a mac (But it will build on a PC)

You need to enable sjasmplus and add it to your path on a mac

To ensure it runs on a mac

Copy from tools in to a new folder

/Users/Shared/zx

For each file (RASM, Disark, Pasmo, SJASMPLUS)

chmod +x ./sjasmplus

Will mark it as an executable

Then to add to the path

Open up Terminal.
Run the following command: sudo nano /etc/paths.
Enter your password, when prompted.
Go to the bottom of the file, and enter the path you wish to add. (e.g. /Users/Shared/zx)
Hit control-x to quit.
Enter “Y” to save the modified buffer.
That's it!


To Build the TAP and SNA

sjasmplus test40.asm

Will aslo build with PASMO (If it supports 128k bancks
)
To Build Music

Export from Arkos Tracker 2 (Song)

Create a stub (See Resources)

PLY_AKM_HARDWARE_SPECTRUM = 1
PLY_AKM_MANAGE_SOUND_EFFECTS = 1     ;Remove the line if no SFX!

include "PlayerAkm.asm"        ;This is the AKm player.
include "pnpmusic.asm"          ;This is the music.
include "SoundEffects.asm"     ;SFX, if you have some.

Then assemble in RASM

-- OLD, gave "clicking error"
rasm pnpmusicrasmstub.asm -o pnpmusicrasmstub -s -sl

See http://www.julien-nevo.com/arkostracker/index.php/forums/topic/weird-noise-artefacts-appearing/

-- NEW (To export all labels)
rasm pnpmusicrasmstub.asm -o pnpmusicrasmstub -s -sl -sq

Convert to PASMO

disark pnpmusicrasmstub.bin pnpmusicpasmo.asm --symbolFile pnpmusicrasmstub.sym --sourceProfile pasmo

It is now ready to be built

TODO:

~~Sort out jumping and collisions and fully understand how the jump counter works~~
~~Move level to $c000 so all code is below and we can bank swap~~
Create home screen, with Music On/Off (Just play a blank piece for silence)
Have title music and ingame music
Create all screens for level 1
Test bank swapping and loading for another level (Build loader in to game, look in to pasmo multi load)