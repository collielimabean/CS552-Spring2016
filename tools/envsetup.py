#!/usr/bin/python

"""
    envsetup.py is intended to create a testing environment for verilog in CS552.
    It will look for and pull in any dependent modules in the common/ folder.
    Run as ./envsetup.py <dir> 
"""

import os
import sys
import shutil

#### Constants ####
DEV_ENV_DIRNAME = 'env'
COMMON_MODULE_PATH = '../common/'

#### Functions ####

def get_dependent_module_names(module_file_path):
    """
        Gets a set of dependent modules that a modules requires.
        :param module_file_path:
            A path to the module file.
        :returns:
            A list of module names, possibly empty
    """
    dependent = []
    with open(module_file_path, 'r') as f:
        pass 

def check_for_missing_modules(module_set):
    """
        Given a set of all required modules, return a set of all
        modules that could not be found in the common/ folder or
        the supplied user directory.
        :param module_set:
            A set of all modules used 
        :returns: 
            A set of all missing modules not in common/ or the 
            user supplied, or false if everything was found.
    """

def copy_dependent_modules(module_set, dest_dir):
    pass

#### Main ####
# sanity checks
if len(sys.argv) != 2:
    print "usage: ./envsetup.py <directory to setup>"
    exit()

if not os.path.isdir(sys.argv[1]):
    print "Could not find {0}".format(sys.argv[1])
    exit()

dev_env_path = os.path.join(sys.argv[1], DEV_ENV_DIRNAME)
if os.path.exists(dev_env_path) and os.path.isdir(dev_env_path):
    print "Existing development environment {0}/ found in {1}. Please save your work, and run the script again.".format(DEV_ENV_DIRNAME, sys.argv[1])
    exit()

# checks ok - begin module collection process
#os.mkdir(dev_env_path)

modules = set([get_dependent_module_names(module) for module in os.listdir(dev_env_path) if module.endswith(".v")])

print "=== Detected dependent modules ==="
print "\n".join(modules)

missing = check_for_missing_modules(modules)
if missing:
    print "ERROR: You have missing modules, listed below. please resolve them, and rerun the script."
    print "=== Missing Modules ==="
    print "\n".join(missing)
    #shutil.rmtree(dev_env_path)
    exit()

# copy all files into development environment
# copy_dependent_modules(modules, dev_env_path)
