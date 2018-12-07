*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  MAIN
*-----------------------------------------------------------
    ORG    $1000

INCREMENT       EQU     $3000
LINE_COUNTER    EQU     $3020
BUFF_POINT      EQU     $3250   * where the string buffer lives
BYTE_COUNTER    EQU     $3040   * counter for the number of bytes the string has
STRING_STORE    EQU     $3500   * where the beginning of the temp string storage lives


START:
    JSR     START_IO
    CLR.L   D0
    CLR.L   D1
    CLR.L   D2
    CLR.L   D3
    CLR.L   D4
    CLR.L   D5

    MOVEA.L #$00000000,A0
    MOVEA.L #$00000000,A1
    MOVEA.L #$00000000,A2
    MOVEA.L #$00000000,A3
    MOVEA.L #$00000000,A6

    MOVE.L  #$2, INCREMENT
    LEA     LINE_COUNTER, A6         * load ing end address into A5
    MOVE.L  #0, (A6)                 * initalize the line counter to 0

MAIN:
    CMP.L   A5,A4                   * comparing start/end addresses
    BGE.L   COMPLETED               * greater than or equal means done
    CMP.L   #25, (A6)
    BEQ     PAUSE
    CMP.L   A4,A5
    BNE     OPCODE_BEGIN            * not done yet, so fetch next opcode

PAUSE:
    MOVE.L  #$0, INCREMENT          * fixes the next line to increment correctly
    MOVE.B  #5, D0
    TRAP    #15
    MOVE.L  #0, (A6)
    BRA     NEXT_ADDRESS

NEXT_ADDRESS:
    ADD.L   INCREMENT, A4           * incrementing address here by INCREMNET amount, needs to be changed
    ADD.L   #1, (A6)                * adding 1 to the line counter
    BRA     MAIN                    * go back to check addresses in MAIN

COMPLETED:
    LEA FINISHED, A1                * load finished message
    MOVE.B  #13, D0                 * displaying message
    TRAP #15

*****
***** THESE LINES BELOW ARE FOR TESTING ONLY *****


* Put variables and constants here
    INCLUDE "opcodes.x68"
    INCLUDE "EA.x68"
    INCLUDE "IO.x68"
    INCLUDE "demo_test.x68"


    END    START        ; last line of source



































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
