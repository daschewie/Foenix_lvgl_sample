#
# Makefile
#
CC = cc65816
LN = ln65816
FOENIX_DIR_NAME = Calypsi-65816-Foenix
FOENIX_MODEL = FMX
MEMORY_MODEL = --code-model=large --data-model=small
LIB_MODEL = lc-sd
FOENIX_LIB = $(FOENIX_DIR_NAME)/Foenix-$(LIB_MODEL).a
FOENIX_LINKER_RULES = $(FOENIX_DIR_NAME)/linker-files/Foenix-$(FOENIX_MODEL).scm


LVGL_DIR_NAME = lvgl
LVGL_DIR = ${shell pwd}
CFLAGS = -I$(LVGL_DIR)/ 
LDFLAGS = -lm
BIN = demo.pgz


#Collect the files to compile
MAINSRC = ./app/main.c

include $(LVGL_DIR)/lvgl/lvgl.mk
#include $(LVGL_DIR)/lv_drivers/lv_drivers.mk
#include $(LVGL_DIR)/lv_demos/lv_demo.mk

OBJEXT ?= .o

AOBJS = $(ASRCS:.S=$(OBJEXT))
COBJS = $(CSRCS:.c=$(OBJEXT))

MAINOBJ = $(MAINSRC:.c=$(OBJEXT))

SRCS = $(ASRCS) $(CSRCS) $(MAINSRC)
OBJS = $(AOBJS) $(COBJS)

## MAINOBJ -> OBJFILES

all: default

%.o: %.c
	@$(CC) $(MEMORY_MODEL) $(CFLAGS) -c $< -o $@
	@echo "CC $<"
    
default: $(AOBJS) $(COBJS) $(MAINOBJ) $(FOENIX_LIB)
	$(LN) -o $(BIN) $(MAINOBJ) $(AOBJS) $(COBJS) $(FOENIX_LINKER_RULES) clib-$(LIB_MODEL)-Foenix.a --output-format=pgz --rtattr printf=reduced --rtattr cstartup=Foenix --semi-hosted

$(FOENIX_LIB):
	(cd $(FOENIX_DIR_NAME) ; make all)

clean: 
	rm -f $(BIN) $(AOBJS) $(COBJS) $(MAINOBJ)
	(cd $(FOENIX_DIR_NAME) ; make clean)

