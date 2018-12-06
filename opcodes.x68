*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  Opcodes, string buffer, DC table, hex conversion
*-----------------------------------------------------------
    *ORG    $1000

BUFF_POINT      EQU     $3000   * where the string buffer lives
BYTE_COUNTER    EQU     $30       * counter for the number of bytes the string has
STRING_STORE    EQU     $4000   * where the beginning of the temp string storage lives


OPCODE_BEGIN:
    LEA        BUFF_POINT,A1        * pointer to string buffer
    LEA        STRING_STORE, A2     * A2 stores the pointer to end of string
    LEA        STRING_STORE, A3     * A3 stores the pointer to start of string
    MOVE.W     #0, BYTE_COUNTER     * starting byte counter with 0

    MOVE.B      #0, D5                * RESETTING HEX CONVERTER COUNTER
    MOVE.L      A4,D6                 * moving current address into D6
    MOVE.L      D6,D7                 * making a copy of D6 into D7
    MOVE.L      #$2, INCREMENT         * resetting the increment counter back to $2, EA may change it.
    MOVE.B      MONEY, (A2)+         * adding a MONEY SYMBOL to the beginning
    ADD.W       #1, BYTE_COUNTER      * increment byte counter
    JSR         HEX_CHAR
    JSR         TAB         * printing tab after HEX address is printed to screen



* op-code debugging
FIRST4BITS:
    MOVE.W  (A4),D2    * moving current memory in address into D2
    MOVE.W  A4,D6      * D6 holds current address to HEX conversion
    MOVE.W  D2,D3       * save a copy of of contents in D3

    CMP.W   #$4E75, D2      * RTS code
    BEQ     OP_RTS

    CMP.W   #$4E71, D2      * NOP code
    BEQ     OP_NOP

    MOVE.L  D3,D2                   * LEA mode
    AND.W   #%1111000111000000, D2
    CMP.W   #%0100000111000000, D2
    BEQ     LEA_MODE

    MOVE.L  D3,D2
    AND.W   #%1111000111000000, D2  * DIVS mode
    CMP.W   #%1000000111000000, D2
    BEQ     DIVS

    MOVE.L  D3,D2
    AND.W   #%1111101110000000, D2  * MOVEM mode
    CMP.W   #%0100100010000000, D2
    BEQ     MOVEM

    MOVE.L  D3,D2
    AND.W   #%1111111111000000, D2  * BLCR mode, source is #value
    CMP.W   #%0000100010000000, D2
    BEQ     BCLR_FROM_IMMEDIATE_DATA
    MOVE.L  D3,D2
    AND.W   #%1111000110000000, D2  * BCLR mode, source is DN
    CMP.W   #%0000000110000000, D2
    BEQ     BCLR_FROM_DN

    MOVE.L  D3,D2
    AND.W   #%1111111011000000, D2  * ASR/ASL mode, <EA only>
    CMP.W   #%1110000011000000, D2
    BEQ     ASD_MEM
    MOVE.L  D3,D2
    AND.W   #%1111111011000000, D2  * LSR/LSL mode, <EA only>
    CMP.W   #%1110011011000000, D2
    BEQ     ROD_MEM
    MOVE.L  D3,D2
    AND.W   #%1111111011000000, D2  * ROR/ROL mode, <EA only>
    CMP.W   #%1110001011000000, D2
    BEQ     LSD_MEM

    MOVE.L  D3,D2
    AND.W   #%1111000000011000, D2  * ASR/ASL mode, #data or DN source
    CMP.W   #%1110000000000000, D2
    BEQ     ASD_REG
    MOVE.L  D3,D2
    AND.W   #%1111000000011000, D2  * ROR/ROL mode, #data or DN source
    CMP.W   #%1110000000001000, D2
    BEQ     LSD_REG
    AND.W   #%1111000000011000, D2  * ROR/ROL mode, #data or DN source
    CMP.W   #%1110000000011000, D2
    BEQ     ROD_REG

    MOVE.L  D3,D2       * ORI mode
    ROL.W   #8,D2
    AND.B   #%11111111, D2
    CMP.B   #%00000000, D2
    BEQ     ORI

    MOVE.L  D3,D2       * EOR mode
    ROL.W   #8,D2
    AND.B   #%11110001, D2
    CMP.B   #%10110001, D2
    BEQ     EOR

    MOVE.L  D3,D2       * NEG mode
    ROL.W   #8,D2
    AND.B   #%11111111, D2
    CMP.B   #%01000100, D2
    BEQ     NEG

    MOVE.L  D3,D2       * CMP mode
    ROL.W   #8,D2
    AND.B   #%11110001, D2
    CMP.B   #%10110000, D2
    BEQ     CMP

    MOVE.L  D3,D2       * CMPI mode
    ROL.W   #8,D2
    AND.B   #%11111111, D2
    CMP.B   #%00001100, D2
    BEQ     CMPI

    MOVE.L  D3,D2       * BRA mode
    ROL.W   #8,D2
    AND.B   #%11111111, D2
    CMP.B   #%01100000, D2
    BEQ     BRA

    MOVE.L  D3,D2       * JSR mode
    AND.W   #%1111111111000000, D2
    CMP.W   #%0100111010000000, D2
    BEQ     JSR

    MOVE.L  D3,D2
    ROL.W   #4,D2               * rotate to the left by 4 to see first 4 bits
    AND.B   #%00001111, D2      * bitmask to check the first 4 bits for opcode type


    CMP.B   #%00000001, D2      * move.b
    BEQ     MOVE
    CMP.B   #%00000011, D2      * move.l
    BEQ     MOVE
    CMP.B   #%00000010, D2      * move.w
    BEQ     MOVE
    CMP.B   #%00001101, D2      * ADD
    BEQ     ADD
    CMP.B   #%00001001, D2      * SUB
    BEQ     SUB
    CMP.B   #%00001100, D2      * MULS
    BEQ     MULS
    CMP.B   #%00001000, D2      * OR
    BEQ     OR
    CMP.B   #%00000101, D2      * SUBQ
    BEQ     SUBQ
    CMP.B   #%00000110, D2      * BCC
    BEQ     BCC_CODES
    BRA UNKNOWN                 * if unknown opcode, print 'DATA' out


OP_NOP:
    MOVE.B  N, (A2)+            * appending letters
    MOVE.B  O, (A2)+
    MOVE.B  P, (A2)+
    ADD.W   #3, BYTE_COUNTER    * increment byte counter
    BRA     BUFFER_LOOP

BCC_CODES:
    MOVE.L  D3,D2
    ROL.W   #8,D2               * rotate to the left by 8 to get conditon mode
    AND.B   #%00001111, D2      * bitmask to check mode
    CMP.B   #%0100, D2          * BCC
    BEQ     BCC
    CMP.B   #%0101, D2          * BCS
    BEQ     BCS
    CMP.B   #%1100, D2          * BGE
    BEQ     BGE
    CMP.B   #%1101, D2          * BLT
    BEQ     BLT
    CMP.B   #%1000, D2          * BVC
    BEQ     BVC
    CMP.B   #%0111, D2          * BEQ
    BEQ     BEQ
    BRA     UNKNOWN

BCC:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  C, (A2)+
    MOVE.B  C, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH
BCS:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  C, (A2)+
    MOVE.B  S, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH
BGE:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  G, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH
BLT:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  L, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH
BVC:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  V, (A2)+
    MOVE.B  C, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH
BEQ:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  E, (A2)+
    MOVE.B  Q, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH

BCC_CODES_FINISH:
    JSR     SIZE_BCC
    CMP.B   #0, D6
    BEQ     BCC_BYTE
    CMP.B   #1, D6
    BEQ     BCC_WORD
    BRA     UNKNOWN

SIZE_BCC:
    MOVE.L  D3,D2
    AND.B   #%11111111, D2  * checking for BRA size 0 = word, 1 = long
    CMP.B   #%00000000, D2
    BEQ     ADD_WORD
    BNE     ADD_BYTE

BCC_BYTE:
    JSR     EA_Absolute_Byte
    BRA     BUFFER_LOOP

BCC_WORD:
    JSR     EA_Absolute_WORD
    BRA     BUFFER_LOOP


ASD_REG:
    MOVE.B  A, (A2)+            * appending letters
    MOVE.B  S, (A2)+
    JSR     DIRECTION
    JSR     ADD_SIZE
    JSR     COUNT_REG
    JSR     MOVE_SOURCE_DN_RTS      * gets register in the last 3 bits
    ADD.W   #2, BYTE_COUNTER    * increment byte counter
    BRA     BUFFER_LOOP

ASD_MEM:
    MOVE.B  A, (A2)+            * appending letters
    MOVE.B  S, (A2)+
    JSR     DIRECTION
    MOVE.B  W, (A2)+
    ADD.W   #3, BYTE_COUNTER    * increment byte counter
    MOVE.B  #1, D6              * saving size for EA
    JSR     TAB
    JSR     EA_MAIN
    BRA     BUFFER_LOOP

LSD_REG:
    MOVE.B  L, (A2)+
    MOVE.B  S, (A2)+
    JSR     DIRECTION
    JSR     ADD_SIZE
    JSR     COUNT_REG
    ADD.W   #2, BYTE_COUNTER
    JSR     MOVE_SOURCE_DN_RTS      * gets register in the last 3 bits
    BRA     BUFFER_LOOP

LSD_MEM:
    MOVE.B  L, (A2)+
    MOVE.B  S, (A2)+
    JSR     DIRECTION
    MOVE.B  W, (A2)+
    ADD.W   #3, BYTE_COUNTER
    MOVE.B  #1, D6
    JSR     TAB
    JSR     EA_MAIN
    BRA     BUFFER_LOOP

ROD_REG:
    MOVE.B  R, (A2)+
    MOVE.B  O, (A2)+
    JSR     DIRECTION
    JSR     ADD_SIZE
    JSR     COUNT_REG
    ADD.W   #2, BYTE_COUNTER
    JSR     MOVE_SOURCE_DN_RTS      * gets register in the last 3 bits
    BRA     BUFFER_LOOP

ROD_MEM:
    MOVE.B  R, (A2)+
    MOVE.B  O, (A2)+
    JSR     DIRECTION
    MOVE.B  W, (A2)+
    ADD.W   #3, BYTE_COUNTER
    MOVE.B  #1, D6              * setting size for EA
    JSR     TAB
    JSR     EA_MAIN
    BRA     BUFFER_LOOP

COUNT_REG:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROR.W   #5,D2
    AND.B   #%00000001, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2
    BEQ     COUNT
    BNE     REG

COUNT:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.W   #7,D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2
    BEQ     ZERO_IS_EIGHT
    BNE     NOT_EIGHT
ZERO_IS_EIGHT:
    MOVE.W  #8, D2
NOT_EIGHT:
    ADD.B   #$30, D2
    MOVE.B  POUND, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  COMMA, (A2)+
    ADD.W   #3, BYTE_COUNTER
    RTS

REG:
    JSR MOVE_DEST_DN_RTS
    MOVE.B  COMMA, (A2)+
    ADD.W   #1, BYTE_COUNTER
    RTS


DIRECTION:
    MOVE.L  D3, D2
    ROL.W   #8, D2
    AND.B   #%00000001, D2
    CMP.B   #0, D2
    BEQ     RIGHT
    BNE     LEFT
    RTS

RIGHT:
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #2, BYTE_COUNTER
    RTS

LEFT:
    MOVE.B  L, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #2, BYTE_COUNTER
    RTS



BCLR_FROM_IMMEDIATE_DATA:
    MOVE.B  B, (A2)+
    MOVE.B  C, (A2)+
    MOVE.B  L, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    JSR     BCLR_SIZE
    ADD.W   #6, BYTE_COUNTER
    JSR     EA_Immediate            * this will be a special case
    MOVE.B  COMMA, (A2)+
    JSR     EA_MAIN                 * destination EA is normal
    BRA     BUFFER_LOOP


BCLR_FROM_DN:
    MOVE.B  B, (A2)+
    MOVE.B  C, (A2)+
    MOVE.B  L, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    JSR     BCLR_SIZE
    ADD.W   #6, BYTE_COUNTER
    JSR     MOVE_DEST_DN_RTS
    MOVE.B  COMMA, (A2)+
    JSR     EA_MAIN
    BRA     BUFFER_LOOP


BCLR_SIZE:
    MOVE.L  D3, D2
    AND.B   #%00111000, D2      * bitmask to check the mode for size
    CMP.B   #%00000000, D2      * if DN that means the size is Long
    BEQ     BCLR_PRINT_LONG
    BNE     BCLR_PRINT_BYTE

BCLR_PRINT_LONG:
    MOVE.B  #2, D6      * saving size for EA
    JSR     ADD_LONG
    RTS

BCLR_PRINT_BYTE:
    MOVE.B  #0, D6      * saving size for EA
    JSR     ADD_BYTE
    RTS


JSR:
    MOVE.B  J, (A2)+
    MOVE.B  S, (A2)+
    MOVE.B  R, (A2)+
    JSR     TAB
    ADD.W   #3, BYTE_COUNTER
    JSR    EA_MAIN
    BRA     BUFFER_LOOP

BRA:
    MOVE.B  B, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER
    JSR     BRA_SIZE
    BRA     BUFFER_LOOP

BRA_SIZE:
    MOVE.L  D3,D2
    AND.B   #%11111111, D2  * checking for BRA size 0 = word, 1 = long
    CMP.B   #%00000000, D2
    BEQ     BRA_WORD
    BNE     BRA_BYTE


BRA_WORD:
    JSR     ADD_WORD
    JSR     EA_Absolute_WORD
    RTS


BRA_BYTE:
    JSR     ADD_BYTE
    JSR     EA_Absolute_Byte
    RTS

CMPI:
    MOVE.B  C, (A2)+
    MOVE.B  M, (A2)+
    MOVE.B  P, (A2)+
    MOVE.B  I, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #6, BYTE_COUNTER
    JSR     ADD_SIZE
    JSR     EA_Immediate      * special EA
    MOVE.B  COMMA, (A2)+
    JSR    EA_MAIN
    BRA     BUFFER_LOOP

CMP:
    MOVE.B  C, (A2)+
    MOVE.B  M, (A2)+
    MOVE.B  P, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #5, BYTE_COUNTER
    JSR     ADD_SIZE
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    JSR     MOVE_DEST_DN

EOR:
    MOVE.B  E, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    JSR     ADD_SIZE
    JSR     MOVE_DEST_DN_RTS    *actually grabbing the source here, but it lives in the same place as source for most
    MOVE.B  COMMA, (A2)+
    JSR     EA_MAIN
    ADD.W   #5, BYTE_COUNTER
    BRA     BUFFER_LOOP

MOVEM:
    MOVE.B  M, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  M, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #6, BYTE_COUNTER
    JSR     MOVEM_SIZE
    JSR    EA_MAIN          * special EA
    BRA     BUFFER_LOOP

MOVEM_SIZE:
    MOVE.L  D3,D2
    ROR.W   #6,D2
    AND.B   #%00000001, D2  * checking for MOVEM size 0 = word, 1 = long
    CMP.B   #%00000000, D2
    BEQ     MOVEM_WORD
    BNE     MOVEM_LONG

MOVEM_WORD:
    JSR    ADD_WORD
    MOVE.B  #1, D6      * saving size for EA
    JSR    EA_MAIN
    RTS

MOVEM_LONG:
    JSR    ADD_LONG
    MOVE.B  #2, D6      * saving size for EA
    JSR    EA_MAIN
    RTS

NEG:
    MOVE.B  N, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  G, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER
    JSR     ADD_SIZE
    JSR     EA_MAIN
    BRA     BUFFER_LOOP

ORI:
    MOVE.B  O, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  I, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #5, BYTE_COUNTER
    JSR     ADD_SIZE
    JSR     EA_Immediate          * special EA
    MOVE.B  COMMA, (A2)+
    JSR     EA_MAIN
    BRA     BUFFER_LOOP

OR:
    MOVE.B  O, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #3, BYTE_COUNTER
    JSR     ADD_SIZE
    MOVE.L  D3,D2
    ROL.W   #8,D2               * rotate left 8 bits to get the direction
    AND.B   #%00000001, D2      * bitmask to see direction
    CMP.B   #%00000000, D2
    BEQ     OR_DEST_DN
    BNE     OR_DEST_EA
OR_DEST_DN:                     * <EA> OR DN direction
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    ADD.W   #1, BYTE_COUNTER
    JSR     MOVE_DEST_DN_RTS
    BRA     BUFFER_LOOP

OR_DEST_EA:                      * DN OR <EA> direction
    JSR     MOVE_DEST_DN_RTS
    MOVE.B  COMMA, (A2)+
    ADD.W   #1, BYTE_COUNTER
    JSR     EA_MAIN
    BRA     BUFFER_LOOP



DIVS:
    MOVE.B  D, (A2)+
    MOVE.B  I, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  S, (A2)+
    JSR     TAB
    ADD.W   #5, BYTE_COUNTER
    MOVE.B  #1, D6      * saving size for EA
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    JSR     MOVE_DEST_DN_RTS
    BRA     BUFFER_LOOP

LEA_MODE:
    MOVE.B  L, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  A, (A2)+
    JSR     TAB
    ADD.W   #4, BYTE_COUNTER
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    JSR     MOVE_DEST_AN_RTS
    BRA     BUFFER_LOOP

MULS:
    MOVE.B  M, (A2)+
    MOVE.B  U, (A2)+
    MOVE.B  L, (A2)+
    MOVE.B  S, (A2)+
    JSR         TAB
    ADD.W      #5, BYTE_COUNTER
    MOVE.B  #1, D6      * saving size for EA
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    JSR     MOVE_DEST_DN_RTS
    BRA     BUFFER_LOOP


SUB:
    MOVE.B  S, (A2)+
    MOVE.B  U, (A2)+
    MOVE.B  B, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #4, BYTE_COUNTER
    JSR     ADD_SIZE        *ADD_SIZE also works for SUB size
    MOVE.L  D3,D2
    ROL.W   #8,D2               * rotate left 8 bits to get the direction
    AND.B   #%00000001, D2      * bitmask to see direction
    CMP.B   #%00000000, D2
    BEQ     ADD_DEST_DN      * <EA>, DN -> DN
    BNE     ADD_DEST_EA      * DN, <EA> -> <EA>
    * will branch to buffer loop after one of two lines above

SUBQ:
    MOVE.B  S, (A2)+
    MOVE.B  U, (A2)+
    MOVE.B  B, (A2)+
    MOVE.B  Q, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #5, BYTE_COUNTER
    JSR     ADD_SIZE        *ADD_SIZE also works for SUBQ size
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.W   #7,D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2
    BEQ     POUND_8         * if zero, that means value is 8
    BNE     NORMAL_SUBQ
POUND_8:
    MOVE.W  #8, D2
NORMAL_SUBQ:
    ADD.B   #$30, D2
    MOVE.B  POUND, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  COMMA, (A2)+
    ADD.W   #3, BYTE_COUNTER
    JSR     EA_MAIN
    BRA     BUFFER_LOOP


ADD:
     MOVE.W  D3, D2      * reset address contents to before bitmask
     ROL.W   #8, D2     * now checking the destination mode set by rotating left by 10
     ROL.W   #2, D2
     AND.B   #%00000011, D2  * bitmask to see 2 bits for mode
     CMP.B   #%00000011, D2      * move Dn
     BEQ     ADDA
     BNE     ADD_NORMAL
     BRA     UNKNOWN

ADD_NORMAL:
    MOVE.B  A, (A2)+
    MOVE.B  D, (A2)+
    MOVE.B  D, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #4, BYTE_COUNTER
    JSR     ADD_SIZE
    MOVE.L  D3,D2
    ROL.W   #8,D2               * rotate left 8 bits to get the direction
    AND.B   #%00000001, D2      * bitmask to see direction
    CMP.B   #%00000000, D2
    BEQ     ADD_DEST_DN      * <EA>, DN -> DN
    BNE     ADD_DEST_EA      * DN, <EA> -> <EA>
    * will branch to buffer loop after one of two lines above

ADD_DEST_DN:
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    ADD.w   #1, BYTE_COUNTER
    JSR     MOVE_DEST_DN_RTS
    BRA     BUFFER_LOOP

ADD_DEST_EA:
    JSR    MOVE_DEST_DN_RTS
    MOVE.B  COMMA, (A2)+
    ADD.w   #1, BYTE_COUNTER
    JSR    EA_MAIN
    BRA    BUFFER_LOOP


ADDA:
    MOVE.B  A, (A2)+
    MOVE.B  D, (A2)+
    MOVE.B  D, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #5, BYTE_COUNTER
    MOVE.L  D3,D2
    ROL.W   #8,D2               * rotate left 8 bits to get the direction
    AND.B   #%00000001, D2      * bitmask to see direction
    CMP.B   #%00000000, D2      * 0 is word, 1 is long
    BEQ     ADDA_WORD
    BNE     ADDA_LONG
    * will branch to buffer loop after one of two lines above

ADDA_WORD:
    JSR     ADD_WORD
    MOVE.B  #1, D6          * saving size for EA
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    ADD.w   #1, BYTE_COUNTER
    JSR     MOVE_DEST_AN_RTS
    BRA     BUFFER_LOOP

ADDA_LONG:
    JSR     ADD_LONG
    MOVE.B  #2, D6          * saving size for EA
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    ADD.w   #1, BYTE_COUNTER
    JSR     MOVE_DEST_AN_RTS
    BRA     BUFFER_LOOP




ADD_SIZE:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #8,D2       * rotate to the left by 8 to see first 4 bits
    ROL.W   #2,D2       * rotate to the left by 2 to see first 4 bits
    AND.B   #%00000011, D2      * bitmask to check the first 4 bits for opcode type
    CMP.B   #%00000000, D2      * move.b
    BEQ     ADD_BYTE
    CMP.B   #%00000001, D2      * move.l
    BEQ     ADD_WORD
    CMP.B   #%00000010, D2      * move.w
    BEQ     ADD_LONG
    BRA     UNKNOWN

ADD_BYTE:
    MOVE.B  B, (A2)+
    MOVE.B  #0, D6      * saving size for EA
    JSR         TAB
    ADD.W      #1, BYTE_COUNTER
    RTS
    *BRA     BUFFER_LOOP

ADD_WORD:
    MOVE.B  W, (A2)+
    MOVE.B  #1, D6      * saving size for EA
    JSR         TAB
    ADD.W      #1, BYTE_COUNTER
    RTS
    *BRA     BUFFER_LOOP

ADD_LONG:
    MOVE.B  L, (A2)+
    MOVE.B  #2, D6      * saving size for EA
    JSR         TAB
    ADD.W      #1, BYTE_COUNTER
    RTS
    *BRA     BUFFER_LOOP


OP_RTS:
    MOVE.B  R, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  S, (A2)+
    JSR         TAB
    ADD.W   #3, BYTE_COUNTER
    BRA     BUFFER_LOOP

MOVE:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROR.W   #6, D2     * now checking the destination mode set by rotating left by 10
    AND.B   #%00000001, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2      * move Dn
    BEQ     MOVE_DN
    CMP.B   #%00000001, D2      * move An
    BGE     MOVE_AN
    BRA     UNKNOWN

*desination mode is register
MOVE_DN:
    MOVE.B  M, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #5, BYTE_COUNTER
    BRA MOVE_SIZE


MOVE_AN:
    MOVE.B  M, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #6, BYTE_COUNTER
    BRA MOVE_SIZE



MOVE_SIZE:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #4,D2       * rotate to the left by 4 to see first 4 bits
    AND.B   #%00001111, D2      * bitmask to check the first 4 bits for opcode type
    CMP.B   #%00000001, D2      * move.b
    BEQ     BYTE
    CMP.B   #%00000011, D2      * move.W
    BEQ     WORD
    CMP.B   #%00000010, D2      * move.L
    BEQ     LONG
    BRA     UNKNOWN


BYTE:
    MOVE.B  B, (A2)+
    JSR         TAB
    MOVE.B  #0, D6          *saving size for EA
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_SOURCE

WORD:
    MOVE.B  W, (A2)+
    JSR         TAB
    MOVE.B  #1, D6          *saving size for EA
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_SOURCE

LONG:
    MOVE.B  L, (A2)+
    JSR         TAB
    MOVE.B  #2, D6          *saving size for EA
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_SOURCE


MOVE_SOURCE:
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_DEST

MOVE_SOURCE_DN_RTS:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  D, (A2)+
    MOVE.B  D2, (A2)+
    ADD.W      #2, BYTE_COUNTER
    RTS


MOVE_DEST:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #8, D2      * rotate to the left by 4 to see first 4 bits
    ROL.W   #2, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2      * move.b
    BEQ     MOVE_DEST_DN
    CMP.B   #%00000001, D2
    BEQ     MOVE_DEST_AN
    CMP.B   #%00000010, D2
    BEQ     MOVE_DEST_AN_010
    CMP.B   #%00000011, D2
    BEQ     MOVE_DEST_AN_011
    CMP.B   #%00000100, D2
    BEQ     MOVE_DEST_AN_100
    BRA     UNKNOWN

MOVE_DEST_DN:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #7,D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  D, (A2)+
    MOVE.B  D2, (A2)+
    ADD.W   #2, BYTE_COUNTER
    BRA     BUFFER_LOOP

MOVE_DEST_DN_RTS:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #7,D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  D, (A2)+
    MOVE.B  D2, (A2)+
    ADD.W   #2, BYTE_COUNTER
    RTS

MOVE_DEST_AN:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #7, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    ADD.W   #2, BYTE_COUNTER
    BRA     BUFFER_LOOP

MOVE_DEST_AN_RTS:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #7, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    ADD.W   #2, BYTE_COUNTER
    RTS

MOVE_DEST_AN_010:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #7, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  OPEN_PARA, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  CLOSE_PARA, (A2)+
    ADD.W   #4, BYTE_COUNTER
    BRA     BUFFER_LOOP

MOVE_DEST_AN_011:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #7, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  OPEN_PARA, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  CLOSE_PARA, (A2)+
    MOVE.B  PLUS, (A2)+
    ADD.W   #5, BYTE_COUNTER
    BRA     BUFFER_LOOP

MOVE_DEST_AN_100:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #7, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  MINUS, (A2)+
    MOVE.B  OPEN_PARA, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  CLOSE_PARA, (A2)+
    ADD.W   #5, BYTE_COUNTER
    BRA     BUFFER_LOOP





* unkown op-code type
UNKNOWN:
    MOVE.B  D, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  A, (A2)+
    JSR     TAB
    MOVE.B  MONEY, (A2)+
    ADD.W      #5, BYTE_COUNTER
    MOVE.L  D3, D2      * moving clean copy of instruction into D2
    MOVE.B  #4, D5      * resrtarting HEX counter
    CLR.L   D6
    MOVE.L  D2, D6      * moving word instruction into D6
    SWAP  D6
    JSR     HEX_CHAR
    BRA     BUFFER_LOOP


BUFFER_LOOP:
    CMPA       A2,A3                * checking if start/end address match of string
    BEQ        PRINT_BUFFER         * finished if addresses match
    MOVE.B     (A3)+,(A1)+          * move byte letter from string_store to A1
    BRA        BUFFER_LOOP          * loop back untill start/end addresses match

PRINT_BUFFER:
    MOVE.B     #0, D0               * trap task 0 to print string in buffer A1
    LEA        BUFF_POINT,A1
    MOVE.W     BYTE_COUNTER, D1     * need to say how many bytes to print in D1
    TRAP #15
    JMP         NEXT_ADDRESS


HEX_CHAR:
    CMP.B   #8,D5   * D5 is counter, must loop 8 times for full LONG address
    BEQ     HEX_CHAR_DONE
    MOVE.L  D6,D7
    AND.L   #%11110000000000000000000000000000, D6
    ROL.L   #4,D6
    *ROR.L   #4,D6
    ADD.B   #1,D5
    CMP.L   #9, D6
    BLE     NUMBER
    BGE     LETTER
HEX_CHAR_DONE:
    RTS

NUMBER:
    ADD.L   #$30, D6
    MOVE.B  D6, (A2)+
    ADD.W      #1, BYTE_COUNTER
    ROL.L   #4,D7
    MOVE.L  D7,D6
    BRA     HEX_CHAR

LETTER:
    ADD.L   #$37, D6
    MOVE.B  D6, (A2)+
    ADD.W      #1, BYTE_COUNTER
    ROL.L   #4,D7
    MOVE.L  D7,D6
    BRA     HEX_CHAR

TAB:
    MOVE.B  SPACE, (A2)+
    MOVE.B  SPACE, (A2)+
    MOVE.B  SPACE, (A2)+
    MOVE.B  SPACE, (A2)+
    MOVE.B  SPACE, (A2)+
    ADD.W      #5, BYTE_COUNTER
    RTS



    SIMHALT             ; halt simulator


* Put variables and constants here
_0          DC.B '0',0
_1          DC.B '1',0
_2          DC.B '2',0
_3          DC.B '3',0
_4          DC.B '4',0
_5          DC.B '5',0
_6          DC.B '6',0
_7          DC.B '7',0
_8          DC.B '8',0
_9          DC.B '9',0
A           DC.B 'A',0
B           DC.B 'B',0
C           DC.B 'C',0
D           DC.B 'D',0
E           DC.B 'E',0
F           DC.B 'F',0
G           DC.B 'G',0
H           DC.B 'H',0
I           DC.B 'I',0
J           DC.B 'J',0
K           DC.B 'K',0
L           DC.B 'L',0
M           DC.B 'M',0
N           DC.B 'N',0
O           DC.B 'O',0
P           DC.B 'P',0
Q           DC.B 'Q',0
R           DC.B 'R',0
S           DC.B 'S',0
T           DC.B 'T',0
U           DC.B 'U',0
V           DC.B 'V',0
W           DC.B 'W',0
X           DC.B 'X',0
Y           DC.B 'Y',0
Z           DC.B 'Z',0
OPEN_PARA   DC.B '(',0
CLOSE_PARA  DC.B ')',0
DOT         DC.B '.',0
PLUS        DC.B '+',0
MINUS       DC.B '-',0
FINISHED    DC.L 'FINISHED',0
SPACE       DC.B ' ',0
QUESTION    DC.B '?',0
COMMA       DC.B ',',0
MONEY       DC.B '$',0
POUND       DC.B '#',0

    *END    START        ; last line of source
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
