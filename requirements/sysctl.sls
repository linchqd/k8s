sysctl-conf:
  file.managed:
    - name: /etc/sysctl.d/kubernetes.conf
    - source: salt://modules/k8s/requirements/files/kubernetes.conf
    - user: root
    - group: root
    - mode: 644

  cmd.run:
    - name: sysctl -p /etc/sysctl.d/kubernetes.conf

user-namespace:
  cmd.run:
    - name: grubby --args="user_namespace.enable=1" --update-kernel="$(grubby --default-kernel)"

mount-cgroup:
  cmd.run:
    - name: mount | grep '/sys/fs/cgroup/cpu,cpuacct' || mount -t cgroup -o cpu,cpuacct none /sys/fs/cgroup/cpu,cpuacct
