# vim:ft=python
python

import sys
import os
import psutil
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

# Common settings
gdb.execute('set auto-load safe-path /')
gdb.execute('set unwindonsignal on')
gdb.execute('set verbose off')

standalone, caller = is_standalone()
if standalone:
    gdb_version_info = get_gdb_version()
    # Load gdb-dashboard if available and system supports it (gdb 7.7+ with Python 2.7+)
    if ((gdb_version_info[0] > 7 or (gdb_version_info[0] == 7 and gdb_version_info[1] >= 7))
    and (sys.version_info[0] > 2 or (sys.version_info[0] == 2 and sys.version_info[1] >= 7))
    and os.path.exists(os.path.expanduser('~/.gdb-dashboard/gdb_dashboard.py'))):
        sys.path.append(os.path.expanduser('~/.gdb-dashboard'))
        import gdb_dashboard
    # Standalone session without dashboard
    else:
        # Colorize prompt
        gdb.execute('set prompt \033[34m(gdb) \033[0m')
else:
    # Non-standalone call
    gdb.execute('set confirm off')
    gdb.execute('set pagination off')
    gdb.execute('set prompt ({name}) '.format(name=caller))

