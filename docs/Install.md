# Installation

## Préparation

Si ce n'est pas déjà fait, cloner le dépôt.

```
git clone https://github.com/JLague/xalt_doc.git && cd xalt_doc
```

## Installation de XALT

```
sudo yum install libuuid-devel
eb XALT-2.10.15.eb --try-amend=config_py=/abs/path/to/config.py \
    --try-amend=syshost=env_var:CC_CLUSTER \
    --try-amend=transmission=file \
    --try-amend=file_prefix=/var/log/xalt
patch /path/to/modulefile < $(git rev-parse --show-toplevel)/module_preload.patch
```

## Configuration de Filebeat

Copier le fichier

```
sudo cp $(git rev-parse --show-toplevel)/config/logrotate/xalt /etc/logrotate.d/
```

Ajouter le contenu de [filebeat.yml](../config/filebeat/filebeat.yml) à `/etc/filebeat/filebeat.yml`, puis redémarrer Filebeat.

```
systemctl restart filebeat
```

## Configuration de Logstash

1. Ajouter [xalt.conf](../config/logstash/xalt.conf) aux fichiers de configuration Logstash




