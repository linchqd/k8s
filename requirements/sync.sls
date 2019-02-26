/etc/resolv.conf:
  file.managed:
    - source: salt://modules/k8s/requirements/files/resolv.conf
    - user: root
    - group: root
    - mode: 644
/etc/hosts:
  file.managed:
    - source: salt://modules/k8s/requirements/files/hosts
    - user: root
    - group: root
    - mode: 644
    - template: jinja
