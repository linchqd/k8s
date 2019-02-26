etcd-workdir:
  file.directory:
    - name: /var/lib/etcd
    - user: root
    - group: root
    - mode: 755
    - makedirs: True 

/etc/kubernetes/cert/etcd-key.pem:
  file.managed:
    - source: salt://modules/k8s/etcd/files/etcd-key.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/etcd.pem:
  file.managed:
    - source: salt://modules/k8s/etcd/files/etcd.pem
    - user: root
    - group: root
    - mode: 644

etcd-service:
  file.managed:
    - name: /etc/systemd/system/etcd.service
    - source: salt://modules/k8s/etcd/files/etcd.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  service.running:
    - name: etcd
    - enable: True
    - require:
      - file: etcd-service
      - file: etcd-workdir
      - /etc/kubernetes/cert/etcd.pem
