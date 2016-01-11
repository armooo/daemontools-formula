{% from "daemontools/map.jinja" import daemontools with context %}

{% for service, settings in daemontools.services.items() %}

daemontools_service_{{ service }}_dir:
  file.directory:
    - name: {{ settings.service_dir }}/{{ service }}
    - user: {{ settings.user }}

daemontools_service_{{ service }}_run_file:
  file.managed:
    - name: {{ settings.service_dir }}/{{ service }}/run
    - contents_pillar: daemontools:services:{{ service }}:run
    - user: {{ settings.user }}
    - mode: 755

daemontools_service_{{ service }}_log_dir:
  file.directory:
    - name: {{ settings.service_dir }}/{{ service }}/log
    - user: {{ settings.user }}

daemontools_service_{{ service }}_log_file:
  file.managed:
    - name: {{ settings.service_dir }}{{ service }}/log/run
    - user: {{ settings.user }}
    - mode: 755
{% if 'log' in settings %}
    - contents_pillar: daemontools:services:{{ service }}:log
{% else %}
    - contents: |
        #!/bin/sh
        exec logger -t {{ service }}
{% endif %}

daemontools_service_{{ service }}_link:
  file.symlink:
    - name: {{ daemontools.lookup.service_path }}/{{ service }}
    - target: {{ settings.service_dir }}/{{ service }}

daemontools_{{ service }}_log_restart:
  cmd.wait:
    - name: svc -t {{ settings.service_dir }}/{{ service }}/log
    - listen:
      - file: {{ settings.service_dir }}/{{ service }}/log/run

daemontools_{{ service }}:
  service.running:
    - name: {{ service }}
    - provider: daemontools
    - listen:
      - file: {{ settings.service_dir }}/{{ service }}/run

{% endfor %}
