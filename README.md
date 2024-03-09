* Introduction

One of the most important file formats in computational chemistry and physics is the CUBE
format that is generated as an output of the GAUSSIAN computational package.
Although the CUBE file format is generally used for representing the electron density, it
is also widely used for visualizing scalar fields in general (such as potential maps,
orbitals, etc.) and is supported by various visualization tools.

The ReadCUBE.jl function provides a very simple way of reading CUBE files as a 3D array in
Julia. The data can then be manipulated fro visualization and more in depth mathematical
analysis.

This function takes a CUBE file and parses the file according to the format of the CUBE
file found [here](https://paulbourke.net/dataformats/cube/). The parsing goes line by
line for the first few lines to extract basic information about the XYZ grid and then
parses the rest into a 3 indexed function foo[i, j, k].
(Note that the standard CUBE file also has the XYZ data of the atoms in the molecule. I
might update the library to export the standard XYZ file for the CUBE function as well. It
might be useful in some cases.)

One limitation: The CUBE file is assumed to be in the Cartesian system.
This, however, is not really a big deal as this covers the majority use cases.

## A similar library:
As I was uploading this function, I saw a new library called
[CUBE.jl](https://github.com/mfherbst/CUBE.jl) by Michael F. Herbst. He is also one of the
core contributors to the DFT package written in Julia (see
[DFTK.jl](https://github.com/JuliaMolSim/DFTK.jl)) and thererfore, not only does he knows
his stuff, but his version of the code might be better suited for integration with the
whole DFTK.jl environment.

## TODO:
- Add flexibility for non-Cartesian CUBE files.
- Store and maybe export the XYZ coordiantes.
- Make the reading of the initial file *lazy* to avoid memory hogging and increase speed.
