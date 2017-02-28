sudo -u postgres /hospitalos/PostgreSQL/9.5/bin/pg_ctl -D /hospitalos/PostgreSQL/9.5/data/ promote
sudo -u postgres sed -i "s/hot_standby = on/#hot_standby = on/g" /hospitalos/PostgreSQL/95/data/postgresql.conf
sudo -u postgres sed -i "s/wal_level/#wal_level/g" /hospitalos/PostgreSQL/9.4/data/postgresql.conf
sudo -u postgres sed -i "s/max_wal_senders/max_wal_senders/g" /hospitalos/PostgreSQL/9.5/data/postgresql.conf
sudo -u postgres sed -i "s/wal_keep_segments/#wal_keep_segments/g" /hospitalos/PostgreSQL/9.5/data/postgresql.conf
sudo -u postgres sed -i "s/max_wal_senders/#max_wal_senders/g" /hospitalos/PostgreSQL/9.5/data/postgresql.conf
sudo -u postgres sed -i "s/synchronous_standby_names/#synchronous_standby_names/g" /hospitalos/PostgreSQL/9.5/data/postgresql.conf
sudo /etc/init.d/postgresql-9.5 restart
