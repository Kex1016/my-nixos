#!/run/current-system/sw/bin/bash

# This script is used to build the configurations. Edit them in the config folder.
# DO NOT TOUCH /etc/nixos DIRECTLY, it will always be overwritten by this script.

FILES=(
    configuration.nix
    home.nix
    packages.nix
    shell.nu
)

# Check if the files exist
for file in "${FILES[@]}"; do
    if [ ! -f config/$file ]; then
        echo "File $file does not exist"
        exit 1
    fi
done

# Remove the old configuration
echo "Removing old configuration files"

for file in "${FILES[@]}"; do
    sudo rm -rf /etc/nixos/$file
    echo "Removed $file"
done

# Copy the new configuration
echo "Copying new configuration files"

for file in "${FILES[@]}"; do
    sudo cp -r config/$file /etc/nixos/$file
    echo "Copied $file"
done

# Build the new configuration
echo "Building new configuration"
sudo nixos-rebuild switch
