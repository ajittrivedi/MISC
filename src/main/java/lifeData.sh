#!/bin/bash

year=$(date +'%Y')
month=$(date +'%m')
day=$(date +'%d')
currDate="$year$month$day"

# File Ingestion Variables
campaign_id=100001
campaign_name="AIA AU"
category_name="lifeData"
sftpLocation="/sftp/dmp/AU_AIA_DMP/to_lemnisk/"
fileNamePattern="AIA_LEMNISK_LIFE_PARTY_$currDate"
success=0

# SFTP Variables
tempFolder="/sftp/autoIngestion/$campaign_id/$category_name"
mkdir -p $tempFolder
cd "$tempFolder"


echo "------------------------START $(date)-------------------------"

rm ./*".tsv.gz"
cp "$sftpLocation$fileNamePattern"* .
echo "Files downloaded successfully"

files="ls $fileNamePattern"*
for file in $files
do
  /usr/bin/gpg2 --pinentry-mode=loopback --homedir /root/.gnupg/ --batch --passphrase-file=/root/gpf $file
  echo "File Decrypted: $?"
  unzip "$fileNamePattern"*".zip" && gzip "$fileNamePattern"*".tsv"
  echo "File Extracted"
  rm ./*".gpg" ./*".zip" ./*".eot"
  chmod 755 ./*
done

#rm "$fileNamePattern"
echo "------------------------END $(date)-------------------------"