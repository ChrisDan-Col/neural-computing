# Computational Neuroscience: Biophysical Neuron and Network Models

This project implements a series of computational neuroscience simulations of increasing complexity, from a single spiking neuron to multi-neuron networks with synaptic dynamics.

## What It Does

### Part 1A — Leaky Integrate-and-Fire Neuron
Simulates a single LIF neuron with biophysically realistic parameters:
- Membrane time constant τ_m = 10 ms, resistance R = 10 MΩ
- Resting potential −65 mV, spike threshold −50 mV, reset −70 mV
- Refractory period 5 ms

The simulation applies constant and stepped input currents, integrates the membrane voltage ODE using the Euler method, detects spikes, and plots voltage traces, spike trains, and F-I (frequency-current) curves.

### Part 1B — Hodgkin-Huxley Model
Implements the full conductance-based Hodgkin-Huxley model with sodium, potassium, and leak channels. Simulates action potential generation, channel gating variable dynamics (m, h, n), and refractory properties under different current stimuli.

### Part 2 — Dendrites and Cable Theory
Models passive cable propagation of voltage along a dendritic compartment. Numerically solves the cable equation to show how signal attenuation varies with cable length, diameter, and membrane resistance. Compares passive vs. active dendritic behaviour.

### Part 3 — Networks and Cognition
Simulates a small network of interconnected neurons with defined synaptic weights. Explores emergent firing patterns, synchronisation, and the effect of connectivity on network dynamics.

## Data

No external dataset. All simulations use mathematically defined biophysical parameters and synthetic current stimuli.

## Tools

MATLAB (ODE Euler integration, plotting functions)

---

**Module:** Neural Computing — University of Lincoln, School of Computer Science  
**Submitted as:** Assessment 1 | Academic Year 2025/2026
