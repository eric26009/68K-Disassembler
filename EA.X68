*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description: This file takes in the instructions from op-code,
* and divide them into the last 6 bits for EA. Then break them down
* further into modes and register that will be used for specifying the
* different addressing mode
*-----------------------------------------------------------

*------------------EA-Codes----------------------------------------
*
*                 EA mode store in D4 and EA register stored in D5
*                ---EA MODES---
*                   0)Dn
*                   1)An
*                   2)(An)
*                   3)(An)+
*                   4)-(An)
*                   5)absolute word, long and immediate
*
*------------------------------------------------------------------

*Check for valid and convert frmo ASCII to HEX
EA_COUNT    EQU     $200

EA_MAIN
                    MOVE.L      D3,D4               *Takes in the 16 bit instruction from D3
                    AND.B       #%00111111,D4       * Take the last 6 bit by doing a bit mask
                    MOVE.B      D4,D5               * Copy the last 6 bits into D5 also
                    AND.B       #%00000111,D5       *Take the last 3 bits into Register in D5
                    AND.B       #%00111000,D4       *Take the first 3 bits into Mode in D4
                    ROR.B       #3,D4               *Rotate to correct position

                    *TODOS:
                    *Case to handle Absolute/Immediate at D7
                    *Special Cases to handle MOVEM and COMPI, MOVE
                    *D6 will be the register to store the size for immediate
                    *0 is a byte
                    *1 is a word
                    *2 is a long

                    CMPI.B      #0,D4
                    BEQ         EA_Dn

                    CMPI.B      #1,D4
                    BEQ         EA_An

                    CMPI.B      #2,D4
                    BEQ         EA_An_Indirect

                    CMPI.B      #3,D4
                    BEQ         EA_An_Plus

                    CMPI.B      #4,D4
                    BEQ         EA_An_Minus

                    CMPI.B      #7,D4
                    BEQ         EA_Absolute_Immediate

                    RTS

* This is the EA data register, D5 stores register number : Dn
EA_Dn
                    CLR.L       D1
                    MOVE.B      D5, D1
                    *-------------------------- Prints Dn
                    MOVE.B      D,(A2)+

                    JSR         Show_Number
                    MOVE.B      D1,(A2)+
                    *--------------------------
                    ADD.W       #2,BYTE_COUNTER

                    MOVE.L      #$2,INCREMENT
                    RTS

* This is the EA address register, D5 stores the register number :An
EA_An

                    CLR.L       D1
                    MOVE.B      D5, D1
                    *-------------------------- Prints An
                    MOVE.B      A,(A2)+

                    JSR         Show_Number
                    MOVE.B      D1,(A2)+
                    *--------------------------
                    ADD.W       #2,BYTE_COUNTER

                    MOVE.L      #$2,INCREMENT
                    RTS

*This is the EA address indirect :(An)
EA_An_Indirect
                    CLR.L       D1
                    MOVE.B      D5,D1
                    *-------------------------- Prints (An)
                    MOVE.B      OPEN_PARA,(A2)+
                    MOVE.B      A,(A2)+

                    JSR         Show_Number
                    MOVE.B      D1,(A2)+

                    MOVE.B      CLOSE_PARA,(A2)+
                    *--------------------------
                    ADD.W       #4,BYTE_COUNTER

                    MOVE.L      #$2,INCREMENT
                    RTS
*This is the EA address indirect with post increment (A0)+
EA_An_Plus
                    CLR.L       D1
                    MOVE.B      D5, D1
                    *-------------------------- Prints (A0)+
                    MOVE.B      OPEN_PARA,(A2)+
                    MOVE.B      A,(A2)+

                    JSR         Show_Number
                    MOVE.B      D1,(A2)+

                    MOVE.B      CLOSE_PARA,(A2)+
                    MOVE.B      PLUS,(A2)+
                    *--------------------------
                    ADD.W       #5,BYTE_COUNTER

                    MOVE.L      #$2,INCREMENT
                    RTS
*This is the EA address indirect with pre decrement -(SP)
EA_An_Minus
                    CLR.L       D1
                    MOVE.B      D5, D1
                    *-------------------------- Prints -(SP)
                    MOVE.B      MINUS,(A2)+
                    MOVE.B      OPEN_PARA,(A2)+
                    MOVE.B      A,(A2)+

                    JSR         Show_Number
                    MOVE.B      D1,(A2)+

                    MOVE.B      CLOSE_PARA,(A2)+
                    *--------------------------
                    ADD.W       #5,BYTE_COUNTER

                    MOVE.L      #$2,INCREMENT
                    RTS
*This will handle the EA absolute addressing and immediate data
EA_Absolute_Immediate
                    CMPI.B      #0,D5
                    BEQ         EA_Absolute_WORD

                    CMPI.B      #1,D5
                    BEQ         EA_Absolute_LONG

                    CMPI.B      #4,D5
                    BEQ         EA_Immediate

*This is the EA for absolute addressing WORD
EA_Absolute_WORD
                    MOVE.B      MONEY,(A2)+
                    ADD.W       #1,BYTE_COUNTER

                    CLR.L       D2                      *clear D2 to show next word data
                    MOVE.W      (A4)+,D2                *Add value to stack and Increment pointer
                    MOVE.W      (A4),D2
                    JSR         Show_FFFF

                    ; CLR.L       EA_COUNT
                    MOVE.B      #4, EA_COUNT                *hardcoded counter in $400 (4 hex values for word)
                    JSR         Display_Address
                    ADD.W       #4,BYTE_COUNTER

                    MOVE.L      #$4,INCREMENT
                    RTS

*This is the EA for absolute addressing LONG
EA_Absolute_LONG
                    MOVE.B      MONEY,(A2)+
                    ADD.W       #1,BYTE_COUNTER

                    CLR.L        D2
                    MOVE.W      (A4)+,D2
                    MOVE.L      (A4),D2
                    MOVE.B      #8,EA_COUNT                 *hardcoded counter in $400 (8 hex values for long)
                    JSR         Display_Address_Long
                    ADD.W       #8,BYTE_COUNTER

                    MOVE.L      #$6,INCREMENT
                    RTS

*This is the EA for Immediate
EA_Immediate
                    MOVE.B      POUND,(A2)+     *displays the # sign
                    MOVE.B      MONEY,(A2)+     *displays the $ sign
                    ADD.W       #2,BYTE_COUNTER

                    JSR         Immediate_Size


                    RTS

Immediate_Size
                    CMPI.B      #2,D6
                    BEQ         Immediate_Long

                    CLR.L       D2                      *clear D2 to show next word data
                    MOVE.W      (A4)+,D2                *Add value to stack and Increment pointer
                    MOVE.W      (A4),D2
                    MOVE.B      #4,EA_COUNT
                    MOVE.L      #$4,INCREMENT
                    ADD.W       #4,BYTE_COUNTER
                    JSR         Display_Address

                    RTS

Immediate_Long
                    CLR.L        D2
                    MOVE.W      (A4)+,D2
                    MOVE.L      (A4),D2
                    MOVE.B      #8,EA_COUNT
                    MOVE.L      #$6,INCREMENT
                    ADD.W       #8,BYTE_COUNTER
                    JSR         Display_Address_Long

                    RTS

*Display hex. Hex stored in D2 and number of rotation in memory $400
*This is a loop that will display the individual value one by one
Display_Address
                    ROL.W       #4,D2           *Rotate the first hex number to the back so we can read
                    MOVE.B      D2,D1           *D1 to store the byte data
                    ANDI.B      #$0F,D1         *AND the byte data so we can only see the first one

                    CMPI.b      #$A,D1          *Check if it is greater than A
                    JSR         Show_Char       *If yes jump to display (A-F)

                    CMPI.B      #$A,D1          *Check if it is less than A
                    BLT         Show_Number     *If yes jump to display (0-9)
                    MOVE.B      D1,(A2)+        *Add the character in stack to display later

                    SUB.B       #1,EA_COUNT
                    CMPI.B      #0,EA_COUNT        *Check if rotation done
                    BNE         Display_Address *call itself again-loop
                    RTS

*Same as above but for LONG
Display_Address_Long
                    ROL.L       #4,D2           *Rotate the first hex number to the back so we can read
                    MOVE.B      D2,D1           *D1 to store the byte data
                    ANDI.B      #$0F,D1         *AND the byte data so we can only see the first one

                    CMPI.B      #$A,D1          *Check if it is greater than A
                    JSR         Show_Char       *If yes jump to display (A-F)

                    MOVE.B      D1,(A2)+        *Add the character in stack to display later

                    SUB.B       #1,EA_COUNT
                    CMPI.B      #0,EA_COUNT         *Check if rotation done
                    BNE         Display_Address_Long *call itself again-loop

                    RTS


Show_Char
                    CMPI        #$A,D1
                    BLT         Show_Number
                    ADD.B       #55,D1
                    RTS

Show_Number
                    ADD.B       #48,D1
                    RTS

Show_FFFF
                    CMPI.L      #$8000,D2
                    BGE         PRINT_FFFF
                    RTS

PRINT_FFFF:
                    MOVE.B      F,(A2)+
                    MOVE.B      F,(A2)+
                    MOVE.B      F,(A2)+
                    MOVE.B      F,(A2)+
                    ADD.W       #4, BYTE_COUNTER
                    RTS

    SIMHALT             ; halt simulator













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
