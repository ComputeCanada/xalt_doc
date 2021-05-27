#!/bin/sh

PREFIX=$HOME
XALT=$PWD/xalt

cd $XALT

./configure --prefix=$PREFIX 		\
--with-syshostConfig=env_var:CC_CLUSTER \
--with-transmission=file 		\
--with-xaltFilePrefix=/var/log/xalt	\
--with-functionTracking=no		\
--with-MySQL=no 			\
--with-config=../CC_config.py && make install

#--with-etcDir=/home/billy/Documents/cq/xalt/reverseMapD	\
