FROM httpd
RUN apt update -y && apt install postgresql -y && apt install htop -y
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ENV POSTGRES_USER=$POSTGRES_USER
ENV POSTGRES_DB=$POSTGRES_DB
EXPOSE 80
VOLUME ["/usr/local/apache2/htdocs/"]
COPY index.html /usr/local/apache2/htdocs/
#RUN echo 'PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -h nlb-web-service-02baa1f603b5bc78.elb.eu-west-3.amazonaws.com $POSTGRES_DB -c "create table cred (name varchar(80), pass varchar(80)); insert into cred values ('\''raw'\'','\''qwerty'\'');" || true' > /home/cmd.sh
RUN echo 'PGPASSWORD=$POSTGRES_PASSWORD psql -U $POSTGRES_USER -h nlb-web-service-02baa1f603b5bc78.elb.eu-west-3.amazonaws.com $POSTGRES_DB -c  "SELECT * FROM cred;" > /usr/local/apache2/cgi-bin/result' > /home/cron.sh
RUN echo "(while true; do /home/cron.sh; sleep 5; done &); httpd-foreground " >> /home/cmd.sh
RUN chmod -R +x /home/
CMD /home/cmd.sh
