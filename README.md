# Compilare

1. Modificare `nethserver-enterprise-groups.xml.in`

2. Eseguire: `make`

3. Se necessario, in po/ directory: `make <lang>.po`

# Pubblicare

1. Eseguire:
```
echo -e "cd nsent/7.2.1511\nput nethesis-updates-groups.xml" | sftp -b - packages.nethesis.it
```

2. Collegarsi al server ed eseguire:
```
repobuild 7.2.1511/nethesis-updates/x86_64
```
