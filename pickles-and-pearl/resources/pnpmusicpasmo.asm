PLY_AKM_REGISTERS_OFFSETVOLUME equ $+1
PLY_AKM_DATA_OFFSETTRANSPOSITION equ $+1
PLY_AKM_OFFSET1B equ $+1
PLY_AKM_STOP_SOUNDS equ $+1
PLY_AKM_USE_HOOKS equ $+1
PLY_AKM_SOUNDEFFECTDATA_OFFSETINVERTEDVOLUME equ $+2
PLY_AKM_OFFSET2B equ $+2
PLY_AKM_DATA_OFFSETPTSTARTTRACK equ $+2
PLY_AKM_START
PLY_AKM_DATA_OFFSETWAITEMPTYCELL jp PLY_AKM_INIT
PLY_AKM_SOUNDEFFECTDATA_OFFSETSPEED equ $+1
PLY_AKM_DATA_OFFSETPTTRACK equ $+1
PLY_AKM_REGISTERS_OFFSETSOFTWAREPERIODLSB equ $+2
PLY_AKM_SOUNDEFFECTDATA_OFFSETCURRENTSTEP jp PLY_AKM_PLAY
PLY_AKM_DATA_OFFSETESCAPENOTE equ $+1
PLY_AKM_CHANNEL_SOUNDEFFECTDATASIZE equ $+2
PLY_AKM_DATA_OFFSETESCAPEINSTRUMENT equ $+2
PLY_AKM_DATA_OFFSETBASENOTE jp PLY_AKM_INITVARS_END
PLY_AKM_DATA_OFFSETPTINSTRUMENT equ $+1
PLY_AKM_INITSOUNDEFFECTS
PLY_AKM_DATA_OFFSETESCAPEWAIT
PLY_AKM_DATA_OFFSETSECONDARYINSTRUMENT
PLY_AKM_REGISTERS_OFFSETSOFTWAREPERIODMSB ld (PLY_AKM_DATA_OFFSETISPITCHUPDOWNUSED),hl
PLY_AKM_DATA_OFFSETINSTRUMENTCURRENTSTEP ret 
PLY_AKM_PLAYSOUNDEFFECT
PLY_AKM_DATA_OFFSETINSTRUMENTSPEED dec a
PLY_AKM_DATA_OFFSETISPITCHUPDOWNUSED equ $+1
PLY_AKM_DATA_OFFSETTRACKPITCHINTEGER equ $+2
PLY_AKM_PTSOUNDEFFECTTABLE
PLY_AKM_DATA_OFFSETTRACKINVERTEDVOLUME ld hl,0
    ld e,a
PLY_AKM_DATA_OFFSETTRACKPITCHSPEED equ $+1
PLY_AKM_DATA_OFFSETTRACKPITCHDECIMAL ld d,0
    add hl,de
PLY_AKM_DATA_OFFSETISARPEGGIOTABLEUSED add hl,de
PLY_AKM_DATA_OFFSETPTARPEGGIOTABLE ld e,(hl)
    inc hl
PLY_AKM_DATA_OFFSETPTARPEGGIOOFFSET ld d,(hl)
PLY_AKM_DATA_OFFSETARPEGGIOCURRENTSTEP ld a,(de)
PLY_AKM_DATA_OFFSETARPEGGIOCURRENTSPEED inc de
PLY_AKM_DATA_OFFSETARPEGGIOORIGINALSPEED ex af,af'
PLY_AKM_DATA_OFFSETCURRENTARPEGGIOVALUE ld a,b
PLY_AKM_DATA_OFFSETPTPITCHTABLE equ $+1
PLY_AKM_DATA_OFFSETISPITCHTABLEUSED ld hl,PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
PLY_AKM_DATA_OFFSETPITCHCURRENTSTEP equ $+1
PLY_AKM_DATA_OFFSETPTPITCHOFFSET ld b,0
PLY_AKM_DATA_OFFSETPITCHORIGINALSPEED equ $+1
PLY_AKM_DATA_OFFSETPITCHCURRENTSPEED sla c
PLY_AKM_DATA_OFFSETCURRENTPITCHTABLEVALUE sla c
PLY_AKM_TRACK1_DATA_SIZE sla c
    add hl,bc
    ld (hl),e
    inc hl
    ld (hl),d
    inc hl
    ld (hl),a
    inc hl
    ld (hl),0
    inc hl
    ex af,af'
    ld (hl),a
    ret 
PLY_AKM_STOPSOUNDEFFECTFROMCHANNEL add a,a
    add a,a
    add a,a
    ld e,a
    ld d,0
    ld hl,PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    add hl,de
    ld (hl),d
    inc hl
    ld (hl),d
    ret 
PLY_AKM_PLAYSOUNDEFFECTSSTREAM rla 
    rla 
    ld ix,PLY_AKM_CHANNEL1_SOUNDEFFECTDATA
    ld iy,PLY_AKM_TRACK3_DATA_END
    ld c,a
    call PLY_AKM_PSES_PLAY
    ld ix,PLY_AKM_CHANNEL2_SOUNDEFFECTDATA
    ld iy,PLY_AKM_TRACK2_REGISTERS
    srl c
    call PLY_AKM_PSES_PLAY
    ld ix,PLY_AKM_CHANNEL3_SOUNDEFFECTDATA
    ld iy,PLY_AKM_TRACK3_REGISTERS
    rr c
    call PLY_AKM_PSES_PLAY
    ld a,c
    ld (PLY_AKM_MIXERREGISTER),a
    ret 
PLY_AKM_PSES_PLAY ld l,(ix+0)
    ld h,(ix+1)
    ld a,l
    or h
    ret z
PLY_AKM_PSES_READFIRSTBYTE ld a,(hl)
    inc hl
    ld b,a
    rra 
    jr c,PLY_AKM_PSES_SOFTWAREORSOFTWAREANDHARDWARE
    rra 
    jr c,PLY_AKM_PSES_HARDWAREONLY
    rra 
    jr c,PLY_AKM_PSES_S_ENDORLOOP
    call PLY_AKM_PSES_MANAGEVOLUMEFROMA_FILTER4BITS
    rl b
    call c,PLY_AKM_PSES_READNOISEANDOPENNOISECHANNEL
    jr PLY_AKM_PSES_SAVEPOINTERANDEXIT
PLY_AKM_PSES_S_ENDORLOOP rra 
    jr c,PLY_AKM_PSES_S_LOOP
    xor a
    ld (ix+0),a
    ld (ix+1),a
    ret 
PLY_AKM_PSES_S_LOOP ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jr PLY_AKM_PSES_READFIRSTBYTE
PLY_AKM_PSES_SAVEPOINTERANDEXIT ld a,(ix+3)
    cp (ix+4)
    jr c,PLY_AKM_PSES_NOTREACHED
    ld (ix+3),0
    db 221
    db 117
    db +0
    db 221
    db 116
    db +1
    ret 
PLY_AKM_PSES_NOTREACHED inc (ix+3)
    ret 
PLY_AKM_PSES_HARDWAREONLY call PLY_AKM_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE
    set 2,c
    jr PLY_AKM_PSES_SAVEPOINTERANDEXIT
PLY_AKM_PSES_SOFTWAREORSOFTWAREANDHARDWARE rra 
    jr c,PLY_AKM_PSES_SOFTWAREANDHARDWARE
    call PLY_AKM_PSES_MANAGEVOLUMEFROMA_FILTER4BITS
    rl b
    call c,PLY_AKM_PSES_READNOISEANDOPENNOISECHANNEL
    res 2,c
    call PLY_AKM_PSES_READSOFTWAREPERIOD
    jr PLY_AKM_PSES_SAVEPOINTERANDEXIT
PLY_AKM_PSES_SOFTWAREANDHARDWARE call PLY_AKM_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE
    call PLY_AKM_PSES_READSOFTWAREPERIOD
    res 2,c
    jr PLY_AKM_PSES_SAVEPOINTERANDEXIT
PLY_AKM_PSES_SHARED_READRETRIGHARDWAREENVPERIODNOISE rra 
    jr nc,PLY_AKM_PSES_H_AFTERRETRIG
    ld d,a
    ld a,255
    ld (PLY_AKM_SETREG13OLD+1),a
    ld a,d
PLY_AKM_PSES_H_AFTERRETRIG and 7
    add a,8
    ld (PLY_AKM_SENDPSGREGISTERR13+1),a
    rl b
    call c,PLY_AKM_PSES_READNOISEANDOPENNOISECHANNEL
    call PLY_AKM_PSES_READHARDWAREPERIOD
    ld a,16
    jp PLY_AKM_PSES_MANAGEVOLUMEFROMA_HARD
PLY_AKM_PSES_READNOISEANDOPENNOISECHANNEL ld a,(hl)
    ld (PLY_AKM_NOISEREGISTER),a
    inc hl
    res 5,c
    ret 
PLY_AKM_PSES_READHARDWAREPERIOD ld a,(hl)
    ld (PLY_AKM_REG11),a
    inc hl
    ld a,(hl)
    ld (PLY_AKM_REG12),a
    inc hl
    ret 
PLY_AKM_PSES_READSOFTWAREPERIOD ld a,(hl)
    ld (iy+5),a
    inc hl
    ld a,(hl)
    ld (iy+9),a
    inc hl
    ret 
PLY_AKM_PSES_MANAGEVOLUMEFROMA_FILTER4BITS and 15
PLY_AKM_PSES_MANAGEVOLUMEFROMA_HARD sub (ix+2)
    jr nc,PLY_AKM_PSES_MVFA_NOOVERFLOW
    xor a
PLY_AKM_PSES_MVFA_NOOVERFLOW ld (iy+1),a
    ret 
PLY_AKM_CHANNEL1_SOUNDEFFECTDATA dw 0
PLY_AKM_CHANNEL1_SOUNDEFFECTINVERTEDVOLUME db 0
PLY_AKM_CHANNEL1_SOUNDEFFECTCURRENTSTEP db 0
PLY_AKM_CHANNEL1_SOUNDEFFECTSPEED db 0
    db 0
    db 0
    db 0
PLY_AKM_CHANNEL2_SOUNDEFFECTDATA db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
PLY_AKM_CHANNEL3_SOUNDEFFECTDATA db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
PLY_AKM_INIT ld de,PLY_AKM_READLINE+1
    ldi
    ldi
    ld de,PLY_AKM_PTARPEGGIOS+1
    ldi
    ldi
    ld de,PLY_AKM_PTPITCHES+1
    ldi
    ldi
    add a,a
    ld e,a
    ld d,0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld ix,PLY_AKM_INITVARS_START
    ld a,13
PLY_AKM_INITVARS_LOOP ld e,(ix+0)
    ld d,(ix+1)
    inc ix
    inc ix
    ldi
    dec a
    jr nz,PLY_AKM_INITVARS_LOOP
    ld (PLY_AKM_PATTERNREMAININGHEIGHT+1),a
    ex de,hl
    ld hl,PLY_AKM_PTLINKER+1
    ld (hl),e
    inc hl
    ld (hl),d
    ld hl,PLY_AKM_TRACK1_DATA
    ld de,PLY_AKM_TRACK1_TRANSPOSITION
    ld bc,37
    ld (hl),a
    ldir
    ld a,(PLY_AKM_SPEED+1)
    dec a
    ld (PLY_AKM_TICKCOUNTER+1),a
    ld hl,(PLY_AKM_READLINE+1)
    ld e,(hl)
    inc hl
    ld d,(hl)
    inc de
    ld (PLY_AKM_TRACK1_PTINSTRUMENT),de
    ld (PLY_AKM_TRACK2_PTINSTRUMENT),de
    ld (PLY_AKM_TRACK3_PTINSTRUMENT),de
    ret 
PLY_AKM_INITVARS_START dw PLY_AKM_NOTEINDEXTABLE+1
    dw PLY_AKM_NOTEINDEXTABLE+2
    dw PLY_AKM_LINKER+1
    dw PLY_AKM_LINKER+2
    dw PLY_AKM_SPEED+1
    dw PLY_AKM_RT_PRIMARYINSTRUMENT+1
    dw PLY_AKM_RT_SECONDARYINSTRUMENT+1
    dw PLY_AKM_RT_PRIMARYWAIT+1
    dw PLY_AKM_RT_SECONDARYWAIT+1
    dw PLY_AKM_DEFAULTSTARTNOTEINTRACKS+1
    dw PLY_AKM_DEFAULTSTARTINSTRUMENTINTRACKS+1
    dw PLY_AKM_DEFAULTSTARTWAITINTRACKS+1
    dw PLY_AKM_FLAGNOTEANDEFFECTINCELL+1
PLY_AKM_INITVARS_END
PLY_AKM_STOP ld (PLY_AKM_SENDPSGREGISTEREND+1),sp
    xor a
    ld (PLY_AKM_TRACK1_VOLUME),a
    ld (PLY_AKM_TRACK2_VOLUME),a
    ld (PLY_AKM_TRACK3_VOLUME),a
    ld a,63
    ld (PLY_AKM_MIXERREGISTER),a
    jp PLY_AKM_SENDPSG
PLY_AKM_PLAY ld (PLY_AKM_SENDPSGREGISTEREND+1),sp
PLY_AKM_TICKCOUNTER ld a,0
    inc a
PLY_AKM_SPEED cp 1
    jp nz,PLY_AKM_TICKCOUNTERMANAGED
PLY_AKM_PATTERNREMAININGHEIGHT ld a,0
    sub 1
    jr c,PLY_AKM_LINKER
    ld (PLY_AKM_PATTERNREMAININGHEIGHT+1),a
    jr PLY_AKM_READLINE
PLY_AKM_LINKER
PLY_AKM_TRACKINDEX ld de,0
    exx
PLY_AKM_PTLINKER ld hl,0
PLY_AKM_LINKERPOSTPT xor a
    ld (PLY_AKM_TRACK1_DATA),a
    ld (PLY_AKM_TRACK1_DATA_END),a
    ld (PLY_AKM_TRACK2_DATA_END),a
PLY_AKM_DEFAULTSTARTNOTEINTRACKS ld a,0
    ld (PLY_AKM_TRACK1_ESCAPENOTE),a
    ld (PLY_AKM_TRACK2_ESCAPENOTE),a
    ld (PLY_AKM_TRACK3_ESCAPENOTE),a
PLY_AKM_DEFAULTSTARTINSTRUMENTINTRACKS ld a,0
    ld (PLY_AKM_TRACK1_ESCAPEINSTRUMENT),a
    ld (PLY_AKM_TRACK2_ESCAPEINSTRUMENT),a
    ld (PLY_AKM_TRACK3_ESCAPEINSTRUMENT),a
PLY_AKM_DEFAULTSTARTWAITINTRACKS ld a,0
    ld (PLY_AKM_TRACK1_ESCAPEWAIT),a
    ld (PLY_AKM_TRACK2_ESCAPEWAIT),a
    ld (PLY_AKM_TRACK3_ESCAPEWAIT),a
    ld b,(hl)
    inc hl
    rr b
    jr nc,PLY_AKM_LINKERAFTERSPEEDCHANGE
    ld a,(hl)
    inc hl
    or a
    jr nz,PLY_AKM_LINKERSPEEDCHANGE
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    jr PLY_AKM_LINKERPOSTPT
PLY_AKM_LINKERSPEEDCHANGE ld (PLY_AKM_SPEED+1),a
PLY_AKM_LINKERAFTERSPEEDCHANGE rr b
    jr nc,PLY_AKM_LINKERUSEPREVIOUSHEIGHT
    ld a,(hl)
    inc hl
    ld (PLY_AKM_LINKERUSEPREVIOUSHEIGHT+1),a
    jr PLY_AKM_LINKERSETREMAININGHEIGHT
PLY_AKM_LINKERUSEPREVIOUSHEIGHT
PLY_AKM_LINKERPREVIOUSREMAININGHEIGHT ld a,0
PLY_AKM_LINKERSETREMAININGHEIGHT ld (PLY_AKM_PATTERNREMAININGHEIGHT+1),a
    ld ix,PLY_AKM_TRACK1_DATA
    call PLY_AKM_CHECKTRANSPOSITIONANDTRACK
    ld ix,PLY_AKM_TRACK1_DATA_END
    call PLY_AKM_CHECKTRANSPOSITIONANDTRACK
    ld ix,PLY_AKM_TRACK2_DATA_END
    call PLY_AKM_CHECKTRANSPOSITIONANDTRACK
    ld (PLY_AKM_PTLINKER+1),hl
PLY_AKM_READLINE
PLY_AKM_PTINSTRUMENTS ld de,0
PLY_AKM_NOTEINDEXTABLE ld bc,0
    exx
    ld ix,PLY_AKM_TRACK1_DATA
    call PLY_AKM_READTRACK
    ld ix,PLY_AKM_TRACK1_DATA_END
    call PLY_AKM_READTRACK
    ld ix,PLY_AKM_TRACK2_DATA_END
    call PLY_AKM_READTRACK
    xor a
PLY_AKM_TICKCOUNTERMANAGED ld (PLY_AKM_TICKCOUNTER+1),a
    ld de,PLY_AKM_PERIODTABLE
    exx
    ld c,224
    ld ix,PLY_AKM_TRACK1_DATA
    call PLY_AKM_MANAGEEFFECTS
    ld iy,PLY_AKM_TRACK3_DATA_END
    call PLY_AKM_PLAYSOUNDSTREAM
    srl c
    ld ix,PLY_AKM_TRACK1_DATA_END
    call PLY_AKM_MANAGEEFFECTS
    ld iy,PLY_AKM_TRACK2_REGISTERS
    call PLY_AKM_PLAYSOUNDSTREAM
    rr c
    ld ix,PLY_AKM_TRACK2_DATA_END
    call PLY_AKM_MANAGEEFFECTS
    ld iy,PLY_AKM_TRACK3_REGISTERS
    call PLY_AKM_PLAYSOUNDSTREAM
    ld a,c
    call PLY_AKM_PLAYSOUNDEFFECTSSTREAM
PLY_AKM_SENDPSG ld sp,PLY_AKM_TRACK3_DATA_END
    ld de,49151
    ld c,253
PLY_AKM_SENDPSGREGISTER pop hl
PLY_AKM_SENDPSGREGISTERAFTERPOP ld b,e
    out (c),l
    ld b,d
    out (c),h
    ret 
PLY_AKM_SENDPSGREGISTERR13
PLY_AKM_SETREG13 ld a,0
PLY_AKM_SETREG13OLD cp 0
    jr z,PLY_AKM_SENDPSGREGISTEREND
    ld (PLY_AKM_SETREG13OLD+1),a
    ld h,a
    ld l,13
    ret 
PLY_AKM_SENDPSGREGISTEREND
PLY_AKM_SAVESP ld sp,0
    ret 
PLY_AKM_CHECKTRANSPOSITIONANDTRACK rr b
    jr nc,PLY_AKM_CHECKTRANSPOSITIONANDTRACK_AFTERTRANSPOSITION
    ld a,(hl)
    ld (ix+1),a
    inc hl
PLY_AKM_CHECKTRANSPOSITIONANDTRACK_AFTERTRANSPOSITION rr b
    jr nc,PLY_AKM_CHECKTRANSPOSITIONANDTRACK_NONEWTRACK
    ld a,(hl)
    inc hl
    sla a
    jr nc,PLY_AKM_CHECKTRANSPOSITIONANDTRACK_TRACKOFFSET
    exx
    ld l,a
    ld h,0
    add hl,de
    ld a,(hl)
    ld (ix+2),a
    ld (ix+4),a
    inc hl
    ld a,(hl)
    ld (ix+3),a
    ld (ix+5),a
    exx
    ret 
PLY_AKM_CHECKTRANSPOSITIONANDTRACK_TRACKOFFSET rra 
    ld d,a
    ld e,(hl)
    inc hl
    ld c,l
    ld a,h
    add hl,de
    db 221
    db 117
    db +2
    db 221
    db 116
    db +3
    db 221
    db 117
    db +4
    db 221
    db 116
    db +5
    ld l,c
    ld h,a
    ret 
PLY_AKM_CHECKTRANSPOSITIONANDTRACK_NONEWTRACK ld a,(ix+2)
    ld (ix+4),a
    ld a,(ix+3)
    ld (ix+5),a
    ret 
PLY_AKM_READTRACK ld a,(ix+0)
    sub 1
    jr c,PLY_AKM_RT_NOEMPTYCELL
    ld (ix+0),a
    ret 
PLY_AKM_RT_NOEMPTYCELL ld l,(ix+4)
    ld h,(ix+5)
PLY_AKM_RT_GETDATABYTE ld b,(hl)
    inc hl
    ld a,b
    and 15
PLY_AKM_FLAGNOTEANDEFFECTINCELL cp 12
    jr c,PLY_AKM_RT_NOTEREFERENCE
    sub 12
    jr z,PLY_AKM_RT_NOTEANDEFFECTS
    dec a
    jr z,PLY_AKM_RT_NONOTEMAYBEEFFECTS
    dec a
    jr z,PLY_AKM_RT_NEWESCAPENOTE
    ld a,(ix+7)
    jr PLY_AKM_RT_AFTERNOTEREAD
PLY_AKM_RT_NEWESCAPENOTE ld a,(hl)
    ld (ix+7),a
    inc hl
    jr PLY_AKM_RT_AFTERNOTEREAD
PLY_AKM_RT_NOTEANDEFFECTS dec a
    ld (PLY_AKM_RT_READEFFECTSFLAG+1),a
    jr PLY_AKM_RT_GETDATABYTE
PLY_AKM_RT_NONOTEMAYBEEFFECTS bit 4,b
    jr z,PLY_AKM_RT_READWAITFLAGS
    ld a,b
    ld (PLY_AKM_RT_READEFFECTSFLAG+1),a
    jr PLY_AKM_RT_READWAITFLAGS
PLY_AKM_RT_NOTEREFERENCE exx
    ld l,a
    ld h,0
    add hl,bc
    ld a,(hl)
    exx
PLY_AKM_RT_AFTERNOTEREAD add a,(ix+1)
    ld (ix+6),a
    ld a,b
    and 48
    jr z,PLY_AKM_RT_SAMEESCAPEINSTRUMENT
    cp 16
    jr z,PLY_AKM_RT_PRIMARYINSTRUMENT
    cp 32
    jr z,PLY_AKM_RT_SECONDARYINSTRUMENT
    ld a,(hl)
    inc hl
    ld (ix+8),a
    jr PLY_AKM_RT_STORECURRENTINSTRUMENT
PLY_AKM_RT_SAMEESCAPEINSTRUMENT ld a,(ix+8)
    jr PLY_AKM_RT_STORECURRENTINSTRUMENT
PLY_AKM_RT_SECONDARYINSTRUMENT
PLY_AKM_SECONDARYINSTRUMENT ld a,0
    jr PLY_AKM_RT_STORECURRENTINSTRUMENT
PLY_AKM_RT_PRIMARYINSTRUMENT
PLY_AKM_PRIMARYINSTRUMENT ld a,0
PLY_AKM_RT_STORECURRENTINSTRUMENT exx
    add a,a
    ld l,a
    ld h,0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,(hl)
    inc hl
    ld (ix+13),a
    db 221
    db 117
    db +10
    db 221
    db 116
    db +11
    exx
    xor a
    ld (ix+12),a
    ld (ix+15),a
    ld (ix+16),a
    ld (ix+17),a
    ld (ix+24),a
    ld (ix+25),a
    ld a,(ix+27)
    ld (ix+26),a
    ld (ix+32),a
    ld (ix+33),a
    ld a,(ix+35)
    ld (ix+34),a
PLY_AKM_RT_READWAITFLAGS ld a,b
    and 192
    jr z,PLY_AKM_RT_SAMEESCAPEWAIT
    cp 64
    jr z,PLY_AKM_RT_PRIMARYWAIT
    cp 128
    jr z,PLY_AKM_RT_SECONDARYWAIT
    ld a,(hl)
    inc hl
    ld (ix+9),a
    jr PLY_AKM_RT_STORECURRENTWAIT
PLY_AKM_RT_SAMEESCAPEWAIT ld a,(ix+9)
    jr PLY_AKM_RT_STORECURRENTWAIT
PLY_AKM_RT_PRIMARYWAIT
PLY_AKM_PRIMARYWAIT ld a,0
    jr PLY_AKM_RT_STORECURRENTWAIT
PLY_AKM_RT_SECONDARYWAIT
PLY_AKM_SECONDARYWAIT ld a,0
PLY_AKM_RT_STORECURRENTWAIT ld (ix+0),a
PLY_AKM_RT_READEFFECTSFLAG ld a,0
    or a
    jr nz,PLY_AKM_RT_READEFFECTS
PLY_AKM_RT_AFTEREFFECTS db 221
    db 117
    db +4
    db 221
    db 116
    db +5
    ret 
PLY_AKM_RT_READEFFECTS xor a
    ld (PLY_AKM_RT_READEFFECTSFLAG+1),a
PLY_AKM_RT_READEFFECT ld iy,PLY_AKM_EFFECTTABLE
    ld b,(hl)
    ld a,b
    inc hl
    and 14
    ld e,a
    ld d,0
    add iy,de
    ld a,b
    rra 
    rra 
    rra 
    rra 
    and 15
    jp (iy)
PLY_AKM_RT_READEFFECT_RETURN bit 0,b
    jr nz,PLY_AKM_RT_READEFFECT
    jr PLY_AKM_RT_AFTEREFFECTS
PLY_AKM_RT_WAITLONG ld a,(hl)
    inc hl
    ld (ix+0),a
    jr PLY_AKM_RT_CELLREAD
PLY_AKM_RT_WAITSHORT ld a,b
    rlca 
    rlca 
    and 3
    ld (ix+0),a
PLY_AKM_RT_CELLREAD db 221
    db 117
    db +4
    db 221
    db 116
    db +5
    ret 
PLY_AKM_MANAGEEFFECTS ld a,(ix+15)
    or a
    jr z,PLY_AKM_ME_PITCHUPDOWNFINISHED
    ld l,(ix+18)
    ld h,(ix+16)
    ld e,(ix+19)
    ld d,(ix+20)
    ld a,(ix+17)
    bit 7,d
    jr nz,PLY_AKM_ME_PITCHUPDOWN_NEGATIVESPEED
PLY_AKM_ME_PITCHUPDOWN_POSITIVESPEED add hl,de
    adc a,0
    jr PLY_AKM_ME_PITCHUPDOWN_SAVE
PLY_AKM_ME_PITCHUPDOWN_NEGATIVESPEED res 7,d
    or a
    sbc hl,de
    sbc a,0
PLY_AKM_ME_PITCHUPDOWN_SAVE ld (ix+17),a
    db 221
    db 117
    db +18
    db 221
    db 116
    db +16
PLY_AKM_ME_PITCHUPDOWNFINISHED ld a,(ix+21)
    or a
    jr z,PLY_AKM_ME_ARPEGGIOTABLEFINISHED
    ld e,(ix+22)
    ld d,(ix+23)
    ld l,(ix+24)
    ld h,0
    add hl,de
    ld a,(hl)
    sra a
    ld (ix+28),a
    ld a,(ix+25)
    cp (ix+26)
    jr c,PLY_AKM_ME_ARPEGGIOTABLE_SPEEDNOTREACHED
    ld (ix+25),0
    inc (ix+24)
    inc hl
    ld a,(hl)
    rra 
    jr nc,PLY_AKM_ME_ARPEGGIOTABLEFINISHED
    ld l,a
    ld (ix+24),a
    jr PLY_AKM_ME_ARPEGGIOTABLEFINISHED
PLY_AKM_ME_ARPEGGIOTABLE_SPEEDNOTREACHED inc a
    ld (ix+25),a
PLY_AKM_ME_ARPEGGIOTABLEFINISHED ld a,(ix+29)
    or a
    ret z
    ld l,(ix+30)
    ld h,(ix+31)
    ld e,(ix+32)
    ld d,0
    add hl,de
    ld a,(hl)
    sra a
    jp p,PLY_AKM_ME_PITCHTABLEENDNOTREACHED_POSITIVE
    dec d
PLY_AKM_ME_PITCHTABLEENDNOTREACHED_POSITIVE ld (ix+36),a
    db 221
    db 114
    db +37
    ld a,(ix+33)
    cp (ix+34)
    jr c,PLY_AKM_ME_PITCHTABLE_SPEEDNOTREACHED
    ld (ix+33),0
    inc (ix+32)
    inc hl
    ld a,(hl)
    rra 
    ret nc
    ld l,a
    ld (ix+32),a
    ret 
PLY_AKM_ME_PITCHTABLE_SPEEDNOTREACHED inc a
    ld (ix+33),a
    ret 
PLY_AKM_PLAYSOUNDSTREAM ld l,(ix+10)
    ld h,(ix+11)
PLY_AKM_PSS_READFIRSTBYTE ld a,(hl)
    ld b,a
    inc hl
    rra 
    jr c,PLY_AKM_PSS_SOFTORSOFTANDHARD
    rra 
    jr c,PLY_AKM_PSS_SOFTWARETOHARDWARE
    rra 
    jr nc,PLY_AKM_PSS_NSNH_NOTENDOFSOUND
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    db 221
    db 117
    db +10
    db 221
    db 116
    db +11
    jr PLY_AKM_PSS_READFIRSTBYTE
PLY_AKM_PSS_NSNH_NOTENDOFSOUND set 2,c
    call PLY_AKM_PSS_SHARED_ADJUSTVOLUME
    ld (iy+1),a
    rl b
    call c,PLY_AKM_PSS_READNOISE
    jr PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER
PLY_AKM_PSS_SOFTORSOFTANDHARD rra 
    jr c,PLY_AKM_PSS_SOFTANDHARD
    call PLY_AKM_PSS_SHARED_ADJUSTVOLUME
    ld (iy+1),a
    ld d,0
    rl b
    jr nc,PLY_AKM_PSS_S_AFTERARPANDORNOISE
    ld a,(hl)
    inc hl
    sra a
    ld d,a
    call c,PLY_AKM_PSS_READNOISE
PLY_AKM_PSS_S_AFTERARPANDORNOISE ld a,d
    call PLY_AKM_CALCULATEPERIODFORBASENOTE
    rl b
    call c,PLY_AKM_READPITCHANDADDTOPERIOD
    exx
    ld (iy+5),l
    ld (iy+9),h
    exx
PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER ld a,(ix+12)
    cp (ix+13)
    jr nc,PLY_AKM_PSS_S_SPEEDREACHED
    inc (ix+12)
    ret 
PLY_AKM_PSS_S_SPEEDREACHED db 221
    db 117
    db +10
    db 221
    db 116
    db +11
    ld (ix+12),0
    ret 
PLY_AKM_PSS_SOFTANDHARD call PLY_AKM_PSS_SHARED_READENVBITPITCHARP_SOFTPERIOD_HARDVOL_HARDENV
    ld a,(hl)
    ld (PLY_AKM_REG11),a
    inc hl
    ld a,(hl)
    ld (PLY_AKM_REG12),a
    inc hl
    jr PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER
PLY_AKM_PSS_SOFTWARETOHARDWARE call PLY_AKM_PSS_SHARED_READENVBITPITCHARP_SOFTPERIOD_HARDVOL_HARDENV
    ld a,b
    rlca 
    rlca 
    rlca 
    rlca 
    and 7
    exx
    jr z,PLY_AKM_PSS_STH_RATIOEND
PLY_AKM_PSS_STH_RATIOLOOP srl h
    rr l
    dec a
    jr nz,PLY_AKM_PSS_STH_RATIOLOOP
    jr nc,PLY_AKM_PSS_STH_RATIOEND
    inc hl
PLY_AKM_PSS_STH_RATIOEND ld a,l
    ld (PLY_AKM_REG11),a
    ld a,h
    ld (PLY_AKM_REG12),a
    exx
    jr PLY_AKM_PSS_SHARED_STOREINSTRUMENTPOINTER
PLY_AKM_PSS_SHARED_READENVBITPITCHARP_SOFTPERIOD_HARDVOL_HARDENV and 2
    add a,8
    ld (PLY_AKM_SENDPSGREGISTERR13+1),a
    ld (iy+1),16
    xor a
    bit 7,b
    jr z,PLY_AKM_PSS_SHARED_RENVBAP_AFTERARPEGGIO
    ld a,(hl)
    inc hl
PLY_AKM_PSS_SHARED_RENVBAP_AFTERARPEGGIO call PLY_AKM_CALCULATEPERIODFORBASENOTE
    bit 2,b
    call nz,PLY_AKM_READPITCHANDADDTOPERIOD
    exx
    ld (iy+5),l
    ld (iy+9),h
    exx
    ret 
PLY_AKM_PSS_SHARED_ADJUSTVOLUME and 15
    sub (ix+14)
    ret nc
    xor a
    ret 
PLY_AKM_PSS_READNOISE ld a,(hl)
    inc hl
    ld (PLY_AKM_NOISEREGISTER),a
    res 5,c
    ret 
PLY_AKM_CALCULATEPERIODFORBASENOTE exx
    ld h,0
    add a,(ix+6)
    add a,(ix+28)
    ld bc,65292
PLY_AKM_FINDOCTAVE_LOOP inc b
    sub c
    jr nc,PLY_AKM_FINDOCTAVE_LOOP
    add a,c
    add a,a
    ld l,a
    ld h,0
    add hl,de
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,b
    or a
    jr z,PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP_FINISHED
PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP srl h
    rr l
    djnz PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP
PLY_AKM_FINDOCTAVE_OCTAVESHIFTLOOP_FINISHED jr nc,PLY_AKM_FINDOCTAVE_FINISHED
    inc hl
PLY_AKM_FINDOCTAVE_FINISHED ld a,(ix+29)
    or a
    jr z,PLY_AKM_CALCULATEPERIODFORBASENOTE_NOPITCHTABLE
    ld c,(ix+36)
    ld b,(ix+37)
    add hl,bc
PLY_AKM_CALCULATEPERIODFORBASENOTE_NOPITCHTABLE ld c,(ix+16)
    ld b,(ix+17)
    add hl,bc
    exx
    ret 
PLY_AKM_READPITCHANDADDTOPERIOD ld a,(hl)
    inc hl
    exx
    ld c,a
    exx
    ld a,(hl)
    inc hl
    exx
    ld b,a
    add hl,bc
    exx
    ret 
PLY_AKM_EFFECTRESETWITHVOLUME ld (ix+14),a
    xor a
    ld (ix+15),a
    ld (ix+21),a
    ld (ix+28),a
    ld (ix+29),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTVOLUME ld (ix+14),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTFORCEINSTRUMENTSPEED call PLY_AKM_EFFECTREADIFESCAPE
    ld (ix+13),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTFORCEPITCHSPEED call PLY_AKM_EFFECTREADIFESCAPE
    ld (ix+34),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTFORCEARPEGGIOSPEED call PLY_AKM_EFFECTREADIFESCAPE
    ld (ix+26),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTTABLE jr PLY_AKM_EFFECTRESETWITHVOLUME
    jr PLY_AKM_EFFECTVOLUME
    jr PLY_AKM_EFFECTPITCHUPDOWN
    jr PLY_AKM_EFFECTARPEGGIOTABLE
    jr PLY_AKM_EFFECTPITCHTABLE
    jr PLY_AKM_EFFECTFORCEINSTRUMENTSPEED
    jr PLY_AKM_EFFECTFORCEARPEGGIOSPEED
    jr PLY_AKM_EFFECTFORCEPITCHSPEED
PLY_AKM_EFFECTPITCHUPDOWN rra 
    jr nc,PLY_AKM_EFFECTPITCHUPDOWN_DEACTIVATED
    ld (ix+15),255
    ld a,(hl)
    inc hl
    ld (ix+19),a
    ld a,(hl)
    inc hl
    ld (ix+20),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTPITCHUPDOWN_DEACTIVATED ld (ix+15),0
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTARPEGGIOTABLE call PLY_AKM_EFFECTREADIFESCAPE
    ld (ix+21),a
    jr z,PLY_AKM_EFFECTARPEGGIOTABLE_STOP
    add a,a
    exx
    ld l,a
    ld h,0
PLY_AKM_PTARPEGGIOS ld bc,0
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,(hl)
    inc hl
    ld (ix+27),a
    ld (ix+26),a
    db 221
    db 117
    db +22
    db 221
    db 116
    db +23
    exx
    xor a
    ld (ix+24),a
    ld (ix+25),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTARPEGGIOTABLE_STOP ld (ix+28),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTPITCHTABLE call PLY_AKM_EFFECTREADIFESCAPE
    ld (ix+29),a
    jp z,PLY_AKM_RT_READEFFECT_RETURN
    add a,a
    exx
    ld l,a
    ld h,0
PLY_AKM_PTPITCHES ld bc,0
    add hl,bc
    ld a,(hl)
    inc hl
    ld h,(hl)
    ld l,a
    ld a,(hl)
    inc hl
    ld (ix+35),a
    ld (ix+34),a
    db 221
    db 117
    db +30
    db 221
    db 116
    db +31
    exx
    xor a
    ld (ix+32),a
    ld (ix+33),a
    jp PLY_AKM_RT_READEFFECT_RETURN
PLY_AKM_EFFECTREADIFESCAPE cp 15
    ret c
    ld a,(hl)
    inc hl
    ret 
PLY_AKM_TRACK1_DATA
PLY_AKM_TRACK1_WAITEMPTYCELL db 0
PLY_AKM_TRACK1_TRANSPOSITION db 0
PLY_AKM_TRACK1_PTSTARTTRACK dw 0
PLY_AKM_TRACK1_PTTRACK dw 0
PLY_AKM_TRACK1_BASENOTE db 0
PLY_AKM_TRACK1_ESCAPENOTE db 0
PLY_AKM_TRACK1_ESCAPEINSTRUMENT db 0
PLY_AKM_TRACK1_ESCAPEWAIT db 0
PLY_AKM_TRACK1_PTINSTRUMENT dw 0
PLY_AKM_TRACK1_INSTRUMENTCURRENTSTEP db 0
PLY_AKM_TRACK1_INSTRUMENTSPEED db 0
PLY_AKM_TRACK1_TRACKINVERTEDVOLUME db 0
PLY_AKM_TRACK1_ISPITCHUPDOWNUSED db 0
PLY_AKM_TRACK1_TRACKPITCHINTEGER dw 0
PLY_AKM_TRACK1_TRACKPITCHDECIMAL db 0
PLY_AKM_TRACK1_TRACKPITCHSPEED dw 0
PLY_AKM_TRACK1_ISARPEGGIOTABLEUSED db 0
PLY_AKM_TRACK1_PTARPEGGIOTABLE dw 0
PLY_AKM_TRACK1_PTARPEGGIOOFFSET db 0
PLY_AKM_TRACK1_ARPEGGIOCURRENTSTEP db 0
PLY_AKM_TRACK1_ARPEGGIOCURRENTSPEED db 0
PLY_AKM_TRACK1_ARPEGGIOORIGINALSPEED db 0
PLY_AKM_TRACK1_CURRENTARPEGGIOVALUE db 0
PLY_AKM_TRACK1_ISPITCHTABLEUSED db 0
PLY_AKM_TRACK1_PTPITCHTABLE dw 0
PLY_AKM_TRACK1_PTPITCHOFFSET db 0
PLY_AKM_TRACK1_PITCHCURRENTSTEP db 0
PLY_AKM_TRACK1_PITCHCURRENTSPEED db 0
PLY_AKM_TRACK1_PITCHORIGINALSPEED db 0
PLY_AKM_TRACK1_CURRENTPITCHTABLEVALUE dw 0
PLY_AKM_TRACK1_DATA_END
PLY_AKM_TRACK2_DATA
PLY_AKM_TRACK2_WAITEMPTYCELL db 0
    db 0
    db 0
    db 0
PLY_AKM_TRACK2_PTTRACK db 0
    db 0
    db 0
PLY_AKM_TRACK2_ESCAPENOTE db 0
PLY_AKM_TRACK2_ESCAPEINSTRUMENT db 0
PLY_AKM_TRACK2_ESCAPEWAIT db 0
PLY_AKM_TRACK2_PTINSTRUMENT db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
PLY_AKM_TRACK2_DATA_END
PLY_AKM_TRACK3_DATA
PLY_AKM_TRACK3_WAITEMPTYCELL db 0
    db 0
    db 0
    db 0
PLY_AKM_TRACK3_PTTRACK db 0
    db 0
    db 0
PLY_AKM_TRACK3_ESCAPENOTE db 0
PLY_AKM_TRACK3_ESCAPEINSTRUMENT db 0
PLY_AKM_TRACK3_ESCAPEWAIT db 0
PLY_AKM_TRACK3_PTINSTRUMENT db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
    db 0
PLY_AKM_TRACK3_DATA_END
PLY_AKM_REGISTERS_RETTABLE
PLY_AKM_TRACK1_REGISTERS db 8
PLY_AKM_TRACK1_VOLUME db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 0
PLY_AKM_TRACK1_SOFTWAREPERIODLSB db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 1
PLY_AKM_TRACK1_SOFTWAREPERIODMSB db 0
    dw PLY_AKM_SENDPSGREGISTER
PLY_AKM_TRACK2_REGISTERS db 9
PLY_AKM_TRACK2_VOLUME db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 2
PLY_AKM_TRACK2_SOFTWAREPERIODLSB db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 3
PLY_AKM_TRACK2_SOFTWAREPERIODMSB db 0
    dw PLY_AKM_SENDPSGREGISTER
PLY_AKM_TRACK3_REGISTERS db 10
PLY_AKM_TRACK3_VOLUME db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 4
PLY_AKM_TRACK3_SOFTWAREPERIODLSB db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 5
PLY_AKM_TRACK3_SOFTWAREPERIODMSB db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 6
PLY_AKM_NOISEREGISTER db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 7
PLY_AKM_MIXERREGISTER db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 11
PLY_AKM_REG11 db 0
    dw PLY_AKM_SENDPSGREGISTER
    db 12
PLY_AKM_REG12 db 0
    dw PLY_AKM_SENDPSGREGISTERR13
    dw PLY_AKM_SENDPSGREGISTERAFTERPOP
    dw PLY_AKM_SENDPSGREGISTEREND
PLY_AKM_PERIODTABLE dw 6778
    dw 6398
    dw 6039
    dw 5700
    dw 5380
    dw 5078
    dw 4793
    dw 4524
    dw 4270
    dw 4030
    dw 3804
    dw 3591
PLY_AKM_END
PNP_START dw PNP_INSTRUMENTINDEXES
    dw 0
    dw 0
    dw PNP_ARPEGGIOINDEXES
PNP_INSTRUMENTINDEXES dw PNP_INSTRUMENT0
    dw PNP_INSTRUMENT1
PNP_INSTRUMENT0 db 255
PNP_INSTRUMENT0LOOP db 0
    db 4
    dw PNP_INSTRUMENT0LOOP
PNP_INSTRUMENT1 db 0
    db 61
    db 57
    db 53
    db 49
    db 45
    db 41
    db 37
    db 33
    db 29
    db 25
    db 21
    db 17
    db 13
    db 9
    db 5
    db 4
    dw PNP_INSTRUMENT0LOOP
PNP_ARPEGGIOINDEXES
PNP_PITCHINDEXES
PNP_SUBSONG0 dw PNP_SUBSONG0_NOTEINDEXES
    dw PNP_SUBSONG0_TRACKINDEXES
    db 6
    db 1
    db 0
    db 3
    db 1
    db 0
    db 0
    db 0
    db 12
PNP_SUBSONG0_LOOP db 170
    db 63
    db 0
    db 13
    db 0
    db 32
    db 0
    db 49
    db 40
    db 0
    db 48
    db 0
    db 67
    db 1
    db 0
    dw PNP_SUBSONG0_LOOP
PNP_SUBSONG0_TRACKINDEXES
PNP_SUBSONG0_TRACK0 db 12
    db 145
    db 18
    db 147
    db 81
    db 212
    db 7
    db 145
    db 147
    db 81
    db 20
    db 147
    db 148
    db 83
    db 30
    db 47
    db 145
    db 147
    db 81
    db 212
    db 127
PNP_SUBSONG0_TRACK1 db 12
    db 80
    db 18
    db 82
    db 80
    db 82
    db 80
    db 82
    db 80
    db 82
    db 85
    db 86
    db 85
    db 86
    db 80
    db 82
    db 80
    db 210
    db 127
PNP_SUBSONG0_TRACK2 db 205
    db 127
PNP_SUBSONG0_TRACK3 db 145
    db 147
    db 81
    db 212
    db 7
    db 145
    db 158
    db 51
    db 83
    db 94
    db 49
    db 147
    db 145
    db 81
    db 84
    db 147
    db 148
    db 94
    db 47
    db 212
    db 127
PNP_SUBSONG0_TRACK4 db 80
    db 82
    db 80
    db 82
    db 80
    db 94
    db 37
    db 80
    db 95
    db 85
    db 86
    db 85
    db 86
    db 80
    db 82
    db 210
    db 127
PNP_SUBSONG0_NOTEINDEXES db 40
    db 52
    db 36
    db 50
    db 48
    db 41
    db 38
SOUNDEFFECTS_SOUNDEFFECTS dw SOUNDEFFECTS_SOUNDEFFECTS_SOUND1
    dw SOUNDEFFECTS_SOUNDEFFECTS_SOUND2
    dw SOUNDEFFECTS_SOUNDEFFECTS_SOUND3
    dw SOUNDEFFECTS_SOUNDEFFECTS_SOUND4
    dw SOUNDEFFECTS_SOUNDEFFECTS_SOUND5
SOUNDEFFECTS_SOUNDEFFECTS_SOUND1 db 0
SOUNDEFFECTS_SOUNDEFFECTS_SOUND1_LOOP db 189
    db 1
    db 95
    db 0
    db 189
    db 1
    db 99
    db 0
    db 177
    db 1
    db 102
    db 0
    db 173
    db 1
    db 106
    db 0
    db 4
SOUNDEFFECTS_SOUNDEFFECTS_SOUND2 db 1
SOUNDEFFECTS_SOUNDEFFECTS_SOUND2_LOOP db 189
    db 1
    db 45
    db 1
    db 189
    db 8
    db 63
    db 1
    db 185
    db 2
    db 146
    db 1
    db 181
    db 16
    db 213
    db 0
    db 177
    db 2
    db 225
    db 0
    db 173
    db 2
    db 239
    db 0
    db 165
    db 16
    db 102
    db 1
    db 157
    db 31
    db 119
    db 0
    db 153
    db 7
    db 80
    db 0
    db 4
SOUNDEFFECTS_SOUNDEFFECTS_SOUND3 db 1
SOUNDEFFECTS_SOUNDEFFECTS_SOUND3_LOOP db 189
    db 1
    db 119
    db 0
    db 57
    db 60
    db 0
    db 181
    db 1
    db 95
    db 0
    db 49
    db 47
    db 0
    db 185
    db 1
    db 80
    db 0
    db 61
    db 40
    db 0
    db 3
    db 15
    db 0
    db 222
    db 1
    db 61
    db 239
    db 0
    db 3
    db 15
    db 0
    db 222
    db 1
    db 61
    db 239
    db 0
    db 3
    db 15
    db 0
    db 222
    db 1
    db 61
    db 239
    db 0
    db 3
    db 30
    db 0
    db 188
    db 3
    db 61
    db 239
    db 0
    db 3
    db 30
    db 0
    db 188
    db 3
    db 61
    db 239
    db 0
    db 4
SOUNDEFFECTS_SOUNDEFFECTS_SOUND4 db 1
SOUNDEFFECTS_SOUNDEFFECTS_SOUND4_LOOP db 189
    db 1
    db 119
    db 0
    db 61
    db 56
    db 0
    db 189
    db 1
    db 106
    db 0
    db 61
    db 53
    db 0
    db 61
    db 100
    db 0
    db 61
    db 50
    db 0
    db 4
SOUNDEFFECTS_SOUNDEFFECTS_SOUND5 db 1
SOUNDEFFECTS_SOUNDEFFECTS_SOUND5_LOOP db 3
    db 2
    db 0
    db 27
    db 0
    db 3
    db 3
    db 0
    db 47
    db 0
    db 3
    db 2
    db 0
    db 30
    db 0
    db 3
    db 5
    db 0
    db 75
    db 0
    db 3
    db 3
    db 0
    db 47
    db 0
    db 3
    db 7
    db 0
    db 119
    db 0
    db 3
    db 5
    db 0
    db 75
    db 0
    db 3
    db 12
    db 0
    db 190
    db 0
    db 3
    db 7
    db 0
    db 119
    db 0
    db 3
    db 19
    db 0
    db 45
    db 1
    db 3
    db 12
    db 0
    db 190
    db 0
    db 3
    db 34
    db 0
    db 24
    db 2
    db 3
    db 50
    db 0
    db 36
    db 3
    db 4
