#!/bin/bash
yum -y update
yum -y install httpd
cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="grey">
<h2><font color="blue">Build by Terraform <font color="red"> Version-2
</font></h2><br><p>
<font color="green"> My Appache Server <br><br>
</body>
</html>
EOF
sudo service httpd start
chkconfig httpd on