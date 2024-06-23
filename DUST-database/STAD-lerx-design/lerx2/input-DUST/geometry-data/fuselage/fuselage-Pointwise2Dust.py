import os

# INPUT: insert Pointwise mesh .dat file
filePath = 'fuselage.dat'

# MAIN
with open(filePath, 'r') as file:
    lines = file.readlines()

rrCounterPosition = 0                           # rr element counter position
rrNumElement = int(lines[0])                    # number of rr element to save
rrFileData = lines[(rrCounterPosition+1):(rrNumElement+1)]

eeCounterPosition = rrNumElement + 1            # ee element counter position
eeNumElement = int(lines[eeCounterPosition])    # number of ee element to save
eeFileData = lines[(eeCounterPosition+1):]      

# OUTPUT
rrFilePath = 'fuselage_rr.dat'          # name of the panel coordinate file
with open(rrFilePath, 'w') as rrFile:     
    rrFile.writelines(rrFileData)       # print panel coordinate file

eeFilePath = 'fuselage_ee.dat'          # name of the connection coordinate file
with open(eeFilePath, 'w') as eeFile:     
    eeFile.writelines(eeFileData)       # print connection file
