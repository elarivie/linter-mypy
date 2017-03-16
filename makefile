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
NPM=npm
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

all: BUILDME

BUILDME:
	${srcdir}/BUILDME

lint: npmInstall
	#${srcdir}/BUILDME
	${srcdir}/node_modules/npm-check-updates/bin/ncu
	${srcdir}/node_modules/coffeelint/bin/coffeelint lib/ spec/

AUTHORS:
	cd ${srcdir}
	${ECHO} "Authors\n=======\nWe'd like to thank the following people for their contributions.\n\n" > ${srcdir}/AUTHORS.md
	${GIT} log --raw | ${GREP} "^Author: " | ${SORT} | ${UNIQ} | ${GREP} -v "@users.noreply.github.com" | ${CUT} -d ' ' -f2- | ${SED} 's/^/- /' >> ${srcdir}/AUTHORS.md
	${GIT} add AUTHORS.md

HEARTBEAT:
	cd ${srcdir}
	${DATE} --utc +%Y-%m > ${srcdir}/HEARTBEAT
	${GIT} add HEARTBEAT

gitcommit: AUTHORS HEARTBEAT
	cd ${srcdir}
	- ${GIT} commit

atomPublishMajor: gitcommit
	${APM} publish major
atomPublishMinor: gitcommit
	${APM} publish minor
atomPublishPatch: gitcommit
	${APM} publish patch
atomPublishBuild: gitcommit
	${APM} publish build

npmInstall:
	${NPM} install
	${NPM} update

develop:
	${APM} develop ${THENAME}
	${ATOM} -d ~/.atom/dev/packages/${THENAME}

.PHONY: all BUILDME HEARTBEAT AUTHORS develop gitcommit lint npmInstall atomPublishMajor atomPublishMinor atomPublishPatch atomPublishBuild
