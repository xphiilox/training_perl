FROM perl:5.42.2-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        ca-certificates \
        apache2 \
        curl \
        git \
        locales \
        make \
    && sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen \
    && locale-gen \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN cpanm --notest Perl::LanguageServer \
    && rm -rf /root/.cpanm

COPY docker/apache-training-perl.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod cgid

WORKDIR /workspace

CMD ["sh", "-lc", "rm -f /var/run/apache2/apache2.pid /var/run/apache2/socks/cgisock.* && apachectl -D FOREGROUND"]
