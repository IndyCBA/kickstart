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
cat << EOFKEY > /ansible/.ssh/authorized_keys
# poner las keys que correspondan
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCmmt+Tai658C2CMyRcMDJykiUBmxnyNYvkKAGaW+VmPw9STIW0q7yJeK5NaeHMhCWuUS9NrLzE9DpUhIMSSK5xf3SjUNVcCzVS0cP1bPXl9dEvR29Igfyj2K9tpsEx/R3GSfmYS+vKWE8qLvjKWzcPo9n8NNfc9CEnxJv1dCpiHz52dNllFYyp58DRz+JM7Wf0SL0jFmH55WC7BhTlRrulEQYj0b5m1OJSlQyywk3UMmKe5jagutCy5Kxix/XGJOGmuTeuPku2ZOI5+JxjKpx+m7UE/IAKZF6ovqVvc++XwsEvCCD+2pPDYeRgycg/MUaKpIH7+u/wP5QOmQNiz/bq5UkH1uMTXreFZx+ZpEu9HynruQE9QEFTTlP93nlPPkmxNcFFh2HMEL85VuL9QTGTBNpMBHSfsXyCvJZDCC/yp0MoLxKMRzGsUS2Bt3mcyNsZdtqZ2JxXUzG6YUySMoEfTJ9xJhIpcyTtiDgboz8gmvaxTIyQnQNrwyahR1FKnUEg6RB0UuMfJOEDQa0sec4Sh9LXZYFM325rwNQXb9KaARt6dQ+kd77cVT2hfhY+bRq4BnpRt1UDUILw/QMSRHJLf8xJ7vEFzaNqqKku26VQX8SUeYT8n0+kh/k5/N45tSjzkH+2V2Y+L9aJgz7RIhrLlgLMwgwKhKPPUHg+vAriBw== lara@polko
EOFKEY
chown -R ansible:ansible /ansible/.ssh
chmod -R go-rwx /ansible/.ssh
%end
