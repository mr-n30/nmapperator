# nmapperator
A script used to automate nmap scans. Script saves output to `argv[2]/nmap/`.

## Usage:
```bash
# bash ./nmapperator.sh <ip(s)_to_scan> <name_of_directory_to_save_output>
```

## Example:
```bash
# bash ./nmapperator.sh 127.0.0.1 ~/Targets/scope/
# ls -lah ~/Targets/scope/nmap/
...
...
...
```
