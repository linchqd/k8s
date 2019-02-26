kubelet-bootstrap-clusterrolebinding:
  cmd.run:
    - name: /etc/kubernetes/bin/kubectl create clusterrolebinding kubelet-bootstrap --clusterrole=system:node-bootstrapper --group=system:bootstrappers
    - unless: /etc/kubernetes/bin/kubectl get clusterrolebinding | grep "kubelet-bootstrap"

auto-approve-node-csr:
  file.managed:
    - name: /etc/kubernetes/csr-crb.yaml
    - source: salt://modules/k8s/auto-approve-node-csr/files/csr-crb.yaml
    - user: root
    - group: root
    - mode: 644
  cmd.run:
    - name: /etc/kubernetes/bin/kubectl apply -f /etc/kubernetes/csr-crb.yaml
    - require:
      - file: auto-approve-node-csr
    - unless: /etc/kubernetes/bin/kubectl get clusterrolebinding | grep "node-server-cert-renewal"
