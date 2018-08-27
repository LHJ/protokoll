#!/bin/bash
origpath=$(pwd)

ordf="August Eriksson"
sekr="Jens Lindholm"

# Choose what date the meeting as being held: eg. 2017-11-30
if [ ! -z "$1"} ] && [ $1='-d' ]
then
    date=$(date +%Y-%m-%d)
    month=$(date +%m-%B)
else
    date=$(date -d $2 +%Y-%m-%d)
    month=$(date -d $2 +%m-%B)
fi

year=$(echo $date | cut -f1 -d-)
day=$(echo $date | cut -f3 -d-)
dir="$year/$month/$day"
template="mall"

if [ ! -e $dir ]; then
    if [ ! -e $template ]
    then
        exit 1
    fi

    if [ ! -e $year ]
    then
        mkdir -p $year
    fi

    if [ ! -e "$year/$month" ]
    then
        mkdir -p "$year/$month"
    fi

    mkdir $dir
    cp -v "$template/"* "$dir"
    cd $dir

    echo "Renaming 'mall.tex' to '$date.tex'"
    mv mall.tex $date.tex
    echo "Replacing \\date in .tex file to current date: $date."
    sed -i "s/\\\date{.*}/\\\date{$date}/" $date.tex

    # Replace the kind of meeting being held
    if [ $1=="-s" ]
    then
        sed -i "s/\\\typ{.*}/\\\typ{Styrelsemöte}/" $date.tex
    elif [ $1=="-m" ]
    then
        sed -i "s/\\\typ{.*}/\\\typ{Medlemsmöte}/" $date.tex
    elif [ $1=="-å" ]
    then
        sed -i "s/\\\typ{.*}/\\\typ{Årsmöte}/" $date.tex
    fi

    # If the names are defined in the script:
    # Insert some of the default names
    if [ -n "$ordf" ] && [ -n "$sekr" ]
    then
        sed -i "s/\\\forordf{.*}/\\\forordf{$ordf}/" $date.tex
        sed -i "s/\\\ordf{.*}/\\\ordf{$ordf}/" $date.tex
        sed -i "s/\\\sekr{.*}/\\\sekr{$sekr}/" $date.tex
        echo "Replacing \\ordf{} and \\sekr{} with defaults assigned in script."
    fi

    echo "Finished."
else
    echo "Directory '$dir' already exists."
fi


