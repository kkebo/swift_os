#pragma once

#include <stddef.h>
#include <stdint.h>

void delay(uint64_t);
void halt(void);
__attribute__((swift_name("enableIRQ()")))
void enable_irq(void);
__attribute__((swift_name("disableIRQ()")))
void disable_irq(void);
#ifndef __x86_64__
__attribute__((swift_name("cleanDCache(start:size:)")))
void clean_dcache_range(uintptr_t start, size_t size);
__attribute__((swift_name("invalidateDCache(start:size:)")))
void invalidate_dcache_range(uintptr_t start, size_t size);
#endif
#ifdef __aarch64__
__attribute__((swift_name("registerVectorTable()")))
void register_vector_table(void);
void brk0(void);
__attribute__((swift_name("enableMMU(mair:tcr:ttbr0:)")))
void enable_mmu(uint64_t mair, uint64_t tcr, uint64_t ttbr0);
__attribute__((swift_name("setTimerPeriod(_:)")))
void set_timer_period(uint32_t val);
__attribute__((swift_name("enableTimer()")))
void enable_timer(void);
__attribute__((swift_name("disableTimer()")))
void disable_timer(void);
__attribute__((swift_name("getCNTFRQ_EL0()")))
uint64_t get_cntfrq_el0(void);
__attribute__((swift_name("getCNTPCT_EL0()")))
uint64_t get_cntpct_el0(void);
__attribute__((swift_name("getCNTP_CTL_EL0()")))
uint64_t get_cntp_ctl_el0(void);
__attribute__((swift_name("getCurrentEL()")))
uint64_t get_currentel(void);
__attribute__((swift_name("getID_AA64MMFR0_EL1()")))
uint64_t get_id_aa64mmfr0_el1(void);
__attribute__((swift_name("getMAIR_EL1()")))
uint64_t get_mair_el1(void);
__attribute__((swift_name("setMAIR_EL1(_:)")))
void set_mair_el1(uint64_t val);
#endif
