using ReadCUBE

# TESTS:
X = range(0, Nx*dx, Nx)
Y = range(0, Ny*dy, Ny)
Z = range(0, Ny*dy, Ny)
println(ElectronDensity[1, 1, 2])

volume(ElectronDensity, colormap=:balance)



