/etc/kubernetes/metrics-server:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - mkdirs: True

/etc/kubernetes/metrics-server/auth-delegator.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/metrics-server/files/auth-delegator.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/metrics-server/auth-reader.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/metrics-server/files/auth-reader.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/metrics-server/metrics-apiservice.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/metrics-server/files/metrics-apiservice.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/metrics-server/metrics-server-deployment.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/metrics-server/files/metrics-server-deployment.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/metrics-server/metrics-server-service.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/metrics-server/files/metrics-server-service.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/metrics-server/resource-reader.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/metrics-server/files/resource-reader.yaml
    - user: root
    - group: root
    - mode: 644

metrics-server:
  cmd.run:
    - name: /etc/kubernetes/bin/kubectl apply -f /etc/kubernetes/metrics-server
    - unless: /etc/kubernetes/bin/kubectl get svc --all-namespaces | grep metrics-server
    - require:
      - file: /etc/kubernetes/metrics-server/resource-reader.yaml
