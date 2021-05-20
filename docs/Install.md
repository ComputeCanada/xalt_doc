# Installation de XALT

## Préparation
```
git clone --recursive git@github.com:JLague/xalt_doc.git
cd xalt_doc
```

## Installation de XALT

```
eb XALT-2.10.10.eb
```

1. Modifier le prefix d'installation et le fichier de configuration dans le fichier [build_xalt.sh](../build_xalt.sh) et l'exécuter.

## Configuration de Filebeat

1. Copier le fichier de configuration de logrotate [xalt](../elk/logrotate.d/xalt) dans `/etc/logrotate.d`

```
cp elk/logrotate.d/xalt /etc/logrotate.d
```

2. Ajouter le contenu de [filebeat.yml](../elk/filebeat.yml) à `/etc/filebeat/filebeat.yml`
3. Redémarrer Filebeat

```
systemctl restart filebeat
```

## Configuration de Logstash

1. Ajouter [xalt.conf](../elk/logstash/xalt.conf) aux fichiers de configuration Logstash




