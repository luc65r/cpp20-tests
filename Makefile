PROJECT := si

CXX := g++
CXXFLAGS := -std=c++20 -march=native
CXXFLAGS += -fmodules-ts
CXXFLAGS += -Wall -Wextra -Wconversion -Wpedantic
LDFLAGS :=

STRIP := strip

ifeq ($(MAKECMDGOALS), release)
MODE := release
CXXFLAGS += -O2
CXXFLAGS += -DNDEBUG
else
MODE := debug
CXXFLAGS += -Og -ggdb
CXXFLAGS += -DDEBUG
CXXFLAGS += -fsanitize=address,undefined -fno-omit-frame-pointer
LDFLAGS += -fsanitize=address,undefined
endif

BUILD_DIR := build/$(MODE)

SRCS := src/si.cxx src/main.cxx #$(wildcard src/*.cxx)
OBJS := $(patsubst src/%.cxx, $(BUILD_DIR)/%.o, $(SRCS))
DEPS := $(OBJS:.o=.d)

REQUIRED_HEADERS := iostream
MODULES := si

all: debug

debug: $(BUILD_DIR)/$(PROJECT)

release: $(BUILD_DIR)/$(PROJECT)

$(BUILD_DIR)/%.o: src/%.cxx | sysgcm
	@mkdir -p $(dir $@)
	$(CXX) -c $< -o $@ $(CXXFLAGS)
	@perl -pi -e 's,(/.+?/include/c\+\+/[^/]+/[^.]+)\.c\+\+m,gcm.cache\1.gcm,' $(@:.o=.d)

$(BUILD_DIR)/$(PROJECT): $(OBJS)
	@mkdir -p $(dir $@)
	$(CXX) -o $@ $^ $(LDFLAGS)
ifeq ($(MODE),release)
	$(STRIP) -s $@
endif

sysgcm: build/sysgcm
build/sysgcm:
	$(CXX) -std=c++20 -fmodules-ts -c -x c++-system-header $(REQUIRED_HEADERS)
	@mkdir build; touch build/sysgcm

clean:
	rm -rf build gcm.cache

.SUFFIXES:

.PHONY: all debug release clean sysgcm

-include $(DEPS)
