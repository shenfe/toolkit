#!/bin/sh 

## 
## convert file from GB2312 to UTF-8
## 

path="$1"
echo "Processing '$path'..."
unset opt
if [ "$2" = "force" ]; then
    opt="-c -s"
fi

if [ -z "$path" ]; then
    echo "Usage: $0 <file or dir>"
elif [ ! -e "$path" ] ; then
    echo "Error: destination '$path' does not exist."
fi

if [ -f "$path" ] ; then
    echo "This is a file."
    echo "Converting $path (gb2312 --> utf-8) ..."
    if file "$path"|grep -q UTF-8 >/dev/null ; then
        echo "Already converted"
    else
        iconv -f gb2312 $opt -t utf-8 "$path" > /tmp/$$.tmp
        if [ $? -eq 0 ] ; then
            echo "Success"
            mv -f /tmp/$$.tmp "$path"
        else
            echo "Failed"
        fi
    fi
elif [ -d "$path" ] ; then
    echo "This is a directory."
    path=`echo "$path/"|sed 's/^ *//;s/ *$//'`
    find "$path" -path "$path.*" -prune -o -type f -print|while read i
    do
        dir=`dirname $i`
        file=`basename $i`
        echo "Converting $dir/$file (gb2312 --> utf-8) ..."
        iconv -f gb2312 -t utf-8 $opt "$i" > /tmp/$$.tmp 2>/dev/null
        if [ $? -eq 0 ] ; then
            echo "Success"
            mv -f /tmp/$$.tmp "$i"
        else
            echo "Failed"
        fi
    done
fi
