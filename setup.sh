#!/bin/bash

# Update system and install necessary packages
apt -y update
apt -y install sudo git dnsutils wget apache2 libapache2-mod-php php-mcrypt php-mysql nvidia-opencl-dev ufw curl

# Clone Hashcat repository and compile
git clone https://github.com/hashcat/hashcat.git
cd hashcat
make
echo "export PATH=\$PATH:$(pwd)" >> ~/.bashrc
cd ..

# Download Hashcat rules
mkdir -p /usr/share/hashcat/rules
cd /usr/share/hashcat/rules
wget https://raw.githubusercontent.com/NotSoSecure/password_cracking_rules/master/OneRuleToRuleThemAll.rule

# Download example wordlists (e.g., RockYou)
mkdir -p /usr/share/hashcat/wordlist
cd /usr/share/hashcat/wordlist
wget http://downloads.skullsecurity.org/passwords/rockyou.txt.bz2
bunzip2 rockyou.txt.bz2

# Configure Apache and firewall
ufw allow 80
ufw allow 443
ufw allow http
ufw allow https
ufw allow in "Apache Full"
systemctl restart apache2

# Deploy Hashcat PHP API script with enhanced security
cat << 'EOF' > /var/www/html/hashcat.php
<?php
// Securely handle input parameters
$wordlist = isset($_GET['wordlist']) ? $_GET['wordlist'] : '';
$rule = isset($_GET['rule']) ? $_GET['rule'] : '';
$hash = isset($_GET['hash']) ? $_GET['hash'] : '';

// Validate and sanitize input parameters
$wordlist = str_replace('../', '', $wordlist); // Remove '../' from the wordlist path
$hash = preg_replace('/[^a-fA-F0-9]/', '', $hash); // Remove non-hex characters from hash
$rule = preg_replace('/[^a-zA-Z0-9_-]/', '', $rule); // Remove non-alphanumeric characters from rule

// Construct and execute Hashcat command
$command = "hashcat -m 1000 " . escapeshellarg($hash) . " " . escapeshellarg($wordlist) . " -r " . escapeshellarg($rule) . " -O";
exec($command, $output, $returnCode);

// Output the result securely
if ($returnCode === 0) {
    echo implode("\n", $output);
} else {
    echo "Error executing hashcat command.";
}
?>
EOF

# Set secure permissions for the PHP script
chown www-data:www-data /var/www/html/hashcat.php
chmod 440 /var/www/html/hashcat.php

# Display server IP address and URL
myip="$(dig +short myip.opendns.com @resolver1.opendns.com)"
echo "Hashcat API URL: http://${myip}/hashcat.php"
