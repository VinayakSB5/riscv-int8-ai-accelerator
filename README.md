# ⚡ RISC-V INT8 AI Accelerator

A 32-bit RISC-V processor core (RV32I subset) integrated with a dedicated hardware **INT8 Multiply-Accumulate (MAC)** accelerator for edge AI inference.

- **Developer:** Vinayreddy
- **Tools:** Verilog HDL, Icarus Verilog, GTKWave

---

## 🏗️ Hardware Architecture & Verification

### 1. Full Top-Level Core Execution (`riscv_top.v`)
Executes instructions end-to-end, showing register writeback for both standard arithmetic and custom MAC instructions.
![Top-Level Core](assets/top_waveform.png)

---

### 2. INT8 MAC Hardware Accelerator (`int8_mac.v`)
Multiplies signed 8-bit activations and weights, accumulating into a 32-bit register.
![INT8 MAC Simulation](assets/mac_waveform.png)

---

### 3. Instruction Fetch & Control Decode (`pc_unit.v`, `control_unit.v`)
Demonstrates PC sequencing, instruction ROM fetches, and control line decoding.
![Fetch & Decode Simulation](assets/fetch_waveform.png)

---

### 4. Datapath & ALU Logic (`alu.v`, `register_file.v`)
Verifies immediate sign extension, 32-bit ALU operations, and zero detection.
![ALU Datapath Simulation](assets/datapath_waveform.png)

---

## 🚀 How to Run Simulations

```powershell
# Top-Level Core Simulation
iverilog -o sim_top.vvp alu.v control_unit.v instruction_memory.v pc_unit.v register_file.v int8_mac.v riscv_top.v tb_riscv_top.v
vvp sim_top.vvp
gtkwave riscv_top_sim.vcd

# Dedicated INT8 MAC Unit Test
iverilog -o sim_mac.vvp int8_mac.v tb_int8_mac.v
vvp sim_mac.vvp
gtkwave mac_waveform.vcd