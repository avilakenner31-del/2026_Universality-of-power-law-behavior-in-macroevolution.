# Dinosaur Mass Datasets (MCMC Inputs)

This directory contains the text files used as primary datasets for the dinosaur power-law modeling MCMC suite. Each file contains formatted taxonomic and mass statistics parsed directly by the respective `.f95` programs.

## 1. Directory Inventory

* **`ListaGrado1.txt`** — Primary full dataset containing **524** entries (Parsed by `powerLawDino`).
* **`ListaGrado2_o.txt`** — Subset variation containing **136** entries (Parsed by `powerLawDinoO`).
* **`ListaGrado2_s.txt`** — Subset variation containing **132** entries (Parsed by `powerLawDinoS`).
* **`ListaGrado2_t.txt`** — Subset variation containing **256** entries (Parsed by `powerLawDinoT`).

---

## 2. File Syntax & Data Structure

All data files share an identical space-separated configuration framework. 

### Format Specification:
* **Line 1:** Header descriptors string (`Taxon/ Mass / Deviation log10(mass)`). The Fortran compilation sequence reads and discards this first line via `read(100,*)` before entering loops.
* **Lines 2+:** Individual dinosaur properties listed sequentially down to row `N+1`. No blank spaces within specimen names are allowed; words must be concatenated using underscores (`_`).

### Column Breakdown:

| Column | Parameter Name | Data Type | Physical Description |
| :--- | :--- | :--- | :--- |
| **1** | `dinoName` | Character(100) | Genus and species taxon descriptor identifier. |
| **2** | `dataMass` | Real | Absolute body mass measurement values. |
| **3** | `dev10Mass` | Real | Statistical standard deviation error scaled to \(log_{10}(\text{mass})\). |

### Structural Preview Example:
```text
Taxon/ Mass / Deviation log10(mass)
Argentinosaurus_huinculensis 94844.08823 0.234294623
Dreadnoughtus_schrani 59367.58807 0.154766696
Brachiosaurus_altithorax 57680.59477 0.200474972
```

---

## 3. Integration with Fortran Programs

When expanding or altering records inside these spreadsheets, keep in mind how variables change:
1. **Row Restrictions:** If rows are added or removed, you **must update parameter `N`** in the corresponding `.f95` header file before compilation to prevent `End-Of-File (EOF)` read errors.
2. **Log Transformations:** The Fortran code applies a $log_{10}$ math operation to Column 2 (`dataMass`) natively during runtime loop calculations:
   ```fortran
   pGauss(log10(dataMass(j)), log10(modelMass(...)), dev10Mass(j))
   ```
   Column 3 (`dev10Mass`) is **already passed as a base-10 logarithmic deviation scale value**, meaning no logarithmic conversions are applied to Column 3 by the software during runtime execution.
