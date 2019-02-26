/usr/bin/cfssl:
  file.managed:
    - source: salt://modules/k8s/requirements/files/cfssl
    - user: root
    - group: root
    - mode: 755

/usr/bin/cfssl-certinfo:
  file.managed:
    - source: salt://modules/k8s/requirements/files/cfssl-certinfo
    - user: root
    - group: root
    - mode: 755

/usr/bin/cfssljson:
  file.managed:
    - source: salt://modules/k8s/requirements/files/cfssljson
    - user: root
    - group: root
    - mode: 755
