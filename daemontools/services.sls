{% from "daemontools/map.jinja" import daemontools with context %}

{% for service, settings in daemontools.services.items() %}

daemontools_service_{{ service }}_dir:
  file.directory:
    - name: {{ settings.service_dir }}
    - user: {{ settings.user }}

daemontools_service_{{ service }}_run_file:
  file.managed:
    - name: {{ settings.service_dir }}/run
    - contents_pillar: daemontools:services:{{ service }}:run
    - user: {{ settings.user }}
    - mode: 755

{% if settings.get('default_down', False) %}
daemontools_service_{{ service }}_down:
  file.managed:
    - name: {{ settings.service_dir }}/down
    - user: {{ settings.user }}
{% else %}
daemontools_service_{{ service }}_down:
  file.absent:
    - name: {{ settings.service_dir }}/down
{% endif %}

daemontools_service_{{ service }}_link:
  file.symlink:
    - name: {{ daemontools.lookup.service_path }}/{{ service }}
    - target: {{ settings.service_dir }}

{% endfor %}
