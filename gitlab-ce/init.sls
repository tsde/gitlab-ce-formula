{% from "gitlab-ce/map.jinja" import gitlab with context %}

{% set repo_sls = {
  'Debian': 'apt',
  'RedHat': 'yum'
}.get(grains.os_family) %}

# Gitlab CE packages are not signed and RedHat complains about it
{% set no_gpg_check = {
  'Debian': false,
  'RedHat': true
}.get(grains.os_family) %}

{% if gitlab.pkg_version is defined %}
{% set version_num = gitlab.pkg_version %}
{% else %}
{% set version_num = '' %}
{% endif %}

include:
  - gitlab-ce.{{ repo_sls }}
  - gitlab-ce.config

gitlab-ce-pkg:
  pkg.installed:
    - name: {{ gitlab.pkg_name }}
    - version: {{ version_num }}
    - skip_verify: {{ no_gpg_check }}
    - require:
      - pkgrepo: gitlab-ce-pkgrepo

gitlab-ce-service:
  service.running:
    - name: {{ gitlab.service_name }}
    - enable: True
    - require:
      - pkg: gitlab-ce-pkg
      - cmd: gitlab-ce-cmd
