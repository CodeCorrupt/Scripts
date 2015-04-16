#!/bin/bash

if test -f $1
then
  echo "roll_back.sh: replacing $(ls -l $1 |awk '// {print $9" dated" ,$6,$7,$8}')"
  echo "roll_back.sh: with $(ls -l $1.v1 |awk '// {print $9" dated" ,$6,$7,$8}')"
                         mv $1    $1.new
  if test -f $1.v1; then mv $1.v1 $1    ; fi
  if test -f $1.v2; then mv $1.v2 $1.v1 ; fi
  if test -f $1.v3; then mv $1.v3 $1.v2 ; fi
  if test -f $1.v4; then mv $1.v4 $1.v3 ; fi
  if test -f $1.v5; then mv $1.v5 $1.v4 ; fi
  if test -f $1.v6; then mv $1.v6 $1.v5 ; fi
  if test -f $1.v7; then mv $1.v7 $1.v6 ; fi
  if test -f $1.v8; then mv $1.v8 $1.v7 ; fi
  if test -f $1.v9; then mv $1.v9 $1.v8 ; fi
else
   echo $1 does not exist!
fi
