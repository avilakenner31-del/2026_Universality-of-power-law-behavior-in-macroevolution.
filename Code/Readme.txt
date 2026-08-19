================================================================================
                    DINOSAUR ANALYSIS SUITE - FORTRAN TOOLS
================================================================================

This suite contains four independent Fortran programs that implement a Markov 
Chain Monte Carlo (MCMC) algorithm using the Metropolis-Hastings method. Each 
program targets a different dinosaur dataset variation to estimate the posterior 
distribution of a power-law model ($M = M_1 \cdot x^{-Q}$).

--------------------------------------------------------------------------------
1. SYSTEM REQUIREMENTS & COMPILATION
--------------------------------------------------------------------------------
* Compiler: Any standard Fortran compiler (e.g., gfortran, Intel ifort).
* Compilation: Compile each program individually using your terminal:
  
  gfortran powerLawDino.f95 -o powerLawDino
  gfortran powerLawDinoO.f95 -o powerLawDinoO
  gfortran powerLawDinoS.f95 -o powerLawDinoS
  gfortran powerLawDinoT.f95 -o powerLawDinoT

--------------------------------------------------------------------------------
2. DATA INPUT FILE SPECIFICATIONS
--------------------------------------------------------------------------------
Every program requires its corresponding input file to be present in the execution 
directory. The files must follow this structured text format:
* Line 1: Header line (automatically skipped by the program).
* Remaining Lines: [Dinosaur_Name] [Mass_Data] [Mass_Deviation] (Space-separated).

Program-specific data specifications:
* Program: `powerLawDino`  | File: 'ListaGrado1.txt'   | Entries (N): 524
* Program: `powerLawDinoO` | File: 'ListaGrado2_o.txt' | Entries (N): 136
* Program: `powerLawDinoS` | File: 'ListaGrado2_s.txt' | Entries (N): 132
* Program: `powerLawDinoT` | File: 'ListaGrado2_t.txt' | Entries (N): 256

--------------------------------------------------------------------------------
3. MCMC PARAMETERS AND HYPERPARAMETERS
--------------------------------------------------------------------------------
All programs execute 100,000 sampling steps (`stps=100000`) and utilize a 
Box-Muller transform for Gaussian proposal generation. 

Variance hyperparameters vary across versions to tune proposals:
* `powerLawDino`  -> devQ = sqrt(0.002), devM = sqrt(10000.), devN = sqrt(100.)
* `powerLawDinoO` -> devQ = sqrt(0.002), devM = sqrt(10000.), devN = sqrt(50.)
* `powerLawDinoS` -> devQ = sqrt(0.002), devM = sqrt(10000.), devN = sqrt(50.)
* `powerLawDinoT` -> devQ = sqrt(0.002), devM = sqrt(10000.), devN = sqrt(50.)

--------------------------------------------------------------------------------
4. SUITE RUNNING INSTRUCTIONS
--------------------------------------------------------------------------------
To run any of the compiled binaries, execute them in your terminal environment:

   ./powerLawDino
   ./powerLawDinoO
   ./powerLawDinoS
   ./powerLawDinoT

--------------------------------------------------------------------------------
5. OUTPUTS GENERATED
--------------------------------------------------------------------------------
Each program independently generates two classes of statistical outputs:

A. Post-Burn-In Sample Output Files
   Saves parameter chains for steps where the condition (20 * step > 100,000) 
   is met to discard the initial burn-in period.
   * `powerLawDino`  generates -> 'posteriorDino.txt'
   * `powerLawDinoO` generates -> 'posteriorDinoO.txt'
   * `powerLawDinoS` generates -> 'posteriorDinoS.txt'
   * `powerLawDinoT` generates -> 'posteriorDinoT.txt'
   
   File Columns: [M1 Parameter] [Q Parameter] [Num Samples] [Normalized Posterior]

B. Live Console Summary (Terminal View)
   * Acceptance Rate (%): Ratio of successfully accepted MCMC parameter updates.
   * Confidence Interval Thresholds: Critical posterior-cut probabilities at:
     - 1-sigma Posterior-cut (68.3% confidence level)
     - 2-sigma Posterior-cut (95.4% confidence level)
     - 3-sigma Posterior-cut (99.7% confidence level)
================================================================================
