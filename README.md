8x8 Signed Serial-Parallel Multiplier on Basys 3 FPGA
Introduction
This project implements an 8-bit signed Serial-Parallel Multiplier (SPM) on the Basys 3 FPGA board (Artix-7 FPGA). The system accepts two 8-bit signed binary numbers via toggle switches, performs sequential multiplication, and displays the signed product in decimal on four 7-segment displays. The design balances hardware efficiency and performance using a hybrid serial-parallel architecture, implemented in Verilog, with validation through Logisim Evolution and version control on GitHub.
System Overview
The system comprises the following components:

Input Interface: Uses 16 slide switches (SW7–SW0 for multiplier, SW15–SW8 for multiplicand) to input two’s complement 8-bit signed numbers.
Control Unit (FSM): Manages data flow, timing, and control signals for operand loading, multiplication, sign correction, and output signaling via a DONE LED (LD0).
Serial-Parallel Multiplier (SPM): Executes a shift-and-add algorithm for signed multiplication, handling two’s complement arithmetic over 8 clock cycles to produce a 16-bit product.
BCD Converter (Double Dabble): Converts the 16-bit binary product to a 5-digit BCD format, supporting values from −32,768 to 32,767.
7-Segment Display Driver: Multiplexes BCD digits across four 7-segment displays, with dynamic updates for scrolling.
Scroll Mechanism: Enables navigation of the 5-digit result using BTNL (left) and BTNR (right) buttons, with the leftmost digit reserved for the sign.
Control Signals: BTNC initiates multiplication, and LD0 indicates completion.

Block Diagram
The system architecture includes:

Input registers for multiplier and multiplicand.
SPM unit with sign extension and accumulation.
Controller FSM for operation sequencing.
Binary-to-BCD converter (Double Dabble).
7-segment display interface with scroll support.

Component Design and Simulation
Serial-Parallel Multiplier (Logisim)
A 4-bit signed SPM was simulated in Logisim Evolution to prototype data flow and control timing. The multiplier is processed serially, while the multiplicand is loaded in parallel. Over 8 clock cycles, the system performs conditional additions, followed by product output starting at the 9th cycle. Sign extension ensures correct handling of negative numbers.
7-Segment Display Driver (Logisim)
The display driver processes 5-digit BCD input, multiplexing three digits at a time based on scroll state. Clock dividers manage refresh timing, and a counter tracks button states for scrolling.
Verilog Implementation
Modules

statemac.v: FSM for state transitions (loading, multiplying, finishing) and scroll control.
spm.v: Implements signed multiplication with CSADD and TCMP submodules.
doubledabble.v: Binary-to-BCD conversion using the Double Dabble algorithm.
seven_segment_driver.v: Manages digit selection and 7-segment encoding.
scroll_control.v: Handles BTNL/BTNR inputs for scrolling.
top_module.v: Integrates all submodules.

RTL Guidelines

Synthesizable RTL with non-blocking (<=) and blocking (=) assignments.
Synchronous resets and clear FSM encoding.
No latches or combinational loops.
Modular, commented code.

Testing and Validation
Simulation

Testbenches validated modules for cases like 12 × -3, -7 × -2, and edge cases (-128 × 127).
FSM timing and BCD conversion (0 to 32,767) were verified.

On-Board Testing

Synthesized using Vivado and deployed on Basys 3.
Inputs set via SW0–SW15, computation triggered by BTNC, and output scrolled using BTNL/BTNR.

Challenges and Solutions

Signed Multiplication Misinterpretation:
Issue: Incorrect results for negative numbers due to improper sign extension.
Solution: Added explicit sign extension for the multiplicand and accumulator.


BCD Overflow:
Issue: Truncation of results > 9999.
Solution: Extended BCD registers to 5 digits and increased shift cycles.


Display Synchronization:
Issue: Flickering due to fast multiplexing.
Solution: Added a clock divider to slow refresh rate, using a counter (0–3) for stable digit updates.


Button Debouncing:
Issue: Multiple scrolls from single button presses.
Solution: Implemented debounce logic with 3-cycle state latching.


Clock Misalignment:
Issue: Inconsistent clock frequencies causing race conditions.
Solution: Centralized clock divider in top module for unified timing.



GitHub Repository
The repository contains:

Verilog source files
Logisim circuit files
Testbenches
Report PDF
Block diagram
README with usage instructions

Link to GitHub Repository (Replace with actual repository URL)
Team Contributions

Mohamed Anan:
Logisim: Designed Double Dabble circuit, SPM output loader, and integrated sub-circuits.
Verilog: Implemented SPM, Double Dabble, FSM, 7-segment driver, scrolling, and testbenches.
Wrote project report.


Mohamed Elsayed:
Logisim: Designed signed SPM with SIPO register and validated multiplication logic.
Verilog: Debugged implementation, configured XDC file, and conducted hardware testing.
Wrote README.


Noor Elshahidi:
Logisim: Built 7-segment display driver and verified scrolling.
Verilog: Ran full system on FPGA, debugged synthesis errors, and ensured clock synchronization.
Managed GitHub repository and sketched block diagram.



Conclusion
This project successfully delivered a signed 8x8 SPM on the Basys 3 FPGA, handling signed multiplication and displaying results in decimal. Key achievements include robust Verilog design, efficient BCD conversion, and user-friendly scrolling. The project enhanced skills in FPGA design, Verilog coding, FSM implementation, and team collaboration, with Logisim and GitHub facilitating validation and coordination.
Usage Instructions

Set multiplier (SW7–SW0) and multiplicand (SW15–SW8).
Press BTNC to start multiplication.
Wait for LD0 to indicate completion.
Use BTNL/BTNR to scroll through the 5-digit decimal output.

