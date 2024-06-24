Hashcat API Server

This repository provides scripts and instructions to deploy a Hashcat API server securely on a Debian-based system (e.g., Ubuntu).

Setup Instructions:

Clone Repository and Navigate

git clone https://github.com/SleepTheGod/Hashcat/
cd Hashcat
Run Setup Script

Execute the setup script to install dependencies, configure Apache, deploy Hashcat, and setup the PHP API:
sudo ./setup.sh
Accessing the Hashcat API

After setup completes, your Hashcat API will be accessible at:
http://your-server-ip/hashcat.php
Usage

Send HTTP GET requests to the API with parameters:

wordlist: Path to the wordlist (relative to /usr/share/hashcat/wordlist/)
rule: Path to the Hashcat rule file (relative to /usr/share/hashcat/rules/)
hash: Hash value to crack
Example request:

http://your-server-ip/hashcat.php?wordlist=rockyou.txt&rule=OneRuleToRuleThemAll.rule&hash=5f4dcc3b5aa765d61d8327deb882cf99
Security Notes:

Ensure to validate and sanitize user input ($_GET parameters in PHP script) to prevent injection attacks.
Review and adjust firewall (ufw) rules and Apache configurations (/etc/apache2/) based on your security policies.
Contributing:

Contributions are welcome! Feel free to submit issues or pull requests.
