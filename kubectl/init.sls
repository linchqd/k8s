kubeconfig-dir:
  file.directory:
    - name: /root/.kube
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/kubernetes/cert/admin.pem:
  file.managed:
    - source: salt://modules/k8s/kubectl/files/admin.pem
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/cert/admin-key.pem:
  file.managed:
    - source: salt://modules/k8s/kubectl/files/admin-key.pem
    - user: root
    - group: root
    - mode: 644

kube-config:
  cmd.run:
    - name: /etc/kubernetes/bin/kubectl config set-cluster kubernetes --certificate-authority=/etc/kubernetes/cert/ca.pem --embed-certs=true --server={{ salt['config.get']('k8s-common-config:apiserver:https') }} --kubeconfig=kubectl.kubeconfig && /etc/kubernetes/bin/kubectl config set-credentials admin --client-certificate=/etc/kubernetes/cert/admin.pem --client-key=/etc/kubernetes/cert/admin-key.pem --embed-certs=true --kubeconfig=kubectl.kubeconfig && /etc/kubernetes/bin/kubectl config set-context kubernetes --cluster=kubernetes --user=admin --kubeconfig=kubectl.kubeconfig && /etc/kubernetes/bin/kubectl config use-context kubernetes --kubeconfig=kubectl.kubeconfig && mv kubectl.kubeconfig /root/.kube/config
    - unless: test -f /root/.kube/config
    - require:
      - file: /etc/kubernetes/cert/admin-key.pem
