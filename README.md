# Universality of power-law behavior in macroevolution: An Assembly Theory approach to dinosaur size distributions

This repository contains the official Fortran 95 source code, processed datasets, and original MCMC posterior outputs associated with the paper **"Universality of power-law behavior in macroevolution: An Assembly Theory approach to dinosaur size distributions"** (Avila Araya, 2026). 

The project applies **Assembly Theory** and a custom **Metropolis–Hastings Markov chain Monte Carlo (MCMC)** algorithm within a Bayesian framework to model upper-bound dinosaur body-mass distributions and test for universal scale-free regularities.

---

## 🔬 Project Overview

Macroevolutionary size distributions are analyzed using an untruncated discrete power-law framework (\(M(x) \propto x^{-k}\)) bounded by a dynamically variable rank cutoff threshold (\(N\)). By fitting four distinct dinosaur datasets, this suite identifies a shared universality class where the scaling exponent remains tightly constrained (\(k \simeq 0.44–0.50\)) across disparate taxonomic groups while the upper rank limit breaks down at a critical physiological boundary of order \(10^3\text{ kg}\).

---

## 💾 Raw Data Provenance & Sorting Logic

### 1. Primary Source
The raw paleontological measurements used in this study were originally obtained from the open-access Zenodo data repository corresponding to the landmark publication:
> **R. B. Benson, G. Hunt, M. T. Carrano, and N. Campione**, *Cope’s rule and the adaptive landscape of dinosaur body size evolution*, Palaeontology 61, 13 (2018).

### 2. Dataset Arrangement & Ranking Framework
Inside every text file located within the `/Data` directory, **specimens are systematically ordered from largest to smallest body mass**. 
* **Row-to-Rank Mapping:** Because the files are sorted in strict descending order, the mathematical hierarchical **ranking position (\(x\))** analyzed throughout the paper maps directly onto the text document's active **data row index** (excluding the first row string header).
* Therefore, Row 2 (the first entry) denotes the absolute apex giant (\(x = 1\)), Row 3 denotes rank (\(x = 2\)), and so forth, establishing a direct connection between physical text lines and the discrete rank equations.

---

## 📂 Repository Structure

The project repository is split into three core functional modules:

```text
├── Code/          # F95 source codes for the MCMC simulation engines
├── Data/          # Cleaned rank-ordered specimen text files (MCMC inputs)
└── Results/       # Preserved posterior probability outputs used in the paper
```

### 1. `/Code` — MCMC Simulation Engines
Contains the independent Fortran 95 simulation tools optimized per data slice to explore the parameter space vector \(\hat{\theta} = (A, k, N)\):
* `powerLawDino.f95` — Core script targeting the full baseline compilation (\(N=524\)).
* `powerLawDinoO.f95` — Target configuration slice for *Ornithischia* (\(N=136\)).
* `powerLawDinoS.f95` — Target configuration slice for *Sauropodomorpha* (\(N=132\)).
* `powerLawDinoT.f95` — Target configuration slice for *Theropoda* (\(N=256\)).

### 2. `/Data` — Specimen Inputs
Contains space-separated raw variables formatted as `[Taxon] [Mass (kg)] [Log10 Deviation Error]`:
* `ListaGrado1.txt` — Full aggregate dataset (\(524\) adult specimens).
* `ListaGrado2_o.txt` — *Ornithischia* clade subset (\(136\) specimens).
* `ListaGrado2_s.txt` — *Sauropodomorpha* clade subset (\(132\) specimens).
* `ListaGrado2_t.txt` — *Theropoda* clade subset (\(256\) specimens).

### 3. `/Results` — Data Preservation Logs
Preserves the post-burn-in parameter files mapped at every accepted state freeze across \(100,000\) loop generations:
* `posteriorDino.txt`, `posteriorDinoO.txt`, `posteriorDinoS.txt`, `posteriorDinoT.txt`.
* **Data Log Format:** Each row contains 4 fields: `[M1 (Scale Constant)]` `[Q (Exponent)]` `[Num (Sample Boundary)]` `[postNorm (Normalized Likelihood)]`.

---

## 🚀 Quick Start & Replication Guide

### Prerequisites
Ensure you have a modern Fortran compiler installed (e.g., GNU Fortran `gfortran` or Intel `ifort`).

### Step 1: Link Data and Code
The compiled Fortran binaries look for input files within their active execution pathway. For standalone runs, copy or symlink the files inside `/Data` into your working directory.

### Step 2: Compile & Execute
To replicate the primary dataset modeling loop (`powerLawDino`), run the following terminal sequence:

```bash
# Compile the source script using gfortran
gfortran Code/powerLawDino.f95 -o powerLawDino

# Execute the simulation engine (Requires ListaGrado1.txt in current folder)
./powerLawDino
```

### Step 3: Interpret Console Outputs
During execution, the console outputs live diagnostic measurements verifying MCMC constraints:
* **Acceptance Rate (%):** Verifies exploratory efficiency (optimally operating within \(19\%\text{ -- }28\%\)).
* **Statistical Cuts:** Reports normalized posterior boundary slices matching the paper's confidence thresholds (\(1\sigma = 68.3\%\), \(2\sigma = 95.4\%\), \(3\sigma = 99.7\%\)).

---

## 📈 Paper Visualizations and Analysis

The datasets preserved under `/Results` can be directly mapped using plotting frameworks like Gnuplot or Python (Matplotlib) to reproduce the paper's critical figures:
* **Joint Posterior Profiles (e.g., Fig. 5a):** Plot Column 2 (\(Q\), structural exponent) against Column 3 (\(Num\), size range) to render the multi-layered bounding confidence contours.
* **Marginal PDFs:** Generate histograms using Column 4 (`postNorm`) as a relative probability weight vector to isolate parameter distribution peaks.

---

## ✒️ Citation Reference

If you leverage this software infrastructure, dataset adjustments, or mathematical frameworks in your research, please cite the primary publication:

```text
Avila Araya, K. A. (2026). Universality of power-law behavior in macroevolution: 
An Assembly Theory approach to dinosaur size distributions. 
School of Physics, Universidad de Costa Rica.
```
================================================================================

