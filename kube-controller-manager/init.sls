/etc/kubernetes/cert/kube-controller-manager-key.pem:
  file.managed:
    - source: salt://modules/k8s/kube-controller-manager/files/kube-controller-manager-key.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/kube-controller-manager.pem:
  file.managed:
    - source: salt://modules/k8s/kube-controller-manager/files/kube-controller-manager.pem
    - user: root
    - group: root
    - mode: 644

kubeconfig-create:
  file.managed:
    - name: /etc/kubernetes/bin/controller-manager-kubeconfig.sh
    - source: salt://modules/k8s/kube-controller-manager/files/controller-manager-kubeconfig.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: . /etc/kubernetes/bin/controller-manager-kubeconfig.sh
    - unless: test -f /etc/kubernetes/kube-controller-manager.kubeconfig
    - require:
      - file: kubeconfig-create
      - file: /etc/kubernetes/cert/kube-controller-manager.pem

kube-controller-manager-service:
  file.managed:
    - name: /etc/systemd/system/kube-controller-manager.service
    - source: salt://modules/k8s/kube-controller-manager/files/kube-controller-manager.service
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  service.running:
    - name: kube-controller-manager
    - enable: True
    - require:
      - file: kube-controller-manager-service
      - cmd: kubeconfig-create 
