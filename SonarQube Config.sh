====SonarQube Server Configuration Ubuntu 18====

==Install Sonarqube on Ubuntu - How to install SonarQube on Ubuntu 18.0.4==
SonarQube is one of the popular static code analysis tools. SonarQube is open-source, Java based tool It also needs database as well - 
Database can be MS SQL, Oracle or PostgreSQL.  We will use PostgreSQL as it is open source as well.
 
==> Make sure port 9000 is opened in Firewall rules.

==Pre-requistes:==
Instance should have at least 2 GB RAM. For AWS, instance should new and type should be t2.small. For Azure it should be standard B1ms which is 2 GB RAM.


==Java 11 installation steps==
# sudo apt-get update && sudo apt-get install default-jdk -y

===Postgres Installation===
# sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
# sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
# sudo apt-get -y install postgresql postgresql-contrib

=>Ignore the message in red color below:<==
# sudo systemctl start postgresql
# sudo systemctl enable postgresql

==Login as postgres user==
# sudo su - postgres

===Now create a user below by executing below command===
# createuser sonar

== Switch to sql shell by entering=
$ psql

==Execute the below three lines (one by one)==

# ALTER USER sonar WITH ENCRYPTED password 'password';

# CREATE DATABASE sonarqube OWNER sonar;

# GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;

# \q
--type exit to come out of postgres user--

== Now install SonarQube Web App==
# sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip

# sudo apt-get -y install unzip
# sudo unzip sonarqube-8.9.10.61524.zip -d /opt
# sudo mv /opt/sonarqube-8.9.10.61524 /opt/sonarqube -v

==Create Group and User:==
# sudo groupadd sonarGroup

==Now add the user with directory access==
# sudo useradd -c "user to run SonarQube" -d /opt/sonarqube -g sonarGroup sonar  
# sudo chown sonar:sonarGroup /opt/sonarqube -R

==Modify sonar.properties file==
# sudo vi /opt/sonarqube/conf/sonar.properties

==> uncomment the below lines by removing # and add values highlighted yellow
sonar.jdbc.username=sonar
sonar.jdbc.password=password

==> Next, uncomment the below line, removing #
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
==>Press escape, and enter :wq! to come out of the above screen.

==Edit the sonar script file and set RUN_AS_USER==
# sudo vi /opt/sonarqube/bin/linux-x86-64/sonar.sh
Add enable the below line 
RUN_AS_USER=sonar

==>Create Sonar as a service(this will enable to start automatically when you restart the server)
Execute the below command:
# sudo vi /etc/systemd/system/sonar.service

==>add the below code in green color:
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop
LimitNOFILE=131072
LimitNPROC=8192
User=sonar
Group=sonarGroup
Restart=always

[Install]
WantedBy=multi-user.target

==>Save the file by entering :wq!<===
 
>>>Kernel System changes
we must make a few modifications to a couple of kernel system limits files for sonarqube to work.

 # sudo vi /etc/sysctl.conf

Add the following lines to the bottom of that file:

vm.max_map_count=262144
fs.file-max=65536

>>>Next, we're going to edit limits.conf. Open that file with the command:<<<

# sudo vi /etc/security/limits.conf

>>>At the end of this file, add the following:<<< 

sonar   -   nofile   65536
sonar   -   nproc    4096

>>Reload system level changes without server boot<<
# sudo sysctl -p

# sudo systemctl start sonar
# sudo systemctl enable sonar
# sudo systemctl status sonar

type q now to come out of this mode.
==> Now execute the below command to see if Sonarqube is up and running. This may take a few minutes.

(Now Restart EC2 instance by going to AWS console and stop/start the EC2 instance)
Once restarted EC2 instance, login again and check the Sonar logs:

# tail -f /opt/sonarqube/logs/sonar.log

Make sure you get the below message that says sonarqube is up.

==>Now access sonarQube UI by going to browser and enter public dns name with port 9000
Now to go to browser  --> http://your_SonarQube_publicdns_name:9000/


























