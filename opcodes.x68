*-------------------------------------------------------------
* Description:  This is the opcodes file that wll decode all the
*               instructions, sizes, string buffer, hex conversion
*               It will also call the EA file for specific instructions
*-------------------------------------------------------------


OPCODE_BEGIN:
        LEA        BUFF_POINT,A1        * pointer to string buffer
        LEA        STRING_STORE, A2     * A2 stores the pointer to end of string
        LEA        STRING_STORE, A3     * A3 stores the pointer to start of string
        MOVE.W     #0, BYTE_COUNTER     * starting byte counter with 0

*-------Clearing all the data for every opcode to avoid mixing it------
        CLR.L       D0
        CLR.L       D1
        CLR.L       D2
        CLR.L       D3
        CLR.L       D4
        CLR.L       D5
        CLR.L       (A0)
        CLR.L       (A1)
        CLR.L       (A2)
        CLR.L       (A3)

        MOVE.B      #0, D5                * RESETTING HEX CONVERTER COUNTER
        MOVE.L      A4,D6                 * moving current address into D6
        MOVE.L      D6,D7                 * making a copy of D6 into D7
        MOVE.L      #$2, INCREMENT         * resetting the increment counter back to $2, EA may change it.
        MOVE.B      MONEY, (A2)+         * adding a MONEY SYMBOL to the beginning
        ADD.W       #1, BYTE_COUNTER      * increment byte counter
        JSR         HEX_CHAR
        JSR         TAB         * printing tab after HEX address is printed to screen



* op-code debugging
OPCODE_DECODE:
    MOVE.W  (A4),D2    * moving current word of memory instruction in address into D2
    MOVE.W  A4,D6      * D6 holds current address to HEX conversion
    MOVE.W  D2,D3       * save a copy of of contents in D3

    CMP.W   #$4E75, D2      * RTS code
    BEQ     OP_RTS

    CMP.W   #$4E71, D2      * NOP code
    BEQ     OP_NOP

    MOVE.L  D3,D2                   * this is reloading the orginial instruction
    AND.W   #%1111000111000000, D2  * LEA mode
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

    MOVE.L  D3,D2
    AND.W   #%1111000111000000, D2  * MULS mode
    CMP.W   #%1100000111000000, D2
    BEQ     MULS

    MOVE.L  D3,D2       * ORI mode
    ROL.W   #8,D2
    AND.B   #%11111111, D2
    CMP.B   #%00000000, D2
    BEQ     ORI


CONTINUE_DECODING:
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
*
* This next block of decoding will only only look at the first four
* bits of the opcode to determine which one it is.

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
    BRA     BUFFER_LOOP         * ready to print out the contents of buffer

BCC_CODES:
    MOVE.L  D3,D2               * reloading the orginial instruction
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
    BRA     UNKNOWN             * safe safe, if unkown print DATA

BCC:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  C, (A2)+
    MOVE.B  C, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH    * continue decoding the rest of the instruction
BCS:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  C, (A2)+
    MOVE.B  S, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH    * continue decoding the rest of the instruction
BGE:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  G, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH    * continue decoding the rest of the instruction
BLT:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  L, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH    * continue decoding the rest of the instruction
BVC:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  V, (A2)+
    MOVE.B  C, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH    * continue decoding the rest of the instruction
BEQ:
    MOVE.B  B, (A2)+            * appending letters
    MOVE.B  E, (A2)+
    MOVE.B  Q, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER    * increment byte counter
    BRA     BCC_CODES_FINISH    * continue decoding the rest of the instruction

BCC_CODES_FINISH:
    JSR     SIZE_BCC            * go get the size of BCC operation
    CMP.B   #0, D6              * if zero = byte size
    BEQ     BCC_BYTE
    CMP.B   #1, D6              * if one = word size
    BEQ     BCC_WORD
    BRA     UNKNOWN             * inc case it fails above compare

SIZE_BCC:
    MOVE.L  D3,D2
    AND.B   #%11111111, D2  * checking for BRA size 0 = word, 1 = long
    CMP.B   #%00000000, D2
    BEQ     ADD_WORD        * if one = word size
    BNE     ADD_BYTE        * if zero = byte size

BCC_BYTE:
    JSR     EA_Absolute_Byte     * go get absolute byte from EA
    BRA     BUFFER_LOOP             * ready to print

BCC_WORD:
    JSR     EA_Absolute_WORD     * go get absolute word from EA
    BRA     BUFFER_LOOP          * ready to print


ASD_REG:
    MOVE.B  A, (A2)+            * appending letters
    MOVE.B  S, (A2)+
    JSR     DIRECTION           * is it left or right
    JSR     ADD_SIZE            * get size
    JSR     COUNT_REG           * immediate or reg
    JSR     MOVE_SOURCE_DN_RTS  * gets register in the last 3 bits
    ADD.W   #2, BYTE_COUNTER    * increment byte counter
    BRA     BUFFER_LOOP         * ready to print

ASD_MEM:
    MOVE.B  A, (A2)+            * appending letters
    MOVE.B  S, (A2)+
    JSR     DIRECTION           * get direction
    MOVE.B  W, (A2)+             * always a WORD
    ADD.W   #3, BYTE_COUNTER    * increment byte counter
    MOVE.B  #1, D6              * saving size for EA
    JSR     TAB
    JSR     EA_MAIN             * go get EA value
    BRA     BUFFER_LOOP         * ready to print

LSD_REG:
    MOVE.B  L, (A2)+            * appending letters
    MOVE.B  S, (A2)+
    JSR     DIRECTION           * get direction
    JSR     ADD_SIZE            * get size
    JSR     COUNT_REG           * reg or immediate value
    ADD.W   #2, BYTE_COUNTER
    JSR     MOVE_SOURCE_DN_RTS      * gets register in the last 3 bits
    BRA     BUFFER_LOOP             * ready to print

LSD_MEM:
    MOVE.B  L, (A2)+                    * append letters
    MOVE.B  S, (A2)+
    JSR     DIRECTION                   * get directon left or right?
    MOVE.B  W, (A2)+                    * always a WORD size
    ADD.W   #3, BYTE_COUNTER
    MOVE.B  #1, D6                      * saving size for EA
    JSR     TAB
    JSR     EA_MAIN                     * go get EA value
    BRA     BUFFER_LOOP                 * ready to print

ROD_REG:
    MOVE.B  R, (A2)+                    * append letters
    MOVE.B  O, (A2)+
    JSR     DIRECTION                   * get directon
    JSR     ADD_SIZE                    * get size
    JSR     COUNT_REG                   * reg or immediate value?
    ADD.W   #2, BYTE_COUNTER
    JSR     MOVE_SOURCE_DN_RTS      * gets register in the last 3 bits
    BRA     BUFFER_LOOP             * ready to print

ROD_MEM:
    MOVE.B  R, (A2)+                * append letters
    MOVE.B  O, (A2)+
    JSR     DIRECTION               * get directon
    MOVE.B  W, (A2)+                * always a WORD size
    ADD.W   #3, BYTE_COUNTER
    MOVE.B  #1, D6              * setting size for EA
    JSR     TAB
    JSR     EA_MAIN             * go get EA value
    BRA     BUFFER_LOOP         * ready to print

COUNT_REG:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROR.W   #5,D2
    AND.B   #%00000001, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2  * this determines if its an immediate or regiser value
    BEQ     COUNT
    BNE     REG

COUNT:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.W   #7,D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2
    BEQ     ZERO_IS_EIGHT   * if all zeros that means it is a value of 8.
    BNE     NOT_EIGHT       * otherwise a value from 1-7
ZERO_IS_EIGHT:
    MOVE.W  #8, D2          * put 8
NOT_EIGHT:
    ADD.B   #$30, D2        * adding $30 to 0-9 number converts it to ASCII form
    MOVE.B  POUND, (A2)+
    MOVE.B  D2, (A2)+       * put number
    MOVE.B  COMMA, (A2)+
    ADD.W   #3, BYTE_COUNTER
    RTS

REG:
    JSR MOVE_DEST_DN_RTS        * reg mode, use opcode helper method for this
    MOVE.B  COMMA, (A2)+
    ADD.W   #1, BYTE_COUNTER
    RTS


DIRECTION:                  * this determines the direction of the operation
    MOVE.L  D3, D2
    ROL.W   #8, D2
    AND.B   #%00000001, D2
    CMP.B   #0, D2
    BEQ     RIGHT
    BNE     LEFT
    RTS

RIGHT:
    MOVE.B  R, (A2)+        * append R for right
    MOVE.B  DOT, (A2)+
    ADD.W   #2, BYTE_COUNTER
    RTS

LEFT:
    MOVE.B  L, (A2)+        * append L for left
    MOVE.B  DOT, (A2)+
    ADD.W   #2, BYTE_COUNTER
    RTS



BCLR_FROM_IMMEDIATE_DATA:       * BCLR from an immediate value
    MOVE.B  B, (A2)+
    MOVE.B  C, (A2)+
    MOVE.B  L, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    JSR     BCLR_SIZE           * go get BCLR size
    ADD.W   #6, BYTE_COUNTER
    JSR     Immediate_Word      * always a word size long
    MOVE.B  COMMA, (A2)+
    JSR     EA_MAIN                 * destination EA is normal
    BRA     BUFFER_LOOP             * ready to print


BCLR_FROM_DN:                   * BCLR from DN
    MOVE.B  B, (A2)+
    MOVE.B  C, (A2)+
    MOVE.B  L, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    JSR     BCLR_SIZE           * get size
    ADD.W   #6, BYTE_COUNTER
    JSR     MOVE_DEST_DN_RTS    * get source DN value
    MOVE.B  COMMA, (A2)+
    JSR     EA_MAIN             * go get EA value
    BRA     BUFFER_LOOP         * ready to print this value


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


JSR:                        * JSR opcode
    MOVE.B  J, (A2)+        * appending letters
    MOVE.B  S, (A2)+
    MOVE.B  R, (A2)+
    JSR     TAB
    ADD.W   #3, BYTE_COUNTER
    JSR    EA_MAIN          * call EA
    BRA     BUFFER_LOOP     * ready to print

BRA:                    * BRA opcode mode
    MOVE.B  B, (A2)+    * appending letters
    MOVE.B  R, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER
    JSR     BRA_SIZE        * get size with help of BRA size
    BRA     BUFFER_LOOP     * ready to print

BRA_SIZE:
    MOVE.L  D3,D2
    AND.B   #%11111111, D2  * checking for BRA size 0 = word, 1 = long
    CMP.B   #%00000000, D2
    BEQ     BRA_WORD
    BNE     BRA_BYTE


BRA_WORD:
    JSR     ADD_WORD        * helper method will add a word
    JSR     EA_Absolute_WORD    * call EA
    RTS


BRA_BYTE:
    JSR     ADD_BYTE         * helper method will add a byte
    JSR     EA_Absolute_Byte    *call EA
    RTS

CMPI:
    MOVE.B  C, (A2)+
    MOVE.B  M, (A2)+
    MOVE.B  P, (A2)+
    MOVE.B  I, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #6, BYTE_COUNTER
    JSR     ADD_SIZE            * calling size helper method
    JSR     EA_Immediate      * special EA
    MOVE.B  COMMA, (A2)+
    JSR    EA_MAIN              * calling EA for help
    BRA     BUFFER_LOOP          * ready to print

CMP:                        * CMP opcode mode
    MOVE.B  C, (A2)+
    MOVE.B  M, (A2)+
    MOVE.B  P, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #5, BYTE_COUNTER
    JSR     ADD_SIZE            * calling size helper method
    JSR     EA_MAIN             * calling EA for help
    MOVE.B  COMMA, (A2)+
    JSR     MOVE_DEST_DN        * calling destination helper for DN mode

EOR:                    * EOR mode
    MOVE.B  E, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    JSR     ADD_SIZE            * helper size method
    JSR     MOVE_DEST_DN_RTS    *actually grabbing the source here, but it lives in the same place as source for most
    MOVE.B  COMMA, (A2)+
    JSR     EA_MAIN             * calling EA for help
    ADD.W   #5, BYTE_COUNTER
    BRA     BUFFER_LOOP         * ready to print

MOVEM:                      * ****MOVEM opcode ** only opcode not complete****
    MOVE.B  M, (A2)+        * for now it will print MOVEM with the correct size
    MOVE.B  O, (A2)+        * it will then print <LIST, EA> or <EA, LIST>
    MOVE.B  V, (A2)+        * depending on the correct direction
    MOVE.B  E, (A2)+
    MOVE.B  M, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #6, BYTE_COUNTER
    JSR     MOVEM_SIZE
    MOVE.L  D3,D2
    AND.W   #%0000010000000000, D2  * checking for MOVEM direction
    CMP.W   #%0000000000000000, D2
    BEQ     MOVEM_TO_EA             * to EA
    BNE     MOVEM_FROM_EA           * from EA

MOVEM_TO_EA:
    MOVE.B  L, (A2)+            * direction is <LIST>, <EA>
    MOVE.B  I, (A2)+
    MOVE.B  S, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  COMMA, (A2)+
    ADD.W   #7, BYTE_COUNTER
    MOVE.B  E, (A2)+
    MOVE.B  A, (A2)+
    *JSR     EA_Absolute_WORD   ** EA is not complete for this **
    MOVE.L  #$4,INCREMENT
    BRA     BUFFER_LOOP         * ready to print

MOVEM_FROM_EA:
    *JSR     EA_Absolute_WORD   ** EA is not complete for this **
    MOVE.B  E, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  COMMA, (A2)+
    MOVE.B  L, (A2)+            * direction is <EA>, <LIST>
    MOVE.B  I, (A2)+
    MOVE.B  S, (A2)+
    MOVE.B  T, (A2)+
    ADD.W   #7, BYTE_COUNTER
    MOVE.L  #$4,INCREMENT
    BRA     BUFFER_LOOP         * ready to print

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
    RTS

MOVEM_LONG:
    JSR    ADD_LONG
    MOVE.B  #2, D6      * saving size for EA
    RTS

NEG:                    * NEG opcode mode
    MOVE.B  N, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  G, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER
    JSR     ADD_SIZE    * calling size helper method
    JSR     EA_MAIN     * calling EA for help
    BRA     BUFFER_LOOP * ready to print

ORI:                    * ORI opcode mode
    MOVE.B  O, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  I, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #5, BYTE_COUNTER
    JSR     ADD_SIZE     * get size helper
    JSR     EA_Immediate          * calling EA help for immediate
    MOVE.B  COMMA, (A2)+
    JSR     EA_MAIN      * calling EA for desination
    BRA     BUFFER_LOOP  * ready to print

OR:                      * OR opcode mode
    MOVE.B  O, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #3, BYTE_COUNTER
    JSR     ADD_SIZE    * calling size help
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
    BRA     BUFFER_LOOP         * ready to print



DIVS:                       * DIVS opcode mode
    MOVE.B  D, (A2)+
    MOVE.B  I, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  S, (A2)+
    JSR     TAB
    ADD.W   #5, BYTE_COUNTER
    MOVE.B  #1, D6      * saving size for EA
    JSR     EA_MAIN     * calling EA for source
    MOVE.B  COMMA, (A2)+
    JSR     MOVE_DEST_DN_RTS    * calling opcode destination helper
    BRA     BUFFER_LOOP         * ready to print

LEA_MODE:                       * opcode LEA mode
    MOVE.B  L, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  A, (A2)+
    JSR     TAB
    ADD.W   #4, BYTE_COUNTER
    JSR     EA_MAIN            * calling EA for help for destination
    MOVE.B  COMMA, (A2)+
    JSR     MOVE_DEST_AN_RTS   * calling opcode helper for desination
    BRA     BUFFER_LOOP         * ready to print this out

MULS:                           * MULS opcode mode
    MOVE.B  M, (A2)+
    MOVE.B  U, (A2)+
    MOVE.B  L, (A2)+
    MOVE.B  S, (A2)+
    JSR         TAB
    ADD.W      #5, BYTE_COUNTER
    MOVE.B  #1, D6      * saving size for EA
    JSR     EA_MAIN     * calling EA for source
    MOVE.B  COMMA, (A2)+
    JSR     MOVE_DEST_DN_RTS    * calling opcode helper for desination
    BRA     BUFFER_LOOP         * ready to print out


SUB:                        * SUB opcode mode
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
    ADD.B   #$30, D2        * adding $30 will convert to ASCII # value
    MOVE.B  POUND, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  COMMA, (A2)+
    ADD.W   #3, BYTE_COUNTER
    JSR     EA_MAIN         * calling EA for get destination
    BRA     BUFFER_LOOP     * ready to print this out


ADD:
     MOVE.W  D3, D2      * reset address contents to before bitmask
     ROL.W   #8, D2     * now checking the destination mode set by rotating left by 10
     ROL.W   #2, D2
     AND.B   #%00000011, D2  * bitmask to see 2 bits for mode
     CMP.B   #%00000011, D2      * move Dn
     BEQ     ADDA            * go to ADDA mode
     BNE     ADD_NORMAL      * go to normal ADD mode
     BRA     UNKNOWN

ADD_NORMAL:                 * normal ADD opcode mode
    MOVE.B  A, (A2)+
    MOVE.B  D, (A2)+
    MOVE.B  D, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #4, BYTE_COUNTER
    JSR     ADD_SIZE       * calling size helper
    MOVE.L  D3,D2
    ROL.W   #8,D2               * rotate left 8 bits to get the direction
    AND.B   #%00000001, D2      * bitmask to see direction
    CMP.B   #%00000000, D2
    BEQ     ADD_DEST_DN      * <EA>, DN -> DN
    BNE     ADD_DEST_EA      * DN, <EA> -> <EA>
    * will branch to buffer loop after one of two lines above

ADD_DEST_DN:            * <EA>, DN -> DN
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    ADD.w   #1, BYTE_COUNTER
    JSR     MOVE_DEST_DN_RTS
    BRA     BUFFER_LOOP

ADD_DEST_EA:            * DN, <EA> -> <EA>
    JSR    MOVE_DEST_DN_RTS
    MOVE.B  COMMA, (A2)+
    ADD.w   #1, BYTE_COUNTER
    JSR    EA_MAIN
    BRA    BUFFER_LOOP


ADDA:                   * ADDA opcode mode
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
    JSR     MOVE_DEST_AN_RTS    * call opcode destination helper
    BRA     BUFFER_LOOP

ADDA_LONG:
    JSR     ADD_LONG
    MOVE.B  #2, D6          * saving size for EA
    JSR     EA_MAIN
    MOVE.B  COMMA, (A2)+
    ADD.w   #1, BYTE_COUNTER
    JSR     MOVE_DEST_AN_RTS    * call opcode destination helper
    BRA     BUFFER_LOOP


* This block below for ADD_SIZE is reused for many opcodes to determine
* the correct size, RTS back to where it was called
*****
ADD_SIZE:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #8,D2       * rotate to the left by 8 to see first 4 bits
    ROL.W   #2,D2       * rotate to the left by 2 to see first 4 bits
    AND.B   #%00000011, D2      * bitmask to check the first 4 bits for opcode type
    CMP.B   #%00000000, D2      * byte size
    BEQ     ADD_BYTE
    CMP.B   #%00000001, D2      * long size
    BEQ     ADD_WORD
    CMP.B   #%00000010, D2      * word size
    BEQ     ADD_LONG
    BRA     UNKNOWN             * just in case does not equate to any above

ADD_BYTE:
    MOVE.B  B, (A2)+
    MOVE.B  #0, D6      * saving size for EA
    JSR         TAB
    ADD.W      #1, BYTE_COUNTER
    RTS

ADD_WORD:
    MOVE.B  W, (A2)+
    MOVE.B  #1, D6      * saving size for EA
    JSR         TAB
    ADD.W      #1, BYTE_COUNTER
    RTS

ADD_LONG:
    MOVE.B  L, (A2)+
    MOVE.B  #2, D6      * saving size for EA
    JSR         TAB
    ADD.W      #1, BYTE_COUNTER
    RTS


OP_RTS:                     * RTS opcode mode
    MOVE.B  R, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  S, (A2)+
    JSR         TAB
    ADD.W   #3, BYTE_COUNTER
    BRA     BUFFER_LOOP     * go print this out

MOVE:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROR.W   #6, D2     * now checking the destination mode set by rotating left by 10
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000001, D2      * move Dn
    BEQ     MOVE_AN
    BRA     MOVE_DN

*desination mode is register
MOVE_DN:
    MOVE.B  M, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #5, BYTE_COUNTER
    BRA MOVE_SIZE

*desination mode is address register
MOVE_AN:
    MOVE.B  M, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #6, BYTE_COUNTER
    BRA MOVE_SIZE


* gets size for MOVE opcode modes
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


BYTE:                   * Byte size
    MOVE.B  B, (A2)+
    JSR         TAB
    MOVE.B  #0, D6          *saving size for EA
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_SOURCE

WORD:                   * Word size
    MOVE.B  W, (A2)+
    JSR         TAB
    MOVE.B  #1, D6          *saving size for EA
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_SOURCE

LONG:                   * Long size
    MOVE.B  L, (A2)+
    JSR         TAB
    MOVE.B  #2, D6          *saving size for EA
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_SOURCE


MOVE_SOURCE:
    JSR     EA_MAIN         * call EA help for this source
    MOVE.B  COMMA, (A2)+
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_DEST       * branch to MOVE_DEST, to determine the source

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
    BEQ     MOVE_DEST_DN    * DN mode
    CMP.B   #%00000001, D2
    BEQ     MOVE_DEST_AN    * AN mode
    CMP.B   #%00000010, D2
    BEQ     MOVE_DEST_AN_010 * address indirect mode
    CMP.B   #%00000011, D2
    BEQ     MOVE_DEST_AN_011 * address indirect postincrement mode
    CMP.B   #%00000100, D2
    BEQ     MOVE_DEST_AN_100 * address indirect decrement mode
    BRA     UNKNOWN          * unknown otherwise

MOVE_DEST_DN:       * DN mode
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

MOVE_DEST_AN:           * AN mode
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

MOVE_DEST_AN_010:       * address indirect mode
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

MOVE_DEST_AN_011:       * address indirect postincrement mode
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

MOVE_DEST_AN_100:       * address indirect decrement mode
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
* will print address location followed by DATA, and then word of unknown
* instruction in HEX
UNKNOWN:
    MOVE.B  D, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  A, (A2)+
    JSR     TAB
    MOVE.B  MONEY, (A2)+
    ADD.W      #5, BYTE_COUNTER
    MOVE.L  D3, D2      * moving clean copy of instruction into D2
    MOVE.B  #4, D5      * restarting HEX counter, move 4 since we just need word
    CLR.L   D6          * cleaning up D6
    MOVE.L  D2, D6      * moving word instruction into D6
    SWAP  D6            * swap low and high bits of D6 to see the word
    JSR     HEX_CHAR    * convert unknown instruction to ASCII, stored in D6
    BRA     BUFFER_LOOP


BUFFER_LOOP:
    CMPA       A2,A3                * checking if start/end address match of string
    BEQ        PRINT_BUFFER         * finished if addresses match
    MOVE.B     (A3)+,(A1)+          * move byte letter from string_store to A1
    BRA        BUFFER_LOOP          * loop back untill start/end addresses match

PRINT_BUFFER:
    MOVE.B     #0, D0               * trap task 0 to print string in buffer A1
    LEA        BUFF_POINT,A1        * load up A1 with the contents of the buffer
    MOVE.W     BYTE_COUNTER, D1     * need to say how many bytes to print in D1
    TRAP #15
    JMP         NEXT_ADDRESS        * continue running the program


HEX_CHAR:
    CMP.B   #8,D5   * D5 is counter, must loop 8 times for full LONG address
    BEQ     HEX_CHAR_DONE       * if equal to 8 then done.
    MOVE.L  D6,D7                * save a copy in D7 of the HEX address
    AND.L   #%11110000000000000000000000000000, D6   * just look at the first four bits
    ROL.L   #4,D6
    ADD.B   #1,D5   * increment the counter by one for HEX convert count
    CMP.L   #9, D6  * figuring out if its a number or letter
    BLE     NUMBER  * if its less then or equal to  9 -> number
    BGE     LETTER  * if its greater than 9 -> letter
HEX_CHAR_DONE:      * When done converting, go back to where it was called
    RTS

NUMBER:                 * this converts number value to ASCII number value
    ADD.L   #$30, D6    * just add $30 to get number
    MOVE.B  D6, (A2)+   * adding number to string buffer
    ADD.W      #1, BYTE_COUNTER
    ROL.L   #4,D7
    MOVE.L  D7,D6
    BRA     HEX_CHAR    * continue decoding HEX address

LETTER:                  * this converts number value to ASCII letter value
    ADD.L   #$37, D6    * just add $37 to get letter
    MOVE.B  D6, (A2)+   * adding letter to string buffer
    ADD.W      #1, BYTE_COUNTER
    ROL.L   #4,D7
    MOVE.L  D7,D6
    BRA     HEX_CHAR     * continue decoding HEX address

TAB:                        * this is a helper method to add a tab
    MOVE.B  SPACE, (A2)+    * (5 spaces)
    MOVE.B  SPACE, (A2)+
    MOVE.B  SPACE, (A2)+
    MOVE.B  SPACE, (A2)+
    MOVE.B  SPACE, (A2)+
    ADD.W      #5, BYTE_COUNTER
    RTS


    ************************************************************************
    **                  opcode decoding finished                          **


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
