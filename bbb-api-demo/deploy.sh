
sudo rm -rf /var/lib/tomcat7/webapps/tutortone*
sudo cp build/libs/tutortone.war /var/lib/tomcat7/webapps/
sudo service tomcat7 restart

