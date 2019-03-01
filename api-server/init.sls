include:
  - modules.k8s.api-server.ha-keepalived

log-dir:
  file.directory:
    - name: /var/log/kubernetes
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/kubernetes/cert/kubernetes-key.pem:
  file.managed:
    - source: salt://modules/k8s/api-server/files/kubernetes-key.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/kubernetes.pem:
  file.managed:
    - source: salt://modules/k8s/api-server/files/kubernetes.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/encryption-config.yaml:
  file.managed:
    - source: salt://modules/k8s/api-server/files/encryption-config.yaml
    - user: root
    - group: root
    - mode: 644
    - template: jinja

/etc/kubernetes/cert/metrics-server-key.pem:
  file.managed:
    - source: salt://modules/k8s/api-server/files/metrics-server-key.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/metrics-server.pem:
  file.managed:
    - source: salt://modules/k8s/api-server/files/metrics-server.pem
    - user: root
    - group: root
    - mode: 644

api-server-service:
  file.managed:  
    - name: /etc/systemd/system/kube-apiserver.service
    - source: salt://modules/k8s/api-server/files/kube-apiserver.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  service.running:
    - name: kube-apiserver
    - enable: True
    - require:
      - file: api-server-service
      - file: /etc/kubernetes/cert/kubernetes.pem
      - file: /etc/kubernetes/encryption-config.yaml

create-clusterrobinding:
  file.managed:
    - name: /etc/kubernetes/bin/create-clusterrolebinding.sh
    - source: salt://modules/k8s/api-server/files/create-clusterrolebinding.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: . /etc/kubernetes/bin/create-clusterrolebinding.sh
    - unless: /etc/kubernetes/bin/kubectl get clusterrolebinding | grep kube-apiserver:kubelet-apis
    - require:
      - file: create-clusterrobinding
      - service: api-server-service
