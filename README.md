# spi-fsm-controller

# FSM-Based SPI Communication Controller


## Overview
This project implements an FSM-based SPI Master Controller using Verilog HDL for synchronous serial communication.


## Features
- FSM-controlled SPI transmission
- MOSI serial communication
- SPI clock generation
- Active-low chip select
- Parity-bit generation
- Synchronous operation
- Asynchronous active-high reset
- Waveform-based simulation verification


## Technologies Used
- Verilog HDL
- SPI Protocol
- FSM Design
- ModelSim / Vivado Simulator


## FSM States
```text
IDLE → LOAD → TRANSFER → PARITY → DONE
```

## Project Structure
```text
spi-fsm-controller/
│
├── rtl/
│   └── spi_master_fsm.v
│
├── tb/
│   └── tb_spi_master.v
│
├── spi_waveform.png
│
├── SPI_Master_FSM_Project_Report.pdf
│
└── README.md
```


## Simulation
The waveform verifies:
- FSM state transitions
- SPI clock generation
- MOSI serial transmission
- Active-low chip select operation
- Transmission completion behavior
