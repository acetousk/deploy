#!/bin/bash

if [[ -v $1 ]] ; then
	echo "ssh identifier not specified. Try to add 'foo@bar'"
	exit 1
fi


# Copy over ssh key
ssh-copy-id $1

FILE_NAME=/home/user/remote_setup.sh

# Remove script
ssh $1 'rm -v /home/user/remote_setup.sh'

# Copy over script
scp ~/homelab/remote_setup.sh $1:/home/user/
ssh $1 'ls -la'

# Run script with root
ssh -t $1 './remote_setup.sh'

# Remove script
ssh $1 'rm -v /home/user/remote_setup.sh'

# Exit Successfully
exit 0

