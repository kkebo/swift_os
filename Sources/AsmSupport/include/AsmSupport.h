#pragma once

#include <stdint.h>

void delay(uint64_t);
void halt(void);
#ifdef __aarch64__
__attribute__((swift_name("getEL()")))
uint32_t get_el(void);
#endif
