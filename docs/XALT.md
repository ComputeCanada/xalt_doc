# Choix
* Monitorer les noeuds de connexion et/ou les noeuds de calcul?
* Monitorer les programmes MPI et non-MPI
    * Les deux sont activés par défaut 
    * `--with-trackScalarPrgms=no` pour monitorer seulement les programmes non-scalaires
* Monitorer l'utilisation des GPU NVIDIA?
    * `--with-trackGPU=yes` pour monitorer l'utilisation des GPU
    * [Nécessite une configuration supplémentaire](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#track-gpu-usage)
* Monitorer des fonctions spécifiques
    * Nécessite une reverse map
    * Activé par défaut si un reverse map est trouvée (`--with-functionTracking=no` pour désactiver)
    * Plus lent (on doit linker 2 fois)
* [Transmission des données](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#xalt-data-transmission)
    * Fichier json &rarr; enregistré pour chaque utilisateur ou dans un endroit global, peut aussi séparer les types de résultats dans des dossiers différents. Scripts permettant de transférer les fichiers .json dans une db MySQL, ce qui permetterait d'utiliser plus facilement avec Grafana? ([lien](https://xalt.readthedocs.io/en/latest/110_db.html))
    * Syslog &rarr; pas beaucoup d'informations (`--with-transmission=syslog`)
* Quels sont les variables d'environnement qui devrait être monitorées?
    * Au moins `$USER`, `$HOSTNAME` et `$SLURM_JOB_ID`

# Options de build
| Option                                | Lien                                                                                                                                           | Description                                                                                                                                    |
|---------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|
| `--with-syshostConfig=`               | [Setting the Name of your Cluster](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#setting-the-name-of-your-cluster)         | Nom du cluster                                                                                                                                 |
| `--with-cmdlineRecord=yes\|no`        | [Turning off command line tracking](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#turning-off-command-line-tracking)       | Est-ce qu'on enregistre aussi les commandes entrées par les usagers?                                                                           |
| `--with-systemPath=`                  | [Defining $PATH used by XALT programs](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#defining-path-used-by-xalt-programs)  | PATH utilisé par XALT                                                                                                                          |
| `--with-transmission=`                | [XALT data transmission](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#xalt-data-transmission)                             | Type de transmission des données (ex: fichiers json, syslog)                                                                                   |
| `–with-xaltFilePrefix=`               | [XALT data transmission](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#xalt-data-transmission)                             | Permet d'enregistrer les fichiers .json dans un endroit global plutôt que pour chaque utilisateur                                              |
| `--with-trackScalarPrgms=yes\|no`     | [Track MPI and/or Non-MPI executables](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#track-mpi-and-or-non-mpi-executables) | Monitorer tous les programmes ou seulement les programmes MPI qui ont plus d'une tâche                                                         |
| `--with-trackGPU=yes\|no`             | [Track GPU usage](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#track-gpu-usage)                                           | Monitorer l'utilisation des GPU NVIDIA                                                                                                         |
| `--with-functionTracking=yes\|no`     | [Function Tracking](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#function-tracking)                                       | Monitorer les fonctions des librairies qui sont utilisées. Nécessite un reverse map                                                            |
| `--with-etcDir=`                      | [Function Tracking](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#function-tracking)                                       | Path du dossier contenant la reverse map                                                                                                       |
| `--with-siteControlledPrefix=yes\|no` | [Site controlled XALT location](https://xalt.readthedocs.io/en/latest/050_install_and_test.html#site-controlled-xalt-location)                 | Permet de spécifier le dossier exact dans le prefix où XALT devrait être installé, ce qui permet alors d'avoir plusieurs versions d'installées |

# Reverse map

Lmod supporte plusieurs types de "cache". La xalt_rmapT qui peut être générée par Lmod est utilisée par XALT pour déterminer quelles librairies devraient être monitorées ainsi que pour associer les noms de modules aux paths qu'ils fournissent. Lorsqu'on génère la xalt_rmapT, on traverse tous les fichiers de module présent dans les dossiers spécifiés dans `$MODULEPATH`. Chaque dossier ajouté à `$MODULEPATH` dans les fichiers de module sera aussi traversé ([source](https://lmod.readthedocs.io/en/latest/136_spider.html#the-spider-tool)).

## Structure générale de la xalt_rmapT
```
{
    "reverseMapT": {
        "/path/vers/le/module1": "nom_du_module1/version(environnement)",
        "/path/vers/le/module2": "nom_du_module2/version(environnement)",
        ...
    }
    "xlibmap": [
        "lib1.so",
        "lib2.so",
        ...
    ]
}
```
## Génération de la reverse map

La xalt_rmapT peut être générée avec 
```
$LMOD_DIR/spider -o xalt_rmapT $MODULEPATH > xalt_rmapT.json
```

| Option           | Description                                                                      |
|------------------|----------------------------------------------------------------------------------|
| `-o outputStyle` | Le format du fichier voulu (voir `$LMOD_DIR/spider --help` pour plus de détails) |

ou encore générée/updatée avec 
```
$LMOD_DIR/update_lmod_system_cache_files -d /path/de/la/cache -t /path/du/timestamp.txt -D -K $MODULEPATH
```

| Option              | Description                                                                  |
|---------------------|------------------------------------------------------------------------------|
| `-d <cacheDir>`     | location of Lmod cache directory (default: determine via `ml --config`)      |
| `-t <timestamp.txt>`| location of Lmod cache timestamp file (default: determine via `ml --config`) |
| `-D`                | enable debug printing                                                        |
| `-K`                | enable update xalt_rmapT cache file                                          |

À noter que cette deuxième solution génère et update aussi un fichier de cache pour Lmod nommé spiderT.lua, qui a une taille d'environ 7MB.