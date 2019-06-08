FROM alpine

RUN apk add curl 

ADD do-ip-update.sh ./

CMD ["./do-ip-update.sh"]
