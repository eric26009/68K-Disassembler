*-----------------------------------------------------------
* Title      : 68k Disassembler (Inverse Assembler)
* Written by : Zealous Zhu and Eric Feldman
* Date       : 11/21/18
* Description: This disassembler program takes the assembly language that was assembled
*              and decode them so that a user can understand.
*               This is the main file that will call all the other files to function
*-----------------------------------------------------------
    ORG    $1000

INCREMENT       EQU     $3000   *Increment is the memory address that will be incremented
LINE_COUNTER    EQU     $3020
BUFF_POINT      EQU     $3250   * where the string buffer lives
BYTE_COUNTER    EQU     $3040   * counter for the number of bytes the string has
STRING_STORE    EQU     $3500   * where the beginning of the temp string storage lives


START:
*---This is the start of the program by calling the IO for user input-----
    JSR     START_IO
*---Clears everything, setting all data regiser to 0----------------------
    CLR.L   D0
    CLR.L   D1
    CLR.L   D2
    CLR.L   D3
    CLR.L   D4
    CLR.L   D5
*---Clears everything, setting all to 0 for address regiser---------------
*---Except starting/ending address----------------------------------------
    MOVEA.L #$00000000,A0
    MOVEA.L #$00000000,A1
    MOVEA.L #$00000000,A2
    MOVEA.L #$00000000,A3
    MOVEA.L #$00000000,A6

    MOVE.L  #$2, INCREMENT
    LEA     LINE_COUNTER, A6         * load ing end address into A5
    MOVE.L  #0, (A6)                 * initalize the line counter to 0

*--------------Loading and the start of decoding-------------------------
MAIN:
    CMP.L   A5,A4                   * comparing start/end addresses
    BGE.L   COMPLETED               * greater than or equal means done
    CMP.L   #31, (A6)
    BEQ     PAUSE
    CMP.L   A4,A5
    BNE     OPCODE_BEGIN            * not done yet, so fetch next opcode

*------------This is the buffer---------------------------------------
PAUSE:
    MOVE.L  #$0, INCREMENT          * fixes the next line to increment correctly
    MOVE.B  #5, D0
    TRAP    #15
    MOVE.L  #0, (A6)
    BRA     NEXT_ADDRESS

*------------This keeps track and increments the next address location-------
NEXT_ADDRESS:
    ADD.L   INCREMENT, A4           * incrementing address here by INCREMNET amount, needs to be changed
    ADD.L   #1, (A6)                * adding 1 to the line counter
    BRA     MAIN                    * go back to check addresses in MAIN

*------------Once we reach the end of decoding, finished messaage------------
COMPLETED:
    LEA FINISHED, A1                * load finished message
    MOVE.B  #13, D0                 * displaying message
    TRAP #15

*---This is the variables and constant table that will be used for opcodes and EA---
*-----------Number 0-9--------------------------------------------------------------
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
*-----------Alphabet A-Z--------------------------------------------------------------
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
*-----------Symbols for EA--------------------------------------------------------------
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


*---Included files so this file can utilize them--------------
    INCLUDE "opcodes.x68"
    INCLUDE "EA.x68"
    INCLUDE "IO.x68"
    INCLUDE "demo_test.x68"


    END    START        ; last line of source











































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
