/**
 * D header file for GNU/Linux.
 *
 * Copyright: Copyright Robert Klotzner 2012.
 * License:   $(LINK2 http://www.boost.org/LICENSE_1_0.txt, Boost License 1.0)
 * Authors:   Robert Klotzner
 */
module core.sys.linux.sys.xattr;

import core.sys.posix.sys.types;

version (linux):

extern (C):
@system:
nothrow:

enum {
	XATTR_CREATE=1, /* set value, fail if attr already exists.  */
	XATTR_REPLACE=2 /* set value, fail if attr does not exist.  */
}

int setxattr(in char* path, in char* name, in void* value, size_t size, int flags);

int lsetxattr(in char* path, in char* name, in void* value, size_t size, int flags);
int fsetxattr(int fd, in char* name, in void* value, size_t size, int flags);
ssize_t getxattr(in char* path, in char* name, void* value, size_t size);
ssize_t lgetxattr(in char* path, in char* name, void* value, size_t size);
ssize_t fgetxattr(int fd, in char* name, void* value, size_t size);
ssize_t listxattr(in char* path, char* list, size_t size);
ssize_t llistxattr(in char* path, char* list, size_t size);
ssize_t flistxattr (int __fd, char *list, size_t size);
int removexattr (in char *path, in char *name);
int lremovexattr (in char *path, in char *name);
int fremovexattr (int fd, in char *name);

