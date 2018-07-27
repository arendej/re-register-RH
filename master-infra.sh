#!/bin/bash
# Unregister and Re-register .. for Red Hat Credentials change.
# The course of action here is:
# - capture, clean, register, attach subs, enable repos, done.


sudo yum makecache fast -q

#get subscription currently consumed
sudo subscription-manager list --consumed|egrep 'Name|Pool|Serial' > ~/previous-subs.txt

#get repos to file
sudo yum repolist enabled|egrep -v 'repolist|Repodata'|tail -n +3|cut -d / -f 1 > ~/previous-repos.txt

#show files generated
echo "Captured Subscriptions & Repos to.."
ls -trh |egrep 'previous-subs|previous-repos'

#unregister
echo -e "\nUnregistering.."
sudo subscription-manager unregister

#clean
echo -e "\nCleaning"
sudo subscription-manager clean

#register
echo -e "\nRegistering"
sudo subscription-manager register --username=$1 --password=$2

#attach subs

ocp_pool="$(sudo subscription-manager list --available --matches "*OpenShift*Infrastructure" | grep "Pool ID:" | awk {'print $3'}| awk 'FNR == 1 {print}')"

echo -e "\nAdding subscription pools"

sudo subscription-manager attach --pool=$ocp_pool

echo -e "\nAdding Repos\n"
#setup repos
sudo subscription-manager repos --disable="*"

sudo subscription-manager repos --enable rhel-7-server-rpms --enable rhel-7-server-extras-rpms --enable rhel-7-server-ose-3.7-rpms --enable rhel-7-fast-datapath-rpms

#for r in $(cat ~/previous-repos.txt); do
#  sudo subscription-manager repos --enable $r
#done

#sudo subscription-manager repos --enable rhel-7-fast-datapath-rpms --enable rhel-7-server-extras-rpms --enable rhel-7-server-ose-3.7-rpms --enable rhel-7-server-rpms

#complete
echo -e "\nListing repos..\n"
sudo yum repolist enabled
sudo yum makecache fast
