yum install samba samba-client samba-common
mv /etc/samba/smb.conf /etc/samba/smb.conf.bak
echo "[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = arm
security = user
map to guest = bad user
dns proxy = no
#============================ Share Definitions ============================== 
[arm]
path = /home/deploy
valid users = deploy
read only = No
[homes]
    comment = Home Directories
    read only = No
    browseable = No
" > /etc/samba/smb.conf
systemctl enable smb.service
systemctl enable nmb.service
firewall-cmd --permanent --zone=public --add-service=samba
setsebool -P samba_enable_home_dirs on
chcon -t samba_share_t /home/deploy/
systemctl restart smb.service
systemctl restart nmb.service

