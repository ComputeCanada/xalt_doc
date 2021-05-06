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
    * Fichier json &rarr; enregistré pour chaque utilisateur ou dans un endroit global, peut aussi séparer les types de résultats dans des dossiers différents
    * Syslog &rarr; pas beaucoup d'informations (`--with-transmission=syslog`)
* Quels sont les variables d'environnement qui devrait être monitorées?

## Notes
* ~~On ne devrait probablement pas utiliser de reverse map, parce que le MODULEPATH peut être modifié et Lmod se fie au MODULEPATH pour créer la reverseMap~~ Les reverse maps de Lmod traversent tous les modulefiles et modifie le MODULEPATH. Pourrait aussi être utile pour Mii.
* 2 moyens d'utiliser les reverse maps &rarr; regénérer une xalt_rmapT.json à chaque fois qu'on veut updater ou utiliser `$LMOD_DIR/update_lmod_system_cache_files` ([lien](https://xalt.readthedocs.io/en/latest/040_reverse_map.html#function-tracking)) pour updater la map à la place de regénérer (il serait possible de faire une cronjob pour automatiser les deux). Le script donné par Lmod serait préférable.

## Options de build
| Option                            | Lien                                                                                                                                           | Description                                                                             |
|-----------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| `--with-syshostConfig=`           | [Setting the Name of your Cluster](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#setting-the-name-of-your-cluster)         | Nom du cluster                                                                          |
| `--with-cmdlineRecord=yes\|no`    | [Turning off command line tracking](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#turning-off-command-line-tracking)       | Est-ce qu'on enregistre aussi les commandes entrées par les usagers?                                           |
| `--with-systemPath=`              | [Defining $PATH used by XALT programs](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#defining-path-used-by-xalt-programs)  | PATH utilisé par XALT                                                                   |
| `--with-transmission=`            | [XALT data transmission](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#xalt-data-transmission)                             | Type de transmission des données (ex: fichiers json, syslog)                            |
| `--with-trackScalarPrgms=yes\|no` | [Track MPI and/or Non-MPI executables](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#track-mpi-and-or-non-mpi-executables) | Monitorer tous les programmes ou seulement les programmes MPI qui ont plus d'une tâche  |
| `--with-trackGPU=yes\|no`         | [Track GPU usage](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#track-gpu-usage)                                           | Monitorer l'utilisation des GPU NVIDIA                                                  |
| `--with-functionTracking=yes\|no` | [Function Tracking](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#function-tracking)                                       | Monitorer les fonctions des librairies qui sont utilisées. Nécessite un reverse map     |
| `--with-etcDir=`                  | [Function Tracking](https://xalt.readthedocs.io/en/latest/020_site_configuration.html#function-tracking)                                       | Path du dossier contenant la reverse map                                                |

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
    * Tester syslog localement
- [ ] Trouver comment créer la reverse map

