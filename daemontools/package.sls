{% from "daemontools/map.jinja" import daemontools with context %}

install-daemontools:
  pkg.installed:
    - name: {{ daemontools.lookup.package_name }}

{% if 'service_name' in daemontools.lookup %}

start-daemontools:
  service.running:
    - name: {{ daemontools.lookup.service_name }}

{% endif %}
