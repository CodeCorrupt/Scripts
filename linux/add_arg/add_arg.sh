#!/bin/bash

# Process Arguments
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
bays=0
units=0
lcs=0
add_arg=1
force=0
arg_str="+t"

while getopts "h?buldfa:" opt; do
    case "$opt" in
    h|\?)
        echo "Usage goes here"
        return 0
        ;;
    b)  bays=1
        ;;
    u)  units=1
        ;;
    l)  lcs=1
        ;;
    d)  add_arg=0 #Will undo the trace (Delete the +t)
        ;;
    f)  force=1 #Will force the change and not ask for each entry, but will still ask at the end for restart
        ;;
    a)  arg_str=$OPTARG
        ;;
    *)
        echo "what the hell did you enter???"
        return 0
        ;;
    esac
done

shift $((OPTIND-1))

[ "$1" = "--" ] && shift


# Actual code...

ask () {
    if [ "$force" -eq "1" ]
    then
        return 0
    else
        while :
        do
            read -p "Modefy $1? (y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]]
            then
                return 0
            elif [[ $REPLY =~ ^[Nn]$ ]]
            then
                return 1
            else
                echo "I don't recognize \"$REPLYi\""
            fi
        done
    fi
}

echo "--IMPORTANT-- None of the imputs are MySql escaped. PLEASE do not put any hacker shit!"
echo "Enter two digit bay #s comma separated: "
read bay_no
bay_cfg=$(echo $(mysql -u ttadmin -ptoptech -D Tms6Data --skip-column-names -e "SELECT config_file FROM BayProfile WHERE ld_bay IN ($bay_no);") | tr " " "\n" | sort | uniq)
echo -e "\nBay Configs:\n----------\n$bay_cfg"
unit_cfg=$(echo $(mysql -u ttadmin -ptoptech -D Tms6Data --skip-column-names -e "SELECT config_file FROM PresetProfile WHERE ld_bay IN ($bay_no);") | tr " " "\n" | sort | uniq)
echo -e "\nUnit Configs:\n----------\n$unit_cfg"
bay_lc=$(echo $(mysql -u ttadmin -ptoptech -D Tms6Data --skip-column-names -e "SELECT lc_name FROM BayProfile WHERE ld_bay IN ($bay_no);") | tr " " "\n" | sort | uniq)
echo -e "\nBay LCs:\n----------\n$bay_lc"
unit_lc=$(echo $(mysql -u ttadmin -ptoptech -D Tms6Data --skip-column-names -e "SELECT control_name FROM PresetProfile WHERE ld_bay IN ($bay_no);") | tr " " "\n" | sort | uniq)
echo -e "\nUnit LCs:\n----------\n$unit_lc"


echo "bays = $bays"
echo "units = $units"
echo "lc = $lc"
echo "add_arg = $add_arg"
echo "force = $force"
echo "arg_str = $arg_str"

cd /tms6/cfg # Switch to the cfg directory as none of the file names are fully pathed
if [ "$bays" -eq "1" ]
then
    for bay in $bay_cfg
    do
        bayarg=$(tail -1 $bay | rev | cut -d' ' -f2- | rev | awk '{print $0" "}')$arg_str
        if ask $bay
        then
            if [ "$add_arg" -eq "1" ]
            then
                if grep -q -w "$arg_str" "$bay"
                then
                    echo "$bay is already uses $arg_str"
                else
                    echo "adding $arg_str to $bay"
                    echo "$bayarg" >> $bay
                fi
            else
                if grep -q -w "$arg_str" "$bay"
                then
                    echo "removing $arg_str form $bay"
                    sed --in-place=.bak "/$arg_str\b/d" $bay
                else
                    echo "$bay is not using $arg_str"
                fi
            fi
        else
            echo "Skipping $bay"
        fi
    done
fi

if [ "$units" -eq "1" ]
then
    for unit in $unit_cfg
    do
        unitarg="$arg_str"
        if ask $unit
        then
            if [ "$add_arg" -eq "1" ]
            then
                if grep -q -w "$arg_str" "$unit"
                then
                    echo "$unit already uses $arg_str"
                else
                    echo "adding $arg_str to $unit"
                    echo "$unitarg" >> $unit
                fi
            else
                if grep -q -w "$arg_str" "$unit"
                then
                    echo "removing $arg_str form $unit"
                    sed --in-place=.bak "/$arg_str\b/d" $unit
                else
                    echo "$unit is not using $arg_str"
                fi
            fi
        else
            echo "Skipping $unit"
        fi
    done
fi

#if [ "$lcs" -eq "1" ]
#then
#    for lc in $lcs
#    do
#        
#    done
#fi
