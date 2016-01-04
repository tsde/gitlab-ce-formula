gitlab-ce-config:
  file.managed:
    - name: /etc/gitlab/gitlab.rb
    - source: salt://gitlab-ce/templates/gitlab.rb.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 0600
    - require:
      - pkg: gitlab-ce-pkg

gitlab-ce-cmd:
  cmd.run:
    - name: gitlab-ctl reconfigure
    - onchanges:
      - file: gitlab-ce-config
