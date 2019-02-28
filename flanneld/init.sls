k8s-cert-dir:
  file.directory:
    - name: /etc/kubernetes/cert
    - user: root
    - group: root
    - mode: 755
    - mkdirs: True

/etc/kubernetes/cert/flanneld-key.pem:
  file.managed:
    - source: salt://modules/k8s/flanneld/files/flanneld-key.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/flanneld.pem:
  file.managed:
    - source: salt://modules/k8s/flanneld/files/flanneld.pem
    - user: root
    - group: root
    - mode: 644

ca-pub-pem:
  file.managed:
    - name: /etc/kubernetes/cert/ca.pem
    - source: salt://modules/k8s/ca-build/files/ca.pem
    - user: root
    - group: root
    - mode: 644

flanneld_to_etcd:
  file.managed:
    - name: /etc/kubernetes/bin/flanneld-to-etcd.sh
    - source: salt://modules/k8s/flanneld/files/flanneld-to-etcd.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja

  cmd.run:
    - name: . /etc/kubernetes/bin/flanneld-to-etcd.sh
    - unless: /etc/kubernetes/bin/etcdctl --endpoints={{ salt['config.get']('k8s-common-config:etcd:endpoints') }} --ca-file=/etc/kubernetes/cert/ca.pem --cert-file=/etc/kubernetes/cert/flanneld.pem --key-file=/etc/kubernetes/cert/flanneld-key.pem get /kubernetes/network/config
    - require:
      - file: ca-pub-pem

flanneld-service:
  file.managed:
    - name: /etc/systemd/system/flanneld.service
    - source: salt://modules/k8s/flanneld/files/flanneld.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja

  service.running:
    - name: flanneld
    - enable: True
    - require:
      - file: flanneld-service
      - cmd: flanneld_to_etcd
