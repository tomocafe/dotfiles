# vim:ft=python
python

import sys
import os
import re

def is_standalone():
    procs = [p.name() for p in [psutil.Process()] + psutil.Process().parents()]
    if 'cgdb' in procs:
        return (False, 'cgdb')
    if 'gdbtui' in procs:
        return (False, 'tui')
    return (True, '')

def get_gdb_version():
    version_string = gdb.execute('show version', False, True).splitlines()[0]
    match = re.search('([0-9]+)\.([0-9]+)', version_string)
    return (match.group(1), match.group(2))

# Site-specific initialization
import glob
for script in glob.glob(os.path.expanduser('~/.gdbinit.d/*')):
    gdb.execute('source ' + script)

try:
    import psutil
    standalone, caller = is_standalone()
    if standalone:
        gdb_version_info = get_gdb_version()
        # Load gdb-dashboard if available and system supports it (gdb 7.7+ with Python 2.7+)
        if ((gdb_version_info[0] > 7 or (gdb_version_info[0] == 7 and gdb_version_info[1] >= 7))
        and (sys.version_info[0] > 2 or (sys.version_info[0] == 2 and sys.version_info[1] >= 7))
        and os.path.exists(os.path.expanduser('~/.gdb-dashboard'))):
            gdb.execute('source ~/.gdb-dashboard')
        # Standalone session without dashboard
        else:
            # Colorize prompt
            gdb.execute('set prompt \033[34m(gdb) \033[0m')
    else:
        # Non-standalone call
        gdb.execute('set confirm off')
        gdb.execute('set pagination off')
        gdb.execute('set prompt ({name}) '.format(name=caller))
except:
    print('Missing psutil package in Python interpreter {interp}'.format(interp=sys.executable))
    print('Unable to detect if this is standalone gdb')

