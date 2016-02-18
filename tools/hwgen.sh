#!/bin/bash
# This script automatically pulls the tarball from the HW site and unpacks it in the repo.

if [ $# -ne 1 ]; then
    echo './hwgen.sh <hw number>'
    exit
fi

repo_base=`dirname $0`/..
hw_dir=$repo_base/hw$1

if [ -d $hw_dir ]; then
    echo "An existing directory for HW$1 has been detected. Please rename or remove the directory, and rerun this script."
    exit
fi

mkdir $hw_dir
cd $hw_dir

echo "Obtaining template from Prof. Karu..."
wget --quiet http://pages.cs.wisc.edu/~karu/courses/cs552/spring2016//handouts/verilog_code/hw$1.tar 

echo "Received! Now unpacking..."
tar xf hw$1.tar
rm -f hw$1.tar
cp -rf ../partners.txt .
echo "Done!"
