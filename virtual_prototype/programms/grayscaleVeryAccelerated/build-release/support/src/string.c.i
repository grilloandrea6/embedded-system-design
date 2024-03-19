# 0 "support/src/string.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "support/src/string.c"
# 1 "support/include/string.h" 1



# 1 "support/include/defs.h" 1



# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 1 3 4
# 145 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4

# 145 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
typedef int ptrdiff_t;
# 214 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
typedef unsigned int size_t;
# 329 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
typedef unsigned int wchar_t;
# 425 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
typedef struct {
  long long __max_align_ll __attribute__((__aligned__(__alignof__(long long))));
  long double __max_align_ld __attribute__((__aligned__(__alignof__(long double))));
# 436 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 3 4
} max_align_t;
# 5 "support/include/defs.h" 2
# 1 "support/include/stdint.h" 1



# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdint-gcc.h" 1 3 4
# 34 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdint-gcc.h" 3 4
typedef signed char int8_t;


typedef short int int16_t;


typedef long int int32_t;


typedef long long int int64_t;


typedef unsigned char uint8_t;


typedef short unsigned int uint16_t;


typedef long unsigned int uint32_t;


typedef long long unsigned int uint64_t;




typedef signed char int_least8_t;
typedef short int int_least16_t;
typedef long int int_least32_t;
typedef long long int int_least64_t;
typedef unsigned char uint_least8_t;
typedef short unsigned int uint_least16_t;
typedef long unsigned int uint_least32_t;
typedef long long unsigned int uint_least64_t;



typedef int int_fast8_t;
typedef int int_fast16_t;
typedef int int_fast32_t;
typedef long long int int_fast64_t;
typedef unsigned int uint_fast8_t;
typedef unsigned int uint_fast16_t;
typedef unsigned int uint_fast32_t;
typedef long long unsigned int uint_fast64_t;




typedef int intptr_t;


typedef unsigned int uintptr_t;




typedef long long int intmax_t;
typedef long long unsigned int uintmax_t;
# 5 "support/include/stdint.h" 2
# 6 "support/include/defs.h" 2
# 5 "support/include/string.h" 2






# 10 "support/include/string.h"
void* memcpy(void* dest, const void* src, size_t n);
void* memmove(void* s1, const void* s2, size_t n);
void bcopy(const void* s1, void* s2, size_t n);
void* memset(void* dest, register int val, register size_t len);
# 2 "support/src/string.c" 2
# 11 "support/src/string.c"
typedef int word;
# 21 "support/src/string.c"
void* memcpy(void* dst0, const void* src0, size_t length) {
    volatile char* dst = dst0;
    const char* src = src0;
    size_t t;

    if (length == 0 || dst == src)
        goto done;
# 40 "support/src/string.c"
    if ((unsigned long)dst < (unsigned long)src) {



        t = (uintptr_t)src;
        if ((t | (uintptr_t)dst) & (sizeof(word) - 1)) {




            if ((t ^ (uintptr_t)dst) & (sizeof(word) - 1) || length < sizeof(word))
                t = length;
            else
                t = sizeof(word) - (t & (sizeof(word) - 1));
            length -= t;
            do { *dst++ = *src++; } while (--t);
        }



        t = length / sizeof(word);
        if (t) do { *(word*)dst = *(word*)src; src += sizeof(word); dst += sizeof(word); } while (--t);
        t = length & (sizeof(word) - 1);
        if (t) do { *dst++ = *src++; } while (--t);
    } else {





        src += length;
        dst += length;
        t = (uintptr_t)src;
        if ((t | (uintptr_t)dst) & (sizeof(word) - 1)) {
            if ((t ^ (uintptr_t)dst) & (sizeof(word) - 1) || length <= sizeof(word))
                t = length;
            else
                t &= (sizeof(word) - 1);
            length -= t;
            do { *--dst = *--src; } while (--t);
        }
        t = length / sizeof(word);
        if (t) do { src -= sizeof(word); dst -= sizeof(word); *(word*)dst = *(word*)src; } while (--t);
        t = length & (sizeof(word) - 1);
        if (t) do { *--dst = *--src; } while (--t);
    }
done:
    return (dst0);
}

void* memmove(void* s1, const void* s2, size_t n) {
    return memcpy(s1, s2, n);
}

void bcopy(const void* s1, void* s2, size_t n) {
    memcpy(s2, s1, n);
}

void* memset(void* dest, register int val, register size_t len) {
    volatile unsigned char* ptr = (unsigned char*)dest;
    while (len-- > 0)
        *ptr++ = val;
    return dest;
}
