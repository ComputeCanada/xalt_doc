# Installation

## Preparation

If it's not already done, clone the repo :
<!--- Replace by CC repo url and name-->
```
git clone <repo_url> && cd <repo_name>
```

## Default config

The EasyBuild recipe and the config file used to build the `xalt/.2.10.15` module can be found [here](https://github.com/ComputeCanada/easybuild-easyconfigs/tree/computecanada-main/easybuild/easyconfigs/x/XALT). For more information on what the different options do, see the [XALT documentation](https://xalt.readthedocs.io/en/latest/).


## Activate XALT tracking

There are several ways XALT can be activated. The simplest one is by using a module that sets the necessary environment variables when loaded. The bare minimum necessary for XALT to function are `XALT_EXECUTABLE_TRACKING` set to `yes` and the path `<XALT_DIR>/lib64/libxalt_init.so` in the `LD_PRELOAD` variable.

### Opt-in

- Explicitly load the XALT module in job scripts.
- 

### Opt-out

## Cluster-specific installation

XALT provides many options that can be modified to fit your needs. Some, like which executables are tracked by XALT, can only be specified at build time, while others, like the location where record files are saved, can be changed with environment variables (`XALT_FILE_PREFIX` in this case).
To modify the configuration, you will need to rebuild XALT with your new config file. To do this, simply modify the CC_config.py file or the EasyBuild recipe and rebuild with

```
eb XALT-*.eb --inject-checksums --force
eb XALT-*.eb --installpath=<install_location>
```

## libuuid-devel

The libuuid-devel package is already installed in `StdEnv/2020`, but it may not be installed on the base system. If it is not present, programs from the base system that are tracked by XALT (e.g. `/bin/{tar,gzip,bzip2}`, see the [config](https://github.com/ComputeCanada/easybuild-easyconfigs/blob/computecanada-main/easybuild/easyconfigs/x/XALT/CC_config.py)) will not have a valid UUID. Since the record files produced by XALT are split over many directories based on UUID, every record with an invalid UUID will end up in the same directory.

## Filebeat

The role of Filebeat is to send the JSON records to the ELK cluster. The provided configuration file reads the JSON records from the directories located in `/var/log/xalt/` and sends them to a Logstash instance on an ELK cluster.

Note: The config file was written for Filebeat `5.6.16`. Newer versions of Filebeat may have a different structure and some options may have different names in newer versions of Filebeat. For example, `filebeat.prospectors` and `input_type` have been renamed to `filebeat.inputs` and `type` respectively.

## Logstash
The role of Logstash is to remove unnecessary values and parse. The IP addresses and ports of the ElasticSearch instances need to be modified in the `output` part of the configuration file.
