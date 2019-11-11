#!/bin/ksh
set -e

# Patches can't be applied while reorder_kernel is running. This check is the same as the one
# used by syspatch(8): https://github.com/openbsd/src/blob/master/usr.sbin/syspatch/syspatch.sh#L275
while pgrep -qxf '/bin/ksh .*reorder_kernel'; do sleep 1; done

syspatch

echo "${DESIRED_SYSPATCH_SET}" | tr '[:space:]' '\n' | sed '/^$/d' | sort > /tmp/p.desired
syspatch -l | sort > /tmp/p.installed

if ! diff -u -L 'Desired patches' -L 'Installed patches' /tmp/p.desired /tmp/p.installed >&2; then
  echo 'Set of installed patches differs from the set of desired patches!' >&2
  exit 1
fi

rm /tmp/p.*
