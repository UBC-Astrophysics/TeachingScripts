#!/usr/bin/perl
# Converts data from WebCT into a format suitable for the FSC upload
# It also calculates the distribution for the grade report
# 90-100 A+
# 85-89	 A
# 80-84	 A-
# 76-79	 B+
# 72-75	 B
# 68-71	 B-
# 64-67	 C+
# 60-63	 C
# 55-59	 C-
# 50-54	 D
# 0-49	 F (Fail)
$connect_mode=0;
$scaling=4;
$provgradecol=20;
$finalgradecol=28;
$finalexamcol=29;
$useridcol=2;
$tutorialcol=4;
$year='2015W';
$session='UBC';
$dept='ASTR';
$course='311';
$section='201';
$nstud=0;
$title[0]='80 - 100 A';
$title[1]='68 -  79 B';
$title[2]='55 -  67 C';
$title[3]='50 -  54 D';
$title[4]=' 0 -  49 F';
$firstline=1;
while (<>) {
    @a=split(',');
#    unless ( $#a==108 ) {
#	print "$a[0],$#a\n";
#    }
    if ($firstline) {
	$firstline=0;
	if ($connect_mode) {
	    print "$a[0],$a[1],$a[2],$a[$provgradecol]\n";
	} else {
	    print "Session,Campus,Student Number,Subject,Course,Section,Percent Grade,Standing,Standing Reason\n";
	}
    }
    $a[$finalexamcol]=~s/"//g;
    unless ( /^\#/ || $a[$finalexamcol]=='' ) {
	$a[$finalgradecol] =~ s/"([0-9\.]*)%"/\1/;
	$grade=int($a[$finalgradecol]*100+0.5)+$scaling;
	if ($grade>=43 && $grade<50) {
	    $grade=50;
	}
	if ($grade==49 || $grade==54 || $grade==67 || $grade==79 || $grade==89) {
	    $grade++;
	}
	$id=$a[$useridcol];
	if ($connect_mode==1) {
	    $id =~ s/s//;
	    print "$a[0],$a[1],$id,$grade\n";
	} else {
	    $id =~ s/["s]//g;
	    print "$year,$session,$id,$dept,$course,$section,$grade\n";
	}
	$nstud++;
	$sum+=$grade;
	$sum2+=$grade*$grade;
	if ($grade>=79.5) {
	    $n[0]++;
	} elsif ($grade>=67.5) {
	    $n[1]++;
	} elsif ($grade>=54.5) {
	    $n[2]++;
	} elsif ($grade>=49.5) {
	    $n[3]++;
	} else {
	    $n[4]++;
	}
    }
}
$mean=$sum/$nstud;
$sd=sqrt($sum2/$nstud-$mean*$mean);
print "# Grade Report\n";
print "# Course: $dept $course $year$session\n";
print "# Section: $section\n";
print "# $nstud students with mean of $mean (sd= $sd)\n";
print "# Scaling of $scaling points\n";
for ($i=0;$i<5;$i++) {
    print "# $title[$i] : $n[$i]\n";
}
