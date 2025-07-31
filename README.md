# 🎮 VGA Obstacle Game – Verilog Project

## 📌 Project Summary

This project implements a simple real-time obstacle-avoidance game on a VGA display using an FPGA (Basys3 board). A player-controlled **circle** moves on the screen and must avoid **three vertical moving obstacles**. The display is generated in **Full HD resolution (1920x1080)**.

---

## 🔧 Features

### ✅ VGA Display (1920x1080)
- The screen is generated using a 148.5 MHz clock.
- Synchronization signals (`h_sync`, `v_sync`) are generated to drive the VGA monitor.
- All drawing is pixel-based: background, obstacles, and the moving circle.

### 🎮 User Controls
- The circle is controlled using the four directional buttons:
  - `btnL` – move left
  - `btnR` – move right
  - `btnU` – move up
  - `btnD` – move down
- A reset signal centers the circle on the screen.

### 🚧 Moving Obstacles
- Three vertical obstacles move from **right to left**.
- Each obstacle has a **gap** (opening) at a random vertical position.
- Obstacles reappear on the right after exiting the screen.
- Obstacles have fixed spacing, created using `DELAY` parameters.

### 💥 Collision Detection
- The game detects when the circle overlaps an obstacle (excluding the gap).
- On collision:
  - The circle changes color.
  - The game stops responding to movement (collision signal can be used to disable control logic).

### 🕑 Timing Control
- A **clock divider** slows down the movement of obstacles (e.g., 1 tick every 0.5 seconds).
- Obstacle positions are updated only on this slower tick.

---

## 🔁 System Workflow

1. **Clock Generation**  
   A PLL converts the input clock to 148.5 MHz for VGA timing.

2. **User Input**  
   Button presses are debounced and edge-detected to trigger circle movement.

3. **Circle Control**  
   The player moves the circle using direction buttons. Movement is constrained within screen boundaries.

4. **Obstacle Movement**  
   Three obstacles move horizontally. Each obstacle has a gap the circle can pass through.

5. **Collision Logic**  
   The VGA module checks if the circle touches any obstacle (excluding the gap) and sets a collision flag.

6. **Visual Output**  
   The screen is updated at full resolution with the circle, obstacles, and background colors.

---

## ✅ Implementation Notes

- All movement and display logic is synchronous with the pixel clock.
- Coordinates are stored as 11-bit signed numbers (`[10:0]` or `[11:0]`) to cover the full resolution.
- The circle's radius is fixed and compared with obstacle positions using rectangle logic (no actual circle formula).

---

## 📦 Files Overview

- `topp.v` – Main module: connects all components
- `vga_sync.v` – VGA signal generation + drawing logic
- `controller_patrat.v` – Circle position controller
- `obstacol.v` – Individual obstacle module
- `clk_divizor.v` – Clock divider to slow obstacle movement
- `detector_front.v` – Debounce and edge detection for buttons

---

## 🧪 Simulation & Testing

You can simulate each module (especially `vga_sync` and `controller_patrat`) using ModelSim:
- Apply button pulses
- Observe circle movement
- Check obstacle positions over time
- Verify the `coliziune` signal when objects overlap

---

## 🛠 Future Improvements

- Randomize the vertical position of the obstacle gaps
- Add score or time survived
- Implement restart button after collision
- Add sound effects or animations

---

## Demo





Uploading WhatsApp Video 2025-07-31 at 12.04.52.mp4…

