# XALT

## Questions/Réponses

**Comment identifier le nom du cluster?** :
* `--with-syshostConfig=env_var:CC_CLUSTER`

**Quel est le PATH qui devrait être utilisé par XALT?** :
* Vérifier quels sont les exécutables nécessaires pour XALT
* Vérifier où sont situés ces exécutables

**Est-ce qu'il y a plusieurs endroit contenant des fichiers de modules (ex: cvmfs + local)? Si oui, il faut plusieurs reverse maps.**
* ???

## Choix
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

## Cache de Lmod

Lmod supporte plusieurs types de "cache". La xalt_rmapT qui peut être générée par Lmod est utilisée par XALT pour déterminer quelles librairies devraient être monitorées ainsi que pour associer les noms de modules aux paths qu'ils fournissent. Lorsqu'on génère la xalt_rmapT, on traverse tous les fichiers de module présent dans les dossiers spécifiés dans `$MODULEPATH`. Chaque dossier ajouté à `$MODULEPATH` dans les fichiers de module sera aussi traversé ([source](https://lmod.readthedocs.io/en/latest/136_spider.html#the-spider-tool)).

### Structure générale de la xalt_rmapT
```
{
    "reverseMapT":
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

## Limitations venant du fait que les clusters ne sont pas modifiés
### Limitations dûes à l'utilisation principale du mode `LD_PRELOAD`
Le fait de seulement utiliser le mode `LD_PRELOAD` fait en sorte que seul les exécutables linkés dynamiquements peuvent être monitorés. Ainsi, si un module a été compilé de manière à ce que les exécutables soient statiques, il serait impossible de le monitorer sans le recompiler, soit pour que les exécutables soient dynamiques, soit en utilisant le wrapper de `ld` fourni par XALT pour injecter dans les exécutables le code permettant de monitorer. Il en est de même pour les exécutables créés par les usagers : s'ils sont dynamiques, on peut les monitorer automatiquement avec le mode `LD_PRELOAD`, sinon ils doivent être linkés avec le wrapper de `ld` fourni par XALT.

Les limitations pour le monitoring des exécutables du système de base sont minimes, parce que la grande majorité sont dynamiques. En effet, seulement `sln` et `ldconfig` sont statiques. Vérifié sur StdEnv/2020 (seuls modules loadés) avec
```
for path in ${PATH//:/ }; do
    find $path -exec file {} \; | grep -i static
done
```

Il y a 47 modules uniques sur 550 (total trouvé avec `module --show-hidden -t avail | grep "\/$" | wc -l`) qui fournissent des exécutables statiques (voir [unique_static_modules.json](static_modules/unique_static_modules.json)). Advenant la décision de modifier les clusters, seuls ces modules devront être recompilés avec le wrapper de `ld` fourni par XALT.

### Limitations venant du fait qu'on ne monitore pas les GPU
Les informations fournies par le monitoring des GPU peuvent être trouvé dans l'[exemple d'output](output/gpu.txt).

## Notes
* ~~On ne devrait probablement pas utiliser de reverse map, parce que le MODULEPATH peut être modifié et Lmod se fie au MODULEPATH pour créer la reverseMap~~ Les reverse maps de Lmod traversent tous les modulefiles et modifie le MODULEPATH. Pourrait aussi être utile pour Mii.
* 2 moyens d'utiliser les reverse maps &rarr; regénérer une xalt_rmapT.json à chaque fois qu'on veut updater ou utiliser `$LMOD_DIR/update_lmod_system_cache_files` ([lien](https://xalt.readthedocs.io/en/latest/040_reverse_map.html#function-tracking)) pour updater la map à la place de regénérer (il serait possible de faire une cronjob pour automatiser les deux). Le script donné par Lmod serait préférable.
* Certaines commandes sont exécutés à chaque fois qu'on exécute quelque chose (peut-être seulement local, devrait testé sur la build-node), donc on ne devrait probablement pas les monitorer (en ordre dans lesquelles elles se terminent): 
    1. `wc -l`
    2. `tail -n1`
    3. `/cvmfs/soft.computecanada.ca/gentoo/2020/usr/bin/python2.7 /cvmfs/soft.computecanada.ca/gentoo/2020/usr/lib/python-exec/python2.7/hg id`
* XALT est en mode PRELOAD_ONLY si la variable XALT_PRELOAD_ONLY n'a pas la valeur "yes"
* Le wrapper ld de XALT ne fonctionne pas localement sans faire de modification à la configuration courante (peut-être parce qu'on utilise deux wrappers pour `ld`?). Testé avec la commande `XALT_TRACING=link XALT_PRELOAD_ONLY=no gcc -static -o static_test test.c` ([message d'erreur](ld_error.txt))

## Options de build
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
## Liens utiles
* Repo Github de XALT
    * [Root du repo](https://github.com/xalt/xalt)
    * [Example de fichier de configuration](https://github.com/xalt/xalt/blob/2e393fba883cd6327d6361abda42b955c25bb840/Config/TACC_config.py)
    * [Manuel d'utilisation](https://github.com/xalt/xalt/blob/2e393fba883cd6327d6361abda42b955c25bb840/my_docs/XALTUsersManual-0.5.pdf)
* EasyBuild
    * [easyblock](https://github.com/easybuilders/easybuild-easyblocks/blob/develop/easybuild/easyblocks/x/xalt.py)
    * [easyconfig](https://github.com/easybuilders/easybuild-easyconfigs/blob/develop/easybuild/easyconfigs/x/XALT/XALT-2.8.4.eb)
    * [PR de l'easyconfig](https://github.com/easybuilders/easybuild-easyblocks/pull/1942)
* Documentation
    * [XALT](https://xalt.readthedocs.io/en/latest/index.html)
        * [config.py](https://xalt.readthedocs.io/en/latest/030_site_filtering.html)
        * [reverse map](https://xalt.readthedocs.io/en/latest/040_reverse_map.html)
    * [Lmod](https://lmod.readthedocs.io/en/latest/index.html)
        * [spider](https://lmod.readthedocs.io/en/latest/136_spider.html)
        * [spider cache](https://lmod.readthedocs.io/en/latest/130_spider_cache.html)



## TODO
- [ ] Utiliser syslog plutôt que des fichiers .json?
    - [X] Tester les fichiers JSON pour chaque utilisateur
    - [ ] Tester les fichiers JSON globaux
    - [ ] Tester syslog localement
- [X] Trouver comment créer la reverse map
    - [X] Comprendre comment la xalt_rmapT fonctionne
    - [X] Documenter le fonctionnement de la xalt_rmapT
    - [X] Tester le script d'update de cache de Lmod
- [X] Trouver les modules qui fournissent des exécutables statiques
    - [X] Faire une liste exhaustive des modules qui fournissent des exécutables statiques
    - [X] Faire une liste (sans répétitions) des modules qui fournissent des exécutables statiques
    - [X] Trouver le nombre réel de modules avec des exécutables statiques &rarr; 47 (voir [unique_static_modules.json](static_modules/unique_static_modules.json))
- [ ] Ajuster le fichier config.py selon les besoins
    - [ ] Ajouter `$USER`, `$HOSTNAME` et `$SLURM_JOB_ID` aux variables monitorées
    - [ ] Comprendre le fonctionnement du monitoring des packages
    - [ ] Comprendre le fonctionnement des paths à monitorer (`SKIP` et `KEEP`, ordre des fichiers binaires vs les dossiers)
- [ ] Faire fonctionner le wrapper de `ld`
