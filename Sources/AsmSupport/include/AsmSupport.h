#pragma once

#include <stdint.h>

void delay(uint64_t);
void halt(void);
__attribute__((swift_name("enableIRQ()")))
void enable_irq(void);
__attribute__((swift_name("disableIRQ()")))
void disable_irq(void);
#ifdef __aarch64__
__attribute__((swift_name("getEL()")))
uint32_t get_el(void);
__attribute__((swift_name("registerVectorTable()")))
void register_vector_table(void);
void brk0(void);
#endif
