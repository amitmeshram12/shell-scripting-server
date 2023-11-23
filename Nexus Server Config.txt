 ===Nexus Configrution Server Ubuntu 18===

Let us see how to configure Nexus 3 on Ubuntu 18.0.4.

How to setup SonaType Nexus3 on Ubuntu:

Java 8 installation
# sudo apt update && sudo apt install openjdk-8-jre-headless -y

Note: Nexus is not compatible with Java 11 in Ubuntu 18.0.4. So we need to install Java 8.
# java -version

Execute the below commands -  navigate to /opt directory by changing directory:
# cd /opt

Download Nexus
# sudo wget https://download.sonatype.com/nexus/3/nexus-3.22.0-02-unix.tar.gz

Extract Nexus files

# sudo tar -xvf nexus-3.22.0-02-unix.tar.gz
# sudo mv nexus-3.22.0-02 nexus

Create a user called Nexus
# sudo adduser nexus

==give some password may be as admin, but do remember.
Keep entering enter for all other values and press y to confirm the entries.==

===Give permission to Nexus user===

# sudo chown -R nexus:nexus /opt/nexus
# sudo chown -R nexus:nexus /opt/sonatype-work

# sudo vi /opt/nexus/bin/nexus.rc
  - change run_as_user="nexus" -

==Modify memory settings==
# sudo vi /opt/nexus/bin/nexus.vmoptions

==Add all the below changes the file with below yellow highlighted entry:==
-Xms512M
-Xmx512M
-XX:MaxDirectMemorySize=512m

==Configure Nexus to run as a service==
# sudo vi /etc/systemd/system/nexus.service

==Copy the below content highlighted in green color.==

[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort 
[Install]
WantedBy=multi-user.target

===Now Start Nexus===
# sudo systemctl enable nexus
# sudo systemctl start nexus 
# sudo systemctl status nexus

==if it says stopped, review the steps above and you can troubleshoot by looking into Nexus logs by executing below command:==
# tail -f /opt/sonatype-work/nexus3/log/nexus.log

Press control C to come out of the above window.
It should say Started Sonatype Nexus OSS 3.22.0-02.  If you Nexus stopped, review the steps above.

Once Nexus is successfully installed, you can access it in the browser by 
URL - http://public_dns_name:8081


# cat /opt/sonatype-work/nexus3/admin.password
Now change admin password as == admin123

enable anonymous access

Click Finish.
Sign in with user name/password is admin/admin123
you should see the home page of Nexus.


===Nexus Server Install Redhat====
Here are the steps for installing Sonatype Nexus 3 in RHEL in EC2 on AWS. 
Please create a new Redhat EC2 instance with small type. Choose Redhat Enterprise 8.

==Pre-requisites:==
Make sure you open port 8081 in AWS security group

====Installation Steps:====

# sudo yum install wget -y

===Download Java 8===
# sudo yum install java-1.8.0-openjdk.x86_64 -y

==you can confirm java is installed by typing the below command:==
# java -version

===Execute the below command to navigate to /opt directory by changing directory:===

# cd /opt

===Download Nexus Latest version===

# sudo wget -O nexus3.tar.gz https://download.sonatype.com/nexus/3/latest-unix.tar.gz

===Extract Nexus===
# sudo tar -xvf nexus3.tar.gz
# sudo mv nexus-3* nexus

==Create a user called Nexus==
# sudo adduser nexus

===Change the ownership of nexus files and nexus data directory to nexus user.===
# sudo chown -R nexus:nexus /opt/nexus
# sudo chown -R nexus:nexus /opt/sonatype-work

===Add Nexus as a user===
# sudo vi /opt/nexus/bin/nexus.rc

==change as per above screenshot by removing # and adding nexus=== 
-----run_as_user="nexus"-----

===Modify memory settings in Nexus configuration file===
# sudo vi /opt/nexus/bin/nexus.vmoptions

-Xms512m
-Xmx512m
-XX:MaxDirectMemorySize=512m
after making changes, press  wq!  to come out of the file.

=====Configure Nexus to run as a service=====

# sudo vi /etc/systemd/system/nexus.service

++Copy the below content highlighted in green color.++

[Unit]
Description=nexus service
After=network.target
[Service]
Type=forking
LimitNOFILE=65536
User=nexus
Group=nexus
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort
[Install]
WantedBy=multi-user.target

====Create a link to Nexus====
# sudo ln -s /opt/nexus/bin/nexus /etc/init.d/nexus

====Execute the following command to add nexus service to boot.====

# sudo chkconfig --add nexus
# sudo chkconfig --levels 345 nexus on

===Start Nexus===
# sudo service nexus start

====Check whether Nexus service is running====
# sudo service nexus status

===Check the logs to see if Nexus is running===
# tail -f /opt/sonatype-work/nexus3/log/nexus.log

===>You will see Nexus started..If you Nexus stopped, review the steps above. 
Now press Ctrl C to come out of this windows.===

==>Once Nexus is successfully installed, you can access it in the browser by 
==>URL - http://public_dns_name:8081

===Click on Sign in link===
user name is admin and password can be found by executing below command:

# sudo cat /opt/sonatype-work/nexus3/admin.password

+++ Copy the password and click sign in.+++
Now setup admin password as ==> admin123





























 

































