# macs

MAtlab Circuit Simulation (MACS)

This project contains scripts to simulate the analog behaviour of electronic
circuits in MATLAB. An export to the simulation tool C2E2 has also been
integrated.

FEATURES:
- easy adaptability and extendability
- reasonable export values
- reasonable time scale

The general structure of the framework is the following:
macs - contains reference implementations of circuits we want
       to investigate
|~ exports - exported C2E2 formulas
|~ gates - models of basic gates
|~ misc - files required for the simulations such as the uniform model
|~ parameters - parameter files

