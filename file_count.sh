#!/bin/bash

fileCount=0
lineCount=0

function funCount()
{
    for file in `ls $1`
    do
        if [ -d $1"/"$file ]; then
            funCount $1"/"$file
        else
            declare -i fileLines
            fileLines=`sed -n '$=' $1"/"$file`
            let lineCount=$lineCount+$fileLines
            let fileCount=$fileCount+1
        fi
    done
}

if [ $# -gt 0 ]; then
    for m_dir in $@
    do
        funCount $m_dir
    done
else
    funCount "."
fi

echo "file count: $fileCount"
echo "line count: $lineCount"
