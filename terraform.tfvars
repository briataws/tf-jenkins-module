vpc_name             = "mgmt"
region               = "us-west-2"
environment          = "mgmt"
image_url            = "jenkins/jenkins:lts-jdk11"
instance_network_tag = "Private"
alb_network_tag      = "Public"
alb_internal         = false
app_name             = "Jenkins"
min                  = "1"
max                  = "1"
app_port             = "8080"
container_path       = "/var/jenkins_home"
cpu                  = "2048"
memory               = "4096"


route53_zone_name = "sandbox-testing-private.com"

route53_private_zone = true

env_vars = [{
  "name"  = "JAVA_OPTS"
  "value" = "-Dhudson.footerURL=http://jenkins.sandbox-testing-private.com -Dhudson.DNSMultiCast.disabled=true -Dhudson.udp=-1 -Djava.awt.headless=true -Djenkins.install.runSetupWizard=false"
  },
  {
    "name"  = "JENKINS_OPTS"
    "value" = "--argumentsRealm.passwd.admin=passw0rd --argumentsRealm.roles.user=admin --argumentsRealm.roles.admin=admin"
}]
