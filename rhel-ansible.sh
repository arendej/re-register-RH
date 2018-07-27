#!/bin/bash
# Unregister and Re-register .. for Red Hat Credentials change.
# The course of action here is:
# - capture, clean, register, attach subs, enable repos, done.
# note: not for VDC subs.


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

rh_pool="$(sudo subscription-manager list --available --matches "Red Hat Enterprise Linux Server,*" | grep "Pool ID:" | awk {'print $3'}| awk 'FNR == 1 {print}')"

echo -e "\nAdding subscription pools"

sudo subscription-manager attach --pool=$rh_pool

echo -e "\nAdding Repos\n"
#setup repos
sudo subscription-manager repos --disable="*"

for r in $(cat ~/previous-repos.txt); do
  sudo subscription-manager repos --enable $r
done

#sudo subscription-manager repos --enable rhel-7-server-extras-rpms --enable rhel-7-server-optional-rpms --enable rhel-7-server-rpms

#complete
echo -e "\nListing repos..\n"
sudo yum repolist enabled
