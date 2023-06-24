#!/bin/bash

_help() {
    echo " Usage: ./countlines.sh -o <owner> or -m <month>"
    echo "-o <owner> : Select files where the owner is <owner>"
    echo "-m <month>:  Select files where the creation month is month <month>"
    echo "      Only one the options should be used at a time     "
   }
#Validar si trae el tipo y el argumento


# variables de tipo = _type y argumento = _argumet 


_countLine(){
_type="$1"
_argument="$2"

for _file in *; do
    # Si el elemento no es un archivo, saltar a la siguiente iteración.
    if [ ! -f "$_file" ]; then
    continue
    fi
    #Obtine la informacion de owner y la fecha
    _stats=$(stat -c '%U %y' "$_file")
    _owner=$(echo $_stats | cut -d' ' -f1)
    _month=$(echo $_stats | cut -d' ' -f2 | cut -d'-' -f2)
    _month_name=$(date -d "2000-$_month-01" '+%B')
       if ([ "$_type" == "owner" ] && [ "$_owner" == "$_argument" ]) || \
           ([ "$_type" == "month" ] && [ "$_month_name" == "$_argument" ]); then
            _lines=$(wc -l < "$_file")
            echo "File: $_file, Lines: $_lines"
        fi
    
done
}

if [ "$#" -eq 0 ]; then
    _help
    exit 1
fi
while getopts ":o:m:" _option; do
    case $_option in
        # La opción -o con 'owner' y el argumento  proporcionado.
        o)
            echo "Looking for files where the owner is: $OPTARG"
            _countLine "owner" "$OPTARG"
            exit 0
            ;;
        # La opción -m, con 'month' y el argumento  proporcionado.
        m)
            echo "Looking for files where the month is: $OPTARG"
            _countLine "month" "$OPTARG"
            exit 0
            ;;
        # Para cualquier otra opción, mostrar la ayuda y salir.
        *)
            _help
            ;;
    esac
done
