# TeachingScripts

## findedxtoOSX

Finds links in EdX to OpenStax content and merges the OpenStax content into EdX.  How to use:  Create a Subsection in Edx ("Vertical Component") with the name of the corresponding directory on OpenStax in the OpenStax repository.   Download the course from EdX.  Run the script on the unpacked TAR file.  Repack and upload.

## shiftall.py

Shift all of the dates in a course archive forward a given number of days

usage:   python shiftall.py directory_to_process number_of_days

## add_edx_to_ubc_csv.py

Add the edx grades to the UBC classlist downloaded from the FSC

python add_edx_to_ubc_csv.py match_csv anonid_csv gradebook_csv class_list_csv output_csv

## create_final_upload.py

Using the output from Auto Multiple Choice (AMC) and the matching file between UBC IDs and Anon IDS from survey.ubc.ca create a file to upload to EdX using upload_csv.py

python create_final_upload.py AMC_grade_csv match_csv

## makelibrary.sh

Make a library.xml file from an existing set of directories with html, problem and video files.

## txt2library.sh

Create an EdX library of problems from a txt file with problems.

## txt2xml.awk

Generate a series of XML problems from an txt file with problems.

## combinecsv.py

Combine the output from AMC with a gradebook from Connect.

python3 combinecsv.py tutorials_b.csv ASTR311_2015W_tut2.csv a.csv 9 6

## upload_csv.py

Upload a gradebook in a CSV file to a particular LTI endpoint on EdX:

usage: upload_csv.py [-h] [--mapping-csv MAPPING_CSV] --platform-url
                     PLATFORM_URL [--endpoint ENDPOINT]
                     course_id grade_csv lti_key lti_secret

e.g.

 usage: upload_csv.py [-h] --platform-url PLATFORM_URL
                     course_id grade_csv mapping_csv lti_key lti_secret
                     [--endpoint choice_num]


grades.csv format
  1 - anon-id or edX ID to look up anon ID in the mapping file 
  2 - email just output to screen during the upload or name of assignment
  3 - score
  4 - total possible score
  5 - comment until the next comma or put in "quotes"

  the lti_key isn't actually important, as you have to choose which assignment
  the lti_secret is crucial



python upload_csv.py \
       --platform-url https://edge.edx.org \
       course-v1:UBCx+Heyl01+2015 \
       t.csv \
       lti_key lti_secret_password
