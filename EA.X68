*-----------------------------------------------------------
* Description: This file takes in the instructions from op-code,
* and divide them into the last 6 bits for EA. Then break them down
* further into modes and register that will be used for specifying the
* different addressing mode
*-----------------------------------------------------------


*------------------------------------------------------------------
*This is the EA main that will check for the modes/register to go
*to the right Effective Addressing mode.
*------------------------------------------------------------------
EA_MAIN
                    *This will take the opcodes that is passed and divide them into appropriate mode/regiser
                    *---------------------------------------------------------------------------------------
                    MOVE.L      D3,D4               *Takes in the 16 bit instruction from D3
                    AND.B       #%00111111,D4       * Take the last 6 bit by doing a bit mask
                    MOVE.B      D4,D5               * Copy the last 6 bits into D5 also
                    AND.B       #%00000111,D5       *Take the last 3 bits into Register in D5
                    AND.B       #%00111000,D4       *Take the first 3 bits into Mode in D4
                    ROR.B       #3,D4               *Rotate to correct position
                    
                    
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

*----------------------------------------------------------------- 
EA_Dn
*-------This is the EA data register, D5 stores register number : Dn
*----------------------------------------------------------------- 
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


*-----------------------------------------------------------------
EA_An
*------This is the EA address register, D5 stores the register number :An
*----------------------------------------------------------------- 

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


*----------------------------------------------------------------- 
EA_An_Indirect
*------This is the EA address indirect :(An)----------------------
*----------------------------------------------------------------- 
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


*-----------------------------------------------------------------                     
EA_An_Plus
*------This is the EA address indirect with post increment (A0)+--
*----------------------------------------------------------------- 
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


*-----------------------------------------------------------------                    
EA_An_Minus
*------This is the EA address indirect with pre decrement -(SP)---
*----------------------------------------------------------------- 
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


*-----------------------------------------------------------------                      
EA_Absolute_Immediate
*----This will handle the EA absolute addressing and immediate data
*-----------------------------------------------------------------
                    CMPI.B      #0,D5                   *If register is 0, go to absolute word
                    BEQ         EA_Absolute_WORD

                    CMPI.B      #1,D5                   *If register is 0, go to absolute long
                    BEQ         EA_Absolute_LONG

                    CMPI.B      #4,D5                   *If register is 0, go to immediate
                    BEQ         EA_Immediate


*-----------------------------------------------------------------
EA_Absolute_WORD:
*-----This is the EA for absolute addressing WORD-----------------
*-----------------------------------------------------------------
                    MOVE.B      MONEY,(A2)+
                    ADD.W       #1,BYTE_COUNTER

                    CLR.L       D2                      *clear D2 to show next word data
                    MOVE.W      (A4)+,D2                *Add value to stack and Increment pointer
                    MOVE.W      (A4),D2

                    MOVE.B      #4, D4                  *Place a counter in D4
                    JSR         Display_Address         * go to display address and print
                    ADD.W       #4,BYTE_COUNTER

                    MOVE.L      #$2,INCREMENT
                    RTS
                    
                    
*-----------------------------------------------------------------
EA_Absolute_Byte:
*----This is the EA for absolute addressing BYTE------------------
*-----------------------------------------------------------------
                    MOVE.B      MONEY,(A2)+
                    ADD.W       #1,BYTE_COUNTER

                    MOVE.L      D3,D2
                    AND.B       #%11111111, D2        *checking for BRA size 0 = word, 1 = long

                    MOVE.B      #4, D4                *Place a counter in D4
                    JSR         Display_Address
                    ADD.W       #2,BYTE_COUNTER

                    MOVE.L      #$2,INCREMENT
                    RTS

*-----------------------------------------------------------------
EA_Absolute_LONG:
*----This is the EA for absolute addressing LONG------------------
*-----------------------------------------------------------------
                    MOVE.B      MONEY,(A2)+
                    ADD.W       #1,BYTE_COUNTER

                    CLR.L        D2
                    MOVE.W      (A4)+,D2               *grab the address pointer and increment
                    MOVE.L      (A4),D2
                    MOVE.B      #8,D4                 *hardcoded counter in $400 (8 hex values for long)
                    JSR         Display_Address_Long
                    ADD.W       #8,BYTE_COUNTER

                    MOVE.L      #$4,INCREMENT
                    RTS

*-----------------------------------------------------------------
EA_Immediate:
*-----This is the EA for Immediate-------------------------------
*-----------------------------------------------------------------
                    MOVE.B      POUND,(A2)+     *displays the # sign
                    MOVE.B      MONEY,(A2)+     *displays the $ sign
                    ADD.W       #2,BYTE_COUNTER

                    JSR         Immediate_Size  *Go check the immediate size
                    RTS


*-----------------------------------------------------------------
Immediate_Size:
*-----This will check the immediate size--------------------------
*-----------------------------------------------------------------
                    CMPI.B      #0,D6               *if size is 0, go to byte
                    BEQ         Immediate_Byte
                    CMPI.B      #1,D6               *if size is 0, go to word
                    BEQ         Immediate_Word
                    CMPI.B      #2,D6               *if size is 0, go to long
                    BEQ         Immediate_Long

                    BRA         UNKNOWN             *else print Unkown for not supported


*----------------------------------------------------------------
Immediate_Word:
*-----------------This will do the immediate word size and print--
*-----------------------------------------------------------------
                    CLR.L       D2                      *clear D2 to show next word data
                    MOVE.W      (A4)+,D2                *Add value to stack and Increment pointer
                    MOVE.W      (A4),D2
                    MOVE.B      #4, D4
                    MOVE.L      #$2,INCREMENT           *Increment memory and byte counter
                    ADD.W       #4,BYTE_COUNTER
                    JSR         Display_Address         * Go display address
                    RTS


*----------------------------------------------------------------
Immediate_Byte:
*-----------------This will do the immediate byte size and print
*-----------------------------------------------------------------
                    CLR.L       D2                      *clear D2 to show next word data
                    MOVE.W      (A4)+,D2                *Add value to stack and Increment pointer
                    MOVE.W      (A4),D2
                    MOVE.B      #4, D4
                    MOVE.L      #$2,INCREMENT           *Increment memory and byte counte
                    ADD.W       #4,BYTE_COUNTER 
                    JSR         Display_Address         *Display address
                    RTS
                    
                    
*----------------------------------------------------------------
Immediate_Long:
*-----------------This will do the immediate byte long and print
*-----------------------------------------------------------------
                    CLR.L        D2
                    MOVE.W      (A4)+,D2
                    MOVE.L      (A4),D2

                    MOVE.B      #8, D4

                    MOVE.L      #$4,INCREMENT
                    ADD.W       #8,BYTE_COUNTER

                    JSR         Display_Address_Long

                    RTS
*----------------------------------------------------------------
Display_Address:
*Display hex. Hex stored in D2 and number of rotation in memory
*This is a loop that will display the individual value one by one

                    ROL.W       #4,D2           *Rotate the first hex value to back
                    MOVE.B      D2,D1           *Copy D2 over to D1
                    ANDI.B      #$0F,D1         *AND immediate to show the first value

                    CMPI.b      #$A,D1          *Compare immediate see if is greater than A
                    JSR         Show_Char       *If so, jumpt to label show char to display (A-F ascii)

                    CMPI.B      #$A,D1          *Compare immediate see if is less than A
                    BLT         Show_Number     *If so, jump to display numbers from 0-9
                    MOVE.B      D1,(A2)+        *Add the character in stack to display later

                    SUB.B       #1, D4          *Subtract 1 from counter
                    CMPI.B      #0, D4          *Compare immediate to see if is done rotating
                    BNE         Display_Address *call itself again-loop

                    RTS

*----------------------------------------------------------------
Display_Address_Long
*-------------Same as above but for LONG-------------------------
*----------------------------------------------------------------
                    ROL.L       #4,D2           *Rotate the first hex value to back
                    MOVE.B      D2,D1           *Copy D2 over to D1
                    ANDI.B      #$0F,D1         *AND immediate to show the first value

                    CMPI.B      #$A,D1          *Compare immediate see if is greater than A
                    JSR         Show_Char       *If so, jumpt to label show char to display (A-F ascii)

                    MOVE.B      D1,(A2)+        *Add the character in stack to display later

                    SUB.B       #1,D4           *Subtract 1 from counter
                    CMPI.B      #0,D4           *Compare immediate to see if is done rotating
                    BNE         Display_Address_Long *call itself again-loop

                    RTS

*----------------------------------------------------------------
Show_Char
*---------Label that will compare the ascii and call show number
*----------------------------------------------------------------
                    CMPI        #$A,D1
                    BLT         Show_Number
                    ADD.B       #55,D1
                    RTS
                    
                    
*----------------------------------------------------------------
Show_Number
*---------This will add the correct value for ascii to show------
*----------------------------------------------------------------
                    ADD.B       #48,D1
                    RTS


    SIMHALT             ; halt simulator





*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
