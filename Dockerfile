FROM ultramcu/ubuntu4bbb
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y  \
    apt-get install -y apache2 apache2-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app 

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
