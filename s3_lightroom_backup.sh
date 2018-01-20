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
    --exclude="*Backups" \
    --exclude="Lightroom*" \
    --exclude="*.db*"
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
    --exclude="*Backups" \
    --exclude="Lightroom*" \
    --exclude="*.db*" | inc
}

function clean {
  TARGET=$1
  DRY="--dryrun"

  if [ "$2" == "--live" ]
  then
    DRY=""
  fi

  echo "Removing .DS_Store files"

  aws s3 rm $TARGET $DRY \
  --recursive \
  --exclude="*" \
  --include="*.DS_Store"
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
  *)
    echo "s3-lightroom-backup: sync, check, clean"
    ;;
esac
