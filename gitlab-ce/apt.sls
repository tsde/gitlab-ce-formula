{% from "gitlab-ce/map.jinja" import gitlab with context %}
{% set os = grains.osfullname|lower %}

gitlab-ce-pkgrepo:
  pkgrepo.managed:
    - name: deb https://packages.gitlab.com/gitlab/gitlab-ce/{{ os }}/ {{ gitlab.repodist }} main
    - file: {{ gitlab.repofile }}
    - key_url: {{ gitlab.gpgkey_url }}
