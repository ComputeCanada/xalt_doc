terraform {
  required_version = ">= 0.14.2"
}

module "openstack" {
  source         = "git::https://github.com/ComputeCanada/magic_castle.git//openstack"
  config_git_url = "https://github.com/MagicCastle/elk-environment.git"
  config_version = "main"

  cluster_name = "testelk"
  domain       = "calculquebec.cloud"
  image        = "CentOS-7-x64-2020-11"

  instances = {
    puppet = { type = "p2-3gb", tags = ["puppet"] }
    master = { type = "p2-3gb", tags = ["master"], count = 1 }
    ingest = { type = "p8-12gb", tags = ["ingest", "public"], count = 1 }
    data   = { type = "p2-3gb", tags = ["data"], count = 1 }
  }

  volumes = {
    data = {
      data1 = { size = 50 }
    }
  }

  public_keys = [file("~/.ssh/id_rsa.pub")]

  # Magic Castle default firewall rules are too permissive
  # for this example. The following restricts it to SSH only.
  firewall_rules = [
    {"name"="SSH", "from_port"=22, "to_port"=22, "ip_protocol"="tcp", "cidr"="0.0.0.0/0"},
    {"name"="Kibana", "from_port"=5601, "to_port"=5601, "ip_protocol"="tcp", "cidr"="173.179.216.249/32"},
    {"name"="Logstash", "from_port"=5044, "to_port"=5044, "ip_protocol"="tcp", "cidr"="192.168.239.0/24"},
  ]
}

output "public_ip" {
  value = module.openstack.public_ip
}

output "sudoer" {
  value = module.openstack.accounts.sudoer
}
