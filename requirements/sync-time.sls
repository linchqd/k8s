sync-time:
  cmd.run:
    - name: timedatectl set-timezone Asia/Shanghai && timedatectl set-local-rtc 0 && systemctl restart crond && systemctl restart rsyslog && ntpdate cn.pool.ntp.org
