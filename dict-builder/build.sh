#!/usr/bin/env bash

#Build text version of full dictionary

dict_loc=""
shopt -s extglob

#Check args
if [[ ($# -eq 0) || (-z $1) ]] ; then
    echo "Using default dictionary location of ../dict"
    dict_loc="../dict"
    echo $(ls $dict_loc)
elif [[ $# -eq 1 ]] ; then
    echo "Using supplied dictionary location of $1"
    dict_loc="$1"
    echo $(ls $dict_loc)
else
    echo "Unhandled input (arguments)"
    exit 5
fi

mkdir -p $dict_loc/built

#Check destination folder
if [[ !(-z $(ls -A $dict_loc/built/)) ]] ; then
    echo "Build directory not empty."
    read -p "Destroy contents and continue? [y/N]" confirm
    if [[ $confirm == [yY] ]] ; then
        echo "Destroying"
        rm -r $dict_loc/built/*
    elif [[ $confirm == [nN] || -z $confirm ]] ; then
        read -p "Not destroying, overwrite? [y/N]" owrite
        if [[ $owrite == [yY] ]] ; then
            echo "Overwriting"
        elif [[ $owrite == [nN] || -z $owrite ]] ; then
            echo "Not destroying or overwriting, quit."
            exit 1
        else
            echo "Unhandled input (prompt)"
            exit 4
        fi
    else
        echo "Unhandled input (prompt)"
        exit 4
    fi
fi

#Quick function
conc_to_built () {
	filnam=${1#$dict_loc/}
	echo "Adding $filnam"
	echo "From file $filnam" >> $dict_loc/built/fintext.txt
	echo "" >> $dict_loc/built/fintext.txt
	cat "$1" >> $dict_loc/built/fintext.txt
}

#Add top-level files
echo ""
echo "In top-level"
for txt in $dict_loc/*.txt ; do conc_to_built $txt ; done

for dir in $dict_loc/*/ ; do
    dir=${dir%*/}
    if [[ $dir == "$dict_loc/built" ]] ; then
        echo ""
        echo "Skipping destination directory in concatenation"
    else
        echo ""
        echo "In folder $dir"
        for txt in $dir/*.txt ; do conc_to_built $txt ; done
    fi
done

echo ""
echo "Finished textfile version"

#TODO: other versions

echo "Finished"
