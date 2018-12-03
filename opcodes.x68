*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  OP-CODE and string buffer
*-----------------------------------------------------------
    *ORG    $1000

BUFF_POINT      EQU     $3000   * where the string buffer lives
BYTE_COUNTER    EQU     0       * counter for the number of bytes the string has
STRING_STORE    EQU     $4000   * where the beginning of the temp string storage lives


*START:                  ; first instruction of program

OPCODE_BEGIN:
    LEA        BUFF_POINT,A1        * pointer to string buffer
    LEA        STRING_STORE, A2     * A2 stores the pointer to end of string
    LEA        STRING_STORE, A3     * A3 stores the pointer to start of string
    MOVE.W     #0, BYTE_COUNTER     * starting byte counter with 0

    MOVE.B      #0, D5                * RESETTING HEX CONVERTER COUNTER
    MOVE.L      A4,D6
    MOVE.L      D6,D7
    MOVE.B      MONEY, (A2)+         * adding a MONEY SYMBOL to the beginning
    ADD.W       #1, BYTE_COUNTER
    BRA         HEX_CHAR

CONTINUE:
    JSR         TAB



* work in progress, start of op-code debugging
FIRST4BITS:
    MOVE.W  (A4),D2    * moving long of address $1000 into D2
    MOVE.W  A4,D6   * ******temp holds the address, needs to be changed************
    MOVE.W  D2,D3       * save a copy of of contents in D3

    CMP.L   #$4E75FFFF, D2
    BEQ     OP_RTS

    MOVE.L  D3,D2                   * checking for LEA mode
    AND.W   #%1111000111000000, D2
    CMP.W   #%0100000111000000, D2
    BEQ     LEA_MODE

    MOVE.L  D3,D2
    AND.W   #%1111000111000000, D2  * checking for DIVS mode
    CMP.W   #%1000000111000000, D2
    BEQ     DIVS

    MOVE.L  D3,D2
    AND.W   #%1111101110000000, D2  * checking for MOVEM mode
    CMP.W   #%0100100010000000, D2
    BEQ     MOVEM

    MOVE.L  D3,D2
    ROL.W   #8,D2
    AND.B   #%11111111, D2  * checking for ORI mode
    CMP.B   #%00000000, D2
    BEQ     ORI

    MOVE.L  D3,D2
    ROL.W   #8,D2
    AND.B   #%11110001, D2  * checking for EOR mode
    CMP.B   #%10110001, D2
    BEQ     EOR

    MOVE.L  D3,D2
    ROL.W   #8,D2
    AND.B   #%11111111, D2  * checking for NEG mode
    CMP.B   #%01000100, D2
    BEQ     NEG

    MOVE.L  D3,D2
    ROL.W   #8,D2
    AND.B   #%11110001, D2  * checking for CMP mode
    CMP.B   #%10110000, D2
    BEQ     CMP

    MOVE.L  D3,D2
    ROL.W   #8,D2
    AND.B   #%11111111, D2  * checking for CMPI mode
    CMP.B   #%00001100, D2
    BEQ     CMPI

    MOVE.L  D3,D2
    ROL.W   #8,D2
    AND.B   #%11111111, D2  * checking for BRA mode
    CMP.B   #%01100000, D2
    BEQ     BRA

    MOVE.L  D3,D2
    AND.W   #%1111111111000000, D2  * checking for JSR mode
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
    BRA UNKNOWN                 * if unknown opcode, print 'DATA' out

JSR:
    MOVE.B  J, (A2)+
    MOVE.B  S, (A2)+
    MOVE.B  R, (A2)+
    JSR     TAB
    ADD.W   #3, BYTE_COUNTER
    *JSR    EA_MAIN
    BRA     BUFFER_LOOP

BRA:
    MOVE.B  B, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER
    BRA     BRA_SIZE

BRA_SIZE:
    MOVE.L  D3,D2
    AND.B   #%00000000, D2  * checking for BRA size 0 = word, 1 = long
    CMP.B   #%00000000, D2
    BEQ     BRA_WORD
    BNE     BRA_LONG

BRA_WORD:
    JSR     ADD_WORD
    JSR     TAB
    *JSR    EA_MAIN     *for 16 bit displacemnt
    BRA     BUFFER_LOOP

BRA_LONG:
    JSR     ADD_LONG
    JSR     TAB
    *JSR    EA_MAIN     *for 32 bit displacemnt
    BRA     BUFFER_LOOP

CMPI:
    MOVE.B  C, (A2)+
    MOVE.B  M, (A2)+
    MOVE.B  P, (A2)+
    MOVE.B  I, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #5, BYTE_COUNTER
    JSR     ADD_SIZE
    *JSR    EA_MAIN
    *JSR    EA for special EA
    BRA     BUFFER_LOOP

CMP:
    MOVE.B  C, (A2)+
    MOVE.B  M, (A2)+
    MOVE.B  P, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER
    JSR     ADD_SIZE
    *JSR    EA_MAIN
    JSR     MOVE_DEST_DN

EOR:
    MOVE.B  E, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER
    JSR     ADD_SIZE
    JSR     MOVE_DEST_DN_RTS    *actually grabbing the source here, but it lives in the same place as source for most
    *JSR    EA_MAIN
    BRA     BUFFER_LOOP

MOVEM:
    MOVE.B  M, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  M, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #6, BYTE_COUNTER
    BRA     MOVEM_SIZE

MOVEM_SIZE:
    MOVE.L  D3,D2
    ROR.W   #6,D2
    AND.B   #%00000001, D2  * checking for MOVEM size 0 = word, 1 = long
    CMP.B   #%00000000, D2
    BEQ     MOVEM_WORD
    BNE     MOVEM_LONG

MOVEM_WORD:
    JSR     ADD_WORD
    JSR     TAB
    *JSR    EA_MAIN
    BRA     BUFFER_LOOP

MOVEM_LONG:
    JSR     ADD_LONG
    JSR     TAB
    *JSR    EA_MAIN
    BRA     BUFFER_LOOP



NEG:
    MOVE.B  N, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  G, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER
    JSR     ADD_SIZE
    JSR     TAB
    *JSR    EA_MAIN
    BRA     BUFFER_LOOP

ORI:
    MOVE.B  O, (A2)+
    MOVE.B  R, (A2)+
    MOVE.B  I, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W   #4, BYTE_COUNTER
    JSR     ADD_SIZE
    JSR     TAB
    *MOVE.L  #$4, INCREMENT     * this line needs to be implemented in EA to know by how much to increment
    *JSR    EA_MAIN
    BRA     BUFFER_LOOP

OR:
    MOVE.B  O, (A2)+
    MOVE.B  R, (A2)+
    ADD.W   #2, BYTE_COUNTER
    JSR     TAB
    MOVE.L  D3,D2
    ROL.W   #8,D2               * rotate left 8 bits to get the direction
    AND.B   #%00000001, D2      * bitmask to see direction
    CMP.B   #%00000000, D2
    BEQ     OR_DEST_DN
    BNE     OR_DEST_EA
OR_DEST_DN:                     * <EA> OR DN direction
    *JSR    EA_MAIN
    JSR     MOVE_DEST_DN_RTS
    BRA     BUFFER_LOOP

OR_DEST_EA:                      * DN OR <EA> direction
    JSR     MOVE_DEST_DN_RTS
    *JSR    EA_MAIN
    BRA     BUFFER_LOOP



DIVS:
    MOVE.B  D, (A2)+
    MOVE.B  I, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  S, (A2)+
    JSR     TAB
    ADD.W   #4, BYTE_COUNTER
    *JSR    EA_MAIN
    BRA     MOVE_DEST_DN

LEA_MODE:
    MOVE.B  L, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  A, (A2)+
    JSR     TAB
    ADD.W   #3, BYTE_COUNTER
    *JSR     GET_EA
    BRA     MOVE_DEST_AN_010

MULS:
    MOVE.B  M, (A2)+
    MOVE.B  U, (A2)+
    MOVE.B  L, (A2)+
    MOVE.B  S, (A2)+
    JSR         TAB
    ADD.W      #4, BYTE_COUNTER
    *JSR     EA_MAIN
    BRA     MOVE_DEST_DN


SUB:
    MOVE.B  S, (A2)+
    MOVE.B  U, (A2)+
    MOVE.B  B, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #4, BYTE_COUNTER
    BRA     ADD_SIZE        *ADD_SIZE also works for SUB size

ADD:
     MOVE.W  D3, D2      * reset address contents to before bitmask
     ROL.W   #8, D2     * now checking the destination mode set by rotating left by 10
     ROL.W   #2, D2
     AND.B   #%00000011, D2  * bitmask to see 3 bits for mode
     CMP.B   #%00000011, D2      * move Dn
     BEQ     ADDA
     BNE     ADD_NORAML
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

ADD_DEST_DN:
    *JSR    MAIN_EA
    JSR     MOVE_DEST_DN_RTS
    BRA     BUFF_LOOP

ADD_DEST_DN:
    JSR     MOVE_DEST_DN_RTS
    *JSR    MAIN_EA
    BRA     BUFF_LOOP


ADDA:
    MOVE.B  A, (A2)+
    MOVE.B  D, (A2)+
    MOVE.B  D, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  DOT, (A2)+
    ADD.W      #5, BYTE_COUNTER
    JSR     ADD_SIZE
    * get EA and more work here..
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

ADD_BYTE:
    MOVE.B  B, (A2)+
    JSR         TAB
    ADD.W      #1, BYTE_COUNTER
    RTS
    *BRA     BUFFER_LOOP

ADD_WORD:
    MOVE.B  W, (A2)+
    JSR         TAB
    ADD.W      #1, BYTE_COUNTER
    RTS
    *BRA     BUFFER_LOOP

ADD_LONG:
    MOVE.B  L, (A2)+
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
    ROL.W   #8, D2     * now checking the destination mode set by rotating left by 10
    ROL.W   #2, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
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


BYTE:
    MOVE.B  B, (A2)+
    JSR         TAB
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_SOURCE

WORD:
    MOVE.B  W, (A2)+
    JSR         TAB
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_SOURCE

LONG:
    MOVE.B  L, (A2)+
    JSR         TAB
    ADD.W   #1, BYTE_COUNTER
    BRA     MOVE_SOURCE


MOVE_SOURCE:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    ROL.W   #8, D2      * rotate to the left by 4 to see first 4 bits
    ROL.W   #5, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2      * move.b
    BEQ     MOVE_SOURCE_DN
    CMP.B   #%00000001, D2
    BEQ     MOVE_SOURCE_AN
    CMP.B   #%00000010, D2
    BEQ     MOVE_SOURCE_AN_010
    CMP.B   #%00000011, D2
    BEQ     MOVE_SOURCE_AN_011


MOVE_SOURCE_DN:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  D, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  COMMA, (A2)+
    ADD.W      #3, BYTE_COUNTER
    BRA     MOVE_DEST

MOVE_SOURCE_AN:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    AND.B   #%00000111, D2  * bitmask to see 3 bits for vale
    ADD.B   #$30, D2
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  COMMA, (A2)+
    ADD.W      #3, BYTE_COUNTER
    BRA     MOVE_DEST

MOVE_SOURCE_AN_010:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    AND.B   #%00000111, D2  * bitmask to see 3 bits for vale
    ADD.B   #$30, D2
    MOVE.B  OPEN_PARA, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  CLOSE_PARA, (A2)+
    MOVE.B  COMMA, (A2)+
    ADD.W      #5, BYTE_COUNTER
    BRA     MOVE_DEST

MOVE_SOURCE_AN_011:
    MOVE.W  D3, D2      * reset address contents to before bitmask
    AND.B   #%00000111, D2  * bitmask to see 3 bits for vale
    ADD.B   #$30, D2
    MOVE.B  OPEN_PARA, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  CLOSE_PARA, (A2)+
    MOVE.B  PLUS, (A2)+
    MOVE.B  COMMA, (A2)+
    ADD.W      #6, BYTE_COUNTER
    BRA     MOVE_DEST



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





* unkown op-code type
UNKNOWN:
    MOVE.B  D, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  A, (A2)+
    ADD.W      #4, BYTE_COUNTER


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

    JMP     NEXT_ADDRESS

TEST:
    JSR TEST2

TEST2:
    RTS

HEX_CHAR:
    CMP.B   #4,D5
    BEQ     CONTINUE
    MOVE.L  D6,D7
    AND.W   #%1111000000000000, D6
    ROR.W   #8,D6
    ROR.W   #4,D6
    ADD.B   #1,D5
    CMP.L   #9, D6
    BLE     NUMBER
    BGE     LETTER

NUMBER:
    ADD.B   #$30, D6
    MOVE.B  D6, (A2)+
    ADD.W      #1, BYTE_COUNTER
    ROL.W   #4,D7
    MOVE.L  D7,D6
    BRA     HEX_CHAR

LETTER:
    ADD.B   #$37, D6
    MOVE.B  D6, (A2)+
    ADD.W      #1, BYTE_COUNTER
    ROL.W   #4,D7
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

    *END    START        ; last line of source




















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
