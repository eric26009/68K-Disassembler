*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  MAIN
*-----------------------------------------------------------
    ORG    $1000

START_ADDRESS   EQU     $000010A4       * hard coded start address
END_ADDRESS     EQU     $000010D8      * hard coded end address
INCREMENT       EQU     $8
LINE_COUNTER    EQU     $2000



START:
    MOVE.L  #$2, INCREMENT
    LEA     START_ADDRESS, A4       * loading start address into A4
    LEA     END_ADDRESS, A5         * load ing end address into A5
    LEA     LINE_COUNTER, A6         * load ing end address into A5
    MOVE.L  #0, (A6)                 * initalize the line counter to 0

MAIN:
    CMP.L   A5,A4                   * comparing start/end addresses
    BGE.L   COMPLETED               * greater than or equal means done
    CMP.L   #10, (A6)
    BEQ     PAUSE
    CMP.L   A4,A5
    BNE     OPCODE_BEGIN            * not done yet, so fetch next opcode

PAUSE:
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
TESTING_CODES:
    NOP
    BCC     TEST_LABEL
    BCS     TEST_LABEL
    BGE     TEST_LABEL
    BLT     TEST_LABEL
    BVC     TEST_LABEL
    BEQ     TEST_LABEL
    MOVE.L  D2, D3
    MOVEA.W (A2), A6
    MOVE.B  -(A3),D4
    MOVE.B  (A5)+,(A6)
    ADD.B   D3, $CB2F
    JSR     TEST_LABEL
    BRA     TEST_LABEL
    CMPI.W  #44, (A1)
    CMP.L   #23, D7
    ADDA.L  D2, A3
    EOR.B     D2, (A4)
    MOVEM.W D0-D7/A0-A6, (A2)
    NEG.B       D3
    SUB.L     D2, D5
    ORI.L     #23, D3
    ADD.L       D3, D5
    DIVS      (A2),D2
    MULS      #15,D5                    * LINE FOR TESTING
    LEA       C, A1
    MOVE.L   (A6)+,(A3)+
    MOVE.B   D4,D5
    ADD.B   #15, D3
    ADD.W   #15, D3
    ADD.L   #15,D3
    ADD.L   #203, D3
    SUBQ.B  #1, D3
    BCLR.B  #32, (A3)
    ASR.W   (A3)
    LSR.B   D2, D5
    LSR.L   #7, D1
    LSL.B   #3, D3
    LSL.W   D2, D4
    LSL.W   (A5)+
TEST_LABEL:

    SIMHALT             ; halt simulator

* Put variables and constants here
 INCLUDE "opcodes.x68"
 INCLUDE "EA.x68"
 INCLUDE "demo_test.X68"

    END    START        ; last line of source

























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
