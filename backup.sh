#! /bin/sh
#read options
echo "--------- Welcome to backup pro ---------"
echo -e  "\n 1:Full \n 2:Incremental"
echo "Enter your choice of Full or Incremental Backup:"
read choice
echo "Enter the extension of files to be backed up (e.g. 'sh', 'jpg'):"
read filetype
echo "Enter the backup destination folder:"
read destination
echo "*Computation begins"

###pre-process
#Add *. to specified filetype
filetype=*.$filetype
echo "File type: $filetype"
#Add / to specified destination directory
destination=$destination/
echo "Backup Destination: $destination"
#Set the backup file name
OF=my-backup-$(date +%Y%m%d-%H%M).tgz
echo "Output File: $OF"
#Set the error file name
EF=error.log
mkdir -p $destination

#perform computation
TG=$destination$OF
echo $TG


case $choice in
  1)
    echo "--The selected backup type is Full backup"
    echo "--Backing up $filetype files.."
    sleep 1
    cp *.$filetype $destination
    tar -zcvf $OF $destination   2>$EF
    mv $OF $destination; cd $destination; rm $filetype; cd ..;
    sleep 1
    echo "--Contents of $EF File:"; tail $EF
    break
  ;;
  2)
    echo "--The selected backup type is Incremental Backup"
    ##ls -l | awk 'END {print $9 "\t" $8}'
    ##find -name "*.$filetype" -newer timestamp.file -exec cp '{}' "$destination" +
    find $filetype -newer timestamp.file -exec cp {} $destination \;
    echo "about to create tar"
    tar -zcvf $OF $destination   2>$EF
    mv $OF $destination; cd $destination; rm $filetype; cd ..;
    sleep 1
    echo "--Contents of $EF File:"; tail $EF
    break
  ;;
esac
exit 0
