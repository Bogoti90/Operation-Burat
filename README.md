# Operation Burat
An in-silico modelling pipeline to understand the effects of MERS-CoV Spike glycoprotein mutants on the interaction with the host receptor DPP4. Burat is a special location to me (Deutsch translation: Burat ist ein besonderer Ort für mich) (thanks Thaira for the translation). Found in Kenya, I detected  most of Kenya MERS-CoV viruses from camels during my PhD.

This repository provides a streamlined workflow for predicting and analyzing the interactions between the MERS-CoV Spike protein and DPP4 receptor using cutting-edge computational tools such as AlphaFold, PyMOL, and FoldX. The pipeline includes detailed steps to predict protein structures, inspect and manipulate them, and evaluate the impact of mutations on binding affinity. This pipeline has been developed and tested on MERS-CoV Spike glycoprotein (the prototypic EMC/2012) and human DPP4. The pipeline uses different tools (currently working on a snakemake/nextflow workflow manager 😅)

## Overview

### Key Tools
1. **AlphaFold**: Clever AI tool for prediction of protein structures (in this case Spike-DPP4 structure). ([https://alphafoldserver.com/])
2. **PyMOL**: Structural inspection and preparation. ([https://www.pymol.org/])
3. **FoldX**: Protein repair, mutation analysis, and binding energy calculation. ([https://foldxsuite.crg.eu/])

---

## Pipeline Steps

### Step 1: AlphaFold (By DeepMind Google) 
**Prediction of Spike-DPP4 Interaction**
- **Resource**: [AlphaFold Training Guide](https://www.ebi.ac.uk/training/online/courses/alphafold/an-introductory-guide-to-its-strengths-and-limitations/strengths-and-limitations-of-alphafold/)

#### Key Considerations:
- Inclusion criterion:
  - **pTM Score > 0.5**: Indicates the overall predicted fold for the complex might be similar to the true structure.
    
  - N/B: (Ignore ipTM values as corrections are made in subsequent steps. Do not draw conclusions about pTM scores from AlphaFold when comparing wild-type structures vs point mutant variants if you manually do edit your protein sequences).

#### Notes:
- Ensure input sequence files are consistent across all analyses. The order of input files in AlphaFold matters (discovered this at later analysis points when i used the the input files interchangeably).

### Step 2: PyMOL
**Structural Inspection and Preparation**
1. **Install PyMOL**:
   - Download and install PyMOL from the official [PyMOL website](https://pymol.org/).
   - Ensure you have the latest version for compatibility with advanced features.
2. **Load Structures**:
   - Open PyMOL and load the AlphaFold-generated `.cif` file (e.g., `model_0.cif`).
   - Command example:
     ```
     load fold_2024_11_14_14_47_spike_vs_dpp4_model_0.cif
     ```
3. **Inspect Structural Features**:
   - Use PyMOL’s visualization tools to examine:
     - Protein folding and secondary structure elements.
     - Binding interfaces between Spike and DPP4.
     - Anomalies such as missing residues or unusual conformations.
4. **Save Edited Structures**:
   - Make necessary edits or annotations (e.g., highlighting binding residues).
   - Save the updated structure in `.pdb` format:
     ```
     save spike_dpp4_inspected.pdb
     ```
5. **Generate Visualizations**:
   - Create high-quality images for documentation using PyMOL’s ray-tracing capabilities:
     ```
     ray
     png spike_dpp4_visualization.png
     ```
#### Notes:
- Document observations for reproducibility and further analysis in FoldX.


### Step 3: FoldX
**Repair and Analyze the Protein Complex**

#### Step 3.1: Install FoldX
1. Download FoldX from the official [FoldX website](https://foldx.crg.eu/).
2. Install FoldX and make the executable accessible via your system’s PATH.
3. Add execution permissions using:
   ```bash
   chmod +x foldx5_1
   ```

#### Step 3.2: Prepare the Complex for FoldX Analysis
1. Load the Spike-DPP4 complex PDB file (e.g., `spike_505Y_dpp4_complex.pdb`).
2. Repair the PDB file:
   ```bash
   FoldX --command=RepairPDB --pdb=spike_505Y_dpp4_complex.pdb
   ```
   - Output: A repaired PDB file (e.g., `spike_505Y_dpp4_complex_Repair.pdb`).

- The repair function of FoldX reduces the energy content of a protein-structure model to a minimum by rearranging side chains

#### Step 3.3: Generate and Analyze Mutations
1. Create a mutation list:
   - Format: `WTresidue:ChainResidue:Number:NewResidue`
   - Example for mutating residue D on number  505 on chain A to Tyrosine:
     ```
     DA505Y
     ```
2. Save the mutation list as `individual_list.txt`.
3. Run mutation analysis:
   ```bash
   FoldX --command=BuildModel --pdb=spike_505Y_dpp4_complex_Repair.pdb --mutant-file=individual_list.txt --numberOfRuns=5
   ```
   - This generates structural models for each mutation and calculates changes in Gibbs free energy (ΔΔG). The function BuildModel introduces mutations and optimizes the structure of the new protein variant. The energy function of FoldX is only able to calculate the energy difference in accurate manner between the wildtype and a variant of the protein 

#### Step 3.4: Interpret FoldX Output
1. Check the results file (e.g., `spike_505Y_dpp4_complex_Repair.fxout`):
   - **ΔΔG (kcal/mol)**: (ΔΔG = ΔG Wildtype - ΔG Variant (kcal/mol))
     
     - Positive: Mutation is destabilizing or reduces binding affinity. 
     - Negative: Mutation is stabilizing or increases binding affinity. 
       
- **Outputs Explained**
-After running BuildModel, several output files are generated. These files summarize the energy differences and provide detailed decomposition of the energy components for each mutant and its corresponding wild type.

**Average_PDB_BM.fxout**:
Contains the average energy values for the different runs. This file provides an overall stability score.

**Dif_PDB_BM.fxout**:
Contains the energy differences between the reference wild type and the mutant for each run. Negative values indicate the mutation has stabilized the structure, while positive values suggest destabilization.

**Raw_PDB_BM.fxout**:
Provides the full energy decomposition for both the wild type and mutant structures. This includes all the energy components (e.g., van der Waals, electrostatics, solvation, etc.) for a detailed analysis.

**PdbList_PDB_BM.fxout**:
Lists all the generated mutants along with their corresponding wild-type references. Useful for tracking which mutants were processed.

#### Step 3.5: Summarize Results
- Compile ΔΔG values for all mutations.
- Identify mutations that significantly impact binding affinity.
- Highlight residues critical for Spike-DPP4 interaction.

---

- **An example FoldX Output ΔΔG Visualization from my personal analysis**: 

  ![FoldX Output ΔΔG (kcal/mol)](Kenya_mutants_EMC-Dpp4.png)

---

- **R Script for output visualization**: 
  You can find the R script in the [Foldx.R](FoldX_plots.R).

## Usage Notes
- Ensure software dependencies (AlphaFold, PyMOL, FoldX) are properly installed.
- Follow inclusion criteria and repair protocols to ensure consistent and reliable results.

---

## Contributors
- **Brian M Ogoti**
  - Global Health | Virologist.
  - Contact: [brian.ogoti@cema.africa](mailto:brian.ogoti@cema.africa)
  - Web: [The Center for Epidemiological Modelling and Analysis CEMA](https://cema-africa.uonbi.ac.ke/people/epidemiology/brian-maina)
  - Twitter/X: [@diyobraz2](https://x.com/diyobraz2)
---

## License
This project is licensed under the [CC0-1.0 license](LICENSE).

---

For inquiries or contributions, feel free to open an issue or submit a pull request!




