disabled-firewalld-service:
  service.dead:
    - name: firewalld
    - enable: False
iptables-setting:
  cmd.run:
    - name: iptables -F && sudo iptables -X && sudo iptables -F -t nat && sudo iptables -X -t nat && iptables -P FORWARD ACCEPT && echo "iptables -P FORWARD ACCEPT" >> /etc/rc.d/rc.local && chmod +x /etc/rc.d/rc.local
    - unless: grep "iptables -P FORWARD ACCEPT" /etc/rc.d/rc.local
disabled-swap:
  cmd.run:
    - name: swapoff -a && sed -i '/ swap /s/^\(.*\)$/#\1/g' /etc/fstab
    - unless: grep -E "^#.*?swap" /etc/fstab
disabled-selinux:
  cmd.run:
    - name: setenforce 0 && sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
    - unless: grep "SELINUX=disabled" /etc/sysconfig/selinux
