FROM debian

EXPOSE 80

COPY ./start.sh /start.sh

CMD ["/start.sh"]
