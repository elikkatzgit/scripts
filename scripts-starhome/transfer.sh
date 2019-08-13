#!/bin/bash

source=/starhome/igate/input/
dest=10.0.0.1:/starhome/igate/probe/
file=TLS*

if [ ! -d $source/tmp ]; then
mkdir $source/tmp
fi

mv $source/$file $source/tmp/
scp $source/tmp/$file $dest

if [ "$?" -eq 0 ]; then
rm $source/tmp/$file
else
echo "cannot transfer"
fi

