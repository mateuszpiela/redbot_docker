FROM ubuntu:24.04

ENV BOT_TOKEN=""
ENV PREFIX=""
ENV TZ="Europe/Warsaw"

#Install dependency & add deadsnakes repo for python 3.11
RUN apt-get update &&\
    apt-get install -y curl gnupg &&\
    curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf23c5a6cf475977595c89f51ba6932366a755776" | gpg --dearmor | tee /etc/apt/trusted.gpg.d/deadsnakes.gpg  &&\
    echo "deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu noble main" >> /etc/apt/sources.list.d/deadsnakes.list &&\
    apt-get update &&\
    apt-get -y install python3.11 python3.11-dev python3.11-venv git openjdk-17-jre-headless build-essential nano vim &&\
    rm -rf /var/lib/apt/lists/*


#Create redbot user and configure TimeZone
RUN useradd -d /redbot -m -s /bin/bash redbot &&\
    echo "$TZ" > /etc/timezone

#Install entrypoint
ADD --chmod=777 entrypoint.sh /entrypoint.sh

#Change current user to redbot
USER redbot
RUN python3.11 -m venv ~/redenv &&\
    . /redbot/redenv/bin/activate &&\
    pip install -U pip wheel &&\
    pip install -U Red-DiscordBot &&\
    redbot-setup --no-prompt --instance-name default --data-path /redbot/data &&\
    mkdir -p /redbot/data

VOLUME /redbot/data
ENTRYPOINT ["/entrypoint.sh"]
