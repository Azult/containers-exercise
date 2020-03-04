#ifndef USERID
  #define USERID 1000
#endif
#define _DEFAULT_SOURCE
#define _GNU_SOURCE
#include <sys/wait.h>
#include <sys/utsname.h>
#include <sched.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mount.h>


#define errExit(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)

static int child_code(){
  int groups[2] = {USERID, 27};
  chdir("/home/");
  setgroups(2, groups);
  chroot("/rootfs");
  setregid(USERID,USERID);
  setreuid(USERID,USERID);
  printf("\n\n\033[1;31mchroot\n\n\n\n");
  printf("\tRoot folder set to /rootfs\n");
  printf("\tUser found with uid %d, spawning shell...\n",getuid());
  printf("\tCan you change the root folder back to / ?\n\n\n\n\033[0m\n");
  execve("/bin/bash", 0,0);
}

int main(int argc, char **argv, char **envp) {

    long st_size = sysconf(_SC_PAGESIZE);
    void *st = malloc(st_size) + st_size;
    int flags = SIGCHLD;

    

    pid_t pid = clone(child_code, st, flags, 0);

    if (pid == -1)
      errExit("clone");

    if (waitpid(pid, NULL, 0) == -1 )
        errExit("waitpid");
}

