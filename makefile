#!/usr/bin/make -f -r

# This MakeFile provides development shortcut to frequent tasks.

CUT=cut
SHELL=/bin/sh
GIT=git
GREP=grep
DATE=date
ECHO=echo
MKDIR=mkdir
TOUCH=touch
RM=rm
RM_RF=${RM} -rf
SED=sed
SORT=sort
TAR=tar
UNIQ=uniq
srcdir=.
tmpdir=
outdir=${srcdir}/out

THENAME :=`cat "${srcdir}/NAME"`
THEVERSION :=`cat "${srcdir}/VERSION"`

all:
	${srcdir}/BUILDME

AUTHORS:
	${ECHO} "Authors\n=======\nWe'd like to thank the following people for their contributions.\n\n" > ${srcdir}/AUTHORS
	${GIT} log --raw | ${GREP} "^Author: " | ${SORT} | ${UNIQ} | ${CUT} -d ' ' -f2- | ${SED} 's/^/- /' >> ${srcdir}/AUTHORS

HEARTBEAT:
	${DATE} --utc +%Y-%m > ${srcdir}/HEARTBEAT

.PHONY: all HEARTBEAT AUTHORS
