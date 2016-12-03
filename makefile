#!/usr/bin/make -f -r

# This MakeFile provides development shortcut to frequent tasks.

SHELL=/bin/sh

APM=apm
ATOM=atom
CUT=cut
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

THENAME :=`cat "${srcdir}/NAME"`
THEVERSION :=`cat "${srcdir}/VERSION"`

all:
	${srcdir}/BUILDME

AUTHORS:
	cd ${srcdir}
	${ECHO} "Authors\n=======\nWe'd like to thank the following people for their contributions.\n\n" > ${srcdir}/AUTHORS
	${GIT} log --raw | ${GREP} "^Author: " | ${SORT} | ${UNIQ} | ${CUT} -d ' ' -f2- | ${SED} 's/^/- /' >> ${srcdir}/AUTHORS
	${GIT} add AUTHORS

HEARTBEAT:
	cd ${srcdir}
	${DATE} --utc +%Y-%m > ${srcdir}/HEARTBEAT
	${GIT} add HEARTBEAT

gitcommit:
	cd ${srcdir}
	${GIT} commit

atomPublishMajor: AUTHORS HEARTBEAT gitcommit
	${APM} publish major
atomPublishMinor: AUTHORS HEARTBEAT gitcommit
	${APM} publish minor
atomPublishPatch: AUTHORS HEARTBEAT gitcommit
	${APM} publish patch
atomPublishBuild: AUTHORS HEARTBEAT gitcommit
	${APM} publish build

develop:
	${APM} develop ${THENAME}
	${ATOM} -d ~/.atom/dev/packages/${THENAME}

.PHONY: all HEARTBEAT AUTHORS develop gitcommit atomPublishMajor atomPublishMinor atomPublishPatch atomPublishBuild

