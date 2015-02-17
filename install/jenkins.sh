#!/bin/bash -eux

wget -q http://pkg.jenkins-ci.org/debian-stable/jenkins-ci.org.key -O - | apt-key add -
cat > /etc/apt/sources.list.d/jenkins.list << MUFASA
deb http://pkg.jenkins-ci.org/debian-stable binary/ 
MUFASA

apt-get update
apt-get install -qq jenkins git

service jenkins start

curl -sSOL https://updates.jenkins-ci.org/latest/jquery.hpi
curl -sSOL https://updates.jenkins-ci.org/latest/simple-theme-plugin.hpi
curl -sSOL https://updates.jenkins-ci.org/latest/scm-api.hpi
curl -sSOL https://updates.jenkins-ci.org/latest/credentials.hpi
curl -sSOL https://updates.jenkins-ci.org/latest/p4.hpi
curl -sSOL https://updates.jenkins-ci.org/latest/git-client.hpi
curl -sSOL https://updates.jenkins-ci.org/latest/git.hpi
curl -sSOL https://updates.jenkins-ci.org/latest/scp.hpi
chown jenkins:jenkins *.hpi
mv *.hpi /var/lib/jenkins/plugins

ssh-keyscan -H github.com > /root/.ssh/known_hosts

(cd /var/lib/jenkins/userContent && \
git clone https://github.com/kevinburke/doony.git && \
chown jenkins:jenkins -R doony)
cat > /var/lib/jenkins/org.codefirst.SimpleThemeDecorator.xml << SIMBA
<org.codefirst.SimpleThemeDecorator plugin="simple-theme-plugin@0.3">
  <cssUrl>http://jenkins.test:8081/userContent/doony/doony.css</cssUrl>
  <jsUrl>http://jenkins.test:8081/userContent/doony/doony.js</jsUrl>
</org.codefirst.SimpleThemeDecorator>
SIMBA
chown jenkins:jenkins /var/lib/jenkins/org.codefirst.SimpleThemeDecorator.xml 

service jenkins restart
