#!/bin/bash

DRY="--dryrun"

function sync {
  SOURCE=$1
  TARGET=$2

  if [ "$3" == "--live" ]
  then
    DRY=""
  fi

  echo "Sync $DRY"

  aws s3 sync $SOURCE $TARGET $DRY \
    --exclude="*.DS_Store" \
    --exclude="Backups*" \
    --exclude="Lightroom*" \
    --exclude="*.db*" \
    --exclude="Temp*" \
    --include="Lightroom Catalog.lrcat"
}

function inc {
  while read -r line;
  do
    ((count++));
    echo -ne "\r$count";
  done
  echo
}

function check {
  SOURCE=$1
  TARGET=$2

  echo "Checking sync"

  count=0
  aws s3 sync $SOURCE $TARGET $DRY \
    --exclude="*.DS_Store" \
    --exclude="Backups*" \
    --exclude="Lightroom*" \
    --exclude="*.db*" \
    --include="Lightroom\ Catalog.lrcat" | inc
}

function clean {
  # aws cli leaves temp files when the download fails,
  # sometimes you accidentally upload them back to S3

  TARGET=$1
  echo "Removing Dingleberries files"

  aws s3 rm $TARGET --dryrun \
  --recursive \
  --exclude="*" \
  --include="*.DS_Store" \
  --include="*.*.*" | while read -r line;
    do
      if [[ $line =~ .*\.[a-zA-Z0-9]{8}$ ]]
      then
        f=$(echo $line | sed -e 's/(dryrun)\ delete:\ //g')
        if [ "$2" == "--live" ]
        then
          aws s3 rm "$f"
        else
          echo "$line"
        fi
      fi
    done
}


function clean_local {
  # aws cli leaves temp files when the download fails.

  TARGET=$1

  echo "Removing Dingleberries"

  fls=$(find "$TARGET" -type f)

  IFS=$'\n'
  for f in $fls
  do
    if [[ $f =~ .*\.[a-zA-Z0-9]{8}$ ]]
    then
      if [ "$2" == "--live" ]
      then
        echo "delete: $f"
        rm $f
      else
        echo "(dryrun) delete: $f"
      fi
    fi
  done
}

case $1 in
  "sync")
    sync $2 $3 $4
    ;;
  "check")
    check $2 $3
    ;;
  "clean")
    clean $2 $3
    ;;
  "clean_local")
    clean_local $2 $3
    ;;
  *)
    echo "s3-lightroom-backup: sync, check, clean"
    ;;
esac
