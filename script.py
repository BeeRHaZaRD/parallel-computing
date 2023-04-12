import subprocess as subp

n1 = 220
n2 = 1930
delta = 171

args = [
    ("./bin/gcc-seq", "GCC Seq"),
    ("./bin/gcc-par-1", "GCC Par-1"),
    ("./bin/gcc-par-2", "GCC Par-2"),
    ("./bin/gcc-par-4", "GCC Par-4"),
    ("./bin/gcc-par-6", "GCC Par-6"),

    ("./bin/clang-seq", "Clang Seq"),
    ("./bin/clang-par-1", "Clang Par-1"),
    ("./bin/clang-par-2", "Clang Par-2"),
    ("./bin/clang-par-4", "Clang Par-4"),
    ("./bin/clang-par-6", "Clang Par-6")
]

subp.run("make")
for arg in args:
    print(arg[1], ":", sep='')
    for n in range(n1, n2+1, delta):
        res = subp.run([arg[0], str(n)], encoding="utf-8", stdout=subp.PIPE, text=True)
        print("  ", res.stdout.split("\n")[1])
    print()
