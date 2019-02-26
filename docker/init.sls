/etc/kubernetes/bin/dockerd:
  file.managed:
    - source: salt://modules/k8s/docker/files/dockerd
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/docker:
  file.managed:
    - source: salt://modules/k8s/docker/files/docker
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/docker-containerd:
  file.managed:
    - source: salt://modules/k8s/docker/files/docker-containerd
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/docker-containerd-ctr:
  file.managed:
    - source: salt://modules/k8s/docker/files/docker-containerd-ctr
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/docker-containerd-shim:
  file.managed:
    - source: salt://modules/k8s/docker/files/docker-containerd-shim
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/docker-init:
  file.managed:
    - source: salt://modules/k8s/docker/files/docker-init
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/docker-proxy:
  file.managed:
    - source: salt://modules/k8s/docker/files/docker-proxy
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/docker-runc:
  file.managed:
    - source: salt://modules/k8s/docker/files/docker-runc
    - user: root
    - group: root
    - mode: 755

/etc/docker:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/docker/daemon.json:
  file.managed:
    - source: salt://modules/k8s/docker/files/daemon.json
    - user: root
    - group: root
    - mode: 644

docker-service:
  file.managed:
    - name: /etc/systemd/system/docker.service
    - source: salt://modules/k8s/docker/files/docker.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: docker
    - enable: True
    - require:
      - file: docker-service
      - file: /etc/docker/daemon.json
    - watch:
      - file: /etc/docker/daemon.json

iptables-allowed:
  cmd.run:
    - name: chmod +x /etc/rc.d/rc.local && echo "/sbin/iptables -P FORWARD ACCEPT" >> /etc/rc.d/rc.local
    - unless: grep "iptables -P FORWARD" /etc/rc.d/rc.local
