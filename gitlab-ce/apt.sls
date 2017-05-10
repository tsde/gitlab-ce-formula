{% from "gitlab-ce/map.jinja" import gitlab with context %}

gitlab-ce-pkgrepo:
  pkgrepo.managed:
    - name: deb https://packages.gitlab.com/gitlab/gitlab-ce/{{ grains['os']|lower }}/ {{ grains['oscodename'] }} main
    - file: {{ gitlab.repofile }}
    - key_url: {{ gitlab.gpgkey_url }}
