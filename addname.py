import csv
import sys

dict={}
if (len(sys.argv)<4):
    print("Format:\n\n  python3 addname.py gradebook.csv ams.csv output.csv\n\n")
    exit(-1)
    
with open(sys.argv[1], 'r') as csvfile:
    firstrow=csvfile.readline()
    gradebook = csv.reader(csvfile, delimiter=',',quotechar='"')
    for row in gradebook:
        if (firstrow==None):
            firstrow=row
        else:
            dict[row[2]]=row
tutrows=[]
with open(sys.argv[2], 'r') as csvfile:
    tutgrade = csv.reader(csvfile, delimiter=';',quotechar='"')
    for row in tutgrade:
        try:
            idcode=row[-1]
            row.append(dict[idcode][0])
            row.append(dict[idcode][1])
        except KeyError:
            print(row)
        tutrows.append(row)
with open(sys.argv[3],'w') as csvfile:
    gradewrite = csv.writer(csvfile, delimiter=';',quotechar='"')
    for row in tutrows:
        gradewrite.writerow(row)
