#!/bin/sh
echo "AuthorizedPrincipalsFile %h/.ssh/authorized_principals" >> /etc/ssh/sshd_config.d/ca.conf
echo "TrustedUserCAKeys /etc/ssh/ca.pub" >> /etc/ssh/sshd_config.d/ca.conf
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILMZvLjg6hCNbMgxmhxlsssBxne+ljsv4T+Gdg0wLR4U" > /etc/ssh/ca.pub
echo "admin" >> /home/ec2-user/.ssh/authorized_principals

systemctl restart sshd