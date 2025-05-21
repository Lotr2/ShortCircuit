# 8x8 Signed Serial-Parallel Multiplier on Basys 3 FPGA 🛠️

## Overview 📋
This project implements an 8-bit signed Serial-Parallel Multiplier (SPM) on the Basys 3 FPGA (Artix-7). It accepts two 8-bit signed numbers via toggle switches, performs sequential multiplication, and displays the decimal product on four 7-segment displays. Coded in Verilog, it uses a hybrid serial-parallel architecture, validated with Logisim Evolution and managed on GitHub.

## System Components ⚙️
- **Input Interface**: 16 slide switches (SW7–SW0: multiplier, SW15–SW8: multiplicand) for two’s complement inputs.
- **Control Unit (FSM)**: Manages data flow, timing, and signals (DONE LED: LD0).
- **SPM**: Executes shift-and-add for signed multiplication over 8 clock cycles, producing a 16-bit product.
- **BCD Converter**: Converts binary product to 5-digit BCD (-32,768 to 32,767).
- **7-Segment Display Driver**: Multiplexes BCD digits with scrolling via BTNL (left) and BTNR (right) buttons.
- **Control Signals**: BTNC starts multiplication; LD0 signals completion.

## Architecture 🗺️
- Input registers for multiplier and multiplicand.
- SPM with sign extension and accumulation.
- FSM for operation sequencing.
- Double Dabble BCD converter.
- 7-segment display with scroll support.

## Design & Simulation 🔍
- **Logisim**: Prototyped 4-bit SPM and 7-segment driver for data flow and timing.
- **Verilog Modules**:
  - `statemac.v`: FSM for state transitions and scrolling.
  - `spm.v`: Signed multiplication with CSADD/TCMP.
  - `doubledabble.v`: Binary-to-BCD conversion.
  - `seven_segment_driver.v`: Digit selection and encoding.
  - `scroll_control.v`: Button-based scrolling.
  - `top_module.v`: System integration.
- **RTL**: Synthesizable, modular code with synchronous resets, no latches.

## Testing 🧪
- **Simulation**: Testbenches verified cases (e.g., 12 × -3, -7 × -2, -128 × 127) and BCD conversion.
- **Hardware**: Synthesized on Vivado, tested on Basys 3 with switch inputs and button controls.

## Challenges & Solutions 🛡️
- **Signed Multiplication**: Fixed sign extension for negative numbers.
- **BCD Overflow**: Extended to 5-digit BCD with extra shift cycles.
- **Display Flickering**: Added clock divider for stable multiplexing.
- **Button Debouncing**: Implemented 3-cycle state latching.
- **Clock Misalignment**: Centralized clock divider in top module.

## GitHub Repository 📂
Contains Verilog files, Logisim circuits, testbenches, report PDF, block diagram, and README.  
[Link to Repository](#) (replace with actual URL).

## Team Contributions 👥
- **Mohamed Anan**: Designed SPM, Double Dabble, FSM, 7-segment driver, scrolling, testbenches; wrote report.
- **Mohamed Elsayed**: Built SPM in Logisim, debugged Verilog, configured XDC, tested hardware; wrote README.
- **Noor Elshahidi**: Developed 7-segment driver, FSM, and scrolling; debugged synthesis; wrote report.

## Usage ℹ️
1. Set multiplier (SW7–SW0) and multiplicand (SW15–SW8).
2. Press BTNC to start.
3. Wait for LD0 to light up.
4. Use BTNL/BTNR to scroll through the 5-digit decimal output.

## Conclusion 🎉
This project delivers a robust 8x8 signed SPM on Basys 3, with efficient Verilog design, BCD conversion, and user-friendly scrolling. It enhanced skills in FPGA design, Verilog, FSMs, and teamwork, leveraging Logisim and GitHub for validation.
