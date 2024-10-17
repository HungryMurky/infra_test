#!/bin/bash

# PostgreSQL credentials
DB_USER="myuser"
DB_PASSWORD="mypassword"
DB_NAME="mydatabase"
DB_CONTAINER="infra_test-postgres-1"

# Query the latest system info
latest_info=$(docker exec -e PGPASSWORD="$DB_PASSWORD" $DB_CONTAINER psql -U $DB_USER -d $DB_NAME -t -c "
SELECT network_info, cpu_usage, recorded_time, logged_in_users, processes
FROM system_info
ORDER BY recorded_time DESC
LIMIT 1;
")

# Extract data
network_info=$(echo "$latest_info" | awk -F '|' '{print $1}')
cpu_usage=$(echo "$latest_info" | awk -F '|' '{print $2}')
recorded_time=$(echo "$latest_info" | awk -F '|' '{print $3}')
logged_in_users=$(echo "$latest_info" | awk -F '|' '{print $4}')
processes=$(echo "$latest_info" | awk -F '|' '{print $5}')

# Create or overwrite the index.html file
cat <<EOL > /home/ec2-user/infra_test/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Information</title>
</head>
<body>
    <h1>Latest System Information</h1>
    <p><strong>Recorded Time:</strong> $recorded_time</p>
    <p><strong>Network Info:</strong> <pre>$network_info</pre></p>
    <p><strong>CPU Usage:</strong> $cpu_usage%</p>
    <p><strong>Logged In Users:</strong> <pre>$logged_in_users</pre></p>
    <p><strong>Processes:</strong> <pre>$processes</pre></p>
</body>
</html>
EOL
