# QZS Vibration Isolator for Server Racks

This repository contains the complete MATLAB/Octave simulation engine and analysis suite for a Quasi-Zero-Stiffness (QZS) vibration isolator designed to protect high-density server racks under seismic excitations (IS 1893:2016 Zone III).

---

## 📖 Project Overview
High-Density server infrastructure is vulnerable to low-frequency HVAC hum and high-amplitude seismic shocks. Traditional linear isolation mounts suffer from a design trade-off between static load capability and low-frequency isolation. 

This project implements a **High-Static-Low-Dynamic-Stiffness (HSLDS)** passive mechanical isolator. By combining a positive-stiffness vertical spring with pre-compressed oblique springs, the system cancels the dynamic stiffness at the equilibrium position (QZS condition) to achieve:
- **Resonant Isolation Frequency:** ~0.5 Hz ($16\times$ reduction over rubber mounts).
- **Mass-Invariant Tuning:** The natural frequency remains constant across a $\pm$20% payload mass variation.
- **Seismic Mitigation:** Over 90% displacement attenuation under IS 1893:2016 Zone III accelerations.

---

## ⚡ Main Scripts & Suite Structure
- **`run_complete_suite.m`**: The master control script. Generates and saves all 20 figures (reproduction of seminal Carrella 2007 paper curves + advanced dynamic experiments) in one click.
- **`carrella_live_animation.m`**: Real-time "Digital Twin" simulation showing the physical response of springs and rack alongside scrolling displacement graphs under harmonic base excitation.
- **`carrella_validation.m`**: Validation suite to verify all numerical targets against analytical limits. (Generates `results/carrella_validation_report.md` confirming a 100% PASS rate).
- **`parameters.m`**: Unified configuration file for global design variables, payload masses, and plot styling standardizations.
- **`print_fig.m`**: Screen-capture export utility featuring automatic black-frame and glitch detection for high-fidelity PNG prints.

---

## 🚀 How to Run

### Prerequisite:
Open MATLAB or GNU Octave in the repository root folder.

### Run All Experiments:
Execute the master suite command:
```matlab
run_complete_suite
```
All generated high-resolution figures are saved directly to the `results/` folder.

### Run Live Digital Twin Animation:
Execute the animation script:
```matlab
carrella_live_animation
```
---
