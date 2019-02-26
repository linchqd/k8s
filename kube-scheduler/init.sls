/etc/kubernetes/cert/kube-scheduler-key.pem:
  file.managed:
    - source: salt://modules/k8s/kube-scheduler/files/kube-scheduler-key.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/kube-scheduler.pem:
  file.managed:
    - source: salt://modules/k8s/kube-scheduler/files/kube-scheduler.pem
    - user: root
    - group: root
    - mode: 644

scheduler-kubeconfig-create:
  file.managed:
    - name: /etc/kubernetes/bin/scheduler-kubeconfig.sh
    - source: salt://modules/k8s/kube-scheduler/files/scheduler-kubeconfig.sh
    - user: root
    - group: root
    - mode: 755
  cmd.run:
    - name: . /etc/kubernetes/bin/scheduler-kubeconfig.sh
    - unless: test -f /etc/kubernetes/kube-scheduler.kubeconfig
    - require:
      - file: scheduler-kubeconfig-create
      - file: /etc/kubernetes/cert/kube-scheduler.pem

kube-scheduler-service:
  file.managed:
    - name: /etc/systemd/system/kube-scheduler.service
    - source: salt://modules/k8s/kube-scheduler/files/kube-scheduler.service
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: kube-scheduler
    - enable: True
    - require:
      - file: kube-scheduler-service
      - cmd: scheduler-kubeconfig-create 
