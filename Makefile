CFLAGS = -O3 -Wall -Werror -pedantic -Wextra
OUTPUT = ./bin
SOURCE = lab1.c

all: clean gcc-seq gcc-par-1 gcc-par-2 gcc-par-4 gcc-par-6 clang-seq clang-par-1 clang-par-2 clang-par-4 clang-par-6

.PHONY: clean
clean:
	rm -rf $(OUTPUT)/*

build-gcc: gcc-seq gcc-par-1 gcc-par-2 gcc-par-4 gcc-par-6
gcc-seq:
	gcc $(CFLAGS) -o $(OUTPUT)/$@ $(SOURCE) -lm

gcc-par-1:
	gcc $(CFLAGS) -floop-parallelize-all -ftree-parallelize-loops=1 -o $(OUTPUT)/$@ $(SOURCE) -lm

gcc-par-2:
	gcc $(CFLAGS) -floop-parallelize-all -ftree-parallelize-loops=2 -o $(OUTPUT)/$@ $(SOURCE) -lm

gcc-par-4:
	gcc $(CFLAGS) -floop-parallelize-all -ftree-parallelize-loops=4 -o $(OUTPUT)/$@ $(SOURCE) -lm

gcc-par-6:
	gcc $(CFLAGS) -floop-parallelize-all -ftree-parallelize-loops=6 -o $(OUTPUT)/$@ $(SOURCE) -lm


run-gcc: build-gcc gcc-run-seq gcc-run-par-1 gcc-run-par-2 gcc-run-par-4 gcc-run-par-6

.PHONY: gcc-run-seq gcc-run-par-1 gcc-run-par-2 gcc-run-par-4 gcc-run-par-6
gcc-run-seq:
	$(OUTPUT)/gcc-seq 1000

gcc-run-par-1:
	$(OUTPUT)/gcc-par-1 1000

gcc-run-par-2:
	$(OUTPUT)/gcc-par-2 1000

gcc-run-par-4:
	$(OUTPUT)/gcc-par-4 1000

gcc-run-par-6:
	$(OUTPUT)/gcc-par-6 1000


build-clang: clang-seq clang-par-1 clang-par-2 clang-par-4 clang-par-6

clang-seq:
	clang $(CFLAGS) -o $(OUTPUT)/$@ $(SOURCE) -lm

clang-par-1:
	clang $(CFLAGS) -mllvm -polly -mllvm -polly-parallel -mllvm -polly-omp-backend=LLVM -mllvm -polly-num-threads=1 -o $(OUTPUT)/$@ $(SOURCE) -lm

clang-par-2:
	clang $(CFLAGS) -mllvm -polly -mllvm -polly-parallel -mllvm -polly-omp-backend=LLVM -mllvm -polly-num-threads=2 -o $(OUTPUT)/$@ $(SOURCE) -lm

clang-par-4:
	clang $(CFLAGS) -mllvm -polly -mllvm -polly-parallel -mllvm -polly-omp-backend=LLVM -mllvm -polly-num-threads=4 -o $(OUTPUT)/$@ $(SOURCE) -lm

clang-par-6:
	clang $(CFLAGS) -mllvm -polly -mllvm -polly-parallel -mllvm -polly-omp-backend=LLVM -mllvm -polly-num-threads=6 -o $(OUTPUT)/$@ $(SOURCE) -lm