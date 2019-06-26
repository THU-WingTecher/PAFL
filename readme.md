PAFL
==================
This is an implmentation of PAFL, which utilizes efficient guiding information synchronization and task division to extend existing fuzzing optimizations of single mode to industrial parallel mode. We have integrated AFLFast and FairFuzz with PAFL.

You can use –P option to add the power schedule of AFLFast to AFL. And you can also use –D option to add the optimizations of FairFuzz to AFL. We also supply the –F option, this is another optimization for AFL which select seeds in a balanced way. These options are not conflict, and you can combine them to get a better effect.

When you use PAFL in parallel mode, just use the original usage of AFL with the optimizations you want to use. (For tips on how to fuzz a common target on multiple cores or multiple networked machines, please refer to parallel_fuzzing.txt.)  If you want to divide the fuzzing task, add two options two each instance: -N represents the total number of instances, -I represents the index of fuzzer instance.

We encapsulate these command options in a script named run4.sh which is placed in dir “example”. Just use

```bash
./run4.sh [|fast|fair] ./app
```

  to run PAFL with four instances to fuzz app. (Of course you should run "make" in the root dir to compile and install PAFL first, just like AFL.) You can choose second parameter as [’’, ‘fast’or ‘fair’] to choose AFL, AFLFast or FairFuzz mode. The last two modes are augmented with PAFL which utilizes guiding information synchronization and task division to enhance their optimizations of single mode to parallel mode.
