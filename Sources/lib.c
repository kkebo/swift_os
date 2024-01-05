#include <stddef.h>

int posix_memalign(void **, size_t, size_t) {
    return 0;
}

void free(void *) {}
