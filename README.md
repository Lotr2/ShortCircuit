# 8×8 Signed Serial-Parallel Multiplier (SPM)

A sequential 8-bit signed Serial-Parallel Multiplier implemented on the Basys-3 (Artix-7) FPGA board. One operand (multiplier) is shifted in bit-by-bit (serial), the other (multiplicand) is loaded in parallel. The product is a 16-bit signed value, displayed in decimal on four 7-segment displays, with user controls for start, scroll and done indication.

---

## Features

- Load two 8-bit signed inputs via switches:  
  - **SW7–SW0**: Multiplier  
  - **SW15–SW8**: Multiplicand  
- Press **BTNC** to start multiplication  
- **LD0** lights when computation is complete  
- **16-bit signed product** (range –32768…+32767) displayed in decimal:  
  - Leftmost digit: sign (‘–’ or blank)  
  - Three middle digits: current window of the magnitude  
  - Scroll through up to **5 decimal digits** (magnitude) using **BTNL**/ **BTNR**

---
