core-dns:
  file.managed:
    - name: /etc/kubernetes/coredns.yaml
    - source: salt://modules/k8s/k8s-plugins/coredns/files/coredns.yaml
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  cmd.run:
    - name: /etc/kubernetes/bin/kubectl apply -f /etc/kubernetes/coredns.yaml
    - unless: /etc/kubernetes/bin/kubectl get sa --all-namespaces | grep coredns
    - require:
      - file: core-dns
