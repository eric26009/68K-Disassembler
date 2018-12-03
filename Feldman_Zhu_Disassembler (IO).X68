*-----------------------------------------------------------
* Title      : 68k Disassembler (Inverse Assembler)
* Written by : Zealous Zhu and Eric Feldman
* Date       : 11/21/18
* Description: This disassembler program takes the assembly language that was assembled
*              and decode them so that a user can understand.
*-----------------------------------------------------------
                     ORG        $1000
START:                  
*------------------Program Starts with Instruction------------------
                     LEA        INTRO_MSG,A1         *Load and display the intro message
                     MOVE.B     #14,D0
                     TRAP       #15
                     
*------------------Ask User for Starting Address--------------------                     
                     LEA        U_START_ADDRESS,A1   *Load and ask user for starting address
                     MOVE.B     #14,D0
                     TRAP       #15
                     MOVE.B     #4,D0                *TRAP task 4 reads a number from keyboard
                     TRAP       #15                  *Execute above task
                     MOVEA.L    D1,A3                *Move the user input (starting address) into A3
                     
*------------------Ask User for Ending Address----------------------   
                     LEA        U_END_ADDRESS,A1     *Load and ask user for ending address
                     MOVE.B     #14,D0
                     TRAP       #15
                     MOVE.B     #4,D0                *TRAP task 4 reads a number from keyboard
                     TRAP       #15                  *Execute above task
                     MOVEA.L    D1,A4                *Move user input (ending address) into A4




*------------------OP-Codes----------------------------------------   
*Separate File


*------------------EA-Codes----------------------------------------   
*Separate File



*------------------Variables and constants here----------------------
CR					 EQU        $0D				     * ASCII code for Carriage return
LF					 EQU		$0A				     * ASCII code for Line Feed

*------------------Intro Message-------------------------------------  
INTRO_MSG            DC.B       'We are the Inverse Assembler Team!',CR,LF
                     DC.B       'We can take the assembled machine code and convert it into readable human code',CR,LF
                     DC.B       'To do so, we just need you to give us a Starting Address and Ending Address',CR,LF
                     DC.B       'The addresses are in Hexidecimal only and we can take up to a byte address',CR,LF
                     DC.B       'Lets try it shall we?',CR,LF,CR,LF,0
*------------------Start and End Address Message-----------------------               
U_START_ADDRESS      DC.B       'Enter a Starting Address: $',CR,LF,0  
U_END_ADDRESS        DC.B       'Enter an Ending Address: $',0


*------------------Tells user that their input is off------------------                     
*8Bit_CHECK          DC.B       'Sorry! Input Address must be a Byte long (8 Bits)! Try Again:',0    
                 
                     END    START        ; last line of source


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
