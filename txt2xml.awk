# ord.awk --- do ord and chr

# Global identifiers:
#    _ord_:        numerical values indexed by characters
#    _ord_init:    function to initialize _ord_

BEGIN    { _ord_init(); num=0; }

function _ord_init(    low, high, i, t)
{
    low = sprintf("%c", 7) # BEL is ascii 7
    if (low == "\a") {    # regular ascii
        low = 0
        high = 127
    } else if (sprintf("%c", 128 + 7) == "\a") {
        # ascii, mark parity
        low = 128
        high = 255
    } else {        # ebcdic(!)
        low = 0
        high = 255
    }

    for (i = low; i <= high; i++) {
        t = sprintf("%c", i)
        _ord_[t] = i
    }
}

function ord(str,    c)
{
    # only first character is of interest
    c = substr(str, 1, 1)
    return _ord_[c]
}

function outputmcfile() {
    outputfile=sprintf("Problem%s_%03d.xml",FILENAME,num);
    print "<problem display_name=\"Multiple Choice\" max_attempts=\"1\">" > outputfile;
    printf("  <p>%s</p>\n",header) >> outputfile;
    print "  <multiplechoiceresponse>" >> outputfile;
    gsub(/['"]/,"",header);
    printf("   <choicegroup label=\"%s\" type=\"MultipleChoice\">\n",header) >> outputfile;
    for (i=0;i<nchoices;i++) {
	if (i==truechoice) {
	    printf("      <choice correct=\"true\">%s</choice>\n",choice[i]) >> outputfile;
	} else {
	    printf("      <choice correct=\"false\">%s</choice>\n",choice[i]) >> outputfile;
	}
    }
    print "    </choicegroup>" >> outputfile;
    print "  </multiplechoiceresponse>" >> outputfile;
    print "</problem>" >> outputfile;
    close(outputfile);
}

function outputfbfile() {
    if (tfmode) {
	outputfile=sprintf("Problem%s_%03d.xml",FILENAME,num);
	print "<problem display_name=\"Dropdown\"  max_attempts=\"1\">" > outputfile;
	printf("  <p>%s</p>\n",header) >> outputfile;
	print "  <optionresponse>" >> outputfile;
	printf("   <optioninput options=\"('TRUE','FALSE')\" correct=\"%s\"/>\n",$0) >> outputfile;
	print "  </optionresponse>" >> outputfile;
	print "</problem>" >> outputfile;
	close(outputfile);
    } else {
	outputfile=sprintf("Problem%s_%03d.xml",FILENAME,num);
	print "<problem display_name=\"Text Input\" max_attempts=\"1\">" > outputfile;
	printf("  <p>%s</p>\n",header) >> outputfile;
	printf("    <stringresponse answer=\"%s\" type=\"ci\">\n",$0) >> outputfile
	gsub(/['"]/,"",header);
	printf("      <textline label=\"%s\" size=\"40\"/>\n",header) >> outputfile
	print "    </stringresponse>" >> outputfile;
	print "</problem>" >> outputfile;
	close(outputfile);
    }
}
/True\/False/ {
    num=num-1;
    startfbreading=1; 
    startmcreading=0; 
    tfmode=1;
}
/Multiple-Choice/ {
    startfbreading=0;
    startmcreading=1; 
}
/Fill-in-the-Blank/ {
    num=num-1;
    startmcreading=0;
    startfbreading=1;
    tfmode=0;
}
/Short Answer/ {
    startfbreading=0;
}
(startmcreading) {
    if (/^[0-9]+\)/) {
	num=num+1;
	sub(/^[0-9]+\)/,"");
	gsub(/^ /,"");
	gsub(/ +/," ");
	gsub(/ $/,"");
	header="";
	nchoices=0;
    }
    if ($0 ~ /^[A-Z]\)/) {
	sub(/^.+\)/,"");
	choice[nchoices]=$0;
	nchoices++;
    }
    if (nchoices==0) {
	header=sprintf("%s %s",header,$0);
    }
    if ($0 ~ /Answer/) {
	truechoice=ord($2)-ord("A");
	outputmcfile();
    }
}
(startfbreading) {
    if ($1*1!=0) {
	num=num+1;
	sub(/^[0-9]+\)/,"");
	gsub(/^ /,"");
	gsub(/ +/," ");
	gsub(/ $/,"");
	header="";
    }
    if ($0 ~ /Answer/) {
	gsub(/Answer: +/,"");
	outputfbfile();
    } else {
	header=sprintf("%s %s",header,$0);
    }
}
