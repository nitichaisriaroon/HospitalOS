pid=$(head -n1 /opt/PostgreSQL/9.5/data/postmaster.pid); ps uwf -p $pid --ppid $pid
sudo -u postgres /opt/PostgreSQL/9.5/bin/psql -p 5432 -x -c "select pg_is_in_recovery();"
sudo -u postgres /opt/PostgreSQL/9.5/bin/psql -p 5432 -x -c "select pg_last_xlog_receive_location();"
sudo -u postgres /opt/PostgreSQL/9.5/bin/psql -p 5432 -x -c "select pg_last_xlog_replay_location();"
sudo -u postgres /opt/PostgreSQL/9.5/bin/psql -p 5432 -x -c "select pg_last_xact_replay_timestamp();"



