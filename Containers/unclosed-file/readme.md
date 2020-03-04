Setup:
1. container is chroot to /rootfs

Problem:
1. /etc/shadow is opened.

Escape:
1. cat <&3

Fix:
1. add FD_CLOEXEC flag when open files.
