#!  /bin/bash

set +e

if [ -z "$_USER" -o -z "$_UID" -o -z "$_GID" ]
then
	echo "$0:Error : You must define all the following environment variables : _USER _UID and _GID" 1>&2
	exit 1
fi

if [ -z "$WORKSPACE" -o ! -d "$WORKSPACE" ]
then
	echo "$0:Error : You must define the WORKSPACE environment variable corrresponding to your mount point" 1>&2
	exit 2
fi

groupadd -f -g $_GID $_USER
useradd -d / --uid $_UID --gid $_GID --shell /bin/bash $_USER
$*
RETURN_CODE=$?
chown --silent -R $_USER:$_USER $WORKSPACE
exit $RETURN_CODE
