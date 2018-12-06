Final Project for CSS 422


Definitions - (Do not override)
___________________________________________________


opcodes.x86

	- A1 - BUFF_POINT, defining where A1 is in memory, used for printing.
	- A2 - STRING_STORE, stores pointer to the end of the string buffer.
	- A3 - STRING_STORE, stores pointer to the start of the string buffer.
	- D3 stores a word of current instruction being decoded.
	- BYTE_COUNTER hard coded at $0, stores number of bytes to be printed out.

main.x86

	- A4 - stores starting/current address that is being decoded.
	- A5 - stores ending address of memory that needs to be decoded.
	- A6 - LINE_COUNTER, stores the number of lines printed so far.
	- INCREMENT is hard coded at location $8 (stores the increment to next memory location).

ea.x86

	- D6 stores the size for immediate value (0=Byte, 1=Word, 2=Long).
	- D4 stores 3 bits for the mode.
	- D5 stores 3 bits for the register.


Notes:

	- MULS #value sometimes does not always work correctly 
