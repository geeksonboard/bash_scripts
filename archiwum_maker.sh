#!/bin/bash


# +-------------------------------------------------------------------------+
# |                              GeeksOnBoard                               |
# |                               12.12.2013                                |
# +-------------------------------------------------------------------------+
# | Script makes ordered archives from image files                          |
# | -------------------------------------------------------------------     |
# | Calling syntax: ./archiwum_maker.sh folder_name width height            |
# | -------------------------------------------------------------------     |
# | Program creates archive catalog in the current folder                   |
# | !!!!implicitly overrides file of the same name (archiwum)!!!!!!!        |
# |                                                                         |
# | to change image size package ImageMagic is necessary                    |
# |                                                                         |
# +-------------------------------------------------------------------------+

# 0. input correctness check
 #if there are exactly 4 arguments (including the name)
 ([ $# -ne 3 ] && echo "Script $0: wrong number of arguments. Try: $0 [folder_name] [width] [height]" 1>&2) && exit 1

 #if specified file exists.
 ([ -e $1 ] || echo "Script $0: given file doesn't exist..." 1>&2) || exit 1

 #If ImageMagic package is installed
 [ -e `whereis convert > /dev/null 2>&1` ]  || echo "Package ImageMagic not installed. Search in repositories." 1>&2

# 1. Creating copies of JPEG/PNG files from given folder to archiwum

cd $1

test -d archiwum && rm -rf archiwum
mkdir archiwum
chmod 744 archiwum

for i in *.png ; do cp -a "$i" ./archiwum; done 2> /dev/null #otherwise he's too talkative
for i in *.jpeg ; do cp -a "$i" ./archiwum; done  2> /dev/null
for i in *.PNG ; do cp -a "$i" ./archiwum; done  2> /dev/null
for i in *.JPEG ; do cp -a "$i" ./archiwum; done  2> /dev/null

# 2. changing extensions to low capitals

cd archiwum

for i in * ; do
  ext=$i                                                                                                 
  new_ext=`echo "$(echo $i | cut -d . -f -1).$(echo $i | cut -d . -f 2  | tr [:upper:] [:lower:])"`
  [ "$ext" != "$new_ext" ]  && mv "$ext" "$new_ext"       #not to receive messages that file
                                                          #after change is the same as before
done

# 3. replacing spaces by underlines

for i in * ; do
  img=$i
  new_img=`echo "$i" | sed "s/\ /\_/g"`
  [ "$img" != "$new_img" ] && mv "$img" "$new_img"
done

# 4. changing image size to given values

for i in * ; do convert "$i" -scale $2x$3 "$i" ; done

cd ..
cd ..
test -d archiwum && rm -rf archiwum
mv $1/archiwum ./

# 5. creting tar archives from archiwum
test -d archiwum.tar && rm -rf archiwum.tar
tar -cf archiwum.tar archiwum

echo "finished!"
exit 0


