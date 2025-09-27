FROM ubuntu:25.10
WORKDIR /home/ubuntu

RUN apt update && \
    apt install -y --no-install-recommends cron python3 python3-venv python3-pip build-essential ca-certificates mutt sendmail
RUN python3 -m venv wallakindle \
	&& chmod +x wallakindle/bin/activate \
	&& . wallakindle/bin/activate \
	&& pip3 install wallabag-client
RUN ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh


COPY wallakindle.sh /home/ubuntu/wallakindle.sh 
RUN chmod +x /home/ubuntu/wallakindle.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
