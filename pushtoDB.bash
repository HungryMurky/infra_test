#!/bin/bash

# Gather system information
network_info=$(/usr/sbin/ifconfig)
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
current_time=$(date)
logged_in_users=$(who)
processes=$(ps aux)

# PostgreSQL credentials
DB_USER="myuser"
DB_PASSWORD="mypassword"
DB_NAME="mydatabase"
DB_CONTAINER="infra_test-postgres-1"

# Create and insert data using psql inside the container
docker exec -e PGPASSWORD="$DB_PASSWORD" $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -c "
DO \$\$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'system_info') THEN
        CREATE TABLE system_info (
            id SERIAL PRIMARY KEY,
            network_info TEXT,
            cpu_usage NUMERIC,
            recorded_time TIMESTAMP,
            logged_in_users TEXT,
            processes TEXT
        );
    END IF;
END
\$\$;"

docker exec -e PGPASSWORD="$DB_PASSWORD" $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -c "
INSERT INTO system_info (network_info, cpu_usage, recorded_time, logged_in_users, processes)
VALUES ('$network_info', $cpu_usage, '$current_time', '$logged_in_users', '$processes');
"
