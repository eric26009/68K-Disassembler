Final Project for CSS 422


Definitions - (Do not override)
___________________________________________________

opcodes.x86

	- A2 stores pointer to the end of the string buffer
	- A3 stores pointer to the start of the string buffer

main.x86

	- A4 stores starting address
	- A5 stores ending address

	- ** need to dedicate a register to keep track of number of lines printed so we 	  can implement the feature where it prints 10 lines at a time, until user presses 	  a button. **

* Should be free to override anything else except those above, opcodes reinitializes every time it is called.