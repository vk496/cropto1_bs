CC = gcc
CXX = g++
LD = g++

#CFLAGS=-std=c11 -Wall -g -g3 -DDEBUG_REDUCTION
CFLAGS=-std=c11 -Wall -O3

csrc = $(wildcard *.c) \
       $(wildcard crapto1/*.c) \
       hardnested/hardnested_bruteforce.c \
       hardnested/tables.c

obj = $(csrc:.c=.o)
MULTIARCHSRCS = hardnested/hardnested_bf_core.c hardnested/hardnested_bitarray_core.c

MULTIARCHOBJS = $(MULTIARCHSRCS:%.c=%_NOSIMD.o) \
			$(MULTIARCHSRCS:%.c=%_MMX.o) \
			$(MULTIARCHSRCS:%.c=%_SSE2.o) \
			$(MULTIARCHSRCS:%.c=%_AVX.o) \
			$(MULTIARCHSRCS:%.c=%_AVX2.o)

SUPPORTS_AVX512 :=  $(shell echo | gcc -E -mavx512f - > /dev/null 2>&1 && echo "True" )
HARD_SWITCH_NOSIMD = -mno-mmx -mno-sse2 -mno-avx -mno-avx2
HARD_SWITCH_MMX = -mmmx -mno-sse2 -mno-avx -mno-avx2
HARD_SWITCH_SSE2 = -mmmx -msse2 -mno-avx -mno-avx2
HARD_SWITCH_AVX = -mmmx -msse2 -mavx -mno-avx2
HARD_SWITCH_AVX2 = -mmmx -msse2 -mavx -mavx2
HARD_SWITCH_AVX512 = -mmmx -msse2 -mavx -mavx2 -mavx512f
ifeq "$(SUPPORTS_AVX512)" "True"
	HARD_SWITCH_NOSIMD += -mno-avx512f
	HARD_SWITCH_MMX += -mno-avx512f
	HARD_SWITCH_SSE2 += -mno-avx512f
	HARD_SWITCH_AVX += -mno-avx512f
	HARD_SWITCH_AVX2 += -mno-avx512f
	MULTIARCHOBJS +=  $(MULTIARCHSRCS:%.c=%_AVX512.o)
endif
	
LDFLAGS = -lz -lm -lreadline -lpthread -llzma

.PHONY: all clean



cropto1_bs: $(obj) $(MULTIARCHOBJS)
	$(CXX) -o $@ $^ $(LDFLAGS)


hardnested/hardnested_bf_core_NOSIMD.o : hardnested/hardnested_bf_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_NOSIMD) -c -o $@ $<

hardnested/hardnested_bitarray_core_NOSIMD.o : hardnested/hardnested_bitarray_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_NOSIMD) -c -o $@ $<


hardnested/hardnested_bf_core_MMX.o : hardnested/hardnested_bf_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_MMX) -c -o $@ $<

hardnested/hardnested_bitarray_core_MMX.o : hardnested/hardnested_bitarray_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_MMX) -c -o $@ $<


hardnested/hardnested_bf_core_SSE2.o : hardnested/hardnested_bf_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_SSE2) -c -o $@ $<

hardnested/hardnested_bitarray_core_SSE2.o : hardnested/hardnested_bitarray_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_SSE2) -c -o $@ $<


hardnested/hardnested_bf_core_AVX.o : hardnested/hardnested_bf_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_AVX) -c -o $@ $<

hardnested/hardnested_bitarray_core_AVX.o : hardnested/hardnested_bitarray_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_AVX) -c -o $@ $<


hardnested/hardnested_bf_core_AVX2.o : hardnested/hardnested_bf_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_AVX2) -c -o $@ $<

hardnested/hardnested_bitarray_core_AVX2.o : hardnested/hardnested_bitarray_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_AVX2) -c -o $@ $<

hardnested/hardnested_bf_core_AVX512.o : hardnested/hardnested_bf_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_AVX512) -c -o $@ $<

hardnested/hardnested_bitarray_core_AVX512.o : hardnested/hardnested_bitarray_core.c
	$(CC) $(DEPFLAGS) $(CFLAGS) $(HARD_SWITCH_AVX512) -c -o $@ $<


.PHONY: clean
clean:
	rm -f $(obj) cropto1_bs $(MULTIARCHOBJS)
