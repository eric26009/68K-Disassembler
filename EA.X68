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

EA_MAIN
                    MOVE.L      D3,D4               *Takes in the 16 bit instruction from D3
                    AND.B       #%00111111,D4       * Take the last 6 bit by doing a bit mask
                    MOVE.B      D4,D5               * Copy the last 6 bits into D5 also
                    AND.B       #%00000111,D5       *Take the last 3 bits into Register in D5
                    AND.B       #%00111000,D4       *Take the first 3 bits into Mode in D4
                    ROR.B       #3,D4               *Rotate to correct position
                    
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

                    CLR.L       D2               *clear D2 to show next word data
                    MOVE.W      (A5)+,D2
                    JSR         Show_FFFF
                    
                    MOVE.B      #4, $400
                    JSR         Display_Address

                    MOVE.L      #$4,INCREMENT
                    RTS

*This is the EA for absolute addressing LONG
EA_Absolute_LONG
                    MOVE.L      #$6,INCREMENT
                    RTS

*This is the EA for Immediate
EA_Immediate
                    MOVE.L      #$4,INCREMENT
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

*--------------------------------------------------------------------
*                  Variables and constants here
*--------------------------------------------------------------------










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
