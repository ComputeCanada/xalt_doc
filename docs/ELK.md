# ELK Stack

## Structure

`JSON` &rarr; `Filebeat` &rarr; `Logstash` &rarr; `ES` &larr; `Grafana`

## JSON

* Enregistrés dans des dossiers sous `/var/log/xalt/`
* Les anciens fichiers JSON sont effacés avec logrotate ([config](../elk/logrotate.d/xalt))

## Filebeat

[Fichier de configuration pour Filebeat](../elk/filebeat.yml)

## Logstash

### Liste des champs qui sont conservés
* libA (aplati)

[Fichier de configuration pour Logstash](../elk/logstash/xalt.conf) \
[Filtre Ruby pour Logstash](../elk/logstash/xalt_filter.rb)

## Elasticsearch


## Grafana

![Exemple de tableau de bord sur Grafana](../examples/grafana_es.png)
