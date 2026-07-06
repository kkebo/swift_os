#pragma once

#include <stdint.h>

__attribute__((swift_attr("nonisolated(unsafe)")))
volatile uint32_t  __attribute__((aligned(16))) mbox[36];
