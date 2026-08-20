# RISC-V INT8 AI Accelerator

A 32-bit RISC-V processor core (RV32I) integrated with a hardware INT8 Multiply-Accumulate (MAC) accelerator for edge AI.

- **Developer:** Vinayreddy
- **Tools:** Verilog HDL, Icarus Verilog, GTKWave

### Run Simulation:
```powershell
iverilog -o sim_riscv.vvp alu.v control_unit.v instruction_memory.v pc_unit.v register_file.v int8_mac.v riscv_top.v tb_riscv_top.v
vvp sim_riscv.vvp
Start-Process gtkwave riscv_top_sim.vcd