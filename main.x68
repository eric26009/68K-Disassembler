*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  MAIN
*-----------------------------------------------------------
    ORG    $1000

START_ADDRESS   EQU     $00009000       * hard coded start address
END_ADDRESS     EQU     $0000cccc      * hard coded end address
INCREMENT       EQU     $20
LINE_COUNTER    EQU     $2000



START:
    JSR     START_IO
    MOVE.L  #$2, INCREMENT
    ; LEA     START_ADDRESS, A4       * loading start address into A4
    ; LEA     END_ADDRESS, A5         * load ing end address into A5
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
TEST1:
*    RTS
 *  BCC     TEST_LABEL
*    BCS     TEST_LABEL
*    BGE     TEST_LABEL
*    BLT     TEST_LABEL
*    BVC     TEST_LABEL
*    BEQ     TEST_LABEL
   * CMP.W   D3, D1
   * CMP.L   D3, D7
*    CMPI.B   #15, (A3)
    EOR.B      D5, (A2)
    EOR       D2,$2022
    BCLR    D5, $1200
    NEG     (A3)
    NEG     $2311
*    OR      (A2), D3
*    LEA     $2000, A3
*    OR      D3, (A2)
*    ORI.L   #30, (A2)
*    MULS      $2922,D7
*    DIVS      $2921, D5
*    SUB         $2321, D5
*    SUB         D2, (A2)
*    SUBQ.B        #2, D3
*    SUBQ         #7, (A2)
**    ADD           (A2), D6
*     ADD            D5, $2311
*     ADDA           (A5), A4
*     ADDA           $2311, A2
    * MOVE.B     #15, (A2)
*     MOVEA.L     (A3), A2
   *  MOVE.W     #9, D4
*     MOVEA.W    D3, A3
*     MOVEA.L    #2, A6
*    ADD.L       D3, D5
*    DIVS      (A2),D2
*    MULS      #15,D5
*    DIVS      #8, D5
*    ROR     D3, D5
*    ROR     #4, D4
*    ROL     $1022
*    ROR     $39299999
*    LSR     D3, D5
*    LSL     #4, D4
*    LSR     $1022
*    LSL     $39299999


*
*    MOVE.L  D2, D3
*    MOVEA.W (A2), A6
*    MOVE.B  -(A3),D4
*    MOVE.B  (A5)+,(A6)
*    ADD.B   D3, $CB2F
*    JSR     TEST_LABEL
*    BRA     TEST_LABEL
*    CMPI.W  #44, (A1)
*    CMP.L   #23, D7
*    ADDA.L  D2, A3
*    EOR.B     D2, (A4)
*    MOVEM.W D0-D7/A0-A6, (A2)
*    NEG.B       D3
*    SUB.L     D2, D5
*    ORI.B     #3, D3
*    MULS      #15,D7
*    ADD.L       D3, D5
*    DIVS      (A2),D2
*    MULS      #15,D5
*    DIVS      #8, D5
*                  * LINE FOR TESTING
*    LEA       C, A1
*    MOVE.L   (A6)+,(A3)+
*    MOVE.B   D4,D5
*    ADD.B   #15, D3
*    ADD.W   #15, D3
*    ADD.L   #15,D3
*    ADD.L   #15, D3
*    SUBQ.B  #1, D3
*    BCLR.B  #32, (A3)
*    ASR.W   (A3)
*    LSR.B   D2, D5
*    LSR.L   #7, D1
*    LSL.B   #3, D3
*    LSL.W   D2, D4
*    LSL.W   (A5)+
TEST_LABEL:

    SIMHALT             ; halt simulator

* Put variables and constants here
 INCLUDE "/Users/Eric/Google Drive/Fall 2018/422/68k_git/68K-Disassembler/IO.X68"
 INCLUDE "opcodes.x68"
 INCLUDE "EA.x68"
 INCLUDE "demo_test.X68"


    END    START        ; last line of source































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
