*-----------------------------------------------------------
* Title      : 
* Written by :
* Date       :
* Description: This file takes in the instructions from op-code,
* and divide them into the last 6 bits for EA. Then break them down 
* further into modes and register that will be used for specifying the 
* different addressing mode
*-----------------------------------------------------------

* Put program code here
*------------------EA-Codes----------------------------------------   EA mode store in D4 and EA register stored in D5
EA_MAIN
                    CMPI.W      #0,D4
                    BEQ         EA_Dn
                    
                    CMPI.W      #1,D4
                    BEQ         EA_An


* This is the EA data register, D5 stores register number
EA_Dn
                    MOVE.B      D_Dn,(A2)+
                    ADD.W       #1,BYTE_COUNTER
                    *BRA         BUFFER_LOOP
    
                    CLR.L       D1
                    MOVE.B      D5, D1
                    JSR         Show_Number
                    MOVE.B      #6, D0
                    TRAP        #15
                    RTS

* This is the EA address register, D5 stores the register number                    
EA_An
                    LEA         D_An,A1
                    MOVE.B      D_An,(A2)+
                    ADD.W       #1,BYTE_COUNTER
                    
                    CLR.L       D1
                    MOVE.B      D5,D1
                    JSR         Show_Number
                    MOVE.B      #6,D0
                    TRAP        #15
                    RTS

                                        
EA_An_Indirect      
                    

Show_Number
                    ADD.B   #48,D1
                    RTS


    SIMHALT             ; halt simulator

*--------------------------------------------------------------------
*                  Variables and constants here
*--------------------------------------------------------------------

*------------------Display and show the EA mode----------------------
D_Dn                 DC.B        'D',0
D_An                 DC.B        'A',0
D_AnPlus             DC.B        '(A',0
D_AnPlusN            DC.B        ')',0
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
