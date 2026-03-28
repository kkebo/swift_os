#pragma once

#include <stdint.h>

void delay(uint64_t);
void halt();
uintptr_t get_kernel_start();
uintptr_t get_kernel_end();
#ifdef __aarch64__
uint32_t get_el();
#endif
