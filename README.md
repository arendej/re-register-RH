# re-/ register-RH
This helps register or re-register numerous RHEL servers for OpenShift install.

## Details

* Use ansible, combined with these scripts to unregister and re-register hosts under different Red Hat account credentials.
* Uses the ansible cli with the ansible 'script' module, or you could use these with a playbook.
* **fill in your inventory file before running.**
* infras group includes master nodes and infra nodes.
* apps group is only for app nodes

example:

To run against the masters and infras..

`ansible -i nodes.inv infras -m script -a "master-infra.sh RHuser RHpassword"`

To run against the app nodes..

`ansible -i nodes.inv apps -m script -a "apps.sh RHuser RHpassword"`

Alternatively, you may put your username and password into the script file before passing it along with Ansible.

The [rhel-ansible.sh](https://github.com/ArctiqTeam/re-register-RH-hosts/blob/master/rhel-ansible.sh) script can be run on your ansible bastion host to unregister and register it on new credentials as well. It can be adapted for most RHEL servers, as it captures the prior repos and brings them back.

Note that the output from running this via the Ansible CLI results in lots of output, so you may wish to direct it to a file or use `nohup` with `&`
