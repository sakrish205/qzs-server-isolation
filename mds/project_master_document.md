# Project Roadmap — QZS Vibration Isolator for Data Center Server Racks

## Phase 1: Validation & Verification (Week 1)
- [x] **Experiment 1 - Reproduce Carrella**
  - Scripts: `carrella_fig3_oblique_force.m` through `carrella_fig12_approx_error.m`
  - Output: 10 base validation figures at 600 DPI.
  - Verification: Numerical and analytical limits cross-checked against equations.
  - **Status:** ✅ Complete

- [x] **Experiment 2 — QZS Condition Verification**
  - Action: Verify QZS condition ($K_{total} \approx 0$) at equilibrium.
  - Inputs: $50$, $100$, $150$ kg server masses.
  - Pass Criteria: Total stiffness $< 1$ N/m.
  - **File:** `carrella_validation.m`
  - **Status:** ✅ Complete

---

## Phase 3: Static Parametric Study (Experiment 3)
**Purpose:** First major novel contribution. Natural frequency vs $\gamma$ for 50/100/150 kg racks.
**Standard:** ASHRAE A1-A3 mass range, ISO 10846 target fn < 1 Hz.
**File:** `carrella_experiment3_scaling.m`
**Output:** `results/carrella_exp3_scaling.png`
**Status:** ✅ Complete (600 DPI rendered)

---

## Phase 4: Dynamic Transmissibility (Experiment 4)
**Purpose:** Main novelty over Carrella. Analytical benchmark comparing QZS vs rubber mounts.
**Standard:** ISO 10846-1:2008. Pass: T < 0.1 across high frequency range.
**File:** `carrella_experiment4_transmissibility.m`
**Output:** `results/carrella_exp4_transmissibility.png`
**Status:** ✅ Complete (600 DPI rendered)

---

## Phase 5: IS 1893 Seismic Response (Experiment 5)
**Purpose:** Apply IS 1893 Zone III spectrum. Compare rack acceleration with/without QZS.
**Standard:** IS 1893 Part 1 (2016). Zone III PGA=0.16g, Imp.Factor=1.5.
**File:** `carrella_experiment5_seismic.m`
**Output:** `results/carrella_exp5_seismic.png` (0.5g damage threshold confirmed)
**Status:** ✅ Complete (600 DPI rendered)

---

## Phase 6: VC Criteria Mapping (Experiment 6)
**Purpose:** Convert rack velocity to BBN VC level. Target: VC-B (25 μm/s).
**Standard:** BBN Gordon 1999.
**File:** `carrella_experiment6_vc_mapping.m`
**Output:** `results/carrella_exp6_vc_mapping.png`
**Status:** ✅ Complete (600 DPI rendered)

---

## Phase 8: Belleville Washer Sizing (Experiment 8)
**Purpose:** Physical realisation using disc springs per DIN EN 16983.
**Material:** 51CrV4 spring steel. Optimized for 100kg rack payload.
**File:** `carrella_experiment8_belleville.m`
**Output:** `results/carrella_exp8_belleville.png`
**Status:** ✅ Complete (600 DPI rendered)

---

## Execution Infrastructure
- **Master Control:** `run_complete_suite.m` (Generates all 15 figures in one click)
- **Style Standard:** `carrella_style_header.m` (Enforces Times New Roman and Elsevier margins)
- **Export Engine:** `print_fig.m` (High-resolution 2000px wide PNG export)

---
*Project Status: Ready for Manuscript Submission*
