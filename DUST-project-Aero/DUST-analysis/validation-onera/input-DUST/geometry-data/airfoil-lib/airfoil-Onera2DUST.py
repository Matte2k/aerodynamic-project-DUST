import os
import copy

# INPUT: insert Onera airfoil .dat file
filePath = 'oneraM6_mod.dat'

# MAIN
scriptDir = os.path.dirname('airfoil-Onera2DUST.py')
relPath = 'input/'+ filePath
absPath = os.path.join(scriptDir, relPath)

with open(absPath, 'r') as fileIn:      # open .dat file
    upperData = fileIn.readlines()      # read .dat file
    numLines = len(upperData)           # count half airfoil nodes
    numLines = 2 * numLines             # compute total airfoil nodes

upperData = [entry.strip("   ")         # remove triple space at the start
            for entry in upperData]     # do it every entry of data list

upperData = [entry.replace('   ',' ')   # substitute triple space with a single space
            for entry in upperData]     # do it every entry of data list

lowerData = copy.deepcopy(upperData)    # copy the content of 'data' in a new variable
lowerData.reverse()                     # reverse node order for lower surface

lowerData = [entry.replace(' ',' -')    # add minus to the y component of lower surface
            for entry in lowerData]     # do it every entry of data list                                             

newPath = 'DUST-' + filePath            # output file string path

# OUTPUT
with open(newPath, 'w') as fileOut:
    fileOut.write(str(numLines)+'\n')   # print number of nodes
    fileOut.writelines(lowerData[:])    # print nodes of lower surface in DUST format
    fileOut.writelines(upperData[:])    # print nodes of upper surface in DUST format
