#!/bin/bash
# Script install for HospitalOS Ubuntu 14.04 amd64
# By nitichai Feb 01,2015 
# Change Backup to Parallel dumps PostgreSQL 9.3
instHos=/root/cron_pg_9.3
etpr=/etc/profile
pgHome=/hospitalos/PostgreSQL/9.3
Orif=/backup/ori_files
hCro=/backup/cron
hImp=/backup/implement
mkdir -p $Orif
cd $instHos
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
echo "/bin/rm -f $pgBak/Daily/*" >> daily.sh
echo "$pgPath/pg_dump -i $DB | gzip -9 > $pgBak/Daily/$DB.sql.gz" >> daily.sh
cp daily.sh daily2.sh;sed -i "s/Daily/Daily2/g" daily2.sh
echo "#!/bin/sh" > report1.sh
echo "$pgPath/pg_dump -i reportcenter > $pgBak/Report1/reportcenter.sql" >> report1.sh
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
mv $instHos/cron* $Orif
crontab -u postgres $Orif/cron_postgres
chown postgres.postgres -R $hCro $pgBak
crontab -u root $Orif/cron_root;echo;sleep 1

clear;echo
echo "  Backup crontab files are in : $hCro"
echo "  Database backup files are in : $pgBak"





CREATE EXTENSION dblink;
-- CREATE EXTENSION dblink; รันครั้งแรก

SET var.slave_db = 'host=192.168.1.139 dbname=11373 port=5432 user=postgres password=postgres';
-- var.slave_db host ของเครื่อง slave
GO

(select
        't_visit' as tables
        ,count(*) as master
        ,(t_visit_slave.counts) as slave 
from t_visit
        cross join (select count(*)  as counts from dblink(current_setting('var.slave_db'), 'select t_visit_id from t_visit ') as ( t_visit_id text))  as t_visit_slave
group by
        slave

union

select
        't_patient' as tables
        ,count(*) as master
        ,(t_patient_slave.counts) as slave 
from t_patient
        cross join (select count(*)  as counts from dblink(current_setting('var.slave_db'), 'select t_patient_id from t_patient ') as ( t_patient_id text))  as t_patient_slave
group by
        slave


union

select
        't_health_family' as tables
        ,count(*) as master
        ,(t_health_family_slave.counts) as slave 
from t_health_family
        cross join (select count(*)  as counts from dblink(current_setting('var.slave_db'), 'select t_health_family_id from t_health_family ') as ( t_health_family_id text))  as t_health_family_slave
group by
        slave

union

select
        't_order' as tables
        ,count(*) as master
        ,(t_order_slave.counts) as slave 
from t_order
        cross join (select count(*)  as counts from dblink(current_setting('var.slave_db'), 'select t_order_id from t_order ') as ( t_visit_id text))  as t_order_slave
group by
        slave

union

select
        't_billing' as tables
        ,count(*) as master
        ,(t_billing_slave.counts) as slave 
from t_billing
        cross join (select count(*)  as counts from dblink(current_setting('var.slave_db'), 'select t_billing_id from t_billing ') as ( t_billing_id text))  as t_billing_slave
group by
        slave

)
order by tables asc