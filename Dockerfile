FROM ubuntu:20.04
LABEL author 'Karl Bateman'
WORKDIR /usr/src/app

# environment setup
ENV DEBIAN_FRONTEND noninteractive
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
ENV PYTHONUNBUFFERED 1

# install container dependencies
RUN apt-get update \
    && apt-get install -y software-properties-common -y \
        && add-apt-repository ppa:deadsnakes/ppa \
            && apt-get install -y \
                build-essential \
                curl \
                openjdk-8-jdk \
                python3-pip \
                python3.7 \
                python3.7-dev \
        && rm -rf /var/lib/apt/lists/* \
    ;

# download Polynote and install it's dependencies
# see https://polynote.org/docs/01-installation.html
RUN curl -L https://github.com/polynote/polynote/releases/download/0.3.12/polynote-dist.tar.gz | tar -xzvpf - \
    && cd polynote \
    && pip3 install -r requirements.txt \
    && cd - \
    ;

# add the configuration
COPY config.yaml polynote/config.yml

# install additional Python packages
RUN python3.7 -m pip install --no-cache-dir \
    # HACK(karlbateman): required by Polynote
    jedi \
    jep \
    # typical datasci packages
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

EXPOSE 8192
ENTRYPOINT [ "python3.7" ]
CMD ["polynote/polynote.py"]
