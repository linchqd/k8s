kube-bin-dir:
  file.directory:
    - name: /etc/kubernetes/bin
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

  cmd.run:
    - name: echo "export PATH=/etc/kubernetes/bin:$PATH" >> /etc/profile && source /etc/profile
    - unless: grep "/etc/kubernetes/bin" /etc/profile

/etc/kubernetes/bin/kubectl:
  file.managed:
    - source: salt://modules/k8s/requirements/files/kubectl
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/etcdctl:
  file.managed:
    - source: salt://modules/k8s/requirements/files/etcdctl
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/etcd:
  file.managed:
    - source: salt://modules/k8s/requirements/files/etcd
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/mk-docker-opts.sh:
  file.managed:
    - source: salt://modules/k8s/requirements/files/mk-docker-opts.sh
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/flanneld:
  file.managed:
    - source: salt://modules/k8s/requirements/files/flanneld
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/kube-apiserver:
  file.managed:
    - source: salt://modules/k8s/requirements/files/kube-apiserver
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/kube-controller-manager:
  file.managed:
    - source: salt://modules/k8s/requirements/files/kube-controller-manager
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/kube-scheduler:
  file.managed:
    - source: salt://modules/k8s/requirements/files/kube-scheduler
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/kubeadm:
  file.managed:
    - source: salt://modules/k8s/requirements/files/kubeadm
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/kubelet:
  file.managed:
    - source: salt://modules/k8s/requirements/files/kubelet
    - user: root
    - group: root
    - mode: 755

/etc/kubernetes/bin/kube-proxy:
  file.managed:
    - source: salt://modules/k8s/requirements/files/kube-proxy
    - user: root
    - group: root
    - mode: 755
