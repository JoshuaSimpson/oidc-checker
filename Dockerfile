FROM ubuntu:22.10

RUN apt-get update && apt-get install -y openssl
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]