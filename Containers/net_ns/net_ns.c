#ifndef USERID
  #define USERID 1000
#endif
#define _GNU_SOURCE
#define _DEFAULT_SOURCE
#include <sys/wait.h>
#include <sys/utsname.h>
#include <sched.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>

#define errExit(msg)    do { perror(msg); exit(EXIT_FAILURE); } while (0)

static int child() {
    chdir("/rootfs/home/netns");
    mount("proc", "/rootfs/proc", "proc", NULL, NULL);
    chroot("/rootfs");
    setreuid(USERID,USERID);
    execve("/bin/bash", 0, 0);
}

int main(int argc, char **argv) {

    printf("\n\n\033[1;31mnet namespace\n\n\n\n");
    printf("\tUser found with uid %d, spawning shell...\n",getuid());
    printf("\tCould you find the flag?\n\n\n\n\033[0m\n");

    long stack_size = sysconf(_SC_PAGESIZE);
    void *stack;
    pid_t pid;
    int flags = SIGCHLD | CLONE_NEWPID | CLONE_NEWIPC | CLONE_NEWNS | CLONE_FILES;

    /* Allocate stack for child */
    stack = alloca(stack_size) + stack_size;
    if (stack == NULL)
        errExit("alloca");

    /* Call clone for child */
    pid = clone(child, stack, flags, 0);
    if (pid == -1)
        errExit("clone");

    if (waitpid(pid, NULL, 0) == -1)  /* Wait for child to exit */
        errExit("waitpid");
    else{
	umount("/rootfs/proc");
    }


}
