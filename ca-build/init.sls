k8s-cert:
  file.directory:
    - name: /etc/kubernetes/cert
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/kubernetes/cert/ca-config.json:
  file.managed:
    - source: salt://modules/k8s/ca-build/files/ca-config.json
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/ca-key.pem:
  file.managed:
    - source: salt://modules/k8s/ca-build/files/ca-key.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/ca.pem:
  file.managed:
    - source: salt://modules/k8s/ca-build/files/ca.pem
    - user: root
    - group: root
    - mode: 644
