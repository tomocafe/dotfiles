set auto-load safe-path /
set unwindonsignal off

set confirm off
set verbose off
set pagination off

# el6 compatibility:
# Enable colors after upgrading cgdb to v0.7.0
# Long term waiting for gdb-dashboard, but requires gdb 7.1+ with Python 2.7 compiled in

#set prompt \033[34m(gdb) \033[0m

python
import time
ts = time.asctime(time.localtime(time.time()))
#print ("\033[91m" + "Loaded .gdbinit at " + ts + "\033[0m" + "\n")
print ("Loaded .gdbinit at " + ts + "\n")

