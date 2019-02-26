/var/lib/kube-proxy:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True
/etc/kubernetes/cert/kube-proxy-key.pem:
  file.managed:
    - source: salt://modules/k8s/kube-proxy/files/kube-proxy-key.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/kube-proxy.pem:
  file.managed:
    - source: salt://modules/k8s/kube-proxy/files/kube-proxy.pem
    - user: root
    - group: root
    - mode: 644

kube-proxy-kubeconfig:
  file.managed:
    - name: /etc/kubernetes/bin/kube-proxy-kubeconfig.sh
    - source: salt://modules/k8s/kube-proxy/files/kube-proxy-kubeconfig.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
  cmd.run:
    - name: . /etc/kubernetes/bin/kube-proxy-kubeconfig.sh
    - unless: test -f /etc/kubernetes/kube-proxy.kubeconfig
    - require:
      - file: kube-proxy-kubeconfig
      - file: /etc/kubernetes/cert/kube-proxy.pem

/etc/kubernetes/kube-proxy.config.yaml:
  file.managed:
    - source: salt://modules/k8s/kube-proxy/files/kube-proxy.config.yaml
    - user: root
    - group: root
    - mode: 644
    - template: jinja

kube-proxy-service:
  file.managed:
    - name: /etc/systemd/system/kube-proxy.service
    - source: salt://modules/k8s/kube-proxy/files/kube-proxy.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: kube-proxy
    - enable: True
    - require:
      - file: kube-proxy-service
      - file: /etc/kubernetes/kube-proxy.config.yaml
      - cmd: kube-proxy-kubeconfig
