#!/bin/bash

# Process Arguments
# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

# Initialize our own variables:
output_file=""
bays=0
units=0
lcs=0
trace=1 #1 to put things in trace 0 to take them out
force=0
trace_str="+t"

while getopts "h?bultfs:" opt; do
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
    t)  trace=0 #Will undo the trace (Delete the +t)
        ;;
    f)  force=1 #Will force the change and not ask for each entry, but will still ask at the end for restart
        ;;
    s)  trace_str=$OPTARG
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
echo "Enter two digit bay #: "
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
echo "trace = $trace"
echo "force = $force"
echo "trace_str = $trace_str"

cd /tms6/cfg # Switch to the cfg directory as none of the file names are fully pathed
if [ "$bays" -eq "1" ]
then
    for bay in $bay_cfg
    do
        baytrace=$(tail -1 $bay | rev | cut -d' ' -f2- | rev | awk '{print $0" "}')$trace_str
        if ask $bay
        then
            if [ "$trace" -eq "1" ]
            then
                if grep -q -w "$trace_str" "$bay"
                then
                    echo "$bay is already in trace"
                else
                    echo "adding trace to $bay"
                    echo "$baytrace" >> $bay
                fi
            else
                if grep -q -w "$trace_str" "$bay"
                then
                    echo "removing trace form $bay"
                    sed --in-place=.bak "/$trace_str\b/d" $bay
                else
                    echo "$bay is already not in trace"
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
        unittrace="$trace_str"
        if ask $unit
        then
            if [ "$trace" -eq "1" ]
            then
                if grep -q -w "$trace_str" "$unit"
                then
                    echo "$unit is already in trace"
                else
                    echo "adding trace to $unit"
                    echo "$unittrace" >> $unit
                fi
            else
                if grep -q -w "$trace_str" "$unit"
                then
                    echo "removing trace form $unit"
                    sed --in-place=.bak "/$trace_str\b/d" $unit
                else
                    echo "$unit is already not in trace"
                fi
            fi
        else
            echo "Skipping $unit"
        fi
    done
fi

if [ "$lcs" -eq "1" ]
then
    for lc in $lcs
    do
        
    done
fi
