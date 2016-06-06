AC_INIT([webrtc-audio-processing], [0.2])
AM_INIT_AUTOMAKE([dist-xz subdir-objects tar-ustar])

AC_SUBST(LIBWEBRTC_AUDIO_PROCESSING_VERSION_INFO, [1:0:0])

AM_SILENT_RULES([yes])

# Set up the host_* variables
AC_CANONICAL_HOST

AC_PROG_CC
AC_PROG_CXX
AC_PROG_LIBTOOL
AC_PROG_INSTALL
AM_PROG_AS

AC_LANG_C
AC_LANG_CPLUSPLUS

AC_ARG_WITH([ns-mode],
	    AS_HELP_STRING([--with-ns-mode=float|fixed], [Noise suppresion mode to use. Default is float]))

AS_CASE(["x${with_ns_mode}"],
	["fixed"], [NS_FIXED=1],
	["float"], [NS_FIXED=0],
	[NS_FIXED=0])
AM_CONDITIONAL(NS_FIXED, [test "x${NS_FIXED}" = "x1"])


# Borrowed from gst-plugins-bad
AC_CHECK_HEADER(MobileCoreServices/MobileCoreServices.h, HAVE_IOS="yes", HAVE_IOS="no", [-])

# Based on gst-plugins-bad configure.ac and defines in
# <chromium source>/build/config/BUILDCONFIG.gn and
# webrtc/BUILD.gn
AS_CASE(["${host}"],
    [*android*],
        [
         OS_CFLAGS="-DWEBRTC_ANDROID -DWEBRTC_LINUX"
         PLATFORM_CFLAGS="-DWEBRTC_POSIX"
        ],
    [*-*linux*],
        [
         OS_CFLAGS="-DWEBRTC_LINUX"
         PLATFORM_CFLAGS="-DWEBRTC_POSIX"
        ],
    [*-*darwin*],
        [
         AS_IF([test "$HAVE_IOS" = "yes"],
             [OS_FLAGS="-DWEBRTC_MAC -DWEBRTC_IOS"],
             [OS_FLAGS="-DWEBRTC_MAC"])
         PLATFORM_CFLAGS="-DWEBRTC_POSIX -DWEBRTC_MAC -DWEBRTC_CLOCK_TYPE_REALTIME"
        ]
    # FIXME: Add Windows support
)
AC_SUBST(PLATFORM_CFLAGS)

AS_CASE(["${host_cpu}"],
    [i?86|x86_64],
        [
         HAVE_X86=1
        ],
    [armv7*|armv8*],
        [
         HAVE_ARM=1
         HAVE_ARMV7=1
         ARCH_CFLAGS="-DWEBRTC_ARCH_ARM -DWEBRTC_ARCH_ARM_V7"
        ],
    [arm*],
        [
         HAVE_ARM=1
         ARCH_CFLAGS="-DWEBRTC_ARCH_ARM"
        ]
    # FIXME: Add MIPS support, see webrtc/BUILD.gn for defines
)
AM_CONDITIONAL(HAVE_X86, [test "x${HAVE_X86}" = "x1"])
AM_CONDITIONAL(HAVE_ARM, [test "x${HAVE_ARM}" = "x1"])
AM_CONDITIONAL(HAVE_ARMV7, [test "x${HAVE_ARMV7}" = "x1"])

# Borrowed from pulseaudio's configure.ac
AC_ARG_ENABLE([neon],
    AS_HELP_STRING([--enable-neon], [Enable NEON optimisations on ARM CPUs that support it (yes|no|auto|runtime)]))

AS_IF([test "x$enable_neon" != "xno"],
    AS_IF([test "x$enable_neon" != "xruntime"],
        [
         save_CXXFLAGS="$CXXFLAGS"; CXXFLAGS="-mfpu=neon $CXXFLAGS"
         AC_COMPILE_IFELSE(
            [AC_LANG_PROGRAM(
                [
                 #include <arm_neon.h>
                ], [])],
            [
             HAVE_NEON=1
             ARCH_CFLAGS="$ARCH_CFLAGS -DWEBRTC_HAS_NEON -mfpu=neon"
            ])
         CXXFLAGS="$save_CXXFLAGS"
        ],
        [
         HAVE_NEON=1
         ARCH_CFLAGS="$ARCH_CFLAGS -DWEBRTC_DETECT_NEON -mfpu=neon"
        ])
)
AM_CONDITIONAL([HAVE_NEON], [test "x$HAVE_NEON" = "x1"])

COMMON_CFLAGS="-DWEBRTC_AUDIO_PROCESSING_ONLY_BUILD ${PLATFORM_CFLAGS} ${OS_CFLAGS} ${ARCH_CFLAGS} -DNDEBUG -I\$(top_srcdir)"
COMMON_CXXFLAGS="-std=c++11 -DWEBRTC_AUDIO_PROCESSING_ONLY_BUILD ${PLATFORM_CFLAGS} ${OS_CFLAGS} ${ARCH_CFLAGS} -DNDEBUG -I\$(top_srcdir)"
AC_SUBST([COMMON_CFLAGS])
AC_SUBST([COMMON_CXXFLAGS])

AC_CONFIG_FILES([
webrtc-audio-processing.pc
Makefile
webrtc/Makefile
webrtc/base/Makefile
webrtc/common_audio/Makefile
webrtc/system_wrappers/Makefile
webrtc/modules/Makefile
webrtc/modules/audio_coding/Makefile
webrtc/modules/audio_processing/Makefile
])

AC_OUTPUT
