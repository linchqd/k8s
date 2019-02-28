k8s-common-config:
  hosts_file:
    "192.168.0.11 k8s-master-1.cqt.com k8s-master-1\n\
192.168.0.12 k8s-master-2.cqt.com k8s-master-2\n\
192.168.0.13 k8s-master-3.cqt.com k8s-master-3\n\
192.168.0.21 k8s-node-1.cqt.com k8s-node-1\n\
192.168.0.22 k8s-node-2.cqt.com k8s-node-2\n\
192.168.0.23 k8s-node-3.cqt.com k8s-node-3"

  apiserver:
    https:
      "https://192.168.0.15:8443"
    ip:
      "192.168.0.15"

  etcd:
    nodes:
      "k8s-master-1=https://192.168.0.11:2380,k8s-master-2=https://192.168.0.12:2380,k8s-master-3=https://192.168.0.13:2380"
    endpoints:
      "https://192.168.0.11:2379,https://192.168.0.12:2379,https://192.168.0.13:2379"

  cluster:
    service_cidr:
      "172.30.0.0/16"
    pod_cidr:
      "10.254.0.0/16"
    node_port_range:
      "30000-32767"
    dns:
      "10.254.0.2"
    domain:
      "cluster.local."

  haproxy_backend:
    "k8s-master-1": "192.168.0.11:6443"
    "k8s-master-2": "192.168.0.12:6443"
    "k8s-master-3": "192.168.0.13:6443"

  encryption_key:
    "SZ4lsSf3ru4cYlbs8+BbycgkqTUe4K+Z2qL6uXzp3HU="
