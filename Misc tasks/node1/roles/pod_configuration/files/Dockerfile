FROM  docker.io/library/nginx:1.23

WORKDIR /

COPY . /

RUN chmod 755 ep.sh

ENTRYPOINT ["/ep.sh"]

EXPOSE 5432

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]

