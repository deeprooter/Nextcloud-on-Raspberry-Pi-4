#!/bin/bash
# Ensure script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script with sudo."
  exit 1
fi
CRON_JOB="*/5 * * * * docker exec -u abc nextcloud php /config/www/nextcloud/cron.php"
echo "⚙️  Configuring background maintenance cron task..."
# Read current root crontab lines, safely ignoring error if it is blank
CURRENT_CRONTAB=$(crontab -l 2>/dev/null)
# Verify if the Nextcloud cron string is already present
if echo "$CURRENT_CRONTAB" | grep -qF "docker exec -u abc nextcloud php"; then
  echo "Nextcloud cron configuration already exists. Skipping duplication."
else
  # Add the new automated task string to the existing crontab collection
  (echo "$CURRENT_CRONTAB"; echo "$CRON_JOB") | crontab -
  echo "Nextcloud cron execution string injected successfully."
fi
echo "Verifying updated active root crontab rules:"
crontab -l | tail -n 3
echo " Reminder: Log into your Nextcloud UI panel (Administration settings -> Basic settings) and switch the Background jobs setting from AJAX to Cron."
