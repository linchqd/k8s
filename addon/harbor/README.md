# docker-compose  最新版本  https://github.com/docker/compose/releases/latest

    curl -L https://github.com/docker/compose/releases/download/1.23.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

    chmod +x /usr/local/bin/docker-compose

# harbor 最新版本  https://github.com/goharbor/harbor/releases/latest
    
    wget https://storage.googleapis.com/harbor-releases/release-1.7.0/harbor-offline-installer-v1.7.4.tgz

    tar zxvf harbor-offline-installer-v1.7.4.tgz -C /etc/kubernetes/

    cd /etc/kubernetes/harbor/ && docker load -i harbor.v1.7.4.tar.gz

    # 证书生成
    cfssl gencert -ca=/etc/kubernetes/cert/ca.pem -ca-key=/etc/kubernetes/cert/ca-key.pem -config=/etc/kubernetes/cert/ca-config.json -profile=kubernetes harbor-csr.json | cfssljson -bare harbor
    mv harbor*.pem /etc/kubernetes/cert/

    cp harbor.cfg{,.bak}

    vim harbor.cfg # 修改以下参数
      hostname = 192.168.0.11 
      ui_url_protocol = https
      ssl_cert = /etc/kubernetes/cert/harbor.pem
      ssl_cert_key = /etc/kubernetes/cert/harbor-key.pem

    cp prepare{,.bak}
    
    vim prepare # 修改以下参数
      empty_subj = "/C=/ST=/L=/O=/CN=/"

    mkdir /data
    chmod 777 /var/run/docker.sock /data

    ./install.sh

    log: /var/log/harbor
    data: /data

  #客户端登陆

    mkdir /etc/docker/certs/192.168.0.11 -p
    cp /etc/kubernetes/cert/ca.pem /etc/docker/certs/192.168.0.11/ca.crt
    docker login https://192.168.0.11 -u admin
