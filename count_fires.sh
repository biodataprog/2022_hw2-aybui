# Download a comma delimited datasets from https://data.cnra.ca.gov/ which are listing of fires in several decades larger than 5000+
cd GEN220_data/data
curl https://gis.data.cnra.ca.gov/datasets/CALFIRE-Forestry::recent-large-fire-perimeters-5000-acres.csv?outSR=%7B%22latestWkid%22%3A3857%2C%22wkid%22%3A102100%7D > calfires_2021.csv


# Print out the range of years that occur in this file
cut -d "," -f 2 calfires_2021.csv | sort | uniq
nano calfires_2021.csv # Edit rows 11 and 13 so that they will not appear as their own rows
cut -d "," -f 2 calfires_2021.csv | sort | uniq
YEARMIN=$(cut -d "," -f 2 calfires_2021.csv | sed 1d | sort -n | uniq | head -n 1)
YEARMAX=$(cut -d "," -f 2 calfires_2021.csv | sed 1d | sort -n -r | uniq | head -n 1)
echo "The range of years are $YEARMIN-$YEARMAX"


# Print out the number of fires in the database
firenumb=$(sed 1d calfires_2021.csv | wc -l)
echo "The number of fires in the database is $firenumb"


# Print out the number of fires that occur each year
fireyearly=$(cut -d ',' -f 2 calfires_2021.csv | sed 1d | sort | uniq -c)
echo "The number of fires occuring each year are $fireyearly"


# Print out the name largest fire and acres it burned
for LARGEST in $(sort -t ',' -k13,13 -n -r calfires_2021.csv | cut -d ',' -f 6 | head -n 1)
do
   LARGESTACRES=$(cut -d ',' -f 13 calfires_2021.csv | sed 1d | sort -n -r | head -n 1)
   echo "The largest fire was $LARGEST and burned $LARGESTACRES"
done


# Print out the total acreage burned in each years
for YEAR in $(sed 1d calfires_2021.csv | awk -F, '{arr[$2]+=$13} END {for (i in arr) {print i}}' | sort)
do
   TOTAL=$(sed 1d calfires_2021.csv | awk -F, '{arr[$2]+=$13} END {for (i in arr) {print i, arr[i]}}' | sort | grep $YEAR | cut -d ' ' -f 2)
   echo "In Year $YEAR, Total was $TOTAL"
done
