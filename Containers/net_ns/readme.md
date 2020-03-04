Setup:
1. container is chroot to /rootfs

Problem:
1. Redis service is running anonymously on localhost.

Escape:
1. Read the 'flag' entry in the Redis running on localhost port 6379

Fix:
1. add CLONE_NEWNET flag to the flags passed to the 'clone' function.
