import sys
import re

if (len(sys.argv)<2):
    print("Format:\n\n  python processOpenStax.py file_to_process")
else:
    with open(sys.argv[1]) as f:
        data=f.read()
    htmlfind=re.compile('<html xmlns="http://www.w3.org/1999/xhtml">')
    endfind=re.compile('</html>')
    resourcefind=re.compile('/resources/[a-z0-9]+/')
    m = re.search(r'<title>([^<]+)</title>',data)
    if m is not None:
        title=m.group(1)
    # replace with a straight HTML tag to open
    data=htmlfind.sub('<html>',data)
    # add the attribution to the bottom
    data=endfind.sub('<hr />Download for free at <a href="http://cnx.org/contents/2e737be8-ea65-48c3-aa0a-9f35b4c6a966@13.83">http://cnx.org/contents/2e737be8-ea65-48c3-aa0a-9f35b4c6a966@13.83</a>.</html>',data)
    # replace resource links with links to the EdX static directory
    data=resourcefind.sub('/static/',data)
    print(data.strip())
                    


