#!/bin/sh

# use: randomData.sh -a 1 -b 2 -c 3 -d 4

blocksize=1024

# get options
while getopts x:a:b:c:d:e flag
do
    case "${flag}" in
        x) option=${OPTARG};;
        a) sizesmall=${OPTARG};;
        b) countsmall=${OPTARG};;
        c) sizebig=${OPTARG};;
        d) countbig=${OPTARG};;
	e) directory=${OPTARG};;
    esac
done



# set default values

if [ -z $option ];
 then
  echo "";
  echo "randomData.sh -x 1|2|3 [-a n] [-b n] [-c n] [-d n] [-e path]";
  echo "1 - big and small, 2 - small, 3 - big";
  echo "-a size small files, -b count small files";
  echo "-c size big files, -d count big files";
  echo "-e directory";
  echo "";
fi

if [ -z $sizesmall ]; then sizesmall="512"; fi
if [ -z $countsmall ]; then countsmall="1000"; fi
if [ -z $sizebig ]; then sizebig="1048576"; fi
if [ -z $countbig ]; then countbig="5"; fi
if [ -z $directory ]; then directory="./randomData/"; fi



small_files() {
 x=1;
 mkdir -p "$directory"small-files;
 while [ $x -lt $(($countsmall + 1)) ]
 do
  # dd bs="$blocksize" count="$sizesmall" </dev/urandom >"$directory"small-files/smallfile"$x".txt &> /dev/null
  dd bs="$blocksize" count="$sizesmall" if=/dev/urandom of="$directory"small-files/smallfile"$x".txt iflag=fullblock &> /dev/null
  echo "small file" $x "created."
  x=$(( $x + 1 ))
 done
}

big_files() {
 y=1;
 mkdir -p "$directory"big-files;
 while [ $y -lt $(($countbig + 1)) ]
 do
  # dd bs="$blocksize" count="$sizebig" </dev/urandom >"$directory"big-files/bigfile"$y".txt &> /dev/null
  dd bs="$blocksize" count="$sizebig" if=/dev/urandom of="$directory"big-files/bigfile"$y".txt iflag=fullblock &> /dev/null
  echo "big file" $y "created."
  y=$(( $y + 1 ))
 done
}



if [ "$option" = "1" ];
 then
  echo "**************************************";
  echo "-a size small files:  "$sizesmall;
  echo "-b count small files: "$countsmall;
  echo "-c size big files:    "$sizebig;
  echo "-d count big files:   "$countbig;
  echo "-e directory:         "$directory;
  echo "**************************************";
  echo "small files would consume: "$(($blocksize * $sizesmall * $countsmall / 1048576))" MB";
  echo "big files would consume: "$(($blocksize * $sizebig * $countbig / 1048576))" MB";
  echo "**************************************";
  echo "";
  echo "small and big files will be generated, to cancel press ctrl+c"
  read temppp
  small_files
  big_files
fi

if [ "$option" = "2" ];
 then
  echo "**************************************";
  echo "-a size small files:  "$sizesmall;
  echo "-b count small files: "$countsmall;
  echo "-e directory:         "$directory;
  echo "**************************************";
  echo "small files would consume: "$(($blocksize * $sizesmall * $countsmall / 1048576))" MB";
  echo "**************************************";
  echo "";
  echo "small files will be generated, to cancel press ctrl+c"
  read temppp
  small_files
fi

if [ "$option" = "3" ];
 then
  echo "**************************************";
  echo "-c size big files:    "$sizebig;
  echo "-d count big files:   "$countbig;
  echo "-e directory:         "$directory;
  echo "**************************************";
  echo "big files would consume: "$(($blocksize * $sizebig * $countbig / 1048576))" MB";
  echo "**************************************";
  echo "";
  echo "big files will be generated, to cancel press ctrl+c"
  read temppp
  big_files
fi
