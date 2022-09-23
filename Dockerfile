FROM jupyter/minimal-notebook

LABEL maintainer="Jeffrey Bindinga <jeffrey.bindinga@gmail.com>"

USER root

# Install dependencies
RUN apt-get update && apt-get install -y \
  software-properties-common \
  curl

# Install Zulu OpenJdk 17 (LTS)
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9
# download and install the package that adds 
# the Azul APT repository to the list of sources 
RUN curl -O https://cdn.azul.com/zulu/bin/zulu-repo_1.0.0-3_all.deb
# install the package
RUN apt install ./zulu-repo_1.0.0-3_all.deb
# update the package sources
RUN apt update
RUN apt install -y zulu17-jdk

# Unpack and install the kernel
RUN curl -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip > ijava-kernel.zip
RUN unzip ijava-kernel.zip -d ijava-kernel \
  && cd ijava-kernel \
  && python3 install.py --sys-prefix

# Install jupyter RISE extension.
RUN pip install jupyter_contrib-nbextensions RISE \
  && jupyter-nbextension install rise --py --system \
  && jupyter-nbextension enable rise --py --system \
  && jupyter contrib nbextension install --system \
  && jupyter nbextension enable hide_input/main

# Cleanup
RUN rm ijava-kernel.zip

# Add README.md
ADD "README.md" $HOME

# Set user back to priviledged user.
USER $NB_USER
