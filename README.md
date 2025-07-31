# Priority-Based FIFO Verilog Implementation

## Overview

This project implements a priority-based FIFO (First-In First-Out) buffer using Verilog HDL, capable of storing and processing two levels of priority: high and low. It demonstrates how real-time systems can give precedence to urgent data while maintaining orderly processing of lower-priority inputs.The design uses two separate internal FIFOs for high and low priority data, and always services high-priority data first. This kind of buffer is essential in embedded systems, communication controllers, and CPU I/O scheduling.



## Features

- Implements dual-priority FIFO buffering with separate circular queues.

- Supports standard read_en and write_en handshaking interface.

- Automatically prioritizes high-priority data over low-priority data during read operations.

- FIFO depth and data width are fully parameterized for design scalability.

- Tested using GTKWave waveform viewer with a Verilog testbench and VCD output.

- Clean reset logic and real-time status flags (full, empty) for safe interfacing.
