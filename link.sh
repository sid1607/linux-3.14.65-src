#/bin/bash
if [  "$#" -ne 1 ] || ! [ -d "$1" ]; then
	echo "Usage: $0 <linux-dir>" >& 2
	exit 1
fi
linux_dir=${1%/}
for dir in ./*/
do
    dir=${dir%*/}
    link=${dir##*/}
    rm -rf $linux_dir/$link 
    ln -s `pwd`/$link $linux_dir/$link
done
