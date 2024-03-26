# Choosing mode (graphical|text|cmdline [--non-interactive])
# text
graphical

# Keyboard layouts
keyboard --vckeymap=latam --xlayouts='latam'

# System language
lang en_US.UTF-8
# System timezone
timezone Asia/Shanghai

# Network information
network --bootproto=dhcp --device=link --noipv6 --activate --onboot=yes
network  --hostname=nodocba.localhost

# Firewall configuration
# firewall --enabled --ssh

#Selinux
selinux --disabled

# Partition clearing
ignoredisk --only-use=nvme0n1,nvme1n1
clearpart --drives=nvme0n1,nvme1n1 --all
zerombr

# Disk partitioning (research)
part /boot --fstype="ext4" --ondisk=nvme0n1 --size=2048
part pv.01 --fstype="lvmpv" --ondisk=nvme0n1 --size=1 --grow
volgroup vg_server --pesize=4096 pv.01
logvol /  --fstype="xfs" --size=80000 --name=lv_root --vgname=vg_server

# Recommended swap size = (0.5 * RAM) + (overcommit ratio * RAM)
# 0.5 * 256 + 1 * 256 = 384
# parametrizar esto en lo posible
# logvol swap --fstype="swap" --size=393216 --name=lv_swap --vgname=vg_server
part /home --fstype="xfs" --ondisk=nvme1n1 --size=1 --grow

# System services
services --enabled=NetworkManager,sshd

%packages
@base
@core
%end

# %post
# /usr/sbin/useradd -m -u 1000 -G wheel -d /ansible ansible
# echo "ansible	ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers
# %end

# crea un usuario con acceso root para correr ansible
# %post
# mkdir -p /ansible/.ssh
# cat << EOFKEY > /ansible/.ssh/authorized_keys
# # poner las keys que correspondan
# ssh-rsa
# ssh-ed25519
# ssh-ed25519
# EOFKEY
# chown -R ansible:ansible /ansible/.ssh
# chmod -R go-rwx /ansible/.ssh
# %end


