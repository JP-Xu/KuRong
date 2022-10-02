# KuRong
An on-going machine learning project for prediction of $CO_2$ absoprtion in different types of ionic liquids. 

## Background 
Ionic liquids (ILs) are normally defined as compounds completely composed of ions with melting point below 100 °C. Non-volatile and flexible ILs are popular for $CO_2$ absorption processes as their high polarity which can absorb $CO_2$ molecules preferably. However, there are millons of possible IL structures to explore, this is an exhausted work. Hence, this project aims to use available IL database, QM/MD/MC simulations, and machine learning for the prediction of $CO_2$ absorption with the best accuracy of my knowledge.

## Goal

This project includes several phases:
* Phase 1 - Database scraping from ILThermo NIST database
  * Getting all ionic liquid SMILES structures for further analysis.
* Phase 2 - Create 3D initial structure and geometric optimization and RESP2 partial charges.
  * GAFF will be created for each atom with updated RESP2 partial charges.
* Phase 3 - Molecular dynamic (MD) simulations with GROMACS
  * Bulk phase ionic liquids MD simulations are used for force field validation.
* Phase 4 - Gibbs Ensemble Monte-Carlo (GEMC) simulations
  * Cassandra provides GEMC ensemble for phase change simulations, which fits our needs.
* Phase 5 - Machine learning
  * There are many possible parameters could be used for ML, including molecular descriptors (from QM), temperatures, gibbs energy, etc.
  * Model will be trained and tested based on current database. Out of database observations may also be used for validation.


## Software used in this work:

* Gaussian  -  Quantum Chemistry
* Avogadro - Initial configuration for QM
* Sobtop - Force field generator
* Multiwfn - Quantum analysis tool
* GROMACS - Molecular Dynamic (MD) Simulations
* Cassandra - Monte-Carlo Simulations
* Packmol - Initial configuration for MD
* openbabel - 3D atom structure generation
* Mongodb - Local database 
* Python 
  * Selenium - ILThermo database spider
  * Pandas - data operation
  * pytorch - ML
  * Batch processing - Automated work flow


NOTE: This project is updating slowly as redundant academic/course work during semesters.
