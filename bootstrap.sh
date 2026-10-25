#!/bin/bash
#
#If Anything fails this command will seize all progress
set -e
#
# Define the env variables
HOSTNAME=rhel9.example.com
USERNAME=admin
PASSWORD=welcome2027

# Set the device hostname
echo "Welcome, lets begin by setting the name of your device!" 
hostnamectl set-hostname "$HOSTNAME"
#
#
#
#
# Set IPv4 connection
echo "Great, now lets set connection to auto - IP address will be chosen for you"
nmcli connection modify eno1 ipv4.method auto
nmcli connection up eno1
#
#
#
#
# Create the administration account with full sudo access
echo "$USERNAME will be the primary account holder"
useradd -m -G wheel "$USERNAME" 
chpasswd "$USERNAME":"$PASSWORD"
#
#
#
#
#Create SSH Key for admin user
echo 'Now lets create the users directorys & set the correct permissions'
mkdir -p /home/"$USERNAME"/.ssh/
touch /home/"$USERNAME"/.ssh/authorized_keys
chmod 700 /home/"$USERNAME"/.ssh
chmod 600 /home/"$USERNAME"/.ssh/authorized_keys
chown -R "$USERNAME":"$USERNAME" /home/"$USERNAME"
#
#
#
#
#
#
# Create SSH Key for admin user
echo 'Now lets create the users ssh directory & adjust the permissions'
ssh-keygen -t ed25519 -N "" -f /home/"$USERNAME"/.ssh/"$USERNAME"_key
#
#
#
#
#
# Preinstall these packages 
dnf install -y git
#
#
#
# Let the user know their system is ready
echo 'Your system is ready, rebooting now...'
systemctl reboot
