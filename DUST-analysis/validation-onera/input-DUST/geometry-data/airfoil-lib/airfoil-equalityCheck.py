import os
import copy

# INPUT: insert Onera airfoil .dat file
filePath1 = 'oneraM6_orig.dat'
filePath2 = 'oneraM6_mod.dat'

# MAIN
scriptDir = os.path.dirname('airfoil-Onera2DUST.py')
relPath1 = 'input/'+ filePath1
relPath2 = 'input/'+ filePath2
absPath1 = os.path.join(scriptDir, relPath1)
absPath2 = os.path.join(scriptDir, relPath2)

with open(absPath1, 'r') as fileIn:     # open .dat file
    data1 = fileIn.readlines()          # read .dat file
	
with open(absPath2, 'r') as fileIn:     # open .dat file
    data2 = fileIn.readlines()          # read .dat file

if data1 == data2:                      # check if lists are equal
	print("The lists are identical")
else:
	print("The lists are not identical")