echo Stopping PostgreSQL
sudo service postgresql-9.5 stop

echo Cleaning up old cluster directory
sudo -u postgres rm -rf /opt/PostgreSQL/9.5/data/*

echo Starting base backup as replicator
sudo -u postgres /hospitalos/PostgreSQL/9.5/bin/pg_basebackup -h master -D /hospitalos/PostgreSQL/9.5/data -p 5432 -U postgres -v -P -R -X stream -c fast

echo Startging PostgreSQL
sudo service postgresql-9.5 start
