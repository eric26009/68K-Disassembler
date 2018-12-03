*-----------------------------------------------------------
* Title      : 
* Written by :
* Date       :
* Description: This file takes in the instructions from op-code,
* and divide them into the last 6 bits for EA. Then break them down 
* further into modes and register that will be used for specifying the 
* different addressing mode
*-----------------------------------------------------------

                    * ToDo - Takes in the 16 bit instruction from D3
                    * Take the last 6 bit by doing a bit mask
                    * Divide the 6 bits into mode and register.
                    * The first 3 bits is the Mode and the last 3 bits is the register
                    * Store that in D4 and D5 respectively
                    AND.B #%0000000000111111,D3                        
                    
                    

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
EA_MAIN
                    CMPI.W      #0,D4
                    BEQ         EA_Dn
                    
                    CMPI.W      #1,D4
                    BEQ         EA_An
                    
                    CMPI.W      #2,D4
                    BEQ         EA_An_Indirect
                    
                    CMPI.W      #3,D4
                    BEQ         EA_An_Plus
                    
                    CMPI.W      #4,D4
                    BEQ         EA_An_Minus
                    
                    CMPI.W      #7,D4
                    BEQ         EA_Absolute_Immediate
                    
                    RTS

* This is the EA data register, D5 stores register number : Dn
EA_Dn
                    MOVE.B      D_Dn,(A2)+
                    ADD.W       #1,BYTE_COUNTER
    
                    CLR.L       D1
                    MOVE.B      D5, D1
                    JSR         Show_Number
                    MOVE.B      #6, D0
                    TRAP        #15
                    RTS

* This is the EA address register, D5 stores the register number :An                   
EA_An
                    MOVE.B      D_An,(A2)+
                    ADD.W       #1,BYTE_COUNTER
                    
                    CLR.L       D1
                    MOVE.B      D5,D1
                    JSR         Show_Number
                    MOVE.B      #6,D0
                    TRAP        #15
                    
                    RTS
*This is the EA address indirect :(An)                                      
EA_An_Indirect      
                    MOVE.B      D_AnPlus,(A2)+
                    ADD.W       #2,BYTE_COUNTER 
                    
                    CLR.L       D1
                    MOVE.B      D5,D1
                    JSR         Show_Number
                    MOVE.B      #6,D0
                    TRAP        #15
                    
                    MOVE.B      D_AnPlusEnd,(A2)+
                    ADD.W       #1,BYTE_COUNTER
                    
                    RTS

*This is the EA address indirect with post increment (A0)
EA_An_Plus
                    MOVE.B      D_AnPlus,(A2)+
                    ADD.W       #2,BYTE_COUNTER 
                    
                    CLR.L       D1
                    MOVE.B      D5,D1
                    JSR         Show_Number
                    MOVE.B      #6,D0
                    TRAP        #15
                    
                    MOVE.B      D_AnPlusP,(A2)+
                    ADD.W       #2,BYTE_COUNTER
                    
                    RTS                    
                    
*This is the EA address indirect with pre decrement -(SP)
EA_An_Minus
                    MOVE.B      D_minusAn,(A2)+
                    ADD.W       #3,BYTE_COUNTER 
                    
                    CLR.L       D1
                    MOVE.B      D5,D1
                    JSR         Show_Number
                    MOVE.B      #6,D0
                    TRAP        #15
                    
                    MOVE.B      D_AnPlusEnd,(A2)+
                    ADD.W       #1,BYTE_COUNTER
                    
                    RTS 
*This will handle the EA absolute addressing and immediate data
EA_Absolute_Immediate
                    CMPI.B      #0,D5
                    BEQ         EA_Absolute_WORD
                    
                    CMPI.B      #1,D5
                    BEQ         EA_Absolute_LONG
                    
                    CMPI.B      #4,D5
                    BEQ         EA_Immediate
                    
*This is the EA for absolute addressing WORD, 
EA_Absolute_WORD
                    MOVE.B      D_Address,(A2)+
                    ADD.W       #1,BYTE_COUNTER                     
                    
                    CLR.L       D2 *clear D2 to show next word data
                    MOVE.W      (A5)+,D2
                    JSR         Show_FFFF
                    
*****************To be continued for EA absolute WORD, LONG, Immediate
                 

*This is the EA for absolute addressing LONG    
EA_Absolute_LONG                    


*This is the EA for Immediate
EA_Immediate




Show_Number
                    ADD.B       #48,D1
                    RTS
                    
Show_FFFF
                    CMPI.L      #$8000,D2
                    BGE         FFFF
                    RTS
                    
FFFF                
                    MOVE.B      D_FFFF,(A2)+
                    ADD.W       #4,BYTE_COUNTER
                    RTS   

    SIMHALT             ; halt simulator

*--------------------------------------------------------------------
*                  Variables and constants here
*--------------------------------------------------------------------

*------------------Display and show the EA mode----------------------
D_Dn                 DC.B        'D',0
D_An                 DC.B        'A',0
D_AnPlus             DC.B        '(A',0
D_AnPlusEnd          DC.B        ')',0
D_AnPlusP            DC.B        ')+',0   
D_minusAn            DC.B        '-(A',0
D_FFFF               DC.B        'FFFF',0
D_Address            DC.B        '$',0
D_Immediate          DC.B        '#$',0
D_Comma              DC.B        ',',0







*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
