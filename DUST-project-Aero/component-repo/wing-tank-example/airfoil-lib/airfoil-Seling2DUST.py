import os

# INPUT: insert Seling airfoil .dat file
filePath = 'naca64a012.dat'

# MAIN
scriptDir = os.path.dirname('airfoil-Seling2DUST.py')
relPath = 'input/'+ filePath
absPath = os.path.join(scriptDir, relPath)

with open(absPath, 'r') as fileIn:      # open .dat file
    data = fileIn.readlines()           # read .dat file
    numLines = len(data)-1              # count airfoil nodes

data = [entry.strip("  ")       # remove double space in
        for entry in data]      # every entry of data list

data.reverse()                          # compute DUST nodes order
newPath = 'DUST-' + filePath            # output file string path

# OUTPUT
with open(newPath, 'w') as fileOut:
    fileOut.write(str(numLines)+'\n')   # print number of nodes
    fileOut.writelines(data[:-1])       # print nodes in DUST format
