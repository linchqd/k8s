/var/lib/kubelet:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True 

/var/log/kubernetes:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

bootstrap-kubeconfig:
  file.managed:
    - name: /etc/kubernetes/bin/bootstrap-kubeconfig.sh
    - source: salt://modules/k8s/kubelet/files/bootstrap-kubeconfig.sh
    - user: root
    - group: root
    - mode: 755
    - template: jinja
  cmd.run:
    - name: . /etc/kubernetes/bin/bootstrap-kubeconfig.sh
    - unless: test -f /etc/kubernetes/kubelet-bootstrap.kubeconfig
    - require:
      - file: bootstrap-kubeconfig

/etc/kubernetes/kubelet.config.json:
  file.managed:
    - source: salt://modules/k8s/kubelet/files/kubelet.config.json
    - user: root
    - group: root
    - mode: 644
    - template: jinja

kubelet-service:
  file.managed:
    - name: /etc/systemd/system/kubelet.service
    - source: salt://modules/k8s/kubelet/files/kubelet.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  service.running:
    - name: kubelet
    - enable: True
    - require:
      - file: kubelet-service
      - file: /etc/kubernetes/kubelet.config.json
    - watch:
      - file: /etc/kubernetes/kubelet.config.json
