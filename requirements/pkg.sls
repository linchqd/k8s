requirements-pkg-install:
  pkg.installed:
    - names:
      - epel-release
      - conntrack-tools
      - ipvsadm
      - ipset
      - jq
      - sysstat
      - curl
      - iptables
      - libseccomp
      - ntpdate
      - psmisc
  cmd.run:
    - name: modprobe br_netfilter && modprobe ip_vs
    - require:
      - pkg: requirements-pkg-install
