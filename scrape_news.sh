#!/bin/bash
# =============================================================================
# File Name:    scrape_news.sh
# Description:  Counts the number of times the words 'Gantz' and 'Netanyahu'
#               appear in each article of 'https://www.ynetnews.com/category/'.
# =============================================================================

# Constants
tmp_dir=/tmp/scrape_news
html_file=$tmp_dir/ynet.html
links_file=$tmp_dir/links.txt
regex="https://www.ynetnews.com/article/[a-zA-Z0-9]{9,10}"
tmp_file=$tmp_dir/tmp.html
output_file=./results.csv

# Prep for temp and output files
rm -f "$output_file"

if [ ! -d $tmp_dir ] 
then
    mkdir $tmp_dir
fi

# Get all article links from page
wget -q https://www.ynetnews.com/category/3082 -O $html_file
grep -E -o $regex $html_file | sort | uniq > $links_file
link_count=$(cat $links_file | wc -l)
echo $link_count >> results.csv

# Check each link for words
while read line
do
  wget -q $line -O $tmp_file
  Gantz=$(grep -o "Gantz" $tmp_file | wc -l)
  Netanyahu=$(grep -o "Netanyahu" $tmp_file | wc -l)
  echo -n "$line, " >> results.csv

  if (("$Gantz"==0 && "$Netanyahu"==0))
  then
    echo "-" >> results.csv
  else
    echo "Netanyahu, $Netanyahu, Gantz, $Gantz" >> results.csv
  fi
done < $links_file

# Cleanup
rm -rf $tmp_dir