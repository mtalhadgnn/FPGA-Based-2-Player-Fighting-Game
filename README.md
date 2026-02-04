FPGA-Based 2-Player Fighting Game (Verilog)

This project is a real-time 2D fighting game implemented entirely in Verilog HDL and deployed on the Terasic DE1-SoC FPGA board. It demonstrates FSM-based digital system design, VGA graphics generation, hardware hit detection, and real-time game logic running directly on FPGA hardware.

Project Overview

This project was developed as an EE314 Digital Design end-term project at Middle East Technical University. The objective was to design and implement a complete hardware game system using Verilog and display player interactions in real time through VGA output.

The game includes:

- Player vs Player (PvP) mode  
- Player vs Bot (PvE) mode using LFSR-based AI  
- Normal and directional attack mechanics  
- Blocking, hit stun, and block stun  
- Health and block bars  
- Countdown and match timer  
- VGA visual output  
- LED and HEX display indicators on the FPGA  

All logic is implemented in hardware. No CPU or software game engine is used.

System Architecture

The system is composed of multiple hardware modules:

Finite State Machines (FSMs)

Four FSMs form the core game logic:

- Player 1 FSM: movement, attacks, blocking, state transitions  
- Player 2 FSM: same logic for the second player  
- Bot FSM: AI behavior using Linear Feedback Shift Register (LFSR)  
- Hit Detection FSM: detects hits, blocks, and applies damage  

Attacks are divided into three phases: Startup, Active, and Recovery. Player movement is restricted during recovery frames to simulate realistic fighting game mechanics.

Hit Detection Module

Combat outcomes are determined by checking the overlap between a player's hitbox and the opponent's hurtbox. The system uses comparison logic (> , < , AND operations) to determine hits and blocks. This module acts as the referee of the game.

Clock System

- 50 MHz FPGA base clock  
- 25 MHz VGA controller clock  
- 60 Hz game frame clock  
- Key-controlled slow clock for debugging  

Clock dividers generate the required frequencies.

Display System

Two visual rendering methods are used:

- Bitmap graphics for background visuals  
- .hex sprite files for characters and UI elements  

Sprite data is stored as 3-3-2 RGB pixel values and loaded using $readmemh. A priority-based coloring logic ensures correct visual layering.

Gameplay Mechanics

- Move left and right  
- Attack and directional attack  
- Block system  
- Hit stun and block stun  
- Health reduction  
- Match timer  
- Game over screen  

Hardware Used

- Terasic DE1-SoC FPGA board  
- VGA monitor  
- Onboard LEDs and HEX displays  

Project Structure

/src  
    player_fsm.v  
    bot_fsm.v  
    hit_detection.v  
    vga_driver.v  
    display_modules.v  

/assets  
    sprites.hex  
    background.hex  

/docs  
    project_report.pdf  

Challenges Solved

- Reduced compilation time by scaling 640×480 backgrounds  
- Implemented display priority logic to prevent sprite overlap  
- Added FSM reset to prevent health carry-over between games  
- Designed top-level mode control (menu, countdown, game, game over)

Results

The system successfully implements menu display, countdown, character sprites, health and block bars, timer display, and game over screen. The game runs in real time on FPGA hardware.

Technologies Used

- Verilog HDL  
- FPGA digital design  
- Finite State Machine architecture  
- VGA graphics  
- LFSR for AI behavior  

