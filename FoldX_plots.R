library(tidyverse)
library(readr)
library(dplyr)

#setwd("/Users/admin/Desktop/HpDiskE/LocalDisk/Manuscripts/MERS-CoV_genomics/foldx5_1Mac/Segments/Build")

# File path
file_path <- "Dif_EMC_vs_DPP4_Repair.fxout"

# read the fxout file
fold <- read_delim(
  file_path, 
  delim = "\t", 
  skip = 9,  # lines skipped before the data table
  col_names = c("PDB File", "Total Energy", "Backbone Hbond", "Sidechain Hbond", 
                "Van der Waals", "Electrostatics", "Solvation Polar", 
                "Solvation Hydrophobic", "Van der Waals Clashes", 
                "Entropy Sidechain", "Entropy Mainchain", "Sloop Entropy", 
                "Mloop Entropy", "Cis Bond", "Torsional Clash", 
                "Backbone Clash", "Helix Dipole", "Water Bridge", "Disulfide", 
                "Electrostatic Kon", "Partial Covalent Bonds", "Energy Ionisation", 
                "Entropy Complex")
)



# Mutate the new names in the file chronological order
new_names <- c(
  "EMC-DP-1-V26A", "EMC-DP-2-V26S", "EMC-DP-3-T139I", "EMC-DP-4-D158Y", "EMC-DP-5-S390F",
  "EMC-DP-6-L450F", "EMC-DP-7-D510Y", "EMC-DP-8-A597V", "EMC-DP-9-R626P", "EMC-DP-Z10-A763S",
  "EMC-DP-Z11-A851E", "EMC-DP-Z12-G1006S", "EMC-DP-Z13-A1158S", "EMC-DP-Z14-T1325I"
)

# Rename the `PDB File` column in the tibble
fold <- fold %>%
  mutate(`PDB File` = new_names)


head(fold)

# Visualization 1: Total Energy Comparison
ggplot(fold, aes(x = `PDB File`, y = `Total Energy`)) +
  geom_bar(stat = "identity", fill = "skyblue", color = "black") +
  labs(title = "Energy difference between EMC-DPP4 WT and Mutant",
       x = "EMC-Dpp4 PDB mutant",
       y = "Energy difference (ΔΔG in kcal.mol)") +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 30), # Increased axis title size
    legend.text = element_text(size = 25),              # Increased legend text size
    strip.text = element_text(face = "bold", size = 28), # Increased strip text size
    axis.text = element_text(size = 26),                # Increased axis text size
    legend.title = element_text(size = 24),             # Increased legend title size
    plot.caption = element_text(size = 20),             # Increased caption text size
    panel.grid.major = element_line(color = "grey", size = 0.1), # Thicker grid lines
    axis.text.x = element_text(angle = 90, hjust = 1)   # Rotate x-axis labels
  )+
  coord_flip()  # Flip the axes

# Visualization 2: Van der Waals Clashes
ggplot(fold, aes(x = `PDB File`, y = `Van der Waals Clashes`)) +
  geom_bar(stat = "identity", fill = "salmon", color = "black") +
  labs(title = "Van der Waals Clashes between EMC-DPP4 WT and Mutant",
       x = "PDB File",
       y = "Van der Waals Clashes") +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 30),
    legend.text = element_text(size = 25),
    strip.text = element_text(size = 28),
    axis.text = element_text(size = 26),
    legend.title = element_text(size = 24),
    plot.caption = element_text(size = 20),
    panel.grid.major = element_line(color = "grey", size = 0.1),
    axis.text.x = element_text(angle = 90, hjust = 1)
  )+
  coord_flip()  # Flip the axes



# Visualization 3: Solvation Polar Effects
ggplot(fold, aes(x = `PDB File`, y = `Solvation Polar`)) +
  geom_bar(stat = "identity", fill = "limegreen", color = "black") +
  labs(title = "Solvation Polar Effects between EMC-DPP4 WT and Mutant",
       x = "PDB File",
       y = "Solvation Polar Energy") +
  theme_minimal() +
  theme(
    axis.title = element_text( size = 30),
    legend.text = element_text(size = 25),
    strip.text = element_text( size = 28),
    axis.text = element_text(size = 26),
    legend.title = element_text(size = 24),
    plot.caption = element_text(size = 20),
    panel.grid.major = element_line(color = "grey", size = 0.1),
    axis.text.x = element_text(angle = 90, hjust = 1)
  )+
  coord_flip()  # Flip the axes


# Visualization 4: Electrostatics Contributions
ggplot(fold, aes(x = `PDB File`, y = `Electrostatics`)) +
  geom_bar(stat = "identity", fill = "purple", color = "black") +
  labs(title = "Electrostatics Contributions between EMC-DPP4 WT and Mutant",
       x = "PDB File",
       y = "Electrostatics Energy") +
  theme_minimal() +
  theme(
    axis.title = element_text(size = 30),
    legend.text = element_text(size = 25),
    strip.text = element_text(size = 28),
    axis.text = element_text(size = 26),
    legend.title = element_text(size = 24),
    plot.caption = element_text(size = 20),
    panel.grid.major = element_line(color = "grey", size = 0.1),
    axis.text.x = element_text(angle = 90, hjust = 1)
  )+
  coord_flip()  # Flip the axes
