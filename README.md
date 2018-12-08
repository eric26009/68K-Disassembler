Final Project for CSS 422


Definitions
___________________________________________________


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

Feldman_Zhu_Disassembler.x68

	Where all the .x68 files are included and run from. It includes all the
	defined constants and equates. It is also responsible for looping through
	memory and pausing and continuing when the user presses enter.

	- A4 - stores starting/current address that is being decoded.
	- A5 - stores ending address of memory that needs to be decoded.
	- A6 - LINE_COUNTER, stores the number of lines printed so far.
	- INCREMENT, stores the increment to next memory location.

ea.x68

	Responsible for decoding the effective address.

	- D4 stores 3 bits for the mode.
	- D5 stores 3 bits for the register.

IO.x68

	Prompts the user to enter a long address between (00004000 - FFFFFFFF).
	Checks to make sure a valid address is entered within the bounds, and with
	correct letters/ and or numbers.
