import sys
import re

if (len(sys.argv)<2):
    print("Format:\n\n  python processOpenStax.py file_to_process")
else:
    with open(sys.argv[1]) as f:
        data=f.read()
    m = re.search(r'<title>([^<]+)</title>',data)
    if m is not None:
	print('<vertical display_name="%s">' % m.group(1))
    else:
    	print('<vertical display_name="unknown">') 
        
    htmlfind=re.compile('<html xmlns="http://www.w3.org/1999/xhtml">')
    bodyfind=re.compile('<body .+</div>\n')
    endfind=re.compile('</body>')
    cnxfind=re.compile('<cnx-pi .+</cnx-pi>',re.DOTALL)
    resourcefind=re.compile('/resources/[a-z0-9]+/')

    
    # replace with a straight HTML tag to open
    data=htmlfind.sub('<html>',data)
    # add the attribution to the bottom
    data=endfind.sub('<hr />Download for free at <a href="http://cnx.org/contents/2e737be8-ea65-48c3-aa0a-9f35b4c6a966@13.83">http://cnx.org/contents/2e737be8-ea65-48c3-aa0a-9f35b4c6a966@13.83</a></body>.',data)
    # replace resource links with links to the EdX static directory
    data=resourcefind.sub('/static/',data)
    # remove cnx-pi tags
    data=cnxfind.sub('',data)
    # remove <body> line
    data=bodyfind.sub('<body>',data)
    print(data.strip())
    print('</vertical>')


