#!/bin/ksh

PW_VAGRANT="$(encrypt vagrant)"
VAGRANT_PUBKEY_URL=https://raw.githubusercontent.com/hashicorp/vagrant/master/keys/vagrant.pub

# Network
echo 'dhcp' > /etc/hostname.em0

# https://www.vagrantup.com/docs/boxes/base.html#root-password-quot-vagrant-quot-
usermod -p "${PW_VAGRANT}" root

# https://www.vagrantup.com/docs/boxes/base.html#quot-vagrant-quot-user
useradd -m -p "${PW_VAGRANT}" vagrant

# https://www.vagrantup.com/docs/boxes/base.html#password-less-sudo
echo 'permit nopass persist vagrant' >> /etc/doas.conf

# https://www.vagrantup.com/docs/boxes/base.html#ssh-tweaks
sed -i 's/^#?UseDNS[[:space:]].*/UseDNS no/' /etc/ssh/sshd_config

# Add default insecure public key
ftp -o /home/vagrant/.ssh/authorized_keys "${VAGRANT_PUBKEY_URL}"
chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
