#!/usr/bin/python2

# making writing all those muxes by hand is too tedious. let's make it better.

# modify the following values to suit your purpose
data_type = "mux2_1"
name_base = "m"
num_modules = 64
start_value = 0

# tuple format: (<connection name>, <wire>, <class>, <width>)
# class can be: "bus", "raw"
# if "raw", can be: 0, 1

print """--------------------------------------------------------------------------------
Welcome to the Verilog Mass Module Instantiation Script (VEMMIS)!
Hopefully this saves you buttloads of time....
Instructions: follow the prompts.
--------------------------------------------------------------------------------
"""
initial_inputs_ok = False

while not initial_inputs_ok:
    data_type = None
    name_base = None
    num_modules = None

    while not data_type:
        data_type = raw_input("What class of module are you instantiating? ").strip() 

    while not name_base:
        name_base = raw_input("What do you want as the base module name? For example if you want m0, m1, etc., you would provide m. ").strip()

    while not num_modules or not num_modules.isdigit():
        num_modules = raw_input("How many of these do you want to create? ")

    num_modules = int(num_modules)
       
    start_value = raw_input("Enter starting module number (default 0): ")
    start_value = int(start_value) if start_value.isdigit() else 0

    print "Cool! Here's what we've got so far:\n"
    print "%s %s%d(...)" % (data_type, name_base, start_value)
    print "- to -"
    print "%s %s%d(...)\n" % (data_type, name_base, (start_value + num_modules) - 1)

    initial_inputs_ok = not bool(raw_input("Press enter if it looks good, otherwise enter anything else to retry: "))

print """-------------------------------------------------------------------------------
Excellent! Next up: the parameters.
!!! IMPORTANT: You MUST use port mapping. !!!
"""

structure_ok = False

while not structure_ok:
    module = { "datatype":data_type,
               "namebase":name_base,
               "startvalue":start_value,
               "nummodules":num_modules }

    module_params = []

    num_params = None
    while not num_params or not num_params.isdigit():
        num_params = raw_input("How many ports does this module have? ")

    for i in range(int(num_params)):
        param = {}
        print "\nNow up: port %d" % i
        
        port_name = None
        port_type = None
        port_width = None

        while not port_name:
            port_name = raw_input("\tWhat's the name of the port? ").strip()

        while not port_type or (port_type not in ('s', 'b')):
            port_type = raw_input("\tSingle pin (s) or bus(b)? ").strip().lower()

        if port_type == 'b':
            valid_port_width = False
            while not valid_port_width:
                port_width = raw_input("\tHow wide is the bus (# bits)? ")

                if not port_width.isdigit():
                    print "\tNot a valid integer.\n"
                    continue

                port_width = int(port_width)

                if port_width <= 0:
                    print "\tInvalid bus width - must be larger than 0!\n"
                    continue

                if port_width == 1:
                    port_type = 's'

                valid_port_width = True
        else:
            port_width = 1 # single wire has width 1

        param["portname"] = port_name
        param["porttype"] = port_type
        param["portwidth"] = port_width
        
        module_params.append(param)

    print "\n--------------------------------------------------------------------------------\n"
    print "Here's what the structure looks like:\n"
    print "%s %s%d(" % (module["datatype"], module["namebase"], module["startvalue"])
    whitespace = 2 + len(module["datatype"]) + len(module["namebase"]) + len(str(module["startvalue"]))
    whitespace += 4 - (whitespace % 4)
    ws = ""
    for i in range(whitespace):
        ws = "%s%s" % (ws, " ")

    for p in module_params:
        line = "%s.%s(...)" % (ws, p["portname"])
        print line
    print ");\n"

    structure_ok = not bool(raw_input("Press enter if all looks good, otherwise input any value to redo it: "))

print "\n--------------------------------------------------------------------------------\n"
print "Module structure declared. Let's wire it up!\n"
