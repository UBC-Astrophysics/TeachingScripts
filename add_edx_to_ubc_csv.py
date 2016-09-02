import csv
import sys

#
# match_csv is the file from survey.ubc.ca that matches UBC IDs to eDx anon IDs 
# anonid_csv is the file from edx that matches eDx anon IDs  to eDx IDs
# gradebook_csv is the edx gradebook
# class_list_csv is the UBC classlist from FSC
# output_csv is the output with the edx grades appended to the UBC classlist
#
#
if len(sys.argv)<6:
    print("python add_edx_to_ubc_csv.py match_csv anonid_csv gradebook_csv class_list_csv output_csv")
else:
    ubcdict={}
    # load matches between UBC ID and anon_id
    with open(sys.argv[1], 'r') as csvfile:
        applicants=csv.reader(csvfile, delimiter=',',quotechar='"')
        for person in applicants:
            ubcdict[person[17]]=person[21]
    # load matches between anon_id and edx ID
    edxdict={}
    with open(sys.argv[2], 'r') as csvfile:
        applicants=csv.reader(csvfile, delimiter=',',quotechar='"')
        for person in applicants:
            edxdict[person[1]]=person[0]
    # load final grades and index by edx ID
    edxgrades={}
    with open(sys.argv[3], 'r') as csvfile:
        applicants=csv.reader(csvfile, delimiter=',',quotechar='"')
        for person in applicants:
            edxgrades[person[0]]=person

    # load up the classlist
    with open(sys.argv[4], 'r') as csvfile:
        applicants = csv.reader(csvfile, delimiter=',',quotechar='"')
        with open(sys.argv[5],'wb') as csvoutfile:
            outputcsv = csv.writer(csvoutfile)
            for person in applicants:
                try:
                    anonid=ubcdict[person[2]]
                    edxid=edxdict[anonid]
                    outputcsv.writerow(person+[anonid,edxid]+edxgrades[edxid])
                except KeyError:
                    outputcsv.writerow(person+["AnonID","EdXID"]+edxgrades["id"])
