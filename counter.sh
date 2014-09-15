#!/bin/bash

# script informing about total size and number of files in current folder 

echo -n "Total files size: "
du -sh
echo -n "Number of files: "
ls -lR|grep ^-|wc -l
