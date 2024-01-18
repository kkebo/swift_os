static inline unsigned char volatile_load(const volatile unsigned char *ptr) {
    return *ptr;
}

static inline void volatile_store(volatile unsigned char *ptr, unsigned char data) {
    *ptr = data;
}
