#!/bin/bash

filter="/^State\/Country|^ALASKA|^AMERICAN SAMOA|^GUAM|^HAWAII|^MIDWAY ISLANDS|^PUERTO RICO|^VIRGIN ISLANDS \(U|^WAKE ISLAND/"
d="[0-9]"

for f in ./*.xls; do
  year=$(basename $f .xls | sed "s/ovs\($d$d\)-$d$d/20\1/")
  month=$(basename $f .xls | sed "s/ovs$d$d-\($d$d\)/\1/")
  echo $month/$year $f
  excel2csv "$f" |
    awk "$filter{print}" |
    sed "s/\($d$d\/$d$d\),/\1\/$year,/g" |
    sed "s/ ,/,/g" |
    sed "s/\($d$d$d$d\)-\($d$d\)-\($d$d\)/\2\/\3\/\1/g" |
    sed "s/\(,Effective Date\)\$/\1,Publication Date/" |
    sed "s/\($d\)\$/\1,$month\/01\/$year/" \
      > "./$(basename $f .xls).csv"
done
