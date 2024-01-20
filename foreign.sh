#!/bin/bash

d="[0-9]"
l="[a-zA-Z]"

for f in ./*.xls; do
  year=$(basename $f .xls | sed "s/$l*\($d$d$d$d\)PD/\1/")
  month=$(basename $f .xls | sed "s/\($l*\)\($d$d$d$d\)PD/\1/")
  echo $month/$year $f
  excel2csv "$f" |
    sed "s/ \{2,\}/ /g" |
    sed "s/ \{1,\},/,/g" |
    sed "s/,,,,,.*\$//" |
    sed "s/ \$//" |
    sed "s/,\{1,\}\$//" |
    sed "s/Country Name,/Country,/" |
    sed "s/Footnote Ref,/Footnote Reference,/" |
    sed "s/Footnote References,/Footnote Reference,/" |
    sed "s/Location Name,/Location,/" |
    sed "s/Lodging Rate,/Lodging,/" |
    sed "s/Meal \\& Incidentals,/Meals \\& Incidentals,/" |
    sed "s/Meals and Incidentals,/Meals \\& Incidentals,/" |
    sed "s/,,Effective Date,/,Per Diem,Effective Date,/" |
    sed "s/Season code,/Season Code,/" |
    sed "s/,Seasonal /,Season /" |
    sed "s/COUNTRY,LOCATION,SEASON CODE,SEASON START DATE,SEASON END DATE,LODGING,MEALS \\& INCIDENTALS,PER DIEM,EFFECTIVE DATE,FOOTNOTE REFERENCE,LOCATION CODE/Country,Location,Season Code,Season Start Date,Season End Date,Lodging,Meals \\& Incidentals,Per Diem,Effective Date,Footnote Reference,Location Code/" |
    sed "s/\(,Location Code\)/\1,Publication Date/" |
    sed "s/\($d\)\$/\1,\"$month 1, $year\"/" \
      > "./$(basename $f .xls).csv"
done
