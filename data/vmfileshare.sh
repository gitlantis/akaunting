sudo mkdir /mnt/vmfileshare
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/akauntstorage.cred" ]; then
    sudo bash -c 'echo "username=akauntstorage" >> /etc/smbcredentials/akauntstorage.cred'
    sudo bash -c 'echo "password=yor script_has_own_pass" >> /etc/smbcredentials/akauntstorage.cred'
fi
sudo chmod 600 /etc/smbcredentials/akauntstorage.cred

sudo bash -c 'echo "//akauntstorage.file.core.windows.net/vmfileshare /mnt/vmfileshare cifs nofail,vers=3.0,credentials=/etc/smbcredentials/akauntstorage.cred,dir_mode=0777,file_mode=0777,serverino" >> /etc/fstab'
sudo mount -t cifs //akauntstorage.file.core.windows.net/virtualfileshare /mnt/vmfileshare -o vers=3.0,credentials=/etc/smbcredentials/akauntstorage.cred,dir_mode=0777,file_mode=0777,serverino
