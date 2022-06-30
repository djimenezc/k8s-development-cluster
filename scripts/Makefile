SELF_DIR_SCRIPTS := $(dir $(lastword $(MAKEFILE_LIST)))
REMOTE_HOST ?= localhost
REMOTE_PORT ?= 443
LOCAL_PORT ?= 57007
JUMPER_MACHINE_ID ?= david_security_scanner

scripts-tunnel-security-scanner-machine:
	${SELF_DIR_SCRIPTS}aws-tunnel.sh $(REMOTE_HOST) $(REMOTE_PORT) $(LOCAL_PORT) $(JUMPER_MACHINE_ID)

scripts-tunnel-security-scanner-machine-kill:
	kill -9 $(shell lsof -t -i:${LOCAL_PORT})