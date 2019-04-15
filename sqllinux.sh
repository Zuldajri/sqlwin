echo "SQL_PASSWORD=$SQL_PASSWORD"

fdisk -l /dev/sdc || break
        fdisk /dev/sdc << EOF
n
p
1


p
w
EOF
 

sudo mkfs -t ext4 /dev/sdc1

sudo mkdir /datadrive

sudo mount /dev/sdc1 /datadrive

UUID=$(sudo -i blkid | grep /dev/sdc1 | awk 'NR==1 {print $2}' | sed 's/"//g')

echo $UUID /datadrive              ext4    defaults,nofail 1 2  >> /etc/fstab

echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
source ~/.bashrc

sudo firewall-cmd --zone=public --add-port=1433/tcp --permanent
sudo firewall-cmd --reload

sudo systemctl stop mssql-server
sudo /opt/mssql/bin/mssql-conf set-sa-password << EOF
$SQL_PASSWORD
$SQL_PASSWORD
EOF
