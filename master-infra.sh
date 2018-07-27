# Unregister and Re-register .. for Red Hat Credentials change.
# The course of action here is:
# - capture, clean, register, attach subs, enable repos, done.
--- # for the app nodes
- hosts: infras
  connection: ssh
  become: yes
  vars:
    - rhuser: yourusername
    - rhpass: yourpassword
  tasks:

  - name: update yum cache
    shell: sudo yum makecache fast -q

  - name: get subscriptions currently consumed
    shell: "sudo subscription-manager list --consumed|egrep 'Name|Pool|Serial' > ~/previous-subs.txt"
    run_once: yes

  - name: get repos to file
    shell: "sudo yum repolist enabled|egrep -v 'repolist|Repodata'|tail -n +3|cut -d / -f 1 > ~/previous-repos.txt"
    run_once: yes

  - name: unregister & clean
    shell: sudo subscription-manager unregister && sudo subscription-manager clean

  - name: register
    shell: "sudo subscription-manager register --username={{ yourusername }} --password={{ yourpassword }}"

  - name: attach subs
    shell: 'OCP_POOL="$(sudo subscription-manager list --available --matches "*OpenShift*Infrastructure" | grep "Pool ID:" | awk {'print $3'}| awk 'FNR == 1 {print}')"'

  - name: Add subscription pools
    shell: sudo subscription-manager attach --pool=$OCP_POOL

  - name: clear repos
    shell: 'sudo subscription-manager repos --disable="*"'

  - name: add repos
    shell: sudo subscription-manager repos --enable rhel-7-server-rpms --enable rhel-7-server-extras-rpms --enable rhel-7-server-ose-3.7-rpms --enable rhel-7-fast-datapath-rpms

  - name: update cache and list enabled repos
    shell: sudo yum makecache fast && sudo subscription-manager repos --list-enabled
