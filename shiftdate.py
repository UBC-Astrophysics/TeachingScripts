import dateutil.parser 
import datetime
import sys
import re

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

if (len(sys.argv)<3):
    print("Format:\n\n  python shiftdate.py file_to_process number_of_days")
else:
    td=datetime.timedelta(int(sys.argv[2]))

    timestamp=re.compile('[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]T[0-9][0-9]:[0-9][0-9]:[0-9][0-9]')

    # only recognize dates from 2000 to 2099
    # just in case you have earlier dates that aren't due dates (i.e. don't shift them)
    progdate=re.compile('[0-9]+\w+(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|Nov(?:ember)?|Dec(?:ember)?)\w+(2\d{3})(?=\D|$)')

    with open(sys.argv[1]) as f:
        for line in f:
            newline=timestamp.sub(replacetimestamp,line)
            newline=progdate.sub(replacedate,newline)
            print(newline.strip())

