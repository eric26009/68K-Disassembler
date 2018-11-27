*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  MAIN
*-----------------------------------------------------------
    ORG    $1000
    
START_ADDRESS   EQU     $1000       * hard coded start address
END_ADDRESS     EQU     $1308       * hard coded end address
    
   
    
START:                  
    LEA     START_ADDRESS, A4       * loading start address into A4
    LEA     END_ADDRESS, A5         * load ing end address into A5
    
MAIN:
    CMP.L   A5,A4                   * comparing start/end addresses
    BGE.L   COMPLETED               * greater than or equal means done
    CMP.L   A4,A5
    BNE     OPCODE_BEGIN            * not done yet, so fetch next opcode
    
NEXT_ADDRESS:
    ADD.L   #$2, A4                 * incrementing address here by 2, needs to be changed
    BRA     MAIN                    * go back to check addresses in MAIN
    
COMPLETED:
    LEA FINISHED, A1                * load finished message
    MOVE.B  #13, D0                 * displaying message
    TRAP #15

    
    
    SIMHALT             ; halt simulator

* Put variables and constants here
 INCLUDE "/Users/Eric/Google Drive/Fall 2018/422/68k_git/68K-Disassembler/opcodes.x68"

    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
