#!/bin/bash
# Ensure script is running as root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script with sudo."
  exit 1
fi
CONF_FILE="/etc/sysctl.conf"
echo "Optimizing Linux storage write buffers..."
# Check if the settings already exist to prevent duplicates
if grep -q "vm.dirty_background_ratio" "$CONF_FILE"; then
  echo "Buffer configurations already exist in $CONF_FILE. Skipping append."
else
# Append production rules safely to the end of the file
  echo -e "\n# Optimized parameters for external USB drive storage stability\nvm.dirty_background_ratio = 5\nvm.dirty_ratio = 10" >> "$CONF_FILE"
  echo "Optimization rules successfully appended to $CONF_FILE."
fi

# Force the OS kernel to re-read and apply configurations instantly
echo "🔄 Reloading system control kernel configurations..."
sysctl -p
echo "buffer optimization completed successfully!"
