PROJECT := si

CC := gcc
CFLAGS := -std=c++20 -fmodules-ts -march=native
CFLAGS += -Wall -Wextra -Wconversion -Wpedantic
CFLAGS += -MMD -MP
LDFLAGS :=

STRIP := strip

ifeq ($(MAKECMDGOALS), release)
MODE := release
CFLAGS += -O2
CFLAGS += -DNDEBUG
else
MODE := debug
CFLAGS += -Og -ggdb
CFLAGS += -DDEBUG
CFLAGS += -fsanitize=address,undefined -fno-omit-frame-pointer
LDFLAGS += -fsanitize=address,undefined
endif

BUILD_DIR := build/$(MODE)

SRCS := $(wildcard src/*.cpp)
OBJS := $(SRCS:src/%.cpp:$(BUILD_DIR)/%.o)
DEPS := $(OBJS:.o=.d)

all: debug

debug: $(BUILD_DIR)/$(PROJECT)

release: $(BUILD_DIR)/$(PROJECT)

$(BUILD_DIR)/%.o: src/%.cpp
	@mkdir -p $(dir $@)
	$(CC) -c $< -o $@ $(CFLAGS)

$(BUILD_DIR)/$(PROJECT): $(OBJS)
	@mkdir -p $(dir $@)
	$(CC) -o $@ $^ $(LDFLAGS)
ifeq ($(MODE),release)
	$(STRIP) -s $@
endif

clean:
	rm -rf build

.SUFFIXES:

.PHONY: all debug release clean

-include $(DEPS)
