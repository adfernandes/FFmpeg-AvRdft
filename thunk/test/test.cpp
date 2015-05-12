extern "C" {

    enum RDFTransformType {
        DFT_R2C,
        IDFT_C2R,
        IDFT_R2C,
        DFT_C2R,
    };

    void *    av_rdft_init( int nbits, int trans ) ;
    void      av_rdft_calc( void * s, void * data );
    void      av_rdft_end ( void * s )             ;

    void * my_av_rdft_init( int nbits, int trans ) ;
    void   my_av_rdft_calc( void * s, void * data );
    void   my_av_rdft_end ( void * s )             ;

}

#ifdef USE_FFMPEG
    #define my_av_rdft_init av_rdft_init
    #define my_av_rdft_calc av_rdft_calc
    #define my_av_rdft_end  av_rdft_end
#endif

#include <cmath>
#include <vector>
#include <iostream>

using namespace std;

int main() {

    const int nbits  = 6;
    const int length = 1 << nbits;

    void * context = my_av_rdft_init( nbits, DFT_R2C );
    if ( ! context ) { cerr << "null context" << endl; return 1; }

    float data[length] __attribute__((aligned(32)));

    for ( int i = 0; i < length; i++ ) data[i] = sin( 4.0f * ( float(i)/float(length) * 2.0f * M_PI ) );
    cout << "x <- c("; for ( int i = 0; i < length; ++i ) { cout << ( i ? "," : "" ) << data[i]; } cout << ")" << endl;

    my_av_rdft_calc( context, data );
    cout << "y <- c("; for ( int i = 0; i < length; ++i ) { cout << ( i ? "," : "" ) << data[i] << "+" << data[i+1] << "i"; i += 1; } cout << ")" << endl;

    my_av_rdft_end( context );
    return 0;
}
