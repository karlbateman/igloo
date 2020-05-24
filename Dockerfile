FROM ubuntu
LABEL author 'Karl Bateman'
WORKDIR /usr/src/app

# environment setup
ENV DEBIAN_FRONTEND noninteractive
ENV JAVAHOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PYTHONUNBUFFERED 1

# install container dependencies
RUN apt-get update \
    && apt-get install -y software-properties-common -y \
        && add-apt-repository ppa:deadsnakes/ppa \
            && apt-get install -y \
                build-essential \
                curl \
                openjdk-8-jdk \
                pandoc \
                python3-pip \
                python3.7 \
                texlive-xetex \
        && rm -rf /var/lib/apt/lists/* \
    ;

# download additional Python packages
RUN python3.7 -m pip install --no-cache-dir \
    beautifulsoup4 \
    deepdiff \
    langdetect \
    matplotlib \
    numpy \
    pandas \
    protorpc \
    pyspark \
    requests \
    scikit-learn \
    scipy \
    spacy \
    sqlalchemy \
    ;

# download Polynote
RUN curl -L https://github.com/polynote/polynote/releases/download/0.2.8/polynote-dist.tar.gz | tar -xzvpf -

# install the configuration
COPY config.yaml polynote/config.yml

EXPOSE 8192
ENTRYPOINT [ "bash" ]
CMD ["polynote/polynote"]
