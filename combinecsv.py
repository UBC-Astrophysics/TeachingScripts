import csv
import sys

dict={}
if (len(sys.argv)<6):
    print("Format:\n\n  python3 combinecsv.py gradebook.csv ams.csv output.csv number_of_columns_to_sum number_of_output_column\n\n")
    exit(-1)
    
with open(sys.argv[1], 'r') as csvfile:
    firstrow=csvfile.readline()
    gradebook = csv.reader(csvfile, delimiter=',',quotechar='"')
    for row in gradebook:
        if (firstrow==None):
            firstrow=row
        else:
            dict[row[2]]=row
            
with open(sys.argv[2], 'r') as csvfile:
    tutgrade = csv.reader(csvfile, delimiter=';',quotechar='"')
    for row in tutgrade:
        try:
            sumup=0
            n=0
            for ss in row[-(int(sys.argv[4])+1):-1]:
              sumup+=int(ss)
              n+=1
            dict[row[-1]][int(sys.argv[5])]=sumup*1.0/n
        except KeyError:
            print(row)
        except ValueError:
            print(row)
            
with open(sys.argv[3],'w') as csvfile:
    csvfile.write(firstrow)
    gradewrite = csv.writer(csvfile, delimiter=',',quotechar='"')
#    gradewrite.writerow(firstrow)
    for row in dict:
        gradewrite.writerow( dict[row])
