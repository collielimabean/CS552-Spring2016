#!/usr/bin/python

"""
    envsetup.py is intended to create a testing environment for verilog in CS552.
    It will look for and pull in any dependent modules in the common/ folder.
    Run as ./envsetup.py <dir> 
"""

import os
import re
import sys
import shutil

#### Constants ####
DEV_ENV_DIRNAME = 'env'
COMMON_MODULE_PATH = '../common/'
VERILOG_KEYWORDS = (
    "assign", "module", "endmodule", "input", "output",
    "wire", "`define", "parameter", "case", "casex", "reg",
    "always", "begin", "end", "attribute", "buf", "bufif0", "default",
    "bufif1", "casez", "cmos", "deassign", "disable", "edge", "endcase",
    "else", "endattribute", "endfunction", "endprimitive", "endspecify",
    "endtable", "endtask", "event", "for", "forever", "fork", "function",
    "highz0", "highz1", "if", "ifnone", "initial", "inout", "integer",
    "join", "medium", "large", "macromodule", "negdge", "nmos", "notif0",
    "notif1", "pmos", "posedge", "primitive", "pull0", "pull1", "pulldown",
    "pullup", "rcmos", "real", "realtime", "release", "repeat", "rnmos",
    "rpmos", "rtran", "rtranif0", "rtranif1", "scalared", "signed", "small",
    "specify", "specparam", "strength", "strong0", "strong1", "supply0",
    "supply1", "table", "task", "time", "table", "tranif0", "tranif1", "tri",
    "tri0", "tri1", "triand", "trior", "trireg", "unsigned", "vectored",
    "wait", "wand", "weak0", "weak1", "while", "wor"
)

OPERATORS = ('=', '<', '>', '!=', '+', '-', '*', '/')

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
        # get rid of empty lines and indentation
        raw_file_text = '\n'.join([l.strip() for l in f.readlines() if l.strip()])

        # stripping comments
        raw_file_text = re.sub("(?s)\/\*(.*?)\*\/", "", raw_file_text, re.M)
        raw_file_text = re.sub("(\s*)\/\/(.*)", "", raw_file_text)

        # toss out strings
        raw_file_text = re.sub("(\s*)\"(.*)\"", "", raw_file_text)

        # breaking into statements
        stmts = [l.strip() for l in raw_file_text.split(';')]

        def get_module_name(token):
            return token[:token.index('(')] if '(' in token else token

        for stmt in stmts:
            tokens = stmt.split()
            if len(tokens) < 2:
                continue
            
            # append top level module name 
            if tokens[0] == 'module':
                dependent.append(get_module_name(tokens[1]))
                continue

            # jank separator for instantiated modules - feel free to add more exceptions
            elif tokens[0] not in VERILOG_KEYWORDS and 'always' not in tokens[0] and \
                     all(op not in tokens[1] for op in OPERATORS) and \
                     not '#' in tokens[0] and \
                     tokens[0][0] not in ('@$0123456789'):
                dependent.append(tokens[0])

        return dependent


def check_for_missing_modules(module_set, user_dir):
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
    missing = []
    for module in module_set:
        common_file = os.path.join(COMMON_MODULE_PATH, module + '.v')
        user_file = os.path.join(user_dir, module + '.v')
        if not os.path.exists(common_file) and not os.path.exists(user_file):
            missing.append(module)
    return missing


def copy_dependent_modules(module_set, user_dir, dest_dir):
    for module in module_set:
        common_file = os.path.join(COMMON_MODULE_PATH, module + '.v')
        user_file = os.path.join(user_dir, module + '.v')
        if os.path.exists(common_file):
            shutil.copy2(common_file, dest_dir)
        else:  
            shutil.copy2(user_file, dest_dir)

#### Main ####
# sanity checks
if len(sys.argv) != 2:
    print "usage: ./envsetup.py <directory to setup>"
    exit()

user_dir = sys.argv[1]

if not os.path.isdir(user_dir):
    print "Could not find {0}".format(user_dir)
    exit()

dev_env_path = os.path.join(user_dir, DEV_ENV_DIRNAME)

if os.path.exists(dev_env_path) and os.path.isdir(dev_env_path):
    print "Existing development environment {0}/ found in {1}. Please save your work, and run the script again.".format(DEV_ENV_DIRNAME, user_dir)
    exit()

# checks ok - begin module collection process
os.mkdir(dev_env_path)

# first pass - get user dependent modules
unflattened_module_list = [get_dependent_module_names(os.path.join(user_dir, module)) for module in os.listdir(user_dir) if module.endswith(".v")]
modules = set([module for sublist in unflattened_module_list for module in sublist])

# second pass - pull common module dependencies
unflattened_module_list = [get_dependent_module_names(os.path.join(COMMON_MODULE_PATH, module + '.v')) for module in modules if not os.path.exists(os.path.join(user_dir, module + '.v'))]
additional_common_modules = set([module for sublist in unflattened_module_list for module in sublist])

modules |= additional_common_modules
 
print "=== Detected dependent modules ==="
print "\n".join(modules)

missing = check_for_missing_modules(modules, user_dir)
if missing:
    print "ERROR: You have missing modules that were not found in %s or %s, listed below. please resolve them, and rerun the script." % (user_dir, COMMON_MODULE_PATH)
    print "=== Missing Modules ==="
    print "\n".join(missing)
    shutil.rmtree(dev_env_path)
    exit()

# copy all files into development environment
copy_dependent_modules(modules, user_dir, dev_env_path)
print "Done!"
