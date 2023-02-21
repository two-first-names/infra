data "cloudinit_config" "vault" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = file("${path.module}/userdata/add-ssh-ca.sh")
  }
}

resource "aws_instance" "vault" {
  ami           = data.aws_ssm_parameter.ami.value
  instance_type = "t4g.micro"
  subnet_id     = aws_subnet.main.id

  vpc_security_group_ids = [aws_security_group.vault.id]

  associate_public_ip_address = true
  ipv6_address_count          = 1

  user_data = data.cloudinit_config.vault.rendered

  tags = {
    Name = "vault.engiqueer.net"
  }
}

resource "aws_security_group" "vault" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_route53_record" "vault_a" {
  zone_id = aws_route53_zone.engiqueer.zone_id
  name    = "vault"
  type    = "A"
  ttl     = 300
  records = [aws_instance.vault.public_ip]
}

resource "aws_route53_record" "vault_aaaa" {
  zone_id = aws_route53_zone.engiqueer.zone_id
  name    = "vault"
  type    = "AAAA"
  ttl     = 300
  records = aws_instance.vault.ipv6_addresses
}