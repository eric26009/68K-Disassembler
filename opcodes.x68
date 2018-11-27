*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  OP-CODE and string buffer
*-----------------------------------------------------------
    *ORG    $1000
    
BUFF_POINT      EQU     $2000   * where the string buffer lives
BYTE_COUNTER    EQU     0       * counter for the number of bytes the string has
STRING_STORE    EQU     $3000   * where the beginning of the temp string storage lives
TAB             EQU     $9      * ASCII hex for tab


*START:                  ; first instruction of program

OPCODE_BEGIN:
    LEA        BUFF_POINT,A1        * pointer to string buffer
    LEA        STRING_STORE, A2     * A2 stores the pointer to end of string
    LEA        STRING_STORE, A3     * A3 stores the pointer to start of string
    MOVE.W     #0, BYTE_COUNTER     * starting byte counter with 0  
    
    MOVE.B    #0, D5                * RESETTING HEX CONVERTER COUNTER
    MOVE.L  A4,D6
    MOVE.L  D6,D7
    MOVE.B     MONEY, (A2)+         * adding a MONEY SYMBOL to the beginning
    ADD.W      #1, BYTE_COUNTER
    BRA        HEX_CHAR
CONTINUE:
    MOVE.B     SPACE, (A2)+         * adding a space to the beginning
    ADD.W      #1, BYTE_COUNTER
    
*    MOVE.L   (A6),A5                     * LINE FOR TESTING
*    MOVE.B   #5,D4
*    MOVE.B   D4,D5

    
        
* work in progress, start of op-code debugging
FIRST4BITS:
    MOVE.L  (A4),D2    * moving long of address $1000 into D2
    MOVE.W  A4,D6   * ******temp holds the address, needs to be changed************
    MOVE.L  D2,D3       * save a copy of of contents in D3
    
    CMP.L   #$4E75FFFF, D2
    BEQ     OP_RTS
    
    MOVE.L  D3,D2
    ROL.L   #4,D2       * rotate to the left by 4 to see first 4 bits
    AND.B   #%00001111, D2      * bitmask to check the first 4 bits for opcode type
    
    MOVE.L  D3,D2
    CMP.B   #%00000001, D2      * move.b
    BEQ     MOVE
    CMP.B   #%00000011, D2      * move.l
    BEQ     MOVE
    CMP.B   #%00000010, D2      * move.w
    BEQ     MOVE
    CMP.B   #%00001101, D2      * ADD
    BEQ     ADD
    *CMP.B   #%00000000, D2      * somthing tbd
    *BEQ     _0000
    BRA UNKNOWN
    
ADD:

    
OP_RTS:
    MOVE.B  R, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  S, (A2)+
    ADD.W   #3, BYTE_COUNTER
    BRA     BUFFER_LOOP
        
MOVE:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.L   #8, D2     * now checking the destination mode set by rotating left by 10
    ROL.L   #2, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2      * move.b
    BEQ     MOVE_DN
    CMP.B   #%00000001, D2
    BEQ     MOVE_AN
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
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.L   #4,D2       * rotate to the left by 4 to see first 4 bits
    AND.B   #%00001111, D2      * bitmask to check the first 4 bits for opcode type
    CMP.B   #%00000001, D2      * move.b
    BEQ     BYTE
    CMP.B   #%00000011, D2      * move.l
    BEQ     WORD
    CMP.B   #%00000010, D2      * move.w
    BEQ     LONG

    
BYTE:
    MOVE.B  B, (A2)+
    MOVE.B  SPACE,(A2)+
    ADD.W      #2, BYTE_COUNTER
    BRA     MOVE_SOURCE

WORD:
    MOVE.B  W, (A2)+
    MOVE.B  SPACE, (A2)+
    ADD.W      #2, BYTE_COUNTER
    BRA     MOVE_SOURCE
    
LONG:
    MOVE.B  L, (A2)+
    MOVE.B  SPACE,(A2)+
    ADD.W      #2, BYTE_COUNTER
    BRA     MOVE_SOURCE
    
    
MOVE_SOURCE:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.L   #8, D2      * rotate to the left by 4 to see first 4 bits
    ROL.L   #5, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2      * move.b
    BEQ     MOVE_SOURCE_DN
    CMP.B   #%00000001, D2
    BEQ     MOVE_SOURCE_AN
    CMP.B   #%00000010, D2
    BEQ     MOVE_SOURCE_AN_010
  
    
MOVE_SOURCE_DN:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    SWAP    D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  D, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  COMMA, (A2)+  
    ADD.W      #3, BYTE_COUNTER
    BRA     MOVE_DEST
    
MOVE_SOURCE_AN:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    SWAP    D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for vale
    ADD.B   #$30, D2
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  COMMA, (A2)+  
    ADD.W      #3, BYTE_COUNTER
    BRA     MOVE_DEST
    
MOVE_SOURCE_AN_010:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    SWAP    D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for vale
    ADD.B   #$30, D2
    MOVE.B  OPEN_PARA, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    MOVE.B  CLOSE_PARA, (A2)+
    MOVE.B  COMMA, (A2)+  
    ADD.W      #5, BYTE_COUNTER
    BRA     MOVE_DEST

    
        
MOVE_DEST:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.L   #8, D2      * rotate to the left by 4 to see first 4 bits
    ROL.L   #2, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    CMP.B   #%00000000, D2      * move.b
    BEQ     MOVE_DEST_DN
    CMP.B   #%00000001, D2
    BEQ     MOVE_DEST_AN
    CMP.B   #%00000010, D2
    BEQ     MOVE_DEST_AN_010
    
MOVE_DEST_DN:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.L   #7,D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  D, (A2)+
    MOVE.B  D2, (A2)+
    ADD.W      #2, BYTE_COUNTER
    BRA     BUFFER_LOOP
    
MOVE_DEST_AN:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.L   #7, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    ADD.W      #2, BYTE_COUNTER
    BRA     BUFFER_LOOP
    
MOVE_DEST_AN_010:
    MOVE.L  D3, D2      * reset address contents to before bitmask
    ROL.L   #7, D2
    AND.B   #%00000111, D2  * bitmask to see 3 bits for mode
    ADD.B   #$30, D2
    MOVE.B  A, (A2)+
    MOVE.B  D2, (A2)+
    ADD.W      #2, BYTE_COUNTER
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
