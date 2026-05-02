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

Each instruction is 3 bytes:

| Byte | Description |
|------|-------------|
| op_code | Operation and unit select |
| op1 | Source / immediate |
| op2 | Destination / operand |

The op_code byte is further subdivided as follows:
-	Bit [7]: mode select - 0 = calculation mode, 1 = move (MOV) mode
-	Bits [5:4]: unit select (calculation mode only) - 00 = ALU, 01 = Conditional, 10 = Xtra, 11 = Stack
-	Bits [3:0]: operation code within the selected unit
-	Bit [6]: unused in the current revision (reserved for future use)

## Datapath Summary
The Top module acts as the central decode and routing hub. On every clock cycle, the Programme block reads three bytes from program memory at the current PC address and presents them as op_code, op1, and op2. The Top module decodes op_code combinationally and asserts enable signals to exactly one functional unit per cycle. Results are written back to the register file or fed to the program counter on the next clock edge.

<img width="624" height="384" alt="image" src="https://github.com/user-attachments/assets/d4444ed6-0868-423d-9e46-b85e1727c422" />

## Module Overview

- **ALU** – Performs arithmetic and logical operations (signed and unsigned) and updates flags.  
- **Register File** – 8 general-purpose registers with asynchronous read and synchronous write.  
- **Program Counter** – Advances instruction address and handles jumps/branches.  
- **Control Logic** – Decodes opcode and enables the appropriate execution unit.  
- **Conditional Unit** – Evaluates branch conditions based on flag values.  
- **Stack** – Supports push/pop operations and return address handling.  
- **RAM** – 256-byte data memory with register-indirect addressing.  

## Simulation

The design has been verified using **Xilinx Vivado** through:

- Functional simulation of individual modules  
- Waveform-based verification  
- Execution of a test program covering arithmetic, branching, memory, and stack operations  

## Future Work

- Extend architecture to 16-bit  
- Improve instruction encoding efficiency  
- Add hardware CALL instruction  
- Explore multi-cycle / pipelined design  
