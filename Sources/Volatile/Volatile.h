#pragma once

static inline unsigned int volatile_load(const volatile unsigned int *ptr) {
    return *ptr;
}

static inline void volatile_store(volatile unsigned int *ptr, unsigned int data) {
    *ptr = data;
}
