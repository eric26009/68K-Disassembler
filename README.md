Final Project for CSS 422

By: Eric Feldman and Zealous Zhu


To run
___________________________________________________

	1. Open Easy68k and open up "Feldman_Zhu_Disassembler.x68" file.
	2. Execute program and follow prompts provided by the opening screen.
	3. The disassembler lives between 00001000 to 00003FFF.
	4. There is a test file loaded at 00004000, that may be run.


Supported Opcodes
___________________________________________________

	- MOVE, MOVEA
	- ADD, ADDA
	- SUB, SUBQ
	- MULS, DIVS
	- LEA
	- OR, ORI
	- NEG
	- EOR
	- LSR, LSL
	- ASR, ASL
	- ROL, ROR
	- BCLR
	- CMP, CMPI
	- BCC, BCS, BGE, BLT, BVC, BEQ
	- BRA, JSR, RTS
	- NOP

	* MOVEM will print MOVEM and correct size
      but EA will print "LIST, EA" or "EA, LIST", not actual contents


Supported effective addressing modes
___________________________________________________

	- Data Register Direct:  Dn
	- Address Register Direct:  An
	- Address Register Indirect:  (An)
	- Address Register Indirect with Post incrementing:  (A0)+
	- Address Register Indirect with Pre decrementing:  -(SP)
	- Immediate Data:  #
	- Absolute Long Address:  (xxx).L
	- Absolute Word Address:  (xxx).W


Files
___________________________________________________

Feldman_Zhu_Disassembler.x68

	Where all the .x68 files are included and run from. It includes all the
	defined constants and equates. It is also responsible for looping through
	memory and pausing and continuing when the user presses enter.

	- A4 - stores starting/current address that is being decoded.
	- A5 - stores ending address of memory that needs to be decoded.
	- A6 - LINE_COUNTER, stores the number of lines printed so far.
	- INCREMENT, stores the increment to next memory location.

opcodes.x68

	Responsible for decoding the opcodes, converting current memory address
	hex conversion, buffering the string for printing, determining correct sizes
	and printing once finished with a line.

	- A1 - BUFF_POINT, defining where A1 is in memory, used for printing.
	- A2 - STRING_STORE, stores pointer to the end of the string buffer.
	- A3 - STRING_STORE, stores pointer to the start of the string buffer.
	- D3 stores a word of current instruction being decoded.
	- D6 stores the size for immediate value (0=Byte, 1=Word, 2=Long).
	- BYTE_COUNTER, stores number of bytes to be printed out.


ea.x68

	Responsible for decoding the effective address.

	- D4 stores 3 bits for the mode.
	- D5 stores 3 bits for the register.

IO.x68

	Prompts the user to enter a long address between (00004000 - FFFFFFFF).
	Checks to make sure a valid address is entered within the bounds, and with
	correct letters/ and or numbers.


Notes
___________________________________________________

	If an unknown opcode is passed, the program will print DATA followed by the
	hex instruction that was unknown. The increment is for the next memory
	location is set to $2, since we no longer know where exactly the next
	instruction lives. Therefore, after DATA, one or few bogus lines may be
	printed.
