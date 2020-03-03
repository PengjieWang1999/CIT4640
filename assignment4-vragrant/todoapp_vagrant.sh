#!/bin/bash -x



echo "Creating todoapp..."
sudo useradd -p $(openssl passwd -1 P@ssw0rd) todoapp
echo "Complete"


    # Install package

echo "Installing packages..."
sudo yum -y update
sudo yum -y install git nodejs npm mongodb-server nginx mongodb
sudo systemctl enable mongod
sudo systemctl start mongod
echo "Complete"


    # config firewall

echo "Configuring firewall..."
sudo firewall-cmd --zone=public --add-service=http
sudo firewall-cmd --zone=public --add-port=8080/tcp
sudo firewall-cmd --runtime-to-permanent
echo "Complete"

    # Setup Todo App

echo "Set up todoapp"
sudo chmod 755 /home/todoapp
sudo rm -rf /home/todoapp/app
git clone https://github.com/timoguic/ACIT4640-todo-app.git /home/todoapp/app
cd /home/todoapp/app
sudo npm install
sudo chown todoapp /home/todoapp/app
sudo cp -f /home/admin/database.js /home/todoapp/app/config
sudo cp -f /home/admin/nginx.conf /etc/nginx
sudo cp -f /home/admin/todoapp.service /etc/systemd/system

export LANG=C
mongorestore -d acit4640 /home/admin/ACIT4640
        
sudo systemctl enable nginx
sudo systemctl restart nginx
sudo systemctl daemon-reload
sudo systemctl enable todoapp
sudo systemctl restart todoapp
echo "Complete"


