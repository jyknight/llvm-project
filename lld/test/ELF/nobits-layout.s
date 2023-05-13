# REQUIRES: aarch64
# RUN: llvm-mc -filetype=obj -triple=aarch64 %s -o %t.o
# RUN: ld.lld --no-rosegment %t.o -o %t
# RUN: llvm-readelf -S -l %t | FileCheck %s

## If a SHT_NOBITS section is before a non-NOBITS section with the
## same permissions, the non-NOBITS section should get a new LOAD
## segment. This situation doesn't typically occur, since NOBITS is
## usually used only for .bss, which goes at the end of the RW
## segment anyhow.

## In this test, we unusually create a NOBITS rodata, and use
## --no-rosegment, which normally would merge .rodata and .text.
## Instead, it creates a distinct LOAD with the same permissions.

# CHECK: Name          Type     Address          Off    Size   ES Flg Lk Inf Al
# CHECK: nobits_rodata NOBITS   0000000000200120 000120 004000 00   A  0   0  1
# CHECK: .text         PROGBITS 0000000000214120 004120 0003e8 00  AX  0   0  4

# CHECK: Type Offset   VirtAddr           PhysAddr           FileSiz  MemSiz   Flg Align
# CHECK: LOAD 0x000000 0x0000000000200000 0x0000000000200000 0x000120 0x004120 R E 0x10000
# CHECK: LOAD 0x004120 0x0000000000214120 0x0000000000214120 0x0003e8 0x0003e8 R E 0x10000

# CHECK: 01 nobits_rodata
# CHECK: 02 .text

.section nobits_rodata, "a", @nobits
.zero 16384

.section .text, "ax", @progbits
.zero 1000
