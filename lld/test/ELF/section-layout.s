# REQUIRES: x86
# RUN: llvm-mc -filetype=obj -triple=x86_64-unknown-linux %s -o %t
# RUN: ld.lld %t -o %tout
# RUN: llvm-readobj --sections %tout | FileCheck %s

# Check that sections are laid out in the correct order.

.global _start
.text
_start:

.section u1,"axl",@nobits
.section u2,"axl"
.section v1,"awl",@nobits
.section v2,"awl"
.section w1,"awxl",@nobits
.section w2,"awxl"
.section x1,"al",@nobits
.section x2,"al"

.section t,"x",@nobits
.section s,"x"
.section r,"w",@nobits
.section q,"w"
.section p,"wx",@nobits
.section o,"wx"
.section n,"",@nobits
.section m,""

.section l,"awx",@nobits
.section k,"awx"
.section j,"aw",@nobits
.section i,"aw"
.section g,"awT",@nobits
.section e,"awT"
.section d,"ax",@nobits
.section c,"ax"
.section a1,"a",@llvm_odrtab
.section a2,"a",@nobits
.section b,"a"

// Large rodata goes first
// CHECK: Name: x2
// CHECK: Name: x1

// For non-executable and non-writable sections, PROGBITS appear after other types (except NOBITS).
// CHECK: Name: a1
// CHECK: Name: b
// CHECK: Name: a2

// CHECK: Name: c
// CHECK: Name: d

// Sections that are both writable and executable appear before
// sections that are only writable.
// CHECK: Name: k
// CHECK: Name: l

// TLS sections are only sorted on NOBITS.
// CHECK: Name: e
// CHECK: Name: g

// Writable sections appear after TLS and other relro sections.
// CHECK: Name: i
// CHECK: Name: j

// Other largedata sections go at the end
// CHECK: Name: v2
// CHECK: Name: v1
// CHECK: Name: w2
// CHECK: Name: w1
// CHECK: Name: u2
// CHECK: Name: u1

// Non allocated sections are in input order.
// CHECK: Name: t
// CHECK: Name: s
// CHECK: Name: r
// CHECK: Name: q
// CHECK: Name: p
// CHECK: Name: o
// CHECK: Name: n
// CHECK: Name: m
