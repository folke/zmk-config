#pragma once

#define KEYS_L LT0 LT1 LT2 LT3 LT4 LM0 LM1 LM2 LM3 LM4 LB0 LB1 LB2 LB3 LB4  // left hand
#define KEYS_R RT0 RT1 RT2 RT3 RT4 RM0 RM1 RM2 RM3 RM4 RB0 RB1 RB2 RB3 RB4  // right hand
#define KEYS_T LH2 LH1 LH0 RH0 RH1 RH2                                      // thumbs

// The default layout has 34 keys. Additional keys can be added by pre-setting any of
// the macros defined in this file to one or more keys before sourcing this file.

/* left of left half */
#if !defined _LTX  // top row, left
    #define _LTX
#endif
#if !defined _LMX  // middle row, left
    #define _LMX
#endif
#if !defined _LBX  // bottom row, left
    #define _LBX
#endif
#if !defined _LHX  // thumb row, left
    #define _LHX
#endif

/* between left and right half */
#if !defined _MTX  // top row, middle
    #define _MTX
#endif
#if !defined _MMX  // middle row, middle
    #define _MMX
#endif
#if !defined _MBX  // bottom row, middle
    #define _MBX
#endif
#if !defined _MHX  // thumb row, middle
    #define _MHX
#endif

/* right of right half */
#if !defined _RTX  // top row, right
    #define _RTX
#endif
#if !defined _RMX  // middle row, right
    #define _RMX
#endif
#if !defined _RBX  // bottom row, right
    #define _RBX
#endif
#if !defined _RHX  // thumb row, right
    #define _RHX
#endif


