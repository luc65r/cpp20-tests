cxx.std = experimental
cxx.features.modules = true

using cxx

cxx.coptions += -Og -march=native -ggdb
cxx.coptions += -Wall -Wextra -Wconversion -Wpedantic
cxx.loptions += -flto=auto

mxx{src/*}: extension = mxx
cxx{src/*}: extension = cxx

exe{build/si}: {cxx mxx}{src/*}