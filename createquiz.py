import sys

def closefile():
    f.write("""
  </randomize>
</vertical>
""")
    f.close()
    print('  <vertical url_name="VerticalQuiz%s_%03d"/>' % (quiznumber,question))

quiznumber=sys.argv[1]
quiztitle=sys.argv[2]

content = sys.stdin.readlines()
nskip=len(content)/20
question=0
print('<sequential display_name="Quiz %s - %s" format="Quizzes" graded="true">' %
      (quiznumber,quiztitle))
for i, l in enumerate(content):
    if (i % nskip==0):
        if (question):
            closefile()
        question+=1
        f=open("VerticalQuiz%s_%03d.xml" % (quiznumber,question),"w")
        f.write("""<vertical display_name="Quiz %s, Question %d">
  <randomize>""" % (quiznumber,question))
    f.write("""
     <problem url_name="%s"/>""" % l.rstrip().replace('.xml',''))
if (question):
    closefile()
print('</sequential>')    
