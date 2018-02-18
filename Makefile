TARGET = c-ray
TARGETPROFILE = c-ray-prof
CC = gcc

ifdef USESDL2
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		FRAMEWORKS = -lSDL2
	else
		FRAMEWORKS = -I/usr/local/include -L/usr/local/lib -lSDL2
	endif

	ifeq ($(usesdl),no)
		FRAMEWORKS = -I/usr/local/include
	endif
endif

CFLAGS = -O2 -std=c99 -Wall -D_DEFAULT_SOURCE
CPROFILE= -pg --no-pie -fPIC
ifdef DEBUG
	CFLAGS += -g
endif
LINKER = gcc -o
LFLAGS = -I. -lm -pthread $(FRAMEWORKS)
LPROFILE= -pg

ifdef LTTNG_SIMPLE
	CFLAGS += -DLTTNG -DLTTNG_SIMPLE
	LFLAGS += -llttng-ust -ldl
endif

ifdef LTTNG_MYTRACE
	CFLAGS += -Isrc -DLTTNG -DLTTNG_MYTRACE
	LFLAGS += -llttng-ust -ldl
endif

FRAMEWORK_PATH = /Library/Frameworks

SRCDIR = src
OBJDIR = obj
BINDIR = bin

SOURCES := $(wildcard $(SRCDIR)/*.c)
INCLUDES := $(wildcard $(SRCDIR)/*.h)
OBJECTS := $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
OBJECTSPROFILE := $(SOURCES:$(SRCDIR)/%.c=$(OBJDIR)/%_p.o)
rm = rm -f

$(BINDIR)/$(TARGET): $(OBJECTS)
	@$(LINKER) $@ $(LFLAGS) $(OBJECTS) $(FRAMEWORKS)
	@echo "Linking complete..."

$(OBJECTS): $(OBJDIR)/%.o : $(SRCDIR)/%.c
	@$(CC) $(CFLAGS) -c $< -o $@ $(FRAMEWORKS)
	@echo "Compiled "$<" successfully"

profile: $(BINDIR)/$(TARGETPROFILE)

$(BINDIR)/$(TARGETPROFILE): $(OBJECTSPROFILE)
	@$(LINKER) $@ $(LFLAGS) $(LPROFILE) $(OBJECTSPROFILE) $(FRAMEWORKS)
	@echo "Linking profiled complete..."

$(OBJECTSPROFILE): $(OBJDIR)/%_p.o : $(SRCDIR)/%.c
	@$(CC) $(CFLAGS) $(CPROFILE) -c $< -o $@ $(FRAMEWORKS)
	@echo "Compiled profiled "$<" successfully"

.PHONY: clean
clean:
	@$(rm) $(OBJECTS) $(OBJECTSPROFILE)
	@echo "Cleanup done"

.PHONY: remove
remove: clean
	@$(rm) $(BINDIR)/$(TARGET) $(BINDIR)/$(TARGETPROFILE)
	@echo "Binary removed"
