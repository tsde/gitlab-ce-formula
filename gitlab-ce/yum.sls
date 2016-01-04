{% from "gitlab-ce/map.jinja" import gitlab with context %}

gitlab-ce-pkgrepo:
  pkgrepo.managed:
    - humanname: Gitlab CE Repository
    - baseurl: https://packages.gitlab.com/gitlab/gitlab-ce/el/{{ gitlab.repodist }}/$basearch
    - gpgcheck: 1
    - gpgkey: {{ gitlab.gpgkey_url }}
