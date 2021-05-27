#!/bin/sh

FILENAME="test"
EXTENSION="c"
LD="ld.gold"
COMPILER=gcc

$COMPILER -c $FILENAME.$EXTENSION -o tmp.o && /cvmfs/soft.computecanada.ca/gentoo/2020/usr/bin/$LD \
-plugin /cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/libexec/gcc/x86_64-pc-linux-gnu/9.3.0/liblto_plugin.so \
-plugin-opt=/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/libexec/gcc/x86_64-pc-linux-gnu/9.3.0/lto-wrapper \
-plugin-opt=-fresolution=/tmp/ccsEPOq7.res -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lgcc_eh -plugin-opt=-pass-through=-lc \
-m elf_x86_64 -static -o $FILENAME \
/cvmfs/soft.computecanada.ca/gentoo/2020/usr/lib/../lib64/crt1.o \
/cvmfs/soft.computecanada.ca/gentoo/2020/usr/lib/../lib64/crti.o \
/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/lib/gcc/x86_64-pc-linux-gnu/9.3.0/crtbeginT.o \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/libffi/3.3/lib64/../lib64 \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/libffi/3.3/lib/../lib64 \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Compiler/intel2020/openmpi/4.0.3/lib/../lib64 \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/lib/gcc/x86_64-pc-linux-gnu/9.3.0 \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/lib/gcc/x86_64-pc-linux-gnu/9.3.0/../../../../lib64 \
-L/cvmfs/soft.computecanada.ca/gentoo/2020/lib/../lib64 \
-L/cvmfs/soft.computecanada.ca/gentoo/2020/usr/lib/../lib64 \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Compiler/intel2020/boost/1.72.0/lib \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Core/python/3.8.2/lib \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/libffi/3.3/lib64 \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/libffi/3.3/lib \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Compiler/intel2020/openmpi/4.0.3/lib \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Core/libfabric/1.10.1/lib \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/avx2/Core/ucx/1.8.0/lib \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/imkl/2020.1.217/mkl/lib/intel64 \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/imkl/2020.1.217/lib/intel64 \
-L/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/lib/gcc/x86_64-pc-linux-gnu/9.3.0/../../.. \
-L/cvmfs/soft.computecanada.ca/gentoo/2020/lib \
-L/cvmfs/soft.computecanada.ca/gentoo/2020/usr/lib \
./tmp.o --start-group -lgcc_eh -lc -lgcc --end-group \
/cvmfs/soft.computecanada.ca/easybuild/software/2020/Core/gcccore/9.3.0/lib/gcc/x86_64-pc-linux-gnu/9.3.0/crtend.o \
/cvmfs/soft.computecanada.ca/gentoo/2020/usr/lib/../lib64/crtn.o \
./lib/xalt_initialize_regular.o \
./lib/librun_submission.a -ldl -lz -lm -lc -lgcc -t

rm ./tmp.o