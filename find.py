#!/usr/bin/python3.7

import subprocess
import os

net = '192.168.1.0/24'
port = '22'
wait = '1'

def exec_cmd(cmd):
    command = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, _ = command.communicate()
    return (stdout.decode(), command.returncode)

def find_ips():
    cmd = ['nmap', '-sP', net]
    stdout = exec_cmd(cmd)[0]
    output = stdout.split(os.linesep)[1:-2:2]

    ips = []
    for i in output:
        line = i.rstrip(')').split('(')
        ip = line[1]
        ips.append(ip)

    return ips

def check_port(ips, port):
    cmd = ['nc', '-zw', wait]

    ip_list = []
    for ip in ips:
        cmd.extend([ip, port])
        result = exec_cmd(cmd)[1]
        # it is success if result == 0
        if not result:
            ip_list.append(ip)
        cmd = cmd[:-2]

    print(ip_list)

if __name__ == '__main__':
    check_port(find_ips(), port)
