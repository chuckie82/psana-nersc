#
# Dockerfile
#
# Latest version of centos
# Test 01: Test script original owned by Chuck Yoon
#
FROM centos:centos7
MAINTAINER Monarin Uervirojnangkoorn <monarin@stanford.edu>

RUN yum clean all && \
    yum -y install bzip2.x86_64 libgomp.x86_64 telnet.x86_64 gcc-c++

# https://repo.continuum.io/miniconda/
ADD Miniconda2-latest-Linux-x86_64.sh miniconda.sh
RUN chmod +x miniconda.sh
RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh
RUN /bin/bash miniconda.sh -b -p /opt/conda
RUN rm miniconda.sh
ENV PATH /opt/conda/bin:$PATH

# psana-conda
RUN conda update -y conda
RUN conda install -y -c conda-forge mpich
RUN conda install -y -c anaconda mpi4py hdf5 h5py pytables libtiff 
RUN rm -rf /opt/conda/lib/python2.7/site-packages/numexpr-2.6.2-py2.7.egg-info
RUN conda install -y --channel lcls-rhel7 psana-conda
RUN conda uninstall --force mpich

# cctbx
RUN conda install scons
ADD bootstrap.py bootstrap.py
ADD modules modules
RUN python bootstrap.py build --builder=xfel --with-python=/opt/conda/bin/python --nproc=1

# recreate /reg/d directories for data
RUN mkdir -p /reg/g &&\
    mkdir -p /reg/d/psdm/CXI &&\
    mkdir -p /reg/d/psdm/cxi

# for profiling
RUN yum -y install strace
