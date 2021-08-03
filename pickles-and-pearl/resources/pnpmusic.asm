; Untitled, Song part, encoded in the AKM (minimalist) format V0.


pnp_Start:
pnp_StartDisarkGenerateExternalLabel:

pnp_DisarkPointerRegionStart0:
	dw pnp_InstrumentIndexes	; Index table for the Instruments.
pnp_DisarkForceNonReferenceDuring2_1:
	dw 0	; Index table for the Arpeggios.
pnp_DisarkForceNonReferenceDuring2_2:
	dw 0	; Index table for the Pitches.

; The subsongs references.
	dw pnp_Subsong0
pnp_DisarkPointerRegionEnd0:

; The Instrument indexes.
pnp_InstrumentIndexes:
pnp_DisarkPointerRegionStart3:
	dw pnp_Instrument0
	dw pnp_Instrument1
pnp_DisarkPointerRegionEnd3:

; The Instrument.
pnp_DisarkByteRegionStart4:
pnp_Instrument0:
	db 255	; Speed.

pnp_Instrument0Loop:	db 0	; Volume: 0.

	db 4	; End the instrument.
pnp_DisarkPointerRegionStart5:
	dw pnp_Instrument0Loop	; Loops.
pnp_DisarkPointerRegionEnd5:

pnp_Instrument1:
	db 0	; Speed.

	db 61	; Volume: 15.

	db 57	; Volume: 14.

	db 53	; Volume: 13.

	db 49	; Volume: 12.

	db 45	; Volume: 11.

	db 41	; Volume: 10.

	db 37	; Volume: 9.

	db 33	; Volume: 8.

	db 29	; Volume: 7.

	db 25	; Volume: 6.

	db 21	; Volume: 5.

	db 17	; Volume: 4.

	db 13	; Volume: 3.

	db 9	; Volume: 2.

	db 5	; Volume: 1.

	db 4	; End the instrument.
pnp_DisarkPointerRegionStart6:
	dw pnp_Instrument0Loop	; Loop to silence.
pnp_DisarkPointerRegionEnd6:

pnp_DisarkByteRegionEnd4:
pnp_ArpeggioIndexes:
pnp_DisarkPointerRegionStart7:
pnp_DisarkPointerRegionEnd7:

pnp_DisarkByteRegionStart8:
pnp_DisarkByteRegionEnd8:

pnp_PitchIndexes:
pnp_DisarkPointerRegionStart9:
pnp_DisarkPointerRegionEnd9:

pnp_DisarkByteRegionStart10:
pnp_DisarkByteRegionEnd10:

; Untitled, Subsong 0.
; ----------------------------------

pnp_Subsong0:
pnp_Subsong0DisarkPointerRegionStart0:
	dw pnp_Subsong0_NoteIndexes	; Index table for the notes.
	dw pnp_Subsong0_TrackIndexes	; Index table for the Tracks.
pnp_Subsong0DisarkPointerRegionEnd0:

pnp_Subsong0DisarkByteRegionStart1:
	db 6	; Initial speed.

	db 1	; Most used instrument.
	db 0	; Second most used instrument.

	db 3	; Most used wait.
	db 1	; Second most used wait.

	db 0	; Default start note in tracks.
	db 0	; Default start instrument in tracks.
	db 0	; Default start wait in tracks.

	db 12	; Are there effects? 12 if yes, 13 if not. Don't ask.
pnp_Subsong0DisarkByteRegionEnd1:

; The Linker.
pnp_Subsong0DisarkByteRegionStart2:
; Pattern 0
pnp_Subsong0_Loop:
	db 170	; State byte.
	db 63	; New height.
	db ((pnp_Subsong0_Track0 - ($ + 2)) & #ff00) / 256	; New track (0) for channel 1, as an offset. Offset MSB, then LSB.
	db ((pnp_Subsong0_Track0 - ($ + 1)) & 255)
	db ((pnp_Subsong0_Track1 - ($ + 2)) & #ff00) / 256	; New track (1) for channel 2, as an offset. Offset MSB, then LSB.
	db ((pnp_Subsong0_Track1 - ($ + 1)) & 255)
	db ((pnp_Subsong0_Track2 - ($ + 2)) & #ff00) / 256	; New track (2) for channel 3, as an offset. Offset MSB, then LSB.
	db ((pnp_Subsong0_Track2 - ($ + 1)) & 255)

; Pattern 1
	db 40	; State byte.
	db ((pnp_Subsong0_Track3 - ($ + 2)) & #ff00) / 256	; New track (3) for channel 1, as an offset. Offset MSB, then LSB.
	db ((pnp_Subsong0_Track3 - ($ + 1)) & 255)
	db ((pnp_Subsong0_Track4 - ($ + 2)) & #ff00) / 256	; New track (4) for channel 2, as an offset. Offset MSB, then LSB.
	db ((pnp_Subsong0_Track4 - ($ + 1)) & 255)

	db 1	; End of the Song.
	db 0	; Speed to 0, meaning "end of song".
pnp_Subsong0DisarkByteRegionEnd2:
pnp_Subsong0DisarkPointerRegionStart3:
	dw pnp_Subsong0_Loop

pnp_Subsong0DisarkPointerRegionEnd3:
; The indexes of the tracks.
pnp_Subsong0_TrackIndexes:
pnp_Subsong0DisarkPointerRegionStart4:
pnp_Subsong0DisarkPointerRegionEnd4:

pnp_Subsong0DisarkByteRegionStart5:
pnp_Subsong0_Track0:
	db 12	; Note with effects flag
	db 145	; Primary instrument (1). Note reference (1). Secondary wait (1).
	db 18	;    Volume effect, with inverted volume: 1.
	db 147	; Primary instrument (1). Note reference (3). Secondary wait (1).
	db 81	; Primary instrument (1). Note reference (1). Primary wait (3).
	db 212	; Primary instrument (1). Note reference (4). New wait (7).
	db 7	;   Escape wait value.
	db 145	; Primary instrument (1). Note reference (1). Secondary wait (1).
	db 147	; Primary instrument (1). Note reference (3). Secondary wait (1).
	db 81	; Primary instrument (1). Note reference (1). Primary wait (3).
	db 20	; Primary instrument (1). Note reference (4). 
	db 147	; Primary instrument (1). Note reference (3). Secondary wait (1).
	db 148	; Primary instrument (1). Note reference (4). Secondary wait (1).
	db 83	; Primary instrument (1). Note reference (3). Primary wait (3).
	db 30	; Primary instrument (1). New escaped note: 47. 
	db 47	;   Escape note value.
	db 145	; Primary instrument (1). Note reference (1). Secondary wait (1).
	db 147	; Primary instrument (1). Note reference (3). Secondary wait (1).
	db 81	; Primary instrument (1). Note reference (1). Primary wait (3).
	db 212	; Primary instrument (1). Note reference (4). New wait (127).
	db 127	;   Escape wait value.

pnp_Subsong0_Track1:
	db 12	; Note with effects flag
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 18	;    Volume effect, with inverted volume: 1.
	db 82	; Primary instrument (1). Note reference (2). Primary wait (3).
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 82	; Primary instrument (1). Note reference (2). Primary wait (3).
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 82	; Primary instrument (1). Note reference (2). Primary wait (3).
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 82	; Primary instrument (1). Note reference (2). Primary wait (3).
	db 85	; Primary instrument (1). Note reference (5). Primary wait (3).
	db 86	; Primary instrument (1). Note reference (6). Primary wait (3).
	db 85	; Primary instrument (1). Note reference (5). Primary wait (3).
	db 86	; Primary instrument (1). Note reference (6). Primary wait (3).
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 82	; Primary instrument (1). Note reference (2). Primary wait (3).
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 210	; Primary instrument (1). Note reference (2). New wait (127).
	db 127	;   Escape wait value.

pnp_Subsong0_Track2:
	db 205	; New wait (127).
	db 127	;   Escape wait value.

pnp_Subsong0_Track3:
	db 145	; Primary instrument (1). Note reference (1). Secondary wait (1).
	db 147	; Primary instrument (1). Note reference (3). Secondary wait (1).
	db 81	; Primary instrument (1). Note reference (1). Primary wait (3).
	db 212	; Primary instrument (1). Note reference (4). New wait (7).
	db 7	;   Escape wait value.
	db 145	; Primary instrument (1). Note reference (1). Secondary wait (1).
	db 158	; Primary instrument (1). New escaped note: 51. Secondary wait (1).
	db 51	;   Escape note value.
	db 83	; Primary instrument (1). Note reference (3). Primary wait (3).
	db 94	; Primary instrument (1). New escaped note: 49. Primary wait (3).
	db 49	;   Escape note value.
	db 147	; Primary instrument (1). Note reference (3). Secondary wait (1).
	db 145	; Primary instrument (1). Note reference (1). Secondary wait (1).
	db 81	; Primary instrument (1). Note reference (1). Primary wait (3).
	db 84	; Primary instrument (1). Note reference (4). Primary wait (3).
	db 147	; Primary instrument (1). Note reference (3). Secondary wait (1).
	db 148	; Primary instrument (1). Note reference (4). Secondary wait (1).
	db 94	; Primary instrument (1). New escaped note: 47. Primary wait (3).
	db 47	;   Escape note value.
	db 212	; Primary instrument (1). Note reference (4). New wait (127).
	db 127	;   Escape wait value.

pnp_Subsong0_Track4:
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 82	; Primary instrument (1). Note reference (2). Primary wait (3).
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 82	; Primary instrument (1). Note reference (2). Primary wait (3).
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 94	; Primary instrument (1). New escaped note: 37. Primary wait (3).
	db 37	;   Escape note value.
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 95	; Primary instrument (1). Same escaped note: 37. Primary wait (3).
	db 85	; Primary instrument (1). Note reference (5). Primary wait (3).
	db 86	; Primary instrument (1). Note reference (6). Primary wait (3).
	db 85	; Primary instrument (1). Note reference (5). Primary wait (3).
	db 86	; Primary instrument (1). Note reference (6). Primary wait (3).
	db 80	; Primary instrument (1). Note reference (0). Primary wait (3).
	db 82	; Primary instrument (1). Note reference (2). Primary wait (3).
	db 210	; Primary instrument (1). Note reference (2). New wait (127).
	db 127	;   Escape wait value.

pnp_Subsong0DisarkByteRegionEnd5:
; The note indexes.
pnp_Subsong0_NoteIndexes:
pnp_Subsong0DisarkByteRegionStart6:
	db 40	; Note for index 0.
	db 52	; Note for index 1.
	db 36	; Note for index 2.
	db 50	; Note for index 3.
	db 48	; Note for index 4.
	db 41	; Note for index 5.
	db 38	; Note for index 6.
pnp_Subsong0DisarkByteRegionEnd6:

