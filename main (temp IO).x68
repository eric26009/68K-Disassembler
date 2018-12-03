*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  MAIN
*-----------------------------------------------------------
    ORG    $1000

START_ADDRESS   EQU     $102E       * hard coded start address
END_ADDRESS     EQU     $1044       * hard coded end address
INCREMENT       EQU     $8



START:
    MOVE.L  #$2, INCREMENT
    LEA     START_ADDRESS, A4       * loading start address into A4
    LEA     END_ADDRESS, A5         * load ing end address into A5

MAIN:
    CMP.L   A5,A4                   * comparing start/end addresses
    BGE.L   COMPLETED               * greater than or equal means done
    CMP.L   A4,A5
    BNE     OPCODE_BEGIN            * not done yet, so fetch next opcode

NEXT_ADDRESS:
    ADD.L   INCREMENT, A4                 * incrementing address here by 2, needs to be changed
    BRA     MAIN                    * go back to check addresses in MAIN

COMPLETED:
    LEA FINISHED, A1                * load finished message
    MOVE.B  #13, D0                 * displaying message
    TRAP #15

    JSR     TEST_LABEL
    BRA     TEST_LABEL
    CMPI.W  #44, (A1)
    CMP.L   #23, D7
    EOR.B     D2, (A4)
    MOVEM.W D0-D7/A0-A6, (A2)
    NEG.B       D3
    ORI.L     #23, D3
    DIVS      #20,D2
    MULS      #20,D2                    * LINE FOR TESTING
    LEA       C, A1
    MOVE.L   (A6)+,(A3)+
    MOVE.B   D4,D5

TEST_LABEL:

    SIMHALT             ; halt simulator

* Put variables and constants here
 INCLUDE "opcodes.x68"
 INCLUDE "EA.x68"

    END    START        ; last line of source














*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
