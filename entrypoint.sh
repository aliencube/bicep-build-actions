#!/bin/sh -l

set -e

if [ "$#" -lt 1 ]
then
echo  "Please provide at least one .bicep file"
exit
else
echo -e "\c"
fi

for file in "$@"
do
    bicep build $file
done
