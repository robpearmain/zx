;chars:

; SPACE

    defb 0,0,0,0,0,0,0,0

; !

    defb %00001100
    defb %00011100
    defb %00111100
    defb %00111000
    defb %01100000
    defb %00000000
    defb %11000000
    defb %00000000

    ; Need to define the next 12
    DEFS 12*8

; .

    defb %00000000
    defb %00000000
    defb %00000000
    defb %00000000
    defb %00000000
    defb %01100000
    defb %01100000
    defb %00000000

    ; Need to define /
    DEFS 8

    ; 0

    defb %00111000
    defb %01001100
    defb %11000110
    defb %11000110
    defb %11000110
    defb %01100100
    defb %00111000
    defb %00000000

    ; 1

    defb %00011000
    defb %00111000
    defb %00011000
    defb %00011000
    defb %00011000
    defb %00011000
    defb %01111110
    defb %00000000

    ; 2

    defb %01111100
    defb %11000110
    defb %00001110
    defb %00111100
    defb %01111000
    defb %11100000
    defb %11111110
    defb %00000000

    ; 3 

    defb %01111110
    defb %00001100
    defb %00011000
    defb %00111100
    defb %00000110
    defb %11000110
    defb %01111100
    defb %00000000

    ; 4

    defb %00011100
    defb %00111100
    defb %01101100
    defb %11001100
    defb %11111110
    defb %00001100
    defb %00001100
    defb %00000000

    ; 5

    defb %11111100
    defb %11000000
    defb %11111100
    defb %00000110
    defb %00000110
    defb %11000110
    defb %01111100
    defb %00000000

    ; 6

    defb %00111100
    defb %01100000
    defb %11000000
    defb %11111100
    defb %11000110
    defb %11000110
    defb %01111100
    defb %00000000

    ; 7

    defb %11111110
    defb %11000110
    defb %00001100
    defb %00011000
    defb %00110000
    defb %00110000
    defb %00110000
    defb %00000000

    ; 8

    defb %01111000
    defb %11000100
    defb %11100100
    defb %01111000
    defb %10011110
    defb %10000110
    defb %01111100
    defb %00000000

    ; 9
    
    defb %01111100
    defb %11000110
    defb %11000110
    defb %01111110
    defb %00000110
    defb %00001100
    defb %01111000
    defb %00000000

    ; Need to define the next 7
    DEFS 7 * 8

    ; A
    
    defb %00111000
    defb %01101100
    defb %11000110
    defb %11000110
    defb %11111110
    defb %11000110
    defb %11000110
    defb %00000000

    ; B

    defb %11111100
    defb %11000110
    defb %11000110
    defb %11111100
    defb %11000110
    defb %11000110
    defb %11111100
    defb %00000000

    ; C


    defb %00111100
    defb %01100110
    defb %11000000
    defb %11000000
    defb %11000000
    defb %01100110
    defb %00111100
    defb %00000000

    ; D

    defb %11111100
    defb %11001100
    defb %11000110
    defb %11000110
    defb %11000110
    defb %11001100
    defb %11111100
    defb %00000000

    ; E

    defb %11111110
    defb %11000000
    defb %11000000
    defb %11111000
    defb %11000000
    defb %11000000
    defb %11111110
    defb %00000000

    ; F

    defb %11111110
    defb %11000000
    defb %11000000
    defb %11111100
    defb %11000000
    defb %11000000
    defb %11000000
    defb %00000000

    ; G

    defb %00111110
    defb %01100000
    defb %11000000
    defb %11001110
    defb %11000110
    defb %01100110
    defb %00111110
    defb %00000000

    ; H
    
    defb %11000110
    defb %11000110
    defb %11000110
    defb %11111110
    defb %11000110
    defb %11000110
    defb %11000110
    defb %00000000

    ; I
    
    defb %01111110
    defb %00011000
    defb %00011000
    defb %00011000
    defb %00011000    
    defb %00011000
    defb %01111110
    defb %00000000

    ; J

    defb %00000110
    defb %00000110
    defb %00000110
    defb %00000110
    defb %00000110
    defb %11000110
    defb %01111100
    defb %00000000

    ; K
    defb %11000110
    defb %11001100
    defb %11011000
    defb %11110000
    defb %11111000
    defb %11011100
    defb %11001110
    defb %00000000

     ; L

    defb %11000000
    defb %11000000
    defb %11000000
    defb %11000000
    defb %11000000
    defb %11000000
    defb %11111100
    defb %00000000

    ; M
    defb %11000110
    defb %11101110
    defb %11111110
    defb %11111110
    defb %11010110
    defb %11000110
    defb %11000110
    defb %00000000

    ; N
    defb %11000110
    defb %11100110
    defb %11110110
    defb %11111110
    defb %11011110
    defb %11001110
    defb %11000110
    defb %00000000

    ; O
    defb %01111100
    defb %11000110
    defb %11000110
    defb %11000110
    defb %11000110
    defb %11000110
    defb %01111100
    defb %00000000

    ; P

    defb %11111100
    defb %11000110
    defb %11000110
    defb %11000110
    defb %11111100
    defb %11000000
    defb %11000000
    defb %00000000

    ; Q

    defb %01111100
    defb %11000110
    defb %11000110
    defb %11000110
    defb %11011110
    defb %11001100
    defb %01111010
    defb %00000000

    ; R

    defb %11111100
    defb %11000110
    defb %11000110
    defb %11001110
    defb %11111000
    defb %11011100
    defb %11001110
    defb %00000000

    ; S

    defb %01111000
    defb %11001100
    defb %11000000
    defb %01111100
    defb %00000110
    defb %11000110
    defb %01111100
    defb %00000000

    ; T

    defb %11111100
    defb %00110000
    defb %00110000
    defb %00110000
    defb %00110000
    defb %00110000
    defb %00110000
    defb %00000000

    ; U

    defb %11000110
    defb %11000110
    defb %11000110
    defb %11000110
    defb %11000110
    defb %11000110
    defb %01111100
    defb %00000000

    ; V

    defb %11000110
    defb %11000110
    defb %11000110
    defb %11101110
    defb %01111100
    defb %00111000
    defb %00010000
    defb %00000000

    ; W
    
    defb %11000110
    defb %11000110
    defb %11010110
    defb %11111110
    defb %11111110
    defb %11101110
    defb %11000110
    defb %00000000

    ; X
    defb %11000110
    defb %11101110
    defb %01111100
    defb %00111000
    defb %01111100
    defb %11101110
    defb %11000110
    defb %00000000

    ; Y
    defb %11001100
    defb %11001100
    defb %11001100
    defb %01111000
    defb %00110000
    defb %00110000
    defb %00110000
    defb %00000000

    ; Z
    defb %11111110
    defb %00001110
    defb %00011100
    defb %00111000
    defb %01110000
    defb %11100000
    defb %11111110
    defb %00000000
