using Plots
using GLMakie
#gr()
verbose = true

inputFile = open(raw"D:\Emacs\Julia_Programs\sp2-z-4.cub", "r")
Lines = readlines(inputFile)
close(inputFile)
# Skip the comments in the CUBE file:
Lines = Lines[3:end]
# Split lines using space as separator.
# NOTE: System is assumed in Cartesian coordinates.
line1 = split(Lines[1], ' ')
# Put the parsed 1st line into accessible form L1.
# We do the parse with Float, but the first number is going to be used as an Int64 later on:
L1 = [ ]
for index in 1:length(line1)
    if !isnothing(tryparse(Float64, line1[index]))
        push!(L1, parse(Float64, line1[index]))
    end
end
display(L1)
NumberOfAtoms = Int(L1[1])
# Parsing the 2nd line:
line2 = split(Lines[2], ' ')
L2 =[ ]
for index in 1:length(line2)
    if !isnothing(tryparse(Float64, line2[index]))
        push!(L2, parse(Float64, line2[index]))
    end
end
Nx = Int(L2[1])
dx = L2[2]
# Parsing the 3rd line:
line3 = split(Lines[3], ' ')
L3 =[ ]
for index in 1:length(line3)
    if !isnothing(tryparse(Float64, line3[index]))
        push!(L3, parse(Float64, line3[index]))
    end
end
Ny = Int(L3[1])
dy = L3[3]
# parsing the 4th line:
line4 = split(Lines[4], ' ')
L4 =[ ]
for index in 1:length(line4)
    if !isnothing(tryparse(Float64, line4[index]))
        push!(L4, parse(Float64, line4[index]))
    end
end
Nz = Int(L4[1])
dz = L4[4]
# Test script to check for correct reading:
if verbose
    println("Number of atoms: ", NumberOfAtoms)
    println(Nx)
    println(dx)
    println(Ny)
    println(dy)
    println(Nz)
    println(dz)
end

# Read and store the XYZ coordinates in a separate file:
Lines = Lines[7+NumberOfAtoms:end]

# Essentially flatten the weird structure of data in the CUBE file:
newLine = join(Lines)
newLine = split(newLine, ' ')
        
# Initialize electron density:
ElectronDensity = zeros(Float64, Nx, Ny, Nz)
println(typeof(newLine))
println(length(newLine))
# Start reading the electron density. Some clever workarounds here!
index = 1
for ix in 1:Nx
    for iy in 1:Ny
        for iz in 1:Nz
            while isnothing(tryparse(Float64,newLine[index]))
                if index < length(newLine)
                    global index += 1
                else
                    break
                end
            end
            if index < length(newLine)
                ElectronDensity[ix, iy, iz] = parse(Float64, newLine[index])
                global index += 1
            else
                break
            end
        end
    end
end


println(typeof(ElectronDensity))
display(ElectronDensity)


# TESTS:
X = range(0, Nx*dx, Nx)
Y = range(0, Ny*dy, Ny)
Z = range(0, Ny*dy, Ny)
println(ElectronDensity[1, 1, 2])
#=
contour(X, Y, z, levels=10, color=:turbo, clabels=true, cbar=false, lw=1)
contour(X, Y, [ElectronDensity[i, j, 8] for i in 1:Nx for j in 1:Ny])
contourf(X, Y, [ElectronDensity[i, j, 5] for i in 1:Nx for j in 1:Ny])

# Create animation for evolution of the wavefunction:
anim = @animate for k in 1:Nz
    contourf(X, Y, [ElectronDensity[i, j, k] for i in 1:Nx for j in 1:Ny])
end

# Save the animation as a gif
gif(anim, "WavefunctionSquared.gif", fps = 8)
=#
volume(ElectronDensity)
save("volume.png")
# Calculate the Laplacian of the density:
Laplacian = zeros(Float64, Nx-1, Ny-1, Nz-1)
for i in 2:Nx-1
    for j in 2:Ny-1
        for k in 2:Nz-1
            Laplacian[i, j, k] = (ElectronDensity[i+1,j,k]-2*ElectronDensity[i,j,k]+ElectronDensity[i-1,j,k])/dx^2 + (ElectronDensity[i,j+1,k]-2*ElectronDensity[i,j,k]+ElectronDensity[i,j-1,k])/dy^2 + (ElectronDensity[i,j,k+1]-2*ElectronDensity[i,j,k]+ElectronDensity[i,j,k-1])/dz^2
        end
    end
end

colormap = to_colormap(:plasma)
colormap[1] = RGBAf(0,0,0,0)
colormap[2] = RGBAf(0,0,0,0)
mini, maxi = extrema(Laplacian)
normed = Float64.((Laplacian .- mini) ./ (maxi - mini))
colormap2 = to_colormap(:balance)
colormap3 = cgrad(:balance, scale = :log)
colormap4 = to_colormap(:heat)
volume(normed, colormap=colormap4)
volume(ElectronDensity, colormap=:balance)

slice = [ElectronDensity[i, j, Nz-1] for i in 1:Nx-1, j in 1:Ny-1]
contour(slice, colormap=colormap2)
#=
slice = [normed[i, j, 1] for i in 1:Nx-1, j in 1:Ny-1]
anim = @animate for k in 1:Nz-1
    slice = [normed[i, j, k] for i in 1:Nx-1, j in 1:Ny-1]
    Plots.contour(slice, colormap=colormap2)
end
# Save the animation as a gif
gif(anim, "WavefunctionLaplacian.gif", fps = 8)
=#
