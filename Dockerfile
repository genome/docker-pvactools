#License Agreements
#pVACtools is licensed under [NPOSL-3.0](http://opensource.org/licenses/NPOSL-3.0).

#By using the IEDB software, you are consenting to be bound by and become a "Licensee" for the use of IEDB tools and are consenting to the terms and conditions of the Non-Profit Open Software License ("Non-Profit OSL") version 3.0

#Please read these two license agreements [here](http://tools.iedb.org/mhci/download/) before proceeding. If you do not agree to all of the terms of these two agreements, you must not install or use the product. Companies (for-profit entities) interested in downloading the command-line versions of the IEDB tools or running the entire analysis resource locally, should contact us (license@iedb.org) for details on licensing options.

#Citing the IEDB
#All publications or presentations of data generated by use of the IEDB Resource Analysis tools should include citations to the relevant reference(s), found [here](http://tools.iedb.org/mhci/reference/).


FROM continuumio/miniconda3
MAINTAINER Susanna Kiwala <ssiebert@wustl.edu>

LABEL \
    description="Image for pVACtools" \
    version="1.1.0_mhci_2.19.1_mhcii_2.17.5"

RUN apt-get update && apt-get install -y \
    build-essential \
    tcsh \
    gawk

RUN conda create -n pvactools_py27 python=2.7 -y

RUN mkdir /opt/iedb
COPY LICENSE /opt/iedb/.

#IEDB MHC I 2.19.1
WORKDIR /opt/iedb
RUN wget https://downloads.iedb.org/tools/mhci/2.19.1/IEDB_MHC_I-2.19.1.tar.gz
RUN tar -xzvf IEDB_MHC_I-2.19.1.tar.gz
WORKDIR /opt/iedb/mhc_i
RUN bash -c "source activate pvactools_py27 && ./configure"
WORKDIR /opt/iedb
RUN rm IEDB_MHC_I-2.19.1.tar.gz

#IEDB MHC II 2.17.5
WORKDIR /opt/iedb
RUN wget https://downloads.iedb.org/tools/mhcii/2.17.5/IEDB_MHC_II-2.17.5.tar.gz
RUN tar -xzvf IEDB_MHC_II-2.17.5.tar.gz
WORKDIR /opt/iedb/mhc_ii
RUN bash -c "source activate pvactools_py27 && /opt/conda/envs/pvactools_py27/bin/python ./configure.py"
WORKDIR /opt/iedb
RUN rm IEDB_MHC_II-2.17.5.tar.gz

#pVACtools 1.1.0
ENV MHCFLURRY_DOWNLOADS_CURRENT_RELEASE=1.2.0
ENV MHCFLURRY_DATA_DIR=/tmp/
RUN pip install -e git+git://github.com/griffithlab/pVACtools@staging#egg=pvactools
RUN mhcflurry-downloads fetch
