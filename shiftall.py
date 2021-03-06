import dateutil.parser 
import datetime
import sys
import re
import os

def date2str(d):
    q2=list(str(d))
    q2[10]='T'
    return  "".join(q2)

def oldreplacetimestamp(m):
    return(date2str(dateutil.parser.parse(m.group(0))+td))

def replacetimestamp(m):
    return(dateutil.parser.parse(m.group(0))+td).strftime('%Y-%m-%dT%H:%M:%S')

def replacedate(m):
    return (dateutil.parser.parse(m.group(0))+td).strftime('%d %B %Y').lstrip("0").replace(" 0", " ")

def processfile(fname):
    outstring=""
    with open(fname) as f:
        for line in f:
            newline=timestamp.sub(replacetimestamp,line)
            newline=progdate.sub(replacedate,newline)
            outstring=outstring+newline
    with open(fname,"w") as f:
        f.write(outstring)

        
if (len(sys.argv)<3):
    print("Format:\n\n  python shiftall.py directory_to_process number_of_days")
else:
    td=datetime.timedelta(int(sys.argv[2]))

#    progtimestamp=re.compile('[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]\+[0-9][0-9]:[0-9][0-9]')

    timestamp=re.compile('[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]')

    # only recognize dates from 2000 to 2099 
    # just in case you have earlier dates that aren't due dates (i.e. don't shift them)
    progdate=re.compile('[0-9]+ +(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?) +(2\d{3})(?=\D|$)')
    # before July only
#    progdate=re.compile('[0-9]+ +(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?) +(2\d{3})(?=\D|$)')

    for root, subFolders, files in os.walk(sys.argv[1]):
        for fname in files:
            if fname.endswith(".xml") or fname.endswith(".html") or fname.endswith(".tex"):
                processfile(os.path.join(root, fname))
                

