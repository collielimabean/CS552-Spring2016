# making writing all those muxes by hand is too tedious. let's make it better.

# modify the following values to suit your purpose
data_type = "mux2_1"
name_base = "m"
num_modules = 64
start_value = 0

# tuple format: (<connection name>, <wire>, <class>, <width>)
# class can be: "bus", "raw"
# if "raw", can be: 0, 1

print "\n--------------------------------------------------------------------------------\n"
print "Welcome to the VErilog Mass Module Instantiation Script (VEMMIS)!\nHopefully this saves you buttloads of time....\n"
print "Instructions: follow the prompts.\n\n--------------------------------------------------------------------------------\n"

# The loops work.

while 1:
    while 1:
        while 1:
            data_type = raw_input("What class of module are you instantiating? ").strip()
            if data_type is not '':
                break
        
        while 1:
            name_base = raw_input("What do you want as the base module name (m0, m1, etc., but you provide m)? ").strip()
            if name_base is not '':
                break

        while 1:
            num_modules = raw_input("How many of these do you want to create? ")
            if num_modules is not '' and num_modules.isdigit():
                num_modules = int(num_modules)
                break

        val = raw_input("Press enter to start counting at 0, or enter a start number: ")
        if val is '':
            start_value = 0
        else:
            start_value = int(val)

        print "Cool! Here's what we've got so far:\n"
        print "%s %s%d(...)" % (data_type, name_base, start_value)
        print "- to -"
        print "%s %s%d(...)" % (data_type, name_base, (start_value + num_modules) - 1)
        val = raw_input("\nPress enter if it looks good, otherwise enter anything else to retry: ")
        if val is '':
            break
    
    module = { \
                "datatype":data_type, \
                "namebase":name_base, \
                "startvalue":start_value, \
                "nummodules":num_modules}
    module_params = []
    
    print "\n--------------------------------------------------------------------------------\n"
    print "Excellent! Next up: the parameters.\n"
    print "!!! IMPORTANT: You MUST use port mapping. !!!\n"
    
    while 1:
        val = raw_input("How many ports does this module have? ")
        if val is not '' and val.isdigit():
            num_params = int(val)
            break

    while 1:
        for i in range(num_params):
            param = {}
            print "\nNow up: port %d" % i
             
            while 1:
                val = raw_input("    What's the name of the port? ")
                if val is not '':
                    param["portname"] = val
                    break
              
            while 1:
                val = raw_input("    Single pin (s) or bus(b)? ")
                if val is not '' and (val is 's' or val is 'b'):
                    param["porttype"] = val
                    break

            if param["porttype"] is 'b':
                while 1:
                    val = raw_input("    How wide is the bus (# bits)? ")
                    if val is not '' and val.isdigit():
                        port_width = val
                        break
            else:
                port_width = 1

            param["portwidth"] = port_width
            
            '''
            while 1:
                val = raw_input("    What wire(s) would you like to hook up to this port? ")
                if val is not '':
                    param["portwires"] = val
                    break
            
            print "    Here's what it looks like:\n    .%s(%s)" % (param["portname"], param["portwires"])
            val = raw_input("    Press enter if all looks good, otherwise input any value to redo it: ")
            if val is '':
                module_params.append(param)
                break
            '''
    
            module_params.append(param)

        print "\n--------------------------------------------------------------------------------\n"
        print "Here's what the structure looks like:\n"
        print "%s %s%d(" % (module["datatype"], module["namebase"], module["startvalue"])
        whitespace = 2 + len(module["datatype"]) + len(module["namebase"]) + len(str(module["startvalue"]))
        whitespace = whitespace + 4 - (whitespace % 4)
        ws = ""
        for i in range(whitespace):
            ws = "%s%s" % (ws, " ")

        for p in module_params:
            line = "%s.%s(...)" % (ws, p["portname"])
            print line
        print ");\n"
        val = raw_input("Press enter if all looks good, otherwise input any value to redo it: ")
        if val is '':
            break

    print "\n--------------------------------------------------------------------------------\n"
    print "Module structure declared. Let's wire it up!\n"
    break
