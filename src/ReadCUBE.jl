"""
A simple CUBE file reader for Cartesian coordinate system.
"""
function ReadCube(Address::String, Verbose::Boolean)
    inputFile = open(Address, "r")
    Lines = readlines(inputFile)
    close(inputFile)
    # Skip the comments section in the CUBE file:
    Lines = Lines[3:end]
    line1 = split(Lines[1], ' ')
    line2 = split(Lines[2], ' ')
    line3 = split(Lines[3], ' ')
    line4 = split(Lines[4], ' ')
    L1 = [ ]
    L2 = [ ]
    L3 = [ ]
    L4 = [ ]
    for index in 1:length(line1)
        if !isnothing(tryparse(Float64, line1[index]))
            push!(L1, parse(Float64, line1[index]))
        end
    end
    for index in 1:length(line2)
        if !isnothing(tryparse(Float64, line2[index]))
            push!(L2, parse(Float64, line2[index]))
        end
    end
    for index in 1:length(line3)
        if !isnothing(tryparse(Float64, line3[index]))
            push!(L3, parse(Float64, line3[index]))
        end
    end
    for index in 1:length(line4)
        if !isnothing(tryparse(Float64, line4[index]))
            push!(L4, parse(Float64, line4[index]))
        end
    end
    NumberOfAtoms = Int(L1[1])
    Nx = Int(L2[1])
    dx = L2[2]
    Ny = Int(L3[1])
    dy = L3[3]
    Nz = Int(L4[1])
    dz = L4[4]
    # For Verbose = TRUE, see if the reading was done successfully:
    if Verbose
        println("Number of atoms: ", NumberOfAtoms)
        println(Nx)
        println(dx)
        println(Ny)
        println(dy)
        println(Nz)
        println(dz)
    end
    # At this stage, dispose the XYZ coordinates.
    # TODO: Read and store the XYZ coordinates in a separate file:
    Lines = Lines[7+NumberOfAtoms:end]
    # Flatten the weird structure of data in the CUBE file, and split with space as separator:
    newLine = join(Lines)
    newLine = split(newLine, ' ')
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
                    Density[ix, iy, iz] = parse(Float64, newLine[index])
                    global index += 1
                else
                    break
                end
            end
        end
    end
    return Density
end
