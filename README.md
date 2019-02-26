# salt modules k8s
  通过salt来部署k8s高可用集群
# 环境：
    三台master通过keepalived+haproxy实现三节点高可用:
  
      192.168.0.11 k8s-master-1.cqt.com k8s-master-1
  
      192.168.0.12 k8s-master-2.cqt.com k8s-master-2
  
      192.168.0.13 k8s-master-3.cqt.com k8s-master-3
  
    三台node节点:
  
      192.168.0.21 k8s-node-1.cqt.com k8s-node-1
  
      192.168.0.22 k8s-node-2.cqt.com k8s-node-2
  
      192.168.0.23 k8s-node-3.cqt.com k8s-node-3
        
    keepalived为api-server提供的vip为: 192.168.0.15 haproxy通过监听8443来为api-server提供负载均衡

    所有机器使用centos7.4 1708 64位的系统

  # 部署步骤

    准备一个salt master,并安装git,下载源码:

    cd /srv/salt/ && git clone https://github.com/linchqd/k8s.git

    根据实际修改k8s/master k8s/roster k8s/pillar/目录下文件并配置salt
     
    下载kubernetes-1.11.1 server二进制包

    cd /tmp/ && wget https://dl.k8s.io/v1.11.1/kubernetes-server-linux-amd64.tar.gz

    解压后把kubernetes/server/bin下面所有的可执行文件拷贝到/srv/salt/modules/k8s/requirements/files/目录下

    mv /tmp/kubernetes/server/bin/{apiextensions-apiserver,cloud-controller-manager,hyperkube,kubeadm,kube-aggregator,kube-apiserver,kube-controller-manager,kubectl,kubelet,kube-proxy,kube-scheduler,mounter} /srv/salt/modules/k8s/requirements/files/

    # master 部署
    
      # 创建集群CA
        cd /srv/salt/modules/k8s/ca-build/files/ && /srv/salt/modules/k8s/requirements/files/cfssl gencert -initca /srv/salt/modules/k8s/ca-build/files/ca-csr.json | /srv/salt/modules/k8s/requirements/files/cfssljson -bare ca
    
      # 创建集群admin密钥配置文件
        cd /srv/salt/modules/k8s/kubectl/files/ && /srv/salt/modules/k8s/requirements/files/cfssl gencert -ca=/srv/salt/modules/k8s/ca-build/files/ca.pem -ca-key=/srv/salt/modules/k8s/ca-build/files/ca-key.pem -config=/srv/salt/modules/k8s/ca-build/files/ca-config.json -profile=kubernetes admin-csr.json | cfssljson -bare admin
    
      # 部署etcd集群
        修改vim /srv/salt/modules/k8s/etcd/files/etcd-csr.json文件中hosts ip 成etcd集群的节点ip
        cd /srv/salt/modules/k8s/etcd/files/ && /srv/salt/modules/k8s/requirements/files/cfssl gencert -ca=/srv/salt/modules/k8s/ca-build/files/ca.pem -ca-key=/srv/salt/modules/k8s/ca-build/files/ca-key.pem -config=/srv/salt/modules/k8s/ca-build/files/ca-config.json -profile=kubernetes etcd-csr.json | /srv/salt/modules/k8s/requirements/files/cfssljson -bare etcd
    
      # 部署flanneld
        cd /srv/salt/modules/k8s/flanneld/files/ && /srv/salt/modules/k8s/requirements/files/cfssl gencert -ca=/srv/salt/modules/k8s/ca-build/files/ca.pem -ca-key=/srv/salt/modules/k8s/ca-build/files/ca-key.pem -config=/srv/salt/modules/k8s/ca-build/files/ca-config.json   -profile=kubernetes flanneld-csr.json | /srv/salt/modules/k8s/requirements/files/cfssljson -bare flanneld

      # 部署api-server
        根据实际修改vim /srv/salt/modules/k8s/api-server/files/kubernetes-csr.json文件
        cd /srv/salt/modules/k8s/api-server/files/ && /srv/salt/modules/k8s/requirements/files/cfssl gencert -ca=/srv/salt/modules/k8s/ca-build/files/ca.pem -ca-key=/srv/salt/modules/k8s/ca-build/files/ca-key.pem -config=/srv/salt/modules/k8s/ca-build/files/ca-config.json -profile=kubernetes kubernetes-csr.json | /srv/salt/modules/k8s/requirements/files/cfssljson -bare kubernetes

      # 部署kube-controller-manager
        根据实际修改vim /srv/salt/modules/k8s/kube-controller-manager/files/kube-controller-manager-csr.json
        cd /srv/salt/modules/k8s/kube-controller-manager/files/ && /srv/salt/modules/k8s/requirements/files/cfssl gencert -ca=/srv/salt/modules/k8s/ca-build/files/ca.pem -ca-key=/srv/salt/modules/k8s/ca-build/files/ca-key.pem -config=/srv/salt/modules/k8s/ca-build/files/ca-config.json -profile=kubernetes kube-controller-manager-csr.json | /srv/salt/modules/k8s/requirements/files/cfssljson -bare kube-controller-manager

      # 部署kube-scheduler
        根据实际修改vim /srv/salt/modules/k8s/kube-scheduler/files/kube-scheduler-csr.json
        cd /srv/salt/modules/k8s/kube-scheduler/files/ && /srv/salt/modules/k8s/requirements/files/cfssl gencert -ca=/srv/salt/modules/k8s/ca-build/files/ca.pem -ca-key=/srv/salt/modules/k8s/ca-build/files/ca-key.pem -config=/srv/salt/modules/k8s/ca-build/files/ca-config.json -profile=kubernetes kube-scheduler-csr.json | /srv/salt/modules/k8s/requirements/files/cfssljson -bare kube-scheduler

        salt-ssh -E 'k8s-master-[123]' state.sls modules.k8s.master


      # 部署master完成测试

        # etcd测试: 
          etcdctl --endpoints=https://192.168.0.11:2379 --ca-file=/etc/kubernetes/cert/ca.pem --cert-file=/etc/kubernetes/cert/etcd.pem --key-file=/etc/kubernetes/cert/etcd-key.pem cluster-health

        # flanneld测试:
          /etc/kubernetes/bin/etcdctl --endpoints=https://192.168.0.11:2379,https://192.168.0.12:2379,https://192.168.0.13:2379 --ca-file=/etc/kubernetes/cert/ca.pem --cert-file=/etc/kubernetes/cert/flanneld.pem --key-file=/etc/kubernetes/cert/flanneld-key.pem get /kubernetes/network/config
    
          /etc/kubernetes/bin/etcdctl --endpoints=https://192.168.0.11:2379,https://192.168.0.12:2379,https://192.168.0.13:2379 --ca-file=/etc/kubernetes/cert/ca.pem --cert-file=/etc/kubernetes/cert/flanneld.pem --key-file=/etc/kubernetes/cert/flanneld-key.pem ls /kubernetes/network/subnets
    
          /etc/kubernetes/bin/etcdctl --endpoints=https://192.168.0.11:2379,https://192.168.0.12:2379,https://192.168.0.13:2379 --ca-file=/etc/kubernetes/cert/ca.pem --cert-file=/etc/kubernetes/cert/flanneld.pem --key-file=/etc/kubernetes/cert/flanneld-key.pem get /kubernetes/network/subnets/172.30.9.0-24

        # api-server测试:  
          kubectl get all --all-namespaces
          kubectl get cs
          kubectl cluster-info       
    
        # kube-controller-manager测试: 
          kubectl get endpoints kube-controller-manager --namespace=kube-system  -o yaml
    
        # kube-scheduler测试: 
          kubectl get endpoints kube-scheduler --namespace=kube-system  -o yaml
    
      # work节点部署
  
        # kubelet
          在master上为每个node创建token,并替换每个node的对应pillar数据中的TOKEN
          /etc/kubernetes/bin/kubeadm token create --description kubelet-bootstrap-token --groups system:bootstrappers:k8s-node-1 --kubeconfig ~/.kube/config
          /etc/kubernetes/bin/kubeadm token create --description kubelet-bootstrap-token --groups system:bootstrappers:k8s-node-2 --kubeconfig ~/.kube/config
          /etc/kubernetes/bin/kubeadm token create --description kubelet-bootstrap-token --groups system:bootstrappers:k8s-node-3 --kubeconfig ~/.kube/config
          查看所有token: /etc/kubernetes/bin/kubeadm token list --kubeconfig ~/.kube/config
    
        # kube-proxy
          cd /srv/salt/modules/k8s/kube-proxy/files/ && /srv/salt/modules/k8s/requirements/files/cfssl gencert -ca=/srv/salt/modules/k8s/ca-build/files/ca.pem -ca-key=/srv/salt/modules/k8s/ca-build/files/ca-key.pem -config=/srv/salt/modules/k8s/ca-build/files/ca-config.json -profile=kubernetes kube-proxy-csr.json | /srv/salt/modules/k8s/requirements/files/cfssljson -bare kube-proxy
    
        salt-ssh -E 'k8s-node[123]' state.sls modules.k8s.node

        在master上kubectl get nodes查看node状态
