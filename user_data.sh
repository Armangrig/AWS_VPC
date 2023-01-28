#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.253/latest/meta-data/local-ipv4`
 
cat <<EOF > /var/www/html/index.html
<html>
<h2>Build by Power of Terraform <font color="red">/font></h2><br>
Owner Grigoryan
Hello from Arman
</html>
EOF

sudo service httpd start
chkconfig httpd on
