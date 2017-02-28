#!/bin/bash
# Script install for HospitalOS Ubuntu 14.04 amd64
# By Nitichai Sriaroon <nitichai@hospital-os.com>
# Create Mar 15, 2016
# Edit By nitichai 
# Change Backup to Parallel dumps,PostgreSQL9.5
echo “Install HospitalOS Server For Ubuntu 14.04 amd64”
echo “Version HospitalOS_1404Build03”
echo “PostgreSQL Version 9.5”
echo “Pls Install PostgreSQL Path = /hospitalos/PostgreSQL/9.5”
echo “Java 1.6.0_45”
echo “Backup Slony-I & Parallel Dumps”
instHos=/root/install_HospitalOS
etpr=/etc/profile
pgHome=/hospitalos/PostgreSQL/9.5
Orif=/backup/ori_files
hCro=/backup/cron
hImp=/backup/implement
mkdir -p $Orif
cd $instHos
#dpkg -i pak/*  # packages depend on version that you've chosen
#locale-gen th_TH.UTF-8
useradd -m postgres;useradd -m hos
clear
chmod +x post*;./post*;sleep 1
#echo "#set path" >> /root/.bashrc
#echo "export PATH=${PATH}:/hospitalos/PostgreSQL/9.5/bin:/hospitalos/java/jdk1.6.0_45/bin:/hospitalos/glassfish3/glassfish/bin" >> /root/.bashrc
#echo "#set path" >> $etpr
#echo "export PATH=${PATH}:/hospitalos/PostgreSQL/9.5/bin:/hospitalos/java/jdk1.6.0_45/bin:/hospitalos/glassfish3/glassfish/bin" >> $etpr
#source $etpr /root/.bashrc
cd $pgHome/data
cp pg_hba.conf $Orif/pg_hba.conf.ori
cp postgresql.conf $Orif/postgresql.conf.ori
sed -i "/local   all/s/md5/trust/" pg_hba.conf
sed -i "/127.0.0.1/s/md5/trust/" pg_hba.conf
sed -i "/#track_c/s/#track_c/track_c/" postgresql.conf
sed -i "/# Ena/s/#auto/auto/" postgresql.conf
/etc/init.d/postgresql-9.5 restart
clear

#DB
pgPath=$pgHome/bin
echo -n "Please enter your database's name : ";read DB
$pgPath/createdb $DB -U postgres
echo;echo "Already Created Database : $DB"
sleep 1

#Backup
pgBak=/backup/postgres_backup
mkdir $pgBak;cd $_
mkdir -p $hCro Daily Daily2 CheckDB Report1 Report2 Sun Mon Tue Wed Thu Fri Sat Month Midmonth
cd $hCro
echo "#!/bin/sh" > daily.sh
echo "/bin/rm -rf $pgBak/Daily/*" >> daily.sh
echo "$pgPath/pg_dump -Fd $DB -j10 -f $pgBak/Daily/\$(date +%Y%m%d)" >> daily.sh
cp daily.sh daily2.sh;sed -i "s/Daily/Daily2/g" daily2.sh
echo "#!/bin/sh" > report1.sh
echo "$pgPath/pg_dump -i report50 > $pgBak/Report1/report50.sql" >> report1.sh
cp report1.sh report2.sh;sed -i "s/Report1/Report2/g" report2.sh
echo "#!/bin/sh" > check.sh
echo "du -m --time $pgBak/Daily >> $pgBak/CheckDB/sum_db.txt" >> check.sh
echo "#!/bin/sh" > sun.sh
echo "/bin/rm -rf $pgBak/Sun/*" >> sun.sh
echo "$pgPath/pg_dump -Fd $DB -j10 -f $pgBak/Sun/\$(date +%Y%m%d)" >> sun.sh
cp sun.sh mon.sh;sed -i "s/Sun/Mon/g" mon.sh
cp sun.sh tue.sh;sed -i "s/Sun/Tue/g" tue.sh
cp sun.sh wed.sh;sed -i "s/Sun/Wed/g" wed.sh
cp sun.sh thu.sh;sed -i "s/Sun/Thu/g" thu.sh
cp sun.sh fri.sh;sed -i "s/Sun/Fri/g" fri.sh
cp sun.sh sat.sh;sed -i "s/Sun/Sat/g" sat.sh
cp sun.sh month.sh;sed -i "s/Sun/Month/g" month.sh
cp sun.sh midmonth.sh;sed -i "s/Sun/Midmonth/g" midmonth.sh
chmod 755 *

#Crontab
#mv $instHos/cron* $Orif
crontab -u postgres $instHos/cron_postgres
chown postgres.postgres -R $hCro $pgBak

#Samba
#mkdir -m777 $hImp;cd $_
#mkdir -m777 Documents HprintingCenter Manuals OtherPrograms PatchModules
#chown hos.hos -R $hImp
#cd /etc/samba
#cp smb.conf $Orif/smb.conf.ori

#echo  >> smb.conf
#echo "[Implement]" >> smb.conf
#echo "    comment = HospitalOS Share" >> smb.conf
#echo "    path = /backup/implement" >> smb.conf
#echo "#    valid users = hos" >> smb.conf
#echo "    guest ok = yes" >> smb.conf
#echo "    public = yes" >> smb.conf
#echo "    browsable = yes" >> smb.conf
#echo "    writable = yes" >> smb.conf
#sleep 1

#echo "Please enter password of username 'hos'"
#passwd hos;sleep 0.5
#echo;echo "Please enter samba password for username 'hos'"
#smbpasswd -a hos;sleep 1;clear
#cd $instHos

#Java
#hjava=/hospitalos/java
#mkdir /hospitalos/java
#chmod +x jdk*;./jdk*
#mv jdk1* $hjava
#chmod 755 -R $hjava
#echo "export JAVA_HOME=/hospitalos/java/jdk1.6.0_45" >> $etpr
#echo "export JAVA_PATH=/hospitalos/java/jdk1.6.0_45/bin" >> $etpr
#echo "export HISTTIMEFORMAT='%F %T | '" >> $etpr
#chmod 744 $etpr

#Autoupdate
#cp -R autoupdate /var/www/html/
#chmod +x -R /var/www/html/autoupdate

#Slony
tar xjvf slony1-2.2.4.tar.bz2
cd slony1-2.2.4
./configure --with-pgconfigdir=$pgHome/bin/
make
make install

clear;echo
echo "  Backup crontab files are in : $hCro"
echo "  Database backup files are in : $pgBak"
echo "  Original files are in : $Orif"
echo "  Share path : /backup/implement"
#echo;sleep 2
#echo "Press 'Enter' button then system will reboot in 5 sec.";read
#echo 3;sleep 1;echo 2;sleep 1;echo 1;sleep 1;reboot
