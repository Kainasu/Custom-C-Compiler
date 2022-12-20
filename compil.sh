#!/bin/bash

if [ ! -f "./myc" ]; then
    echo "Executable myc introuvable"
    echo "Compilez le en faisant 'make'"
    exit 1
fi

if [ $# -ne 1 ]; then
    echo "Mauvais nombre d'arguments"
    echo "Usage : ./compil.sh <filename>.myc"
    exit 2
fi

if [ ! -f $1 ]; then
    echo "Fichier introuvable"
    exit 3
fi


if [[ $1 != *.myc ]]; then
    echo "Mauvaise extension du fichier"
    echo "Usage : ./compil.sh <filename>.myc"
    exit 4
fi

cfilename=$(basename $1 | sed 's/.myc$/.c/g')
./myc $1 $(dirname $1)/$cfilename

if [ $? != 0 ]; then
    echo "Une erreur lors de la compilation s'est produite"
    exit 5
else
    echo "Compilation réussie"
fi

exefilename=$(basename $1 | sed 's/.myc$//g')
gcc -Isrc -o $(dirname $1)/$exefilename $(dirname $1)/$cfilename src/PCode.c

if [ $? != 0 ]; then
    echo "Une erreur lors de la création de l'executable s'est produite"
    exit 5
else
    echo "Creation de l'executable réussie"
fi
