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
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 20px;
        }
        h1 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ccc;
            padding: 10px;
            text-align: left;
            vertical-align: top; /* Align text to the top of the cell */
        }
        th {
            background-color: #f2f2f2;
        }
        td.network-info { /* Specific styling for Network Info column */
            width: 40%; /* Adjust width as needed */
        }
        pre {
            white-space: pre-wrap;       /* Wrap long lines */
            word-wrap: break-word;       /* Allows breaking inside words */
            background: #e9ecef;
            padding: 10px;
            border-radius: 5px;
        }
    </style>
</head>
<body>
    <h1>Latest System Information</h1>
    <table>
        <tr>
            <th>Recorded Time</th>
            <th class="network-info">Network Info</th>
            <th>CPU Usage (%)</th>
            <th>Logged In Users</th>
            <th>Processes</th>
        </tr>
        <tr>
            <td>$recorded_time</td>
            <td class="network-info"><pre>$network_info</pre></td>
            <td>$cpu_usage</td>
            <td><pre>$logged_in_users</pre></td>
            <td><pre>$processes</pre></td>
        </tr>
    </table>
</body>
</html>
EOL
