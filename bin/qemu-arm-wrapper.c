/* Source: http://www.gentoo.org/proj/en/base/embedded/handbook/?part=1&chap=5 */

#include <string.h>
#include <unistd.h>

int main(int argc, char **argv, char **envp) {
	char *newargv[argc + 5];

	newargv[0] = argv[0];
	newargv[1] = "-cpu";
	newargv[2] = "arm1176";
	newargv[3] = "-r";
	newargv[4] = "3.6.11+";

	memcpy(&newargv[5], &argv[1], sizeof(*argv) * (argc - 1));
	newargv[argc + 4] = NULL;
	return execve("/usr/bin/qemu-arm-static", newargv, envp);
}
