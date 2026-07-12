# spi-fsm-controller

# FSM-Based Multi-Slave SPI Communication Controller

A Verilog HDL implementation of an **FSM-based SPI (Serial Peripheral Interface) communication controller** featuring **one SPI Master and two SPI Slaves**. The design performs serial data transmission with **even parity generation and verification**, supports **slave selection through active-low chip-select**, and implements **ACK/NACK feedback** via the MISO line.

---

## Overview

This project demonstrates the RTL implementation of a complete SPI communication system using Finite State Machines (FSMs). The master transmits an 8-bit data packet followed by an even parity bit to the selected slave. The slave verifies the received parity and returns an acknowledgement (ACK) or negative acknowledgement (NACK) through the MISO line.

The project is entirely developed in **Verilog HDL** and verified using **Xilinx Vivado Simulation (XSim)**.

---

## Features

- FSM-Based SPI Master Controller
- Two SPI Slave Modules
- Active-Low Chip Select Logic
- Shared MOSI and SCLK Bus
- 2:1 MISO Multiplexer
- 8-bit Serial Data Transmission (MSB First)
- Even Parity Generation and Verification
- ACK/NACK Feedback Mechanism
- Hierarchical RTL Design
- Simulation-Based Functional Verification

---

## System Architecture

```
                 +----------------------+
                 |      SPI MASTER      |
                 |  FSM + Shift Reg     |
                 +----------------------+
                    |      |       |
                 MOSI     SCLK    CS[1:0]
                    |      |       |
          -------------------------------
          |                             |
   +---------------+             +---------------+
   |   SPI Slave0  |             |   SPI Slave1  |
   | FSM+Shift Reg |             | FSM+Shift Reg |
   +---------------+             +---------------+
          |                             |
          +---------- MISO -------------+
                     |
                 2:1 Multiplexer
                     |
               Master MISO Input
```

---

## Master FSM

The SPI Master consists of six states:

| State | Description |
|--------|-------------|
| IDLE | Waits for start signal |
| LOAD | Loads transmit data and computes parity |
| TRANSFER | Serially transmits 8 data bits |
| PARITY | Transmits parity bit |
| FEEDBACK | Waits for slave ACK/NACK |
| DONE | Completes transaction |

---

## Slave FSM

Each SPI Slave consists of four states:

| State | Description |
|--------|-------------|
| IDLE | Waits for chip select |
| RECEIVE | Receives serial data bits |
| PARITY_CHECK | Verifies received parity |
| DONE_STATE | Sends ACK/NACK through MISO |

---

## Project Structure

```
spi-fsm-controller/
│
├── rtl/
│   ├── spi_master_fsm.v
│   ├── spi_slave.v
│   └── spi_top.v
│
├── tb/
│   └── tb_spi_top.v
│
├── waveforms/
│   └── spi_waveform.png
│
├── docs/
│   └── report.pdf
│
└── README.md
```

---

## Simulation

### Test Case 1

- Slave Selected : Slave 0
- Data : 0xA5
- ACK : 1
- Parity Error : 0

### Test Case 2

- Slave Selected : Slave 1
- Data : 0x3C
- ACK : 1
- Parity Error : 0

Both transactions completed successfully with correct parity verification and data reception.

---

## Simulation Waveform

The waveform demonstrates:

- Reset initialization
- Slave selection
- Serial data transmission
- Parity bit transmission
- ACK generation
- Transaction completion

> Simulation waveform available in the **waveforms/** directory.

---

## Tools Used

- Verilog HDL
- Xilinx Vivado 2016.4
- XSim Simulator

---

## Key Design Concepts

- Finite State Machine (FSM)
- SPI Protocol
- Shift Registers
- Serial Communication
- Parity Generation & Checking
- Active-Low Chip Select
- Hierarchical RTL Design
- Digital System Design

---

## Future Improvements

- Configurable SPI Modes (CPOL/CPHA)
- Variable Data Width Support
- Configurable Clock Divider
- Multi-byte Packet Transmission
- FIFO-Based Data Buffering
- Interrupt-Based Transaction Completion

---

## Author

**Varsha R S**

Electronics and Communication Engineering  
PSG Institute of Technology and Applied Research

---

## License

This project is intended for educational and academic purposes.
