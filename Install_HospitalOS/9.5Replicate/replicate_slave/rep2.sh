echo Stopping PostgreSQL
sudo service postgresql-9.5 stop
echo Cleaning up old cluster directory
sudo -u postgres rm -rf /hospitalos/PostgreSQL/9.5/data/*
echo Starting base backup as replicator
sudo -u postgres /hospitalos/PostgreSQL/9.5/bin/pg_basebackup —P -R -X stream -h master -D /hospitalos/PostgreSQL/9.5/data -U replicador
sudo -u postgres sed -i "s/#hot_standby = off/hot_standby = on/g" /hospitalos/PostgreSQL/9.5/data/postgresql.conf
echo Writing recovery.conf file
sudo -u postgres bash -c "cat > data/recovery.conf <<- _EOF1_
  standby_mode = 'on'
  primary_conninfo = 'user=replicador host=master port=5432 application_name=hospitalos' 
trigger_file = '/tmp/promoted'
_EOF1_
"
echo Startging PostgreSQL
sudo service postgresql-9.5 start
