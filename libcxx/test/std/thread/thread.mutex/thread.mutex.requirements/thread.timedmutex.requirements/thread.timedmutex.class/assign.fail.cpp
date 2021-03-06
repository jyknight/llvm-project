//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <mutex>

// class timed_mutex;

// timed_mutex& operator=(const timed_mutex&) = delete;

#include <mutex>

int main()
{
    std::timed_mutex m0;
    std::timed_mutex m1;
    m1 = m0;
}
