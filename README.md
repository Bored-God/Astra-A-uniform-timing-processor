# Astra - A uniform timing processor
Astra is a minimal experimental processor architecture focused on datapath design, instruction semantics, and control logic. It emphasizes simplicity and deterministic execution to clearly demonstrate the relationship between hardware structure and instruction behavior.

# Key Features
- 8-bit custom CPU architecture
- Fixed 3-byte instruction format
- ALU with signed/unsigned operations
- Conditional branching using flags
- Stack-based operations (PUSH/POP/RET)
- External RAM support
- Fully modular RTL design

# Architectural Overview

## Key Parameters
Signal	              Description
Data width	        : 8 bits
Register count	    : 8 general-purpose registers (r0-r7)
Program memory	    : 256 bytes (up to ~85 instructions)
Data memory(RAM)	  : 256 bytes, byte-addressable
Stack depth	        : 256 entries, 8-bit wide
Clock period	      : 2 ns (500 MHz, simulation only)
Instruction size	  : 3 bytes (op_code, op1, op2)
PC increment	      : +3 per cycle (non-branch)
Flag register	4 bits: zero [3], overflow [2], negative [1], carry [0]

## Instruction Format
Byte 0: op_code	 	
Encodes operation, mode, and unit select	
The op_code byte is further subdivided as follows:
-	Bit [7]: mode select - 0 = calculation mode, 1 = move (MOV) mode
-	Bits [5:4]: unit select (calculation mode only) - 00 = ALU, 01 = Conditional, 10 = Xtra, 11 = Stack
-	Bits [3:0]: operation code within the selected unit
-	Bit [6]: unused in the current revision (reserved for future use)

Byte 1: op1
Source register / immediate value / jump address	

Byte 2: op2
Destination register / second source register

The Top module acts as the central decode and routing hub. On every clock cycle, the Programme block reads three bytes from program memory at the current PC address and presents them as op_code, op1, and op2. The Top module decodes op_code combinationally and asserts enable signals to exactly one functional unit per cycle. Results are written back to the register file or fed to the program counter on the next clock edge.

<img width="624" height="384" alt="image" src="https://github.com/user-attachments/assets/d4444ed6-0868-423d-9e46-b85e1727c422" />
