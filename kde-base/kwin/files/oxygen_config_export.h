
#ifndef OXYGEN_CONFIG_EXPORT_H
#define OXYGEN_CONFIG_EXPORT_H

#ifdef OXYGEN_CONFIG_STATIC_DEFINE
#  define OXYGEN_CONFIG_EXPORT
#  define OXYGEN_CONFIG_NO_EXPORT
#else
#  ifndef OXYGEN_CONFIG_EXPORT
#    ifdef MAKE_OXYGENSTYLECONFIG_LIB
        /* We are building this library */
#      define OXYGEN_CONFIG_EXPORT __attribute__((visibility("default")))
#    else
        /* We are using this library */
#      define OXYGEN_CONFIG_EXPORT __attribute__((visibility("default")))
#    endif
#  endif

#  ifndef OXYGEN_CONFIG_NO_EXPORT
#    define OXYGEN_CONFIG_NO_EXPORT __attribute__((visibility("hidden")))
#  endif
#endif

#ifndef OXYGEN_CONFIG_DEPRECATED
#  define OXYGEN_CONFIG_DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef OXYGEN_CONFIG_DEPRECATED_EXPORT
#  define OXYGEN_CONFIG_DEPRECATED_EXPORT OXYGEN_CONFIG_EXPORT OXYGEN_CONFIG_DEPRECATED
#endif

#ifndef OXYGEN_CONFIG_DEPRECATED_NO_EXPORT
#  define OXYGEN_CONFIG_DEPRECATED_NO_EXPORT OXYGEN_CONFIG_NO_EXPORT OXYGEN_CONFIG_DEPRECATED
#endif

#define DEFINE_NO_DEPRECATED 0
#if DEFINE_NO_DEPRECATED
# define OXYGEN_CONFIG_NO_DEPRECATED
#endif

#endif
