Final Project for CSS 422


Definitions - (Do not override)
___________________________________________________

************* WRONG BELOW **** NEEDS TO BE REVISED****************************

opcodes.x86

	- A2 stores pointer to the end of the string buffer
	- A3 stores pointer to the start of the string buffer
	- D3 stores word of instruction to be used by EA

main.x86

	- A4 stores starting address
	- A5 stores ending address

EA.x86
	- D6 stores the size for immediate value (0=Byte, 1=Word, 2=Long)
	- D4 stores 3 bits for the mode
	- D5 stores 3 bits for the register


Hard coded values
	- A1 - BUFF_POINT hard coded at $3000  
	- A2 - BYTE_COUNTER hard coded at $ 0       
	- A3 - STRING_STORE hard coded at $4000   

** need to dedicate a register to keep track of number of lines printed so we 	  can implement the feature where it prints 10 lines at a time, until user presses 	  a button. **

* Should be free to override anything else except those above, opcodes reinitializes every time it is called.
