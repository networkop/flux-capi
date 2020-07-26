BIN := $(shell basename $$PWD)


include .mk/kind.mk
include .mk/capi.mk
include .mk/help.mk

