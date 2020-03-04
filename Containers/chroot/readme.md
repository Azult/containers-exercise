Setup:
1. container is chroot to /rootfs

Problem:
1. no chdir. pwd is outside the chrooted path.

Escape:
1. chroot with path traversal - chroot ../../../../../..

Fix:
1. chdir to anywhere in the chrooted path. 
   for example, chdir / after chroot, or chdir /rootfs before chroot
