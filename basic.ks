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
# ignoredisk --only-use=nvme0n1,nvme1n1
# clearpart --drives=nvme0n1,nvme1n1 --all
# zerombr

# Disk partitioning
# part /boot --fstype="ext4" --ondisk=nvme0n1 --size=2048
# part pv.01 --fstype="lvmpv" --ondisk=nvme0n1 --size=1 --grow
# volgroup vg_server --pesize=4096 pv.01
# logvol /  --fstype="xfs" --size=80000 --name=lv_root --vgname=vg_server

# Recommended swap size = (0.5 * RAM) + (overcommit ratio * RAM)
# 0.5 * 256 + 1 * 256 = 384
# parametrizar esto en lo posible
# logvol swap --fstype="swap" --size=393216 --name=lv_swap --vgname=vg_server
# part /home --fstype="xfs" --ondisk=nvme1n1 --size=1 --grow

# System services
services --enabled=NetworkManager,sshd

%packages
@base
@core
%end

%post
/usr/sbin/useradd -m -u 1000 -G wheel -d /ansible ansible
echo "ansible	ALL=(ALL)	NOPASSWD:ALL" >> /etc/sudoers
%end

# crea un usuario con acceso root para correr ansible
%post
mkdir -p /ansible/.ssh

# poner las keys que correspondan
cat << EOFKEY > /ansible/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDKAwHDSJwv/uzyVCZrcl53mErLj5HiXPPeC48jKr1DqFmi6s4LEubfu1UHjGiu/fxC5crthNEMBq8PoIL3KMthFZcwV1PWJjPzBGOfWNFkmLukKGJQytisunJ9QFMp6qHme+sbAKZaC99RedgHQF0fF6zFdJUhm+sYoHU+jF8VUtmsruo32ep6RKDKh7EjIrfWsXmrd9klCcAY9qscECuQiHFUUXHO+0n/LcaKEo/wly6otgqHvGshUmfgVpBucZ+/pWyLFyqC/BgT3SiKdS4k9oe1aTPOrgEMmRCf2eb7giQHXiCiqeLbiYdClUaGQwrfg9VSbNkuLsFzw3tfS7C7 Generated-by-Nova
EOFKEY

chown -R ansible:ansible /ansible/.ssh
chmod -R go-rwx /ansible/.ssh
%end
