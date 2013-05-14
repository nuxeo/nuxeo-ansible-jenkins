# Ansible playbook for Jenkins slave image generation

Generate an Ubuntu image for use by Jenkins as a slave.

Technical details:

 - based on ami-ce7b6fba (from http://alestic.com/).
 - m1.large

## Generate/update image

ansible-playbook -i production slave.yml [-v]

## Testing

ansible-playbook -i stage slave.yml -v -c local [--ask-sudo-pass]

ansible-playbook -i stage slave.yml [-K]

ansible-playbook playbook.yml --list-hosts

## Complete procedure with Jenkins

Log on https://console.aws.amazon.com/ec2/home?region=eu-west-1#s=Instances

### Jenkins slave template generation

Generate an instance from ami-ce7b6fba with m1.large type.  
Set "Jenkins slave template" as label.  
Copy its public hostname into `nuxeo-tools-cloud/ansible/jenkins/production`.  
Issue from `nuxeo-tools-cloud/ansible/jenkins/`:

     ansible-playbook -i production slave.yml -v
     
### Jenkins slave AMI generation

Select the instance on AWS interface and click "Action / Create Image (EBS AMI)".  
Set "Jenkins slave image" as label.  
Browse https://console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Images:  
Copy the AMI ID (for instance ami-a3b1a7d7).

### Jenkins configuration

Browse https://qa.nuxeo.org/jenkins/configure#section147  
In the "Cloud / Amazon EC2 / AMIs" section, set the AMI ID, check its availability ("Check AMI" button) and save. 


Jobs must set "ondemand" as slave restriction to use that EC2 image.


You can ask for an image from https://qa.nuxeo.org/jenkins/computer/ with "Provision via EC2" button.

