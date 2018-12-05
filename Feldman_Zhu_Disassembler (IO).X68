*-----------------------------------------------------------
* Title      : 68k Disassembler (Inverse Assembler)
* Written by : Zealous Zhu and Eric Feldman
* Date       : 11/21/18
* Description: This disassembler program takes the assembly language that was assembled
*              and decode them so that a user can understand.
*-----------------------------------------------------------
                     ORG        $1000

INCREMENT            EQU        $8
LINE_COUNTER         EQU        $2000

START:
*------------------Program Starts with Instruction------------------
                      LEA        INTRO_MSG,A1            *Load and display the intro message
                      MOVE.B     #14,D0
                      TRAP       #15

*------------------Ask User for Starting Address--------------------
input_begin			  LEA		U_START_ADDRESS,A1		            *Ask user for starting address question
					  MOVE.B	#14,D0
					  TRAP		#15						            * Execute the trap task above to display  
						
					  LEA		AddrStart_Aski,A2			* Subroutine reads address location to store address.
					  JSR		User_Inpt                   * Gettting user input

					  LEA		AddrStart_Aski,A0
					  CLR.W		D2                      * Clearing D2-D4
					  CLR.W		D3
					  CLR.W		D4
					  MOVE.B	#$30,(A0)+				* Pushing 2 bytes to zero
					  MOVE.B	#$30,(A0)				
					  LEA		AddrStart_Aski,A0

*----------------This will convert the valid start address from ASCII to HEX---------
Chck_Str_Inpt		  LSL.L		#4,D4
					  ADDI		#1,D2
					  MOVE.B	(A0),D3					* Moves ASCII to D3
					  CMP.B		#$39,(A0)				* Range 0-9?
					  BLE		Aski_nValue				* Branch to Number
					  CMP.B		#$46,(A0)				* Range A-F?
					  BLE		Aski_UC			        * Branch to Uppercase
					  CMP.B		#$66,(A0)				* Range a-f?
					  BLE		Aski_LC          * Branch to Lowercase
						
						
*------------------Ask User for INPUT--------------------
User_Inpt   		 MOVEA.W	A2,A1
					 MOVE.B		#2,D0
					 TRAP		#15
					 CMPI.B		#8,D1					* Is Address Entered Length = 8?
					 BEQ.W		Valid_Inpt				* Good Input
						
					 LEA		CHECK_FOR_8BITS,A1			* Throw error, user input not long.
					 MOVE.B		#13,D0
					 TRAP		#15
					 MOVE.B		#$24,D1
					 MOVE.B		#6,D0
					 TRAP		#15
					 BRA		User_Inpt           * Redo, get input again.

Valid_Inpt:			 RTS                                 * Return with good input.




wrong_Inpts			 MOVE.B		#$24,D1                 * Hex for '$' 
					 MOVE.B		#6,D0                   
					 TRAP		#15                     * Displays '$'

					 LEA		AddrStart_Aski,A1         * Address is not valid so we 
					 MOVE.B		#14,D0                  * print out address entered and 
					 TRAP		#15                     * ask user to re-enter address.
					 LEA		Wrong_Addr_MSG,A1
					 MOVE.B		#13,D0
					 TRAP		#15
			         BRA        input_begin

Aski_nValue    		 CMP.B		#$30,(A0)+				* Number < 0?
					 BLT		wrong_Inpts           * Not valid, ask for new address.
					 SUB.B	 	#$30,D3
					 BRA		change_aski         * Continue on valid

Aski_UC     		 CMP.B		#$41,(A0)+				* Letter < A?
					 BLT		wrong_Inpts
					 SUB.B	 	#$37,D3					
					 BRA		change_aski         * Continue on valid

Aski_LC     		 CMP.B	 	#$61,(A0)+				* Letter < a?
					 BLT		wrong_Inpts
					 SUB.B	 	#$57,D3					* Converts to uppercase
					 BRA		change_aski         * Continue on valid

change_aski			 OR.L		D3,D4					* Masking first 4 bits in D3
					 CMP.B		D1,D2
					 BEQ		User_StartA_Done
					 BRA		Chck_Str_Inpt           * Loop if not done.

User_StartA_Done	 MOVE.L		D4,RealHex_AddrS         * Save HEX converted address.
                     LEA        RealHex_Addrs,A4

*---------------- Getting Ending Address -------------------
User_Inpt_End   	 LEA		U_END_ADDRESS,A1			* Load Question
					 MOVE.B		#14,D0
					 TRAP		#15						* Display Question
					 LEA		AddressEnd_Aski,A2			* Subroutine to read address location and store in A2
					 JSR		User_Inpt           * Getting user input.

 					 MOVE.L		RealHex_AddrS,D5
 					 LEA		AddressEnd_Aski,A0
					 CLR.W		D2                      * Clearing D2-D4
					 CLR.W		D3
					 CLR.W		D4
					 MOVE.B		#$30,(A0)+				* Pushing 2 bytes to zero.
					 MOVE.B		#$30,(A0)
					 LEA		AddressEnd_Aski,A0


*-------------------ASCII to Hex ---------------------------
Chck_end_Inpt		 LSL.L		#4,D4
					 ADDI		#1,D2
					 MOVE.B		(A0),D3					* Moves ASCII to D3
					 CMP.B		#$39,(A0)				* Range 0-9?
					 BLE		Aski_nValue_end				* Branch to Number
					 CMP.B		#$46,(A0)				* Range A-F?
					 BLE		Aski_UC_End			* Branch to Uppercase
					 CMP.B		#$66,(A0)				* Range a-f?
					 BLE		Aski_LC_End         * Branch to Lowercase

wrong_inptsEnd		 LEA		AddressEnd_Aski,A1           * Hex for '$'
					 MOVE.B		#14,D0
					 TRAP		#15                     * Displays '$'
						
					 LEA		Wrong_Addr_MSG,A1             * If address is not valid
					 MOVE.B		#13,D0                  * ask for new ending
					 TRAP		#15                     * ending address.
					 BRA		User_Inpt_End

Aski_nValue_end		 CMP.B		#$30,(A0)+				* Number < 0?
					 BLT		wrong_inptsEnd          * Not valid, ask for new address.
					 SUB.B		#$30,D3
					 BRA		Change_Aski_End        * Continue on valid
					 
Aski_UC_End			 CMP.B		#$41,(A0)+				* Letter < A?
					 BLT		wrong_inptsEnd
					 SUB.B		#$37,D3
					 BRA		Change_Aski_End        * Continue on valid

Aski_LC_End			 CMP.B		#$61,(A0)+				* Letter < a?
					 BLT		wrong_inptsEnd
					 SUB.B	 	#$57,D3                 * Converts to uppercase
					 BRA		Change_Aski_End        * Continue on valid

Change_Aski_End		 OR.L		D3,D4					* Masking first 4 bits in D3
					 CMP.B 		D1,D2					
					 BEQ		User_EndA_Done
					 BRA		Chck_end_Inpt			* Loop if not done.

User_EndA_Done		 MOVE.L	    D4,RealHex_AddrE			* Save HEX converted address.
                     LEA        RealHex_AddrE,A5
						
*-----------------Different Starting/Ending Address Condition Check -----

					 CMP.L		RealHex_AddrS,D4		* Is starting address > ending address?
					 BHI		NextAddrChk				* Branch if starting address < ending address.
						
					 LEA		startBeforeEnd_AddrChk,A1	* Throw error msg if invalid range
					 MOVE.B		#14,D0					
					 TRAP		#15                     * Display error msg

					 BRA		input_begin				* Get starting address again.


NextAddrChk
					 MOVE.L		(RealHex_AddrS),D0		* Grabbing their starting address.
					 CMP.L		D0,A0					* Check if starting address is past our program.
					 BCS		Good_Valid_Addr		    * Valid starting address.
					 LEA		OutOfBound_ERR_MSG,A1	* Throw error if within our program.
					 MOVE.B		#13,D0					
					 TRAP		#15                     * Display error msg.
					 BRA		input_begin				* Get starting address again.
						
Good_Valid_Addr		MOVEA.L		RealHex_AddrE,A5			* We can now place ending address in A6 
                                                            * and begin disassembling.




*------------------OP-Codes----------------------------------------
*Separate File


*------------------EA-Codes----------------------------------------
*Separate File



*------------------Variables and constants here----------------------
CR					 EQU        $0D				        * ASCII code for Carriage return
LF					 EQU		$0A				        * ASCII code for Line Feed


*------------------Intro Message-------------------------------------
INTRO_MSG                       DC.B       'We are the Inverse Assembler Team!',CR,LF
                                DC.B       'We can take the assembled machine code and convert it into readable human code',CR,LF
                                DC.B       'To do so, we just need you to give us a Starting Address and Ending Address',CR,LF
                                DC.B       'The addresses are in Hexidecimal only and we can take up to a byte address',CR,LF
                                DC.B       'Lets try it shall we?',CR,LF,CR,LF,0
*------------------Start and End Address Message-----------------------
U_START_ADDRESS                 DC.B       'Enter a Starting Address: $',CR,LF,0
U_END_ADDRESS                   DC.B       'Enter an Ending Address: $',0

AddrStart_Aski                  DS.B       82
AddressEnd_Aski                 DS.B       82   
RealHex_AddrS                   DS.L       1
RealHex_AddrE                   DS.L       1

*------------------Tells user that their input is off------------------
CHECK_FOR_8BITS                DC.B     'Sorry! Input Address must be a Byte long (8 Bits)! Try Again:',0
startBeforeEnd_AddrChk	       DC.B		'Your ending address needs to be greater than your starting address. Try again!',CR,LF,0
OutOfBound_ERR_MSG             DC.B    	'Out of bound! The code has to be within the program!',CR,LF,0
Wrong_Addr_MSG                 DC.B     'This is not a valid address, try again',0   


                     END    START        ; last line of source



*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
