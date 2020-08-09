# Johannes Laurin Hörmann, johannes.laurin@gmail.com, August 2020
FROM httpd:2.4
COPY ./usr/local/apache2/conf/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./usr/local/apache2/conf/extra/httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
COPY ./usr/local/apache2/conf/extra/httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf
COPY ./usr/local/apache2/conf/extra/httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf

# RUN a2enmod ssl
# RUN a2enmod proxy_http
# RUN a2enmod proxy_wstunnel
# RUN a2ensite traccar
RUN mkdir -p /etc/apache2/sites-enabled \
    && ln -s /etc/apache2/sites-available/traccar.conf /etc/apache2/sites-enabled/