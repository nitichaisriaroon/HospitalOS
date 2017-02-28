#pid=$(head -n1 /hospitalos/PostgreSQL/9.2/data/postmaster.pid); ps uwf -p $pid --ppid $pid
sudo -u postgres /hospitalos/PostgreSQL/9.5/bin/psql -p 5432 -x -c "select * from pg_stat_replication;"
sudo -u postgres /hospitalos/PostgreSQL/9.5/bin/psql -p 5432 -c "select pg_xlog_location_diff(pg_current_xlog_location(),replay_location) from pg_stat_replication;"