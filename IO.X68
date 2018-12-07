*-----------------------------------------------------------
* Title      : 68k Disassembler (Inverse Assembler)
* Written by : Zealous Zhu and Eric Feldman
* Date       : 11/21/18
* Description: This disassembler program takes the assembly language that was assembled
*              and decode them so that a user can understand.
*-----------------------------------------------------------

*--------------------------------------------------------------------
START_IO:
*-------------Program Starts with Introduction and Instruction-------
*--------------------------------------------------------------------
                      LEA        LINE_SPACE,A1            *formatting
                      MOVE.B     #14,D0
                      TRAP       #15
                      
                      LEA        INTRO_MSG,A1            *Load and display the intro message
                      MOVE.B     #14,D0
                      TRAP       #15                     *Execute the trap task above to display
                      
                      LEA       AddressInstruction,A1    *Load and display address range
                      MOVE.B    #14,D0
                      TRAP      #15                      *Execute the trap task above to display

                      LEA        LINE_SPACE,A1           *formatting
                      MOVE.B     #14,D0
                      TRAP       #15

*--------------------------------------------------------------------
input_begin:			  
*------------------Ask User for Starting Address--------------------
*--------------------------------------------------------------------
                      LEA		U_START_ADDRESS,A1		 *Asking user for an starting address instruction
					  MOVE.B	#14,D0
					  TRAP		#15						 *Execute the trap task above to display

					  LEA		AddrStart_Aski,A2		 *Loads the asking address start into Address regiser A2
					  JSR		User_Inpt                *JumpSubRoutine to userInput

					  LEA		AddrStart_Aski,A0        *This will put the start addr in A0 (ASCCI)

                      JSR       CLEAR_D_REGISERS         *This will clear the data regisers for next words
					  MOVE.B	#$30,(A0)+				 *This will move the byte into the stack
					  MOVE.B	#$30,(A0)
					  LEA		AddrStart_Aski,A0        
					  
					  
*----------------------------------------------------------------------
Chck_Str_Inpt:	
*-------This will convert the valid start address from ASCII to HEX----
*----------------------------------------------------------------------	 
                      LSL.L		#4,D4                   *shifts left to get the right bit
					  ADDI		#1,D2
					  
					  MOVE.B	(A0),D3					* This will move the Aski value to D3 to check
					  
					  CMP.B		#$39,(A0)				* Compare the number for range check
					  * Branch on less than or equal to check aski number
					  BLE		Aski_nValue				
					  CMP.B		#$46,(A0)				* Compare for upper case A through Fcheck Range
					  * Branch on less than or equal to lowercase
					  BLE		Aski_LC  
					  * Branch on less than or equal to uppercase
					  BLE		Aski_UC			        
					  CMP.B		#$66,(A0)				* Compare for upper case a through fcheck Range
               

*---------------------------------------------------------------------
wrong_Inpts
*-------Wrong inputs will be checked here-----------------------------
*---------------------------------------------------------------------	
					 LEA		Wrong_Addr_MSG,A1
					 MOVE.B		#13,D0
					 TRAP		#15
			         BRA        input_begin
			         
			         
*---------------------------------------------------------------------
User_Inpt
*-------Ask User for INPUT and CHECK----------------------------------
*---------------------------------------------------------------------	
               		 MOVEA.W	A2,A1                   *Move the address from A2 to A1, creating a copy
					 MOVE.B		#2,D0                   
					 TRAP		#15                     *Execute task for input in address regiser
					 
					 CMPI.B		#8,D1					*Compares the immediate value 8 for 8 bits
					 BEQ.W		Valid_Inpt				*If it is equal, branch to valid bit

					 LEA		CHECK_FOR_8BITS,A1	    *If it is not 8 bits long, show error msg to user
					 MOVE.B		#13,D0
					 TRAP		#15                     *Execute and print error message
					 
					 MOVE.B		#$24,D1
					 MOVE.B		#6,D0
					 TRAP		#15                     *Display the char
					 
					 BRA		User_Inpt               *If the inputs are incorrect, return to ask user input
		
*---------------------------------------------------------------------
Aski_nValue    		 
*-------Checks the ASKI number value----------------------------------
*---------------------------------------------------------------------	
                     CMP.B		#$30,(A0)+				*Compares the value if it is less than 0 (ASCII value)
					 BLT		wrong_Inpts             *Branch to wrong inputs if it is lesss than 0
					 SUB.B	 	#$30,D3
					 BRA		change_aski             *OR ELSE, take the Aski value and convert it


*---------------------------------------------------------------------
Aski_LC
*-------Checks the ASKI uppercase value-------------------------------
*---------------------------------------------------------------------	
     		        CMP.B	 	#$61,(A0)+				*Compares the value if it is less than a (ASCII value)
					 BLT		wrong_Inpts             *Branch to wrong inputs its is less than a
					 
					 SUB.B	 	#$57,D3					*this will change it to up and put in D3
					 BRA		change_aski             *branch to change aski
					 
		
*---------------------------------------------------------------------
Aski_UC
*-------Checks the ASKI uppercase value-------------------------------
*---------------------------------------------------------------------	
             		 CMP.B		#$41,(A0)+				*Comapres the value to the capital A, if it is less than
					 BLT		wrong_Inpts             *Branch to wrong inputs if it is less than
					 
					 SUB.B	 	#$37,D3                 *Subtract aski value 7
					 BRA		change_aski             *OR ELSE, take the Aski value and convert it
					 		 
				 
*---------------------------------------------------------------------
change_aski	
*-------Checks the ASKI uppercase value-------------------------------
*---------------------------------------------------------------------	
            		 OR.L		D3,D4					*This will OR the long of the bits in D3
					 CMP.B		D1,D2                   *Compare the byte of D1 and D2
					 BEQ		User_StartA_Done        *If they are equal, go to done
					 BRA		Chck_Str_Inpt           *Go back /brnach if it is not done


*---------------------------------------------------------------------
User_StartA_Done	 
*-------Checks the ASKI uppercase value-------------------------------
*---------------------------------------------------------------------	
					 JSR       RANGE_CHECK               *This is go check the range of the address
					 CMP.B     #1,D6                     *A flag to check if D6 is set to 1. (1 = wrong input)   
                     BEQ       input_begin               *If it is equal to 1, go back to ask user for address
                     MOVE.L		D4,RealHex_AddrS         *If range is good, save the hex address into realHexAddr value
                     MOVEA.L	RealHex_Addrs,A4         *Also move the address into A4 for starting
                     

*---------------------------------------------------------------------
User_Inpt_End   	 
*-------Now, we will get the ending address---------------------------
*---------------------------------------------------------------------	
                     LEA		U_END_ADDRESS,A1		 *Load ask user for ending address question
					 MOVE.B		#14,D0
					 TRAP		#15						 *Execute task and print question
					 
					 LEA		AddressEnd_Aski,A2		 *Loads the asking address start into Address regiser A2
					 JSR		User_Inpt                *Go to ask user for input

 					 MOVE.L		RealHex_AddrS,D5        * the real hex value into D5
 					 LEA		AddressEnd_Aski,A0      * Load it
 					 
                     JSR        CLEAR_D_REGISERS        *Clear the registers
					 MOVE.B		#$30,(A0)+				
					 MOVE.B		#$30,(A0)
					 LEA		AddressEnd_Aski,A0


*---------------------------------------------------------------------
Chck_end_Inpt
*-------Same as checking for starting address, except we check end now
*---------------------------------------------------------------------	
                      LSL.L		#4,D4                   *shifts left to get the right bit
					  ADDI		#1,D2
					  
					  MOVE.B	(A0),D3					* This will move the Aski value to D3 to check
					  CMP.B		#$39,(A0)				* Compare the number for range check
					  * Branch on less than or equal to check aski number
					  BLE		Aski_nValue_end				
					  CMP.B		#$46,(A0)				* Compare for upper case A through Fcheck Range
					  * Branch on less than or equal to uppercase
					  BLE		Aski_UC_End			        
					  CMP.B		#$66,(A0)				* Compare for upper case a through fcheck Range
					  * Branch on less than or equal to lowercase
					  BLE		Aski_LC_End       


*---------------------------------------------------------------------	
wrong_inptsEnd		 
*-------Same as checking for starting address, except we check end now
*---------------------------------------------------------------------	
					 LEA		Wrong_Addr_MSG,A1       *Show the error message for wrong addresss
					 MOVE.B		#13,D0                  
					 TRAP		#15                     *Execute task above for address and terminte.
					 
					 BRA		User_Inpt_End           *Branch back to ask again

*---------------------------------------------------------------------
Aski_UC_End
*-------Checks the ASKI uppercase end value----------------------------
*---------------------------------------------------------------------	
             		 CMP.B		#$41,(A0)+				*Comapres the value to the capital A, if it is less than
					 BLT		wrong_inptsEnd          *Branch to wrong inputs if it is less than
					 
					 SUB.B	 	#$37,D3                 *Subtract aski value 7
					 BRA		Change_Aski_End         *OR ELSE, take the Aski value and convert it					 
					 

*---------------------------------------------------------------------
Aski_nValue_end    		 
*-------Checks the ASKI number value----------------------------------
*---------------------------------------------------------------------	
                     CMP.B		#$30,(A0)+				*Compares the value if it is less than 0 (ASCII value)
					 BLT		wrong_inptsEnd           *Branch to wrong inputs if it is lesss than 0
					 SUB.B	 	#$30,D3
					 BRA		Change_Aski_End           *OR ELSE, take the Aski value and convert it


*---------------------------------------------------------------------
Aski_LC_End
*-------Checks the ASKI lowercase endvalue-----------------------------
*---------------------------------------------------------------------	
     		         CMP.B	 	#$61,(A0)+				*Compares the value if it is less than a (ASCII value)
					 BLT		wrong_inptsEnd          *Branch to wrong inputs its is less than a
					 
					 SUB.B	 	#$57,D3					*this will change it to up and put in D3
					 BRA		Change_Aski_End         *branch to change aski

					 
*---------------------------------------------------------------------
Change_Aski_End	
*-------Change the ASKI end value-------------------------------------
*---------------------------------------------------------------------	
            		 OR.L		D3,D4					*This will OR the long of the bits in D3
					 CMP.B		D1,D2                   *Compare the byte of D1 and D2
					 BEQ		User_EndA_Done          *If they are equal, go to done
					 BRA		Chck_end_Inpt           *Go back /brnach if it is not done					 
					 
					 
			         
*---------------------------------------------------------------------
Valid_Inpt:			 RTS                                *Simply returns right back if it is correct   
*---------------------------------------------------------------------


*---------------------------------------------------------------------
User_EndA_Done
*-------If converted hex is done, check range and add to address------
*---------------------------------------------------------------------		 
					 JSR       RANGE_CHECK              *Check to make sure the range of address is good
					 CMP.B     #1,D6
                     BEQ       input_begin	
                     
                     MOVE.L	    D4,RealHex_AddrE	    * Puts the valid hex value into variable
                     LEA        RealHex_AddrE,A5        *Then move it to A5 where the ending address 


*---------------------------------------------------------------------
*-------Out of bound Address Check------------------------------------
*---------------------------------------------------------------------	
					 CMP.L		RealHex_AddrS,D4		  *looks at the hex value address in D4
					 BHI		NextAddrChk				  *brasnch to next address to check is less than
					 
					 LEA		startBeforeEnd_AddrChk,A1 *Shows error message for start is greater than end
					 MOVE.B		#14,D0
					 TRAP		#15                       *Execute task and print msg
					 
					 BRA		input_begin				  *Get starting address again.

*---------------------------------------------------------------------
CLEAR_D_REGISERS
*-------THis will simply clear the data registers to read in next word
*---------------------------------------------------------------------
                     CLR.W		D2    * Clearing D2-D4 for new words
					 CLR.W		D3
					 CLR.W		D4
					            
					 RTS     
					 
*---------------------------------------------------------------------
RANGE_CHECK
*-------This checks the range to make sure is in bound----------------
*---------------------------------------------------------------------
                    CMP.L       #$FFFFFF,D4         *Compare address to FFFFFFF
                    BGT         RANGE_ERROR         *If address is greater then print error
                    CMP.L       #$4000,D4           *Compare address to 4000
                    BLT         RANGE_ERROR         *If it is lower than that, print error
                    
                    MOVE.B      #0,D6               *if everything checks out fine, clear flag
                    RTS 

*---------------------------------------------------------------------                          
RANGE_ERROR
*-------This will print the range error message and set flag----------
*---------------------------------------------------------------------
                    LEA         RANGE_ERROR_MSG,A1
                    MOVE.B      #14,D0
                    TRAP        #15
                    MOVE.B      #1,D6
                    RTS              
      
*---------------------------------------------------------------------                     
NextAddrChk
*-------This checks the next address to make sure its correct----------
*---------------------------------------------------------------------
					 MOVE.L		(RealHex_AddrS),D0		*this will move the starting address into D0
					 CMP.L		D0,A0					*Compares it with Address regiser 0
					 BCS		Good_Valid_Addr		    *if it is good, branch to valid address
					 LEA		OutOfBound_ERR_MSG,A1	*If not, show out of bound error message 
					 MOVE.B		#13,D0
					 TRAP		#15                     * execute task and print message
					 BRA		input_begin				* go back to starting

Good_Valid_Addr		 MOVEA.L		RealHex_AddrE,A5	* The valid ending address it put into our A4 ending 
                            
                     RTS                                * go back to main
                   
                

*------------------OP-Codes----------------------------------------
*Separate File


*------------------EA-Codes----------------------------------------
*Separate File



*------------------Variables and constants here----------------------
CR					 EQU     $0D				        * ASCII code for Carriage return
LF					 EQU		$0A				        * ASCII code for Line Feed

*------------------Intro Message-------------------------------------
INTRO_MSG                       DC.B       'We are the Inverse Assembler Team! (ERIC & ZEALOUS)',CR,LF
                                DC.B       'We can take the assembled machine code and convert it into readable human code',CR,LF
                                DC.B       'To do so, we just need you to give us a Starting Address and Ending Address',CR,LF
                                DC.B       'The addresses are in Hexidecimal only and we can take up to a byte address',CR,LF
                                DC.B       'Lets try it shall we?',CR,LF,0
                                
AddressInstruction              DC.B       'Please enter an address between 00004000 to FFFFFFFF',CR,LF,0

LINE_SPACE                      DC.B       '-----------------------------------------------------------------------------',CR,LF,0

*------------------Start and End Address Message-----------------------
U_START_ADDRESS                 DC.B       CR,LF,'Enter a Starting Address: $',0
U_END_ADDRESS                   DC.B       'Enter an Ending Address: $',0

AddrStart_Aski                  DS.B       82
AddressEnd_Aski                 DS.B       82
RealHex_AddrS                   DS.L       1
RealHex_AddrE                   DS.L       1

*------------------Tells user that their input is off------------------
CHECK_FOR_8BITS                DC.B     CR,LF,'Sorry! Input Address must be a Byte long (8 Bits)! Try Again:',CR,LF,0
startBeforeEnd_AddrChk	       DC.B		'Your ending address needs to be greater than your starting address. Try again!',CR,LF,0
RANGE_ERROR_MSG                DC.B     'Please enter the address between 00004000 to FFFFFFFF',CR,LF,0
OutOfBound_ERR_MSG             DC.B    	'Out of bound! Your address has to be after our code!',CR,LF,0
Wrong_Addr_MSG                 DC.B     'That is NOT a valid address! try again',CR,LF,0






*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
