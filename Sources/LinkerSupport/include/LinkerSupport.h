#pragma once

#include <stdint.h>

extern uint8_t __kernel_start;
extern uint8_t __kernel_end;
extern uint8_t __bss_start;
extern uint8_t __bss_end;
extern uint8_t __stack_bottom;
extern uint8_t __stack_top;
extern uint8_t __kernel_image_end;

extern uint8_t __l1_table;
extern uint8_t __l2_table_0;
extern uint8_t __l2_table_1;
extern uint8_t __l2_table_2;
extern uint8_t __l2_table_3;

__attribute__((swift_name("kernelStart")))
static const uintptr_t kernel_start_ptr = (uintptr_t)&__kernel_start;

__attribute__((swift_name("kernelEnd")))
static const uintptr_t kernel_end_ptr = (uintptr_t)&__kernel_end;

__attribute__((swift_name("bssStart")))
static const uintptr_t bss_start_ptr = (uintptr_t)&__bss_start;

__attribute__((swift_name("bssEnd")))
static const uintptr_t bss_end_ptr = (uintptr_t)&__bss_end;

__attribute__((swift_name("stackBottom")))
static const uintptr_t stack_bottom_ptr = (uintptr_t)&__stack_bottom;

__attribute__((swift_name("stackTop")))
static const uintptr_t stack_top_ptr = (uintptr_t)&__stack_top;

__attribute__((swift_name("kernelImageEnd")))
static const uintptr_t kernel_image_end_ptr = (uintptr_t)&__kernel_image_end;

__attribute__((swift_name("l1Table")))
static uintptr_t *const l1_table_ptr = (uintptr_t *)&__l1_table;

__attribute__((swift_name("l2Table0")))
static uintptr_t *const l2_table_0_ptr = (uintptr_t *)&__l2_table_0;

__attribute__((swift_name("l2Table1")))
static uintptr_t *const l2_table_1_ptr = (uintptr_t *)&__l2_table_1;

__attribute__((swift_name("l2Table2")))
static uintptr_t *const l2_table_2_ptr = (uintptr_t *)&__l2_table_2;

__attribute__((swift_name("l2Table3")))
static uintptr_t *const l2_table_3_ptr = (uintptr_t *)&__l2_table_3;

