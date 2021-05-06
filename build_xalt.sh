#!/bin/sh

PREFIX=$HOME
XALT=$PWD/xalt

cd $XALT

./configure --prefix=$PREFIX 		\
--with-syshostConfig=env_var:CC_CLUSTER \
--with-transmission=file 		\
--with-functionTracking=yes		\
--with-MySQL=no 			\
--with-etcDir=$PREFIX/xalt/xalt/etc	\
--with-config=Config/test_config.py && make install
