#!/bin/bash

# Take on argument from user, replace "skeleton" with that
if [ $# -ne 1 ]
then
    echo "Give the name of the project as argument"
    exit 1
fi

for file in $(git grep -r skeleton | awk -F: '{print $1}')
do
    sed -i "s/skeleton/$1/g" $file
done

for file in $(git grep -r SKELETON | awk -F: '{print $1}')
do
    sed -i "s/SKELETON/\L$1/g" $file
done

mv include/skeleton include/$1

echo "# About" > README.md
echo "" >> README.md
echo "This is a project called $1" >> README.md
