FROM nginx

WORKDIR /usr/share/nginx/html

ADD index.html .

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 80

STOPSIGNAL SIGQUIT

CMD ["nginx", "-g", "daemon off;"]
