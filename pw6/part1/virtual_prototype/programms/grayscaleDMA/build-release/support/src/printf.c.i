# 0 "support/src/printf.c"
# 0 "<built-in>"
# 0 "<command-line>"
# 1 "support/src/printf.c"
# 33 "support/src/printf.c"
# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdbool.h" 1 3 4
# 34 "support/src/printf.c" 2
# 1 "support/include/stdint.h" 1



# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdint-gcc.h" 1 3 4
# 34 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdint-gcc.h" 3 4

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
# 35 "support/src/printf.c" 2

# 1 "support/include/printf.h" 1
# 35 "support/include/printf.h"
# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdarg.h" 1 3 4
# 40 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdarg.h" 3 4
typedef __builtin_va_list __gnuc_va_list;
# 103 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stdarg.h" 3 4
typedef __gnuc_va_list va_list;
# 36 "support/include/printf.h" 2
# 1 "/opt/or1k_toolchain/lib/gcc/or1k-elf/13.2.0/include/stddef.h" 1 3 4
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
# 37 "support/include/printf.h" 2
# 49 "support/include/printf.h"

# 49 "support/include/printf.h"
void _putchar(char character);
# 61 "support/include/printf.h"
int printf_(const char* format, ...);
# 72 "support/include/printf.h"
int sprintf_(char* buffer, const char* format, ...);
# 87 "support/include/printf.h"
int snprintf_(char* buffer, size_t count, const char* format, ...);
int vsnprintf_(char* buffer, size_t count, const char* format, va_list va);
# 98 "support/include/printf.h"
int vprintf_(const char* format, va_list va);
# 109 "support/include/printf.h"
int fctprintf(void (*out)(char character, void* arg), void* arg, const char* format, ...);
# 37 "support/src/printf.c" 2






# 1 "support/include/printf_config.h" 1
# 44 "support/src/printf.c" 2
# 122 "support/src/printf.c"
typedef void (*out_fct_type)(char character, void* buffer, size_t idx, size_t maxlen);



typedef struct {
  void (*fct)(char character, void* arg);
  void* arg;
} out_fct_wrap_type;



static inline void _out_buffer(char character, void* buffer, size_t idx, size_t maxlen)
{
  if (idx < maxlen) {
    ((char*)buffer)[idx] = character;
  }
}



static inline void _out_null(char character, void* buffer, size_t idx, size_t maxlen)
{
  (void)character; (void)buffer; (void)idx; (void)maxlen;
}



static inline void _out_char(char character, void* buffer, size_t idx, size_t maxlen)
{
  (void)buffer; (void)idx; (void)maxlen;
  if (character) {
    _putchar(character);
  }
}



static inline void _out_fct(char character, void* buffer, size_t idx, size_t maxlen)
{
  (void)idx; (void)maxlen;
  if (character) {

    ((out_fct_wrap_type*)buffer)->fct(character, ((out_fct_wrap_type*)buffer)->arg);
  }
}




static inline unsigned int _strnlen_s(const char* str, size_t maxsize)
{
  const char* s;
  for (s = str; *s && maxsize--; ++s);
  return (unsigned int)(s - str);
}




static inline 
# 181 "support/src/printf.c" 3 4
             _Bool 
# 181 "support/src/printf.c"
                  _is_digit(char ch)
{
  return (ch >= '0') && (ch <= '9');
}



static unsigned int _atoi(const char** str)
{
  unsigned int i = 0U;
  while (_is_digit(**str)) {
    i = i * 10U + (unsigned int)(*((*str)++) - '0');
  }
  return i;
}



static size_t _out_rev(out_fct_type out, char* buffer, size_t idx, size_t maxlen, const char* buf, size_t len, unsigned int width, unsigned int flags)
{
  const size_t start_idx = idx;


  if (!(flags & (1U << 1U)) && !(flags & (1U << 0U))) {
    for (size_t i = len; i < width; i++) {
      out(' ', buffer, idx++, maxlen);
    }
  }


  while (len) {
    out(buf[--len], buffer, idx++, maxlen);
  }


  if (flags & (1U << 1U)) {
    while (idx - start_idx < width) {
      out(' ', buffer, idx++, maxlen);
    }
  }

  return idx;
}



static size_t _ntoa_format(out_fct_type out, char* buffer, size_t idx, size_t maxlen, char* buf, size_t len, 
# 227 "support/src/printf.c" 3 4
                                                                                                            _Bool 
# 227 "support/src/printf.c"
                                                                                                                 negative, unsigned int base, unsigned int prec, unsigned int width, unsigned int flags)
{

  if (!(flags & (1U << 1U))) {
    if (width && (flags & (1U << 0U)) && (negative || (flags & ((1U << 2U) | (1U << 3U))))) {
      width--;
    }
    while ((len < prec) && (len < 32U)) {
      buf[len++] = '0';
    }
    while ((flags & (1U << 0U)) && (len < width) && (len < 32U)) {
      buf[len++] = '0';
    }
  }


  if (flags & (1U << 4U)) {
    if (!(flags & (1U << 10U)) && len && ((len == prec) || (len == width))) {
      len--;
      if (len && (base == 16U)) {
        len--;
      }
    }
    if ((base == 16U) && !(flags & (1U << 5U)) && (len < 32U)) {
      buf[len++] = 'x';
    }
    else if ((base == 16U) && (flags & (1U << 5U)) && (len < 32U)) {
      buf[len++] = 'X';
    }
    else if ((base == 2U) && (len < 32U)) {
      buf[len++] = 'b';
    }
    if (len < 32U) {
      buf[len++] = '0';
    }
  }

  if (len < 32U) {
    if (negative) {
      buf[len++] = '-';
    }
    else if (flags & (1U << 2U)) {
      buf[len++] = '+';
    }
    else if (flags & (1U << 3U)) {
      buf[len++] = ' ';
    }
  }

  return _out_rev(out, buffer, idx, maxlen, buf, len, width, flags);
}



static size_t _ntoa_long(out_fct_type out, char* buffer, size_t idx, size_t maxlen, unsigned long value, 
# 281 "support/src/printf.c" 3 4
                                                                                                        _Bool 
# 281 "support/src/printf.c"
                                                                                                             negative, unsigned long base, unsigned int prec, unsigned int width, unsigned int flags)
{
  char buf[32U];
  size_t len = 0U;


  if (!value) {
    flags &= ~(1U << 4U);
  }


  if (!(flags & (1U << 10U)) || value) {
    do {
      const char digit = (char)(value % base);
      buf[len++] = digit < 10 ? '0' + digit : (flags & (1U << 5U) ? 'A' : 'a') + digit - 10;
      value /= base;
    } while (value && (len < 32U));
  }

  return _ntoa_format(out, buffer, idx, maxlen, buf, len, negative, (unsigned int)base, prec, width, flags);
}




static size_t _ntoa_long_long(out_fct_type out, char* buffer, size_t idx, size_t maxlen, unsigned long long value, 
# 306 "support/src/printf.c" 3 4
                                                                                                                  _Bool 
# 306 "support/src/printf.c"
                                                                                                                       negative, unsigned long long base, unsigned int prec, unsigned int width, unsigned int flags)
{
  char buf[32U];
  size_t len = 0U;


  if (!value) {
    flags &= ~(1U << 4U);
  }


  if (!(flags & (1U << 10U)) || value) {
    do {
      const char digit = (char)(value % base);
      buf[len++] = digit < 10 ? '0' + digit : (flags & (1U << 5U) ? 'A' : 'a') + digit - 10;
      value /= base;
    } while (value && (len < 32U));
  }

  return _ntoa_format(out, buffer, idx, maxlen, buf, len, negative, (unsigned int)base, prec, width, flags);
}
# 577 "support/src/printf.c"
static int _vsnprintf(out_fct_type out, char* buffer, const size_t maxlen, const char* format, va_list va)
{
  unsigned int flags, width, precision, n;
  size_t idx = 0U;

  if (!buffer) {

    out = _out_null;
  }

  while (*format)
  {

    if (*format != '%') {

      out(*format, buffer, idx++, maxlen);
      format++;
      continue;
    }
    else {

      format++;
    }


    flags = 0U;
    do {
      switch (*format) {
        case '0': flags |= (1U << 0U); format++; n = 1U; break;
        case '-': flags |= (1U << 1U); format++; n = 1U; break;
        case '+': flags |= (1U << 2U); format++; n = 1U; break;
        case ' ': flags |= (1U << 3U); format++; n = 1U; break;
        case '#': flags |= (1U << 4U); format++; n = 1U; break;
        default : n = 0U; break;
      }
    } while (n);


    width = 0U;
    if (_is_digit(*format)) {
      width = _atoi(&format);
    }
    else if (*format == '*') {
      const int w = 
# 620 "support/src/printf.c" 3 4
                   __builtin_va_arg(
# 620 "support/src/printf.c"
                   va
# 620 "support/src/printf.c" 3 4
                   ,
# 620 "support/src/printf.c"
                   int
# 620 "support/src/printf.c" 3 4
                   )
# 620 "support/src/printf.c"
                                  ;
      if (w < 0) {
        flags |= (1U << 1U);
        width = (unsigned int)-w;
      }
      else {
        width = (unsigned int)w;
      }
      format++;
    }


    precision = 0U;
    if (*format == '.') {
      flags |= (1U << 10U);
      format++;
      if (_is_digit(*format)) {
        precision = _atoi(&format);
      }
      else if (*format == '*') {
        const int prec = (int)
# 640 "support/src/printf.c" 3 4
                             __builtin_va_arg(
# 640 "support/src/printf.c"
                             va
# 640 "support/src/printf.c" 3 4
                             ,
# 640 "support/src/printf.c"
                             int
# 640 "support/src/printf.c" 3 4
                             )
# 640 "support/src/printf.c"
                                            ;
        precision = prec > 0 ? (unsigned int)prec : 0U;
        format++;
      }
    }


    switch (*format) {
      case 'l' :
        flags |= (1U << 8U);
        format++;
        if (*format == 'l') {
          flags |= (1U << 9U);
          format++;
        }
        break;
      case 'h' :
        flags |= (1U << 7U);
        format++;
        if (*format == 'h') {
          flags |= (1U << 6U);
          format++;
        }
        break;






      case 'j' :
        flags |= (sizeof(intmax_t) == sizeof(long) ? (1U << 8U) : (1U << 9U));
        format++;
        break;
      case 'z' :
        flags |= (sizeof(size_t) == sizeof(long) ? (1U << 8U) : (1U << 9U));
        format++;
        break;
      default :
        break;
    }


    switch (*format) {
      case 'd' :
      case 'i' :
      case 'u' :
      case 'x' :
      case 'X' :
      case 'o' :
      case 'b' : {

        unsigned int base;
        if (*format == 'x' || *format == 'X') {
          base = 16U;
        }
        else if (*format == 'o') {
          base = 8U;
        }
        else if (*format == 'b') {
          base = 2U;
        }
        else {
          base = 10U;
          flags &= ~(1U << 4U);
        }

        if (*format == 'X') {
          flags |= (1U << 5U);
        }


        if ((*format != 'i') && (*format != 'd')) {
          flags &= ~((1U << 2U) | (1U << 3U));
        }


        if (flags & (1U << 10U)) {
          flags &= ~(1U << 0U);
        }


        if ((*format == 'i') || (*format == 'd')) {

          if (flags & (1U << 9U)) {

            const long long value = 
# 726 "support/src/printf.c" 3 4
                                   __builtin_va_arg(
# 726 "support/src/printf.c"
                                   va
# 726 "support/src/printf.c" 3 4
                                   ,
# 726 "support/src/printf.c"
                                   long long
# 726 "support/src/printf.c" 3 4
                                   )
# 726 "support/src/printf.c"
                                                        ;
            idx = _ntoa_long_long(out, buffer, idx, maxlen, (unsigned long long)(value > 0 ? value : 0 - value), value < 0, base, precision, width, flags);

          }
          else if (flags & (1U << 8U)) {
            const long value = 
# 731 "support/src/printf.c" 3 4
                              __builtin_va_arg(
# 731 "support/src/printf.c"
                              va
# 731 "support/src/printf.c" 3 4
                              ,
# 731 "support/src/printf.c"
                              long
# 731 "support/src/printf.c" 3 4
                              )
# 731 "support/src/printf.c"
                                              ;
            idx = _ntoa_long(out, buffer, idx, maxlen, (unsigned long)(value > 0 ? value : 0 - value), value < 0, base, precision, width, flags);
          }
          else {
            const int value = (flags & (1U << 6U)) ? (char)
# 735 "support/src/printf.c" 3 4
                                                          __builtin_va_arg(
# 735 "support/src/printf.c"
                                                          va
# 735 "support/src/printf.c" 3 4
                                                          ,
# 735 "support/src/printf.c"
                                                          int
# 735 "support/src/printf.c" 3 4
                                                          ) 
# 735 "support/src/printf.c"
                                                                          : (flags & (1U << 7U)) ? (short int)
# 735 "support/src/printf.c" 3 4
                                                                                                               __builtin_va_arg(
# 735 "support/src/printf.c"
                                                                                                               va
# 735 "support/src/printf.c" 3 4
                                                                                                               ,
# 735 "support/src/printf.c"
                                                                                                               int
# 735 "support/src/printf.c" 3 4
                                                                                                               ) 
# 735 "support/src/printf.c"
                                                                                                                               : 
# 735 "support/src/printf.c" 3 4
                                                                                                                                 __builtin_va_arg(
# 735 "support/src/printf.c"
                                                                                                                                 va
# 735 "support/src/printf.c" 3 4
                                                                                                                                 ,
# 735 "support/src/printf.c"
                                                                                                                                 int
# 735 "support/src/printf.c" 3 4
                                                                                                                                 )
# 735 "support/src/printf.c"
                                                                                                                                                ;
            idx = _ntoa_long(out, buffer, idx, maxlen, (unsigned int)(value > 0 ? value : 0 - value), value < 0, base, precision, width, flags);
          }
        }
        else {

          if (flags & (1U << 9U)) {

            idx = _ntoa_long_long(out, buffer, idx, maxlen, 
# 743 "support/src/printf.c" 3 4
                                                           __builtin_va_arg(
# 743 "support/src/printf.c"
                                                           va
# 743 "support/src/printf.c" 3 4
                                                           ,
# 743 "support/src/printf.c"
                                                           unsigned long long
# 743 "support/src/printf.c" 3 4
                                                           )
# 743 "support/src/printf.c"
                                                                                         , 
# 743 "support/src/printf.c" 3 4
                                                                                           0
# 743 "support/src/printf.c"
                                                                                                , base, precision, width, flags);

          }
          else if (flags & (1U << 8U)) {
            idx = _ntoa_long(out, buffer, idx, maxlen, 
# 747 "support/src/printf.c" 3 4
                                                      __builtin_va_arg(
# 747 "support/src/printf.c"
                                                      va
# 747 "support/src/printf.c" 3 4
                                                      ,
# 747 "support/src/printf.c"
                                                      unsigned long
# 747 "support/src/printf.c" 3 4
                                                      )
# 747 "support/src/printf.c"
                                                                               , 
# 747 "support/src/printf.c" 3 4
                                                                                 0
# 747 "support/src/printf.c"
                                                                                      , base, precision, width, flags);
          }
          else {
            const unsigned int value = (flags & (1U << 6U)) ? (unsigned char)
# 750 "support/src/printf.c" 3 4
                                                                            __builtin_va_arg(
# 750 "support/src/printf.c"
                                                                            va
# 750 "support/src/printf.c" 3 4
                                                                            ,
# 750 "support/src/printf.c"
                                                                            unsigned int
# 750 "support/src/printf.c" 3 4
                                                                            ) 
# 750 "support/src/printf.c"
                                                                                                     : (flags & (1U << 7U)) ? (unsigned short int)
# 750 "support/src/printf.c" 3 4
                                                                                                                                                   __builtin_va_arg(
# 750 "support/src/printf.c"
                                                                                                                                                   va
# 750 "support/src/printf.c" 3 4
                                                                                                                                                   ,
# 750 "support/src/printf.c"
                                                                                                                                                   unsigned int
# 750 "support/src/printf.c" 3 4
                                                                                                                                                   ) 
# 750 "support/src/printf.c"
                                                                                                                                                                            : 
# 750 "support/src/printf.c" 3 4
                                                                                                                                                                              __builtin_va_arg(
# 750 "support/src/printf.c"
                                                                                                                                                                              va
# 750 "support/src/printf.c" 3 4
                                                                                                                                                                              ,
# 750 "support/src/printf.c"
                                                                                                                                                                              unsigned int
# 750 "support/src/printf.c" 3 4
                                                                                                                                                                              )
# 750 "support/src/printf.c"
                                                                                                                                                                                                      ;
            idx = _ntoa_long(out, buffer, idx, maxlen, value, 
# 751 "support/src/printf.c" 3 4
                                                             0
# 751 "support/src/printf.c"
                                                                  , base, precision, width, flags);
          }
        }
        format++;
        break;
      }
# 776 "support/src/printf.c"
      case 'c' : {
        unsigned int l = 1U;

        if (!(flags & (1U << 1U))) {
          while (l++ < width) {
            out(' ', buffer, idx++, maxlen);
          }
        }

        out((char)
# 785 "support/src/printf.c" 3 4
                 __builtin_va_arg(
# 785 "support/src/printf.c"
                 va
# 785 "support/src/printf.c" 3 4
                 ,
# 785 "support/src/printf.c"
                 int
# 785 "support/src/printf.c" 3 4
                 )
# 785 "support/src/printf.c"
                                , buffer, idx++, maxlen);

        if (flags & (1U << 1U)) {
          while (l++ < width) {
            out(' ', buffer, idx++, maxlen);
          }
        }
        format++;
        break;
      }

      case 's' : {
        const char* p = 
# 797 "support/src/printf.c" 3 4
                       __builtin_va_arg(
# 797 "support/src/printf.c"
                       va
# 797 "support/src/printf.c" 3 4
                       ,
# 797 "support/src/printf.c"
                       char*
# 797 "support/src/printf.c" 3 4
                       )
# 797 "support/src/printf.c"
                                        ;
        unsigned int l = _strnlen_s(p, precision ? precision : (size_t)-1);

        if (flags & (1U << 10U)) {
          l = (l < precision ? l : precision);
        }
        if (!(flags & (1U << 1U))) {
          while (l++ < width) {
            out(' ', buffer, idx++, maxlen);
          }
        }

        while ((*p != 0) && (!(flags & (1U << 10U)) || precision--)) {
          out(*(p++), buffer, idx++, maxlen);
        }

        if (flags & (1U << 1U)) {
          while (l++ < width) {
            out(' ', buffer, idx++, maxlen);
          }
        }
        format++;
        break;
      }

      case 'p' : {
        width = sizeof(void*) * 2U;
        flags |= (1U << 0U) | (1U << 5U);

        const 
# 826 "support/src/printf.c" 3 4
             _Bool 
# 826 "support/src/printf.c"
                  is_ll = sizeof(uintptr_t) == sizeof(long long);
        if (is_ll) {
          idx = _ntoa_long_long(out, buffer, idx, maxlen, (uintptr_t)
# 828 "support/src/printf.c" 3 4
                                                                    __builtin_va_arg(
# 828 "support/src/printf.c"
                                                                    va
# 828 "support/src/printf.c" 3 4
                                                                    ,
# 828 "support/src/printf.c"
                                                                    void*
# 828 "support/src/printf.c" 3 4
                                                                    )
# 828 "support/src/printf.c"
                                                                                     , 
# 828 "support/src/printf.c" 3 4
                                                                                       0
# 828 "support/src/printf.c"
                                                                                            , 16U, precision, width, flags);
        }
        else {

          idx = _ntoa_long(out, buffer, idx, maxlen, (unsigned long)((uintptr_t)
# 832 "support/src/printf.c" 3 4
                                                                               __builtin_va_arg(
# 832 "support/src/printf.c"
                                                                               va
# 832 "support/src/printf.c" 3 4
                                                                               ,
# 832 "support/src/printf.c"
                                                                               void*
# 832 "support/src/printf.c" 3 4
                                                                               )
# 832 "support/src/printf.c"
                                                                                                ), 
# 832 "support/src/printf.c" 3 4
                                                                                                   0
# 832 "support/src/printf.c"
                                                                                                        , 16U, precision, width, flags);

        }

        format++;
        break;
      }

      case '%' :
        out('%', buffer, idx++, maxlen);
        format++;
        break;

      default :
        out(*format, buffer, idx++, maxlen);
        format++;
        break;
    }
  }


  out((char)0, buffer, idx < maxlen ? idx : maxlen - 1U, maxlen);


  return (int)idx;
}




int printf_(const char* format, ...)
{
  va_list va;
  
# 865 "support/src/printf.c" 3 4
 __builtin_va_start(
# 865 "support/src/printf.c"
 va
# 865 "support/src/printf.c" 3 4
 ,
# 865 "support/src/printf.c"
 format
# 865 "support/src/printf.c" 3 4
 )
# 865 "support/src/printf.c"
                     ;
  char buffer[1];
  const int ret = _vsnprintf(_out_char, buffer, (size_t)-1, format, va);
  
# 868 "support/src/printf.c" 3 4
 __builtin_va_end(
# 868 "support/src/printf.c"
 va
# 868 "support/src/printf.c" 3 4
 )
# 868 "support/src/printf.c"
           ;
  return ret;
}


int sprintf_(char* buffer, const char* format, ...)
{
  va_list va;
  
# 876 "support/src/printf.c" 3 4
 __builtin_va_start(
# 876 "support/src/printf.c"
 va
# 876 "support/src/printf.c" 3 4
 ,
# 876 "support/src/printf.c"
 format
# 876 "support/src/printf.c" 3 4
 )
# 876 "support/src/printf.c"
                     ;
  const int ret = _vsnprintf(_out_buffer, buffer, (size_t)-1, format, va);
  
# 878 "support/src/printf.c" 3 4
 __builtin_va_end(
# 878 "support/src/printf.c"
 va
# 878 "support/src/printf.c" 3 4
 )
# 878 "support/src/printf.c"
           ;
  return ret;
}


int snprintf_(char* buffer, size_t count, const char* format, ...)
{
  va_list va;
  
# 886 "support/src/printf.c" 3 4
 __builtin_va_start(
# 886 "support/src/printf.c"
 va
# 886 "support/src/printf.c" 3 4
 ,
# 886 "support/src/printf.c"
 format
# 886 "support/src/printf.c" 3 4
 )
# 886 "support/src/printf.c"
                     ;
  const int ret = _vsnprintf(_out_buffer, buffer, count, format, va);
  
# 888 "support/src/printf.c" 3 4
 __builtin_va_end(
# 888 "support/src/printf.c"
 va
# 888 "support/src/printf.c" 3 4
 )
# 888 "support/src/printf.c"
           ;
  return ret;
}


int vprintf_(const char* format, va_list va)
{
  char buffer[1];
  return _vsnprintf(_out_char, buffer, (size_t)-1, format, va);
}


int vsnprintf_(char* buffer, size_t count, const char* format, va_list va)
{
  return _vsnprintf(_out_buffer, buffer, count, format, va);
}


int fctprintf(void (*out)(char character, void* arg), void* arg, const char* format, ...)
{
  va_list va;
  
# 909 "support/src/printf.c" 3 4
 __builtin_va_start(
# 909 "support/src/printf.c"
 va
# 909 "support/src/printf.c" 3 4
 ,
# 909 "support/src/printf.c"
 format
# 909 "support/src/printf.c" 3 4
 )
# 909 "support/src/printf.c"
                     ;
  const out_fct_wrap_type out_fct_wrap = { out, arg };
  const int ret = _vsnprintf(_out_fct, (char*)(uintptr_t)&out_fct_wrap, (size_t)-1, format, va);
  
# 912 "support/src/printf.c" 3 4
 __builtin_va_end(
# 912 "support/src/printf.c"
 va
# 912 "support/src/printf.c" 3 4
 )
# 912 "support/src/printf.c"
           ;
  return ret;
}
