## ✨ 4x4 2D Fast Fourier Transform (FFT) in Verilog

This project implements a **4x4 Two-Dimensional Fast Fourier Transform (2D-FFT)** using the Verilog Hardware Description Language. It's designed to be a fully functional, high-speed circuit that processes data sequentially.

The design uses **16-bit fixed-point** numbers to represent both real and complex data.

---

## 🚀 What It Does

The 2D-FFT is used heavily in image processing and signal analysis to convert spatial (or time) data into frequency information. Our system processes a 4x4 matrix of real numbers (16 total inputs) and calculates the complex frequency spectrum.

The calculation is performed in two stages, known as the **Row-Column method**:

1.  **Row FFTs (Stage 1):** The circuit first calculates four parallel 4-point FFTs across the rows of the input data.
2.  **Column FFTs (Stage 2):** It then calculates four parallel 4-point FFTs across the resulting columns to get the final 2D result.
    

---

## 💻 Running the Simulation (Testbench)

To verify the circuit's correct operation, you can run the provided testbench (`tb_fft_4x4_2d.v`) in any standard Verilog simulator (like Vivado, ModelSim, or QuestaSim).

### Simulation Steps

1.  **Start Signal:** The simulation begins by asserting the **`start`** signal for one clock cycle.
2.  **Input Data Loading:** The 16 input data points are loaded sequentially over **four clock cycles** (4 data points per cycle) . This is controlled by the FSM in the Control Unit.
3.  **Completion:** The testbench waits until the top-level **`done`** signal asserts high. This signal indicates that the final 16 real and 16 imaginary outputs are ready.

| Block | CU State Active | Clock Cycle | Input Data (`din_real_0` to `din_real_3`) |
| :--- | :--- | :--- | :--- |
| **Block 1** | `INPUT1` | 1 | [cite_start]$1, 2, 3, 4$ [cite: 53] |
| **Block 2** | `INPUT2` | 2 | [cite_start]$5, 6, 7, 8$ [cite: 55, 56] |
| **Block 3** | `INPUT3` | 3 | [cite_start]$9, 10, 11, 12$ [cite: 57, 58] |
| **Block 4** | `INPUT4` | 4 | [cite_start]$13, 14, 15, 16$ [cite: 59, 60] |

---

## 🏗️ Core Components

The overall design is logically divided into Control and Data sections, orchestrated by the top module:

### 1. Top Level: `fft_4x4_2d.v`

This is the main entry point. It instantiates and connects the **Control Unit (CU)**, which manages timing, to the **Data Unit (DU)**, which handles the actual calculations.

### 2. The Brain: Control Unit (`fft_control_unit.v`)

This module implements a **5-state FSM** (IDLE, INPUT1, INPUT2, INPUT3, INPUT4, FINALIZE) hat manages the input sequence:
* It asserts the **`data_valid`** signal along with the appropriate **`enable_block1` to `enable_block4`** signals to sequence the data loading.
* It transitions to the `FINALIZE` state to wait for the calculation to complete (`fft_done` from DU).

### 3. The Calculation Engine: Data Unit (`fft_data_unit.v`)

This module holds the data registers (`stage1_real`) and performs the two stages of FFT calculation using the butterfly units .
* The `fft_data_unit` asserts the **`fft_done`** signal one cycle after the final input block is loaded, indicating the combinatorial results are ready to be latched to the output registers.

### 4. Calculation Modules (Butterflies)

* **`fft_4point_1.v`**: Used for Stage 1 (Row FFTs) [cite: 107-110]. It only processes **real inputs** and produces complex outputs (real and imaginary).
* *`fft_4point_2.v`**: Used for Stage 2 (Column FFTs). This module processes **complex inputs** (both real and imaginary) and performs the final butterfly calculations.