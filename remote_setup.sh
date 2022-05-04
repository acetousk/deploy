# Disable Password ssh
FILE='/etc/ssh/sshd_config'
LINE='PasswordAuthentication no'
sudo grep -qF -- "$LINE" "$FILE" ||  echo "$LINE" | sudo tee -a "$FILE"
LINE='ChallengeResponseAuthentication no'
sudo grep -qF -- "$LINE" "$FILE" ||  echo "$LINE" | sudo tee -a "$FILE"
LINE='UsePAM no'
sudo grep -qF -- "$LINE" "$FILE" ||  echo "$LINE" | sudo tee -a "$FILE"

# Cat sshd_config
sudo cat -n /etc/ssh/sshd_config

# Find distro
. /etc/os-release

# Restart SSH Daemon
if [[ $ID -eq 'fedora' ]]; then
	echo "restarting sshd daemon on $ID"
	sudo systemctl restart sshd	
elif [[ $ID -eq 'debian' ]]; then
	echo "restarting ssh daemon on $ID"
	sudo systemctl restart ssh
else
	echo "OS is not fedora or debian. Please restart the ssh daemon."
fi

packagesNeeded='nmap wget nano'
if [ -x "$(command -v apk)" ];       then sudo apk add --no-cache $packagesNeeded
elif [ -x "$(command -v apt-get)" ]; then 
	sudo apt-get install -y $packagesNeeded
	sudo apt-get update -y
	sudo apt-get upgrade
elif [ -x "$(command -v dnf)" ];     then 
	sudo dnf -y install $packagesNeeded dnf-automatic
	sudo systemctl start --now dnf-automatic-install.timer
	sudo systemctl enable --now dnf-automatic-install.timer
	sudo dnf update -y
	sudo dnf upgrade -y
elif [ -x "$(command -v zypper)" ];  then sudo zypper install $packagesNeeded
else echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $packagesNeeded">&2; fi

