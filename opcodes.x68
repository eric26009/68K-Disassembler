*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:  OP-CODE and string buffer
*-----------------------------------------------------------
    ORG    $1000
    
BUFF_POINT      EQU     $2000   * where the string buffer lives
BYTE_COUNTER    EQU     0       * counter for the number of bytes the string has
STRING_STORE    EQU     $3000   * where the beginning of the temp string storage lives


START:                  ; first instruction of program

* Put program code here
    MOVE.B     #0, D0               * trap task 0 to print string in buffer A1
    LEA        BUFF_POINT,A1        * pointer to string buffer
    LEA        STRING_STORE, A2     * A2 stores the pointer to end of string
    LEA        STRING_STORE, A3     * A3 stores the pointer to start of string
    MOVE.W     #0, BYTE_COUNTER     * starting byte counter with 0    
    
    MOVE.B   D1,D7                   * LINE FOR TESTING
     
    MOVE.B     I,(A2)+              * testing adding letters to string_store         
    MOVE.B     S,(A2)+              * .. same as above
    MOVE.B     SPACE,(A2)+
    MOVE.B     T,(A2)+
    MOVE.B     H,(A2)+
    MOVE.B     I,(A2)+
    MOVE.B     S,(A2)+
    MOVE.B     SPACE,(A2)+
    MOVE.B     W,(A2)+
    MOVE.B     O,(A2)+
    MOVE.B     R,(A2)+
    MOVE.B     K,(A2)+
    MOVE.B     I,(A2)+
    MOVE.B     N,(A2)+
    MOVE.B     G,(A2)+
    MOVE.B     QUESTION,(A2)+
    MOVE.B     #$A,(A2)+            * new line
    MOVE.B     #$D,(A2)+            * carriage return
    ADD.W      #18, BYTE_COUNTER    * need to say how many bytes are in the string.
    
        
* work in progress, start of op-code debugging
FIRST4BITS:
    MOVE.L  $1016,D2    * moving long of address $1000 into D2
    MOVE.L  D2,D3       * save a copy of of contents in D3
    ROL.W   #4,D2
    
    AND.B   #%00001111, D2      * bitmask to check the first 4 bits for opcode type
    
    
    CMP.B   #%00000001, D2      * move.b
    BEQ     _0001
    CMP.B   #%00000011, D2      * move.l
    BEQ     _0011
    CMP.B   #%00000010, D2      * move.w
    BEQ     _0010
    CMP.B   #%00000000, D2      * somthing tbd
    BEQ     _0000
    
    
*move.b 
_0001:
    MOVE.B  M, (A2)+
    MOVE.B  O, (A2)+
    MOVE.B  V, (A2)+
    MOVE.B  E, (A2)+
    MOVE.B  DOT, (A2)+
    MOVE.B  B, (A2)+
    MOVE.B  #$9, (A2)+          * TAB 
    ADD.W      #7, BYTE_COUNTER
    
    
* move.l
_0011:

*move.w
_0010:

* something that begins with 0000
_0000:


* unkown op-code type
_UNKNOWN:
    MOVE.B  D, (A2)+
    MOVE.B  A, (A2)+
    MOVE.B  T, (A2)+
    MOVE.B  A, (A2)+
    ADD.W      #4, BYTE_COUNTER


BUFFER_LOOP:
    CMPA       A2,A3                * checking if start/end address match of string
    BEQ        PRINT_BUFFER         * finished if addresses match
    MOVE.B     (A3)+,(A1)+          * move byte letter from string_store to A1
    BRA        BUFFER_LOOP               * loop back untill start/end addresses match

PRINT_BUFFER:
    LEA        BUFF_POINT,A1    
    MOVE.W     BYTE_COUNTER, D1
    TRAP #15



   
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
FINISHED    DC.B 'FINISHED',0
SPACE       DC.B ' ',0
QUESTION    DC.B '?',0



    END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
