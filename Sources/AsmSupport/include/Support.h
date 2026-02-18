#pragma once

#include <stdint.h>

void delay(uint64_t);
void halt();
#ifdef __aarch64__
uint32_t get_el();
#endif
