#define FFT_NAME(x) x

#define CONFIG_FFT_FLOAT
typedef float FFTSample;

#define COSTABLE_CONST const
#define DECLARE_ALIGNED(n,t,v) t __attribute__((aligned(n))) v

#define COSTABLE(size) \
    COSTABLE_CONST DECLARE_ALIGNED(32,FFTSample,FFT_NAME(ff_cos_##size))[size/2]

#include "ff_cos.inc"

COSTABLE_CONST FFTSample * const FFT_NAME(ff_cos_tabs)[17] = {
    (void *)0, (void *)0,
    (void *)0, (void *)0,
    FFT_NAME(ff_cos_16),
    FFT_NAME(ff_cos_32),
    FFT_NAME(ff_cos_64),
    FFT_NAME(ff_cos_128),
    FFT_NAME(ff_cos_256),
    FFT_NAME(ff_cos_512),
    FFT_NAME(ff_cos_1024),
    FFT_NAME(ff_cos_2048),
    FFT_NAME(ff_cos_4096),
    FFT_NAME(ff_cos_8192),
    FFT_NAME(ff_cos_16384),
    FFT_NAME(ff_cos_32768),
    FFT_NAME(ff_cos_65536),
};

