# https://github.com/containous/traefik/releases/latest

# traefik_ui_auth.yaml:

    htpasswd -c auth admin
    kubectl create secret generic mysecret --from-file auth --namespace=kube-system --dry-run -o yaml > traefik_ui_auth.yaml

# traefik-tls-cert.yaml:

    openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -keyout gitlab_cqt_com.key -out gitlab_cqt_com.crt -subj "/CN=gitlab.cqt.com"

    kubectl -n kube-system create secret tls gitlab-tls-cert --key=gitlab_cqt_com.key --cert=gitlab_cqt_com.crt --dry-run -o yaml >> traefik-tls-cert.yaml

    多证书:
    # kubectl create secret generic traefik-cert --from-file=star_59iedu_com.key  --from-file=star_59iedu_com.pem  --from-file=star_yingjigl_com.key  --from-file=star_yingjigl_com.pem -n kube-system
