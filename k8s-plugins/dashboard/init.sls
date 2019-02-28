/etc/kubernetes/dashboard:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - mkdirs: True

/etc/kubernetes/dashboard/dashboard-configmap.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/dashboard/files/dashboard-configmap.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/dashboard/dashboard-controller.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/dashboard/files/dashboard-controller.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/dashboard/dashboard-rbac.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/dashboard/files/dashboard-rbac.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/dashboard/dashboard-secret.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/dashboard/files/dashboard-secret.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/dashboard/dashboard-service.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/dashboard/files/dashboard-service.yaml
    - user: root
    - group: root
    - mode: 644

/etc/kubernetes/dashboard/dashboard-admin.yaml:
  file.managed:
    - source: salt://modules/k8s/k8s-plugins/dashboard/files/dashboard-admin.yaml
    - user: root
    - group: root
    - mode: 644

dashboard:
  cmd.run:
    - name: /etc/kubernetes/bin/kubectl apply -f /etc/kubernetes/dashboard
    - unless: /etc/kubernetes/bin/kubectl get svc --all-namespaces | grep kubernetes-dashboard
    - require:
      - file: /etc/kubernetes/dashboard/dashboard-service.yaml
