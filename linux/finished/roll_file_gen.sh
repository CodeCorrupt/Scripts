#!/bin/bash

if test -f $1.new
then
  echo "roll_file.sh: replacing $(ls -l $1 |awk '// {print $9" dated" ,$6,$7,$8}')"
  echo "roll_file.sh: with $(ls -l $1.new |awk '// {print $9" dated" ,$6,$7,$8}')"
  if test -f $1.v9; then rm $1.v9; fi
  if test -f $1.v8; then mv $1.v8 $1.v9; fi
  if test -f $1.v7; then mv $1.v7 $1.v8; fi
  if test -f $1.v6; then mv $1.v6 $1.v7; fi
  if test -f $1.v5; then mv $1.v5 $1.v6; fi
  if test -f $1.v4; then mv $1.v4 $1.v5; fi
  if test -f $1.v3; then mv $1.v3 $1.v4; fi
  if test -f $1.v2; then mv $1.v2 $1.v3; fi
  if test -f $1.v1; then mv $1.v1 $1.v2; fi
  if test -f $1;    then mv $1    $1.v1; fi
  mv $1.new $1
  echo "roll_file.sh new file signature"
else
  echo File $1.new does not exist!
fi

