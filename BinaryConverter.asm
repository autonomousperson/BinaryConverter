 ;        __                _         ______
 ;       / /___ _____ ___  (_)__     / ____/___ _____
 ;  __  / / __ `/ __ `__ \/ / _ \   / /   / __ `/ __ \
 ; / /_/ / /_/ / / / / / / /  __/  / /___/ /_/ / /_/ /
 ; \____/\__,_/_/ /_/ /_/_/\___/   \____/\__,_/\____/
 ; Licensed under GNU GPLv3
 ;
 ; GIT:         https://github.com/autonomousperson/BinaryConverter
 ; Date:        May 6, 2017 8:20PM PST
 ; Filename:    BinaryConverter.asm
 ; Name:        Jamie Cao
 ; CruzID:      Jlcao
 ; Assignment:  Lab3
 ; Desc:        Recieve user input and print in binary
.ORIG x3000
    LD R0, ZERO ; R0 = 0 ...
    STI R0, NEGLOC ; Ini Negitive flag to false
    LEA R0, ME ; Load WE into R0
    PUTS ; Print
    LEA R0, WE ; Load WE into R0
    PUTS ; Print

PROMPT
    LD R0, ZERO ; R0 = 0 ...
    LD R4, NUMS ; Memory location
    STI R0, NDGT ; Set number of digits to 0
    STI R0, RUNO ; Set run one to false
    STI R0, NEGLOC ; Set zero flag to false
    LD R1, ZERO ; Set Total to 0
    LEA R0, PR ; Load PR into R0
    PUTS ; Print

READ
    GETC ; Console -> R0
    OUT ; Show user what they are typing

CNEG
    LD R2, NG ; Load Negitive Character
    NOT R2, R2 ; Get 2's complement
    ADD R2, R2, #1 ; Add 1 to finish 2's complement
    ADD R3, R0, R2 ; Check if -
    BRnp CQuit ; Continue
    LD R3, ONE ;
    STI R3, NEGLOC ; Ini Negitive flag to true
    BR READ ; Go to read if true

CQuit
    LD R2, QT ; Load Quit Character
    NOT R2, R2 ; Get 2's complement
    ADD R2, R2, #1 ; Add 1 to finish 2's complement
    ADD R3, R0, R2 ; Check if X
    BRnp CNL ; If False, Continue
    BR STOP ; If True, Stop

CNL
    LD R2, NL ; Load new line character
    NOT R2, R2 ; Get 2's complement
    ADD R2, R2, #1 ; Add 1 to finish 2's complement
    ADD R3, R0, R2 ; Check if new line
    BRnp STOR ; Continue Reading Characters
    ADD R4, R4, #-1 ; Deinc because we were predicting another int
    BR CALC ; Is a new line, Calculate and print!

STOR
    LD R2, OF ; Load Offset
    NOT R2, R2 ; Get 2's complement
    ADD R2, R2, #1 ; Add 1 to finish 2's complement
    ADD R0, R0, R2; Turn ASCII into number
    STR R0, R4, #0 ; Store R0 into R4
    ADD R4, R4, #1 ; Increment Storage location
    BR READ ; Go to next character

STOP
    LEA R0, GB ; Load WE into R0
    PUTS ; Print
    HALT ; Stop!

CALC
    ; Dont user R4, Contains memory stop location ; R1 Is the value of input number!
    LD R2, ONE ; Set R2 to 1
    MEMIRT
        LDR R0, R4, #0 ; Load last character into R0
        LDI R3, RUNO ; Load Run once flag
        BRz POST ; Skip Multt if its the first loop
        LD R3, TEN ; Number of loops for the multiplication
        LD R5, ZERO ;
        Multt
            ADD R5, R5, R2; Add R2 to R5
            ADD R3, R3, #-1 ; DeInc R3
            BRp Multt ; Loop Untill Done
        AND R2, R2, #0 ; Zero R2
        ADD R2, R2, R5 ; Store R5 into R2
        POST
        LD R3, ONE ; Load True into R3
        STI R3, RUNO ; Set run once to true
        MULT
            ADD R1, R1, R2 ; Add R2 to R1
            ADD R0, R0, #-1 ; DeInc R0
            BRp MULT ; Loop till done
        ADD R4, R4, #-1 ; Deinc mem loc
        LD R5, NUMS ; load Nums start loc
        NOT R5, R5 ; Inverse
        ADD R5, R5, #1 ; 2's complement
        ADD R5, R4, R5 ; Check if went though all mem loc
        BRzp MEMIRT ; Go to MEMIRT
        LDR R0, R1, #0 ; Load Number into R0

        ;Do not use R1, Contains number
        LDI R6, NEGLOC ; Load Neg FLAG
        BRz LOAD
        NOT R1, R1 ; Inverse
        ADD R1, R1, #1 ; 2's Complement

        LOAD              ; Idea of bitmasking from Scott Caldwell
        AND R4, R4, #0   ; Counter
        LEA R2, MSK    ; Address location of top mask
        BEGIN
            LDR R3, R2, #0   ; Load mask
            ADD R2, R2, #1   ; INC Mask Address
            AND R0, R1, R3   ; Check value against mask
            BRz BFALSE        ; If it does not contain the bit at the mast go to Bit False and print a zero
            LD  R0, ON      ; If it does, print a 1
            BR CHK          ; Are we there yet?
        BFALSE
            LD  R0, ZE  ; Loads zero
            BR CHK      ; Continue
        CHK
            OUT ; Prints our bit
            ADD R4, R4, #1 ; Increment address LOC
            LD R5, NST ; Load neg 16
            ADD R0, R4, R5  ; Check if we reached 16 bits
            BRn BEGIN   ; If not do it again
    LD R0, NL ; Load a new line
    OUT ; Print
    BR PROMPT ; GOTO Start

PR           .STRINGZ "Enter a decimal number or X to quit: \n>" ; Loop Message
WE           .STRINGZ "Welcome to the conversion Program! \n" ; Welcome Message
CL           .STRINGZ "Your number in binary is :\n" ; Calc Message
GB           .STRINGZ "\nGoodbye! Halting program... \n" ; Goodbye Message
ZE           .FILL x0030 ; 0
ON           .FILL x0031 ; 1

NL           .FILL x000A ; New Line Character
QT           .FILL x0058 ; Quit Character X
NG           .FILL x002D ; Negitive Character -
OF           .FILL x0030 ; ASCII to Number offset
ONE          .FILL x0001 ; ONE
TEN          .FILL x000A ; Ten
ZERO         .FILL x0000 ; ZERO
NST          .FILL xFFF0 ; Negitive 16

NEGLOC          .FILL x4000 ; FLAG Negitive
RUNO          .FILL x4001 ; FLAG Run Once
NDGT          .FILL x4002 ; FLAG Number Digits
NUMS           .FILL x4100 ; Begin mem location of mumbers

MSK     .FILL x8000
        .FILL x4000
        .FILL x2000
        .FILL x1000
        .FILL x0800
        .FILL x0400
        .FILL x0200
        .FILL x0100
        .FILL x0080
        .FILL x0040
        .FILL x0020
        .FILL x0010
        .FILL x0008
        .FILL x0004
        .FILL x0002
        .FILL x0001

ME
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x000A
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x005f
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x0020
    .FILL x000A
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x0020
    .FILL x0028
    .FILL x005f
    .FILL x0029
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x002f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x000A
    .FILL x0020
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x0060
    .FILL x002f
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x0060
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x005c
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x005f
    .FILL x0020
    .FILL x005c
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x0060
    .FILL x002f
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x0020
    .FILL x005c
    .FILL x000A
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x0020
    .FILL x005f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x000A
    .FILL x0020
    .FILL x005c
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x002f
    .FILL x005c
    .FILL x005f
    .FILL x005f
    .FILL x002c
    .FILL x005f
    .FILL x002f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x002f
    .FILL x005f
    .FILL x002f
    .FILL x005f
    .FILL x002f
    .FILL x005c
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x0020
    .FILL x0020
    .FILL x005c
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x002f
    .FILL x005c
    .FILL x005f
    .FILL x005f
    .FILL x002c
    .FILL x005f
    .FILL x002f
    .FILL x005c
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x005f
    .FILL x002f
    .FILL x0020
    .FILL x000A
    .FILL x0020
    .FILL x004c
    .FILL x0069
    .FILL x0063
    .FILL x0065
    .FILL x006e
    .FILL x0073
    .FILL x0065
    .FILL x0064
    .FILL x0020
    .FILL x0075
    .FILL x006e
    .FILL x0064
    .FILL x0065
    .FILL x0072
    .FILL x0020
    .FILL x0047
    .FILL x004e
    .FILL x0055
    .FILL x0020
    .FILL x0047
    .FILL x0050
    .FILL x004c
    .FILL x0076
    .FILL x0033
    .FILL x0020
    .FILL x0020
    .FILL x002d
    .FILL x0020
    .FILL x004c
    .FILL x0041
    .FILL x0042
    .FILL x0033
    .FILL x000A
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x003d
    .FILL x000A
.END
