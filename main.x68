*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  MAIN
*-----------------------------------------------------------
    ORG    $1000

INCREMENT       EQU     $20
LINE_COUNTER    EQU     $2000
BUFF_POINT      EQU     $3000   * where the string buffer lives
BYTE_COUNTER    EQU     $30       * counter for the number of bytes the string has
STRING_STORE    EQU     $4000   * where the beginning of the temp string storage lives


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
NOP
    RTS
    NOP
    RTS
    LEA     (A0),A0
    LEA     (A5),A0
    LEA     (A7),A0
    LEA     (A0),A7
    LEA     (A5),A7
    LEA     (A7),A7
    CLR.B     D0
    CLR.B     D7
    CLR.W     D0
    CLR.W     D7
    CLR.L     D0
    CLR.L     D7
    CLR.B     (A0)
    CLR.B     (A7)
    CLR.W     (A0)
    CLR.W     (A7)
    CLR.L     (A0)
    CLR.L     (A7)
    CLR.B     (A0)+
    CLR.B     (A7)+
    CLR.W     (A0)+
    CLR.W     (A7)+
    CLR.L     (A0)+
    CLR.L     (A7)+
    CLR.B     -(A0)
    CLR.B     -(A7)
    CLR.W     -(A0)
    CLR.W     -(A7)
    CLR.L     -(A0)
    CLR.L     -(A7)
    MOVE.B    D0,D1
    MOVE.B    D0,(A0)
    MOVE.B    D0,(A0)+
    MOVE.B    D0,-(A0)
    MOVE.B    (A0),D0
    MOVE.B    (A0),(A1)
    MOVE.B    (A0),(A1)+
    MOVE.B    (A0),-(A1)
    MOVE.B    (A0)+,D0
    MOVE.B    (A0)+,(A1)
    MOVE.B    (A0)+,(A1)+
    MOVE.B    (A0)+,-(A1)
    MOVE.B    -(A0),D0
    MOVE.B    -(A0),(A1)
    MOVE.B    -(A0),(A1)+
    MOVE.B    -(A0),-(A1)
    MOVE.W    D0,D1
    MOVE.W    D0,(A0)
    MOVE.W    D0,(A0)+
    MOVE.W    D0,-(A0)
    MOVE.W    A0,D0
    MOVE.W    A0,(A1)
    MOVE.W    A0,(A1)+
    MOVE.W    A0,-(A1)
    MOVE.W    (A0),D0
    MOVE.W    (A0),(A1)
    MOVE.W    (A0),(A1)+
    MOVE.W    (A0),-(A1)
    MOVE.W    (A0)+,D0
    MOVE.W    (A0)+,(A1)
    MOVE.W    (A0)+,(A1)+
    MOVE.W    (A0)+,-(A1)
    MOVE.W    -(A0),D0
    MOVE.W    -(A0),(A1)
    MOVE.W    -(A0),(A1)+
    MOVE.W    -(A0),-(A1)
    MOVE.L    D0,D1
    MOVE.L    D0,(A0)
    MOVE.L    D0,(A0)+
    MOVE.L    D0,-(A0)
    MOVE.L    A0,D0
    MOVE.L    A0,(A1)
    MOVE.L    A0,(A1)+
    MOVE.L    A0,-(A1)
    MOVE.L    (A0),D0
    MOVE.L    (A0),(A1)
    MOVE.L    (A0),(A1)+
    MOVE.L    (A0),-(A1)
    MOVE.L    (A0)+,D0
    MOVE.L    (A0)+,(A1)
    MOVE.L    (A0)+,(A1)+
    MOVE.L    (A0)+,-(A1)
    MOVE.L    -(A0),D0
    MOVE.L    -(A0),(A1)
    MOVE.L    -(A0),(A1)+
    MOVE.L    -(A0),-(A1)
    MOVEM.W   A1-A7,-(A1)
    MOVEM.L   D1-D7,-(A1)
    MOVEM.W   A1/D7,-(A1)
    MOVEM.L   A1/D7,-(A1)
    MOVEM.W   A1-A7,(A1)
    MOVEM.L   D1-D7,(A1)
    MOVEM.W   A1/D7,(A1)
    MOVEM.L   A1/D7,(A1)
    MOVEM.W   (A1)+,A1-A7
    MOVEM.L   (A1)+,D1-D7
    MOVEM.W   (A1)+,A1/D7
    MOVEM.L   (A1)+,A1/D7
    MOVEM.W   (A1),A1-A7
    MOVEM.L   (A1),D1-D7
    MOVEM.W   (A1),A1/D7
    MOVEM.L   (A1),A1/D7
    MOVEA.W    D0,A0
    MOVEA.W    A0,A0
    MOVEA.W    (A0),A0
    MOVEA.W    (A0)+,A0
    MOVEA.W    -(A0),A0
    MOVEA.L    D0,A0
    MOVEA.L    A0,A0
    MOVEA.L    (A0),A0
    MOVEA.L    (A0)+,A0
    MOVEA.L    -(A0),A0  
    ADD.B     D1,D2
    ADD.B     D1,(A1)
    ADD.B     D1,(A1)+
    ADD.B     D1,-(A1)
    ADD.B     (A1),D1
    ADD.B     (A1)+,D1
    ADD.B     -(A1),D1
    ADD.W     D1,D2
    ADD.W     D1,(A1)
    ADD.W     D1,(A1)+
    ADD.W     D1,-(A1)
    ADD.W     (A1),D1
    ADD.W     (A1)+,D1
    ADD.W     -(A1),D1
    ADD.L     D1,D2
    ADD.L     D1,(A1)
    ADD.L     D1,(A1)+
    ADD.L     D1,-(A1)
    ADD.L     (A1),D1
    ADD.L     (A1)+,D1
    ADD.L     -(A1),D1
    SUB.B     D1,D2
    SUB.B     D1,(A1)
    SUB.B     D1,(A1)+
    SUB.B     D1,-(A1)
    SUB.B     (A1),D1
    SUB.B     (A1)+,D1
    SUB.B     -(A1),D1
    SUB.W     D1,D2
    SUB.W     D1,A1
    SUB.W     D1,(A1)
    SUB.W     D1,(A1)+
    SUB.W     D1,-(A1)
    SUB.W     A1,D1
    SUB.W     (A1),D1
    SUB.W     (A1)+,D1
    SUB.W     -(A1),D1
    SUB.L     D1,D2
    SUB.L     D1,A1
    SUB.L     D1,(A1)
    SUB.L     D1,(A1)+
    SUB.L     D1,-(A1)
    SUB.L     A1,D1
    SUB.L     (A1),D1
    SUB.L     (A1)+,D1
    SUB.L     -(A1),D1    
    MULS.W    D0,D1
    MULS.W    (A0),D1
    MULS.W    -(A0),D1
    MULS.W    (A0)+,D1
    DIVU.W    D0,D1
    DIVU.W    (A0),D1
    DIVU.W    -(A0),D1
    DIVU.W    (A0)+,D1
    AND.B     D1,D2
    AND.B     D1,(A1)
    AND.B     D1,(A1)+
    AND.B     D1,-(A1)
    AND.B     (A1),D1
    AND.B     (A1)+,D1
    AND.B     -(A1),D1
    AND.W     D1,D2
    AND.W     D1,(A1)
    AND.W     D1,(A1)+
  OR.B     D1,D2
    OR.B     D1,(A1)
    OR.B     D1,(A1)+
    OR.B     D1,-(A1)
    OR.B     (A1),D1
    OR.B     (A1)+,D1
    OR.B     -(A1),D1
    OR.W     D1,D2
    OR.W     D1,(A1)
    OR.W     D1,(A1)+
    OR.W     D1,-(A1)
    OR.W     (A1),D1
    OR.W     (A1)+,D1
    OR.W     -(A1),D1
    OR.L     D1,D2
    OR.L     D1,(A1)
    OR.L     D1,(A1)+
    OR.L     D1,-(A1)
    OR.L     (A1),D1
    OR.L     (A1)+,D1
    OR.L     -(A1),D1
    LSL.B     D1,D2
    LSL.W     D1,D2
    LSL.W     (A1)
    LSL.W     (A1)+
    LSL.W     -(A1)
    LSL.L     D1,D2
    LSR.B     D1,D2
    LSR.W     D1,D2
    LSR.W     (A1)
    LSR.W     (A1)+
    LSR.W     -(A1)
    LSR.L     D1,D2    
    ASR.B     D1,D2
    ASR.W     D1,D2
    ASR.W     (A1)
    ASR.W     (A1)+
    ASR.W     -(A1)
    ASR.L     D1,D2
    ASL.B     D1,D2
    ASL.W     D1,D2
    ASL.W     (A1)
    ASL.W     (A1)+
    ASL.W     -(A1)
    ASL.L     D1,D2
    ROL.B     D1,D2
    ROL.W     D1,D2
    ROL.W     (A1)
    ROL.W     (A1)+
    ROL.W     -(A1)
    ROL.L     D1,D2
    ROR.B     D1,D2
    ROR.W     D1,D2
    ROR.W     (A1)
    ROR.W     (A1)+
    ROR.W     -(A1)
    ROR.L     D1,D2    
    CMP.B    D0,D1
    CMP.B    (A0),D1
    CMP.B    -(A0),D1
    CMP.B    (A0)+,D1
    CMP.W    D0,D1
    CMP.W    A0,D1
    CMP.W    (A0),D1
    CMP.W    -(A0),D1
    CMP.W    (A0)+,D1
    CMP.L    D0,D1
    CMP.L    A0,D1
    CMP.L    (A0),D1
    CMP.L    -(A0),D1
    CMP.L    (A0)+,D1
    BCC.B     label1
    BCC.B     label2
    BGT.B     label1
    BGT.B     label2
    BLE.B     label1
    BLE.B     label2
    BCC.W     label1
    BCC.W     label2
    BCC.W     label3
    BGT.W     label1
    BGT.W     label2
    BGT.W     label3
    BLE.W     label1
    BLE.W     label2
    BLE.W     label3
    JSR       (A0)
    JSR       $1234
    JSR       $12345678
    JSR       label1
    JSR       label2
    JSR       label3
    NOP
    RTS
label1
    NOP
    RTS
    LEA       $12,A0
    LEA       $1234,A0
    LEA       $12345678,A0
    CLR.B     $12
    CLR.B     $1234
    CLR.B     $12345678
label2
    CLR.W     $12
    CLR.W     $1234
    CLR.W     $12345678
    CLR.L     $12
    CLR.L     $1234
    CLR.L     $12345678
    MOVEQ     #$0,D0
    MOVEQ     #$12,D0
    MOVEQ     #$FF,D0
    ADDI.B    #$12,D1
    ADDI.B    #$12,(A0)
    ADDI.B    #$12,(A0)+
    ADDI.B    #$12,-(A0)
    ADDI.B    #$12,$1234
label3

    ADDQ      #$1,D0
    ADDQ      #$3,D0
    ADDQ      #$8,D0
    MOVE.B    $12,D1
    MOVE.B    $12,(A0)
    MOVE.B    $12,(A0)+
    MOVE.B    $12,-(A0)
    MOVE.B    $1234,D0
    MOVE.B    $1234,(A1)
    MOVE.B    $1234,(A1)+
    MOVE.B    $1234,-(A1)
    MOVE.B    $12345678,D0

    MOVE.B    #$12,D0
    MOVE.B    #$12,(A1)
    MOVE.B    #$12,(A1)+
    MOVE.B    #$12,-(A1)
    MOVE.W    $12,D1
    MOVE.W    $12,(A0)
    MOVE.W    $12,(A0)+
    MOVE.W    $12,-(A0)
    MOVE.W    $1234,D0
    MOVE.W    $1234,(A1)
    MOVE.W    $1234,(A1)+
    MOVE.W    $1234,-(A1)
    MOVE.W    $12345678,D0

    MOVE.W    #$1234,D0
    MOVE.W    #$1234,(A1)
    MOVE.W    #$1234,(A1)+
    MOVE.W    #$1234,-(A1)
    MOVE.L    $12,D1
    MOVE.L    $12,(A0)
    MOVE.L    $12,(A0)+
    MOVE.L    $12,-(A0)
    MOVE.L    $1234,D0
    MOVE.L    $1234,(A1)

    ADD.B     D1,$12
    ADD.B     D1,$1234





* Put variables and constants here
    INCLUDE "opcodes.x68"
    INCLUDE "EA.x68"
    INCLUDE "IO.x68"


    END    START        ; last line of source
































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
