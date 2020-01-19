FROM centos:7

RUN localedef -f UTF-8 -i ja_JP ja_JP.UTF-8
ENV LANG='ja_JP.UTF-8' \
    LANGUAGE='ja_JP:ja' \
    LC_ALL='ja_JP.UTF-8'
RUN \cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    yum install -y java-1.8.0-openjdk unzip libselinux-utils && \
    yum clean all && \
    curl -O https://ymu.dl.osdn.jp/hinemos/64519/hinemos-web-5.0.2-1.el7.x86_64.rpm && \
    rpm -ivh hinemos-web-5.0.2-1.el7.x86_64.rpm && \
    rm -f hinemos-web-5.0.2-1.el7.x86_64.rpm && \
    sed -i -e 's/en_US/ja_JP/' \
    -e 's/1\.7\.0-openjdk/1.8.0-openjdk/' /opt/hinemos_web/hinemos_web.cfg && \
    sed -i -e 's/'\''java version \"1\.7\.0\.\*\"'\''/'\''openjdk version \"1.8.0.*"'\''/' \
    -e 's/-XX:MaxTenuringThreshold=32/-XX:MaxTenuringThreshold=15/' /opt/hinemos_web/bin/tomcat_start.sh && \
    echo 'export CATALINA_OPTS='\'-Duser.timezone=Asia/Tokyo''\''' > /opt/hinemos_web/tomcat/bin/setenv.sh && \
    chmod +x /opt/hinemos_web/tomcat/bin/setenv.sh

EXPOSE 80

CMD /sbin/init
