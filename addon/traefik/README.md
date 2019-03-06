# traefik_ui_auth.yaml:

    htpasswd -c auth admin
    kubectl create secret generic mysecret --from-file auth --namespace=kube-system --dry-run -o yaml > traefik_ui_auth.yaml

# traefik-tls-cert.yaml:

    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout gitlab_cqt_com.key -out gitlab_cqt_com.crt -subj "/CN=gitlab.cqt.com"

    kubectl -n kube-system create secret tls gitlab-tls-cert --key=gitlab_cqt_com.key --cert=gitlab_cqt_com.crt --dry-run -o yaml >> traefik-tls-cert.yaml
