haproxy-keepalived-pkg:
  pkg.installed:
    - names:
      - keepalived
      - haproxy

keepalived-service:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://modules/k8s/api-server/files/keepalived.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja 
    {% if "{{ salt['config.get']('NAME') }}" == "k8s-master-1" %}
    - STATE: MASTER
    - PRIORITY: 120
    {% else %}
    - STATE: BACKUP
    - PRIORITY: 110
    {% endif %}
  service.running:
    - name: keepalived
    - enable: True
    - require:
      - pkg: haproxy-keepalived-pkg
      - file: keepalived-service
    - watch:
      - file: keepalived-service

haproxy-service:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://modules/k8s/api-server/files/haproxy.cfg
    - user: root
    - group: root
    - mode: 644
    - template: jinja
  service.running:
    - name: haproxy
    - enable: True
    - require:
      - pkg: haproxy-keepalived-pkg
      - file: haproxy-service
    - watch:
      - file: haproxy-service
