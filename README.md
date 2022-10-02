# KuRong
An on-going machine learning project for prediction of $CO_2$ absoprtion in different types of ionic liquids. 

## Background 
Non-volatile and flexible ionic liquids (ILs) are popular for $CO_2$ absorption processes as their high polarity which can absorb $CO_2$ molecules preferably.

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



## Software used in this work:

* Gaussian  -  Quantum Chemistry
* Avogadro - Initial configuration for QM
* Sobtop - Force field generator
* Multiwfn - Quantum analysis tool
* GROMACS - Molecular Dynamic (MD) Simulations
* Cassandra - Monte-Carlo Simulations
* Packmol - Initial configuration for MD
* openbabel - 3D atom structure generation
* Python 
  * Selenium - ILThermo database spider
  * Batch processing - Automated work flow