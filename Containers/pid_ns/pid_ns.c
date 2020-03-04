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
  chdir("/rootfs");
  chroot("/rootfs");
  mount("proc", "/proc", "proc", 0, 0);
  // setreuid(USERID,USERID);
  printf("\n\n\033[1;31mpid_ns\n\n\n\n");
  printf("\tclone syscall invoked with CLONE_NEWUTS and CLONE_NEWNS flags\n");
  printf("\tUser found with uid %d, spawning shell...\n",getuid());
  printf("\tCan you change the UTS and mount namespaces back to initial namespaces?\n\n\n\n\033[0m\n");

  execve("~/bash_sys_admin -p", 0,0);
}

int main(int argc, char **argv, char **envp) {

    long st_size = sysconf(_SC_PAGESIZE);
    void *st = malloc(st_size) + st_size;
    int flags = SIGCHLD | CLONE_NEWUTS | CLONE_NEWNS;


    pid_t pid = clone(child_code, st, flags, 0);

    if (pid == -1)
      errExit("clone");

    if (waitpid(pid, NULL, 0) == -1 )
        errExit("waitpid");

    umount("/rootfs/proc");
}

