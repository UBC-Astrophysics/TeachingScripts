import csv
import sys

#
# match_csv is the file from survey.ubc.ca that matches UBC IDs to eDx anon IDs 
#  
# AMC_grade_csv is the output from AMC with the exam marks
#
# the output is the csv file to upload to edx using upload_edx.py
#
if len(sys.argv)<3:
    print("python create_final_upload.py AMC_grade_csv match_csv")
else:
    dict={}
    with open(sys.argv[2], 'r') as csvfile:
        applicants=csv.reader(csvfile, delimiter=',',quotechar='"')
        for person in applicants:
            dict[person[17]]=person[21]
    
    with open(sys.argv[1], 'r') as csvfile:
        applicants = csv.reader(csvfile, delimiter=',',quotechar='"')
        mean=0
        num=0
        top=0
        for person in applicants:
            try:
                if person[0] != 'Exam':
# two extra points for the last question, four extra points for curve                    
                    total=6
                    for d in person[4:94]:
                        total=total+float(d)/3
                    for d in person[94:102]:
                        total=total+float(d)
                    print("%s,Final,%g,50,http://www.phas.ubc.ca/~heyl/asdf234/finalSummer2016/%04d-%s.pdf" % (dict[person[1]],total,int(person[0]),person[2]))
                    if total>top:
                        top=total
                    mean=mean+total
                    num=num+1
            except KeyError:
                print(person)

