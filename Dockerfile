FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY dist/ /var/www/html/

RUN chown -R www-data:www-data /var/www/html/

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]


#docker build -t webapp01 .
#docker run -d -p 3000:80 --name webapp01 <Image ID>
#curl http://localhost:3000
