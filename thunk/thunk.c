void * av_rdft_init( int nbits, int trans );
void   av_rdft_calc( void * s, void * data );
void   av_rdft_end ( void * s );

#ifdef _WIN32
	#define PUBLIC __attribute__((stdcall,dllexport))
#else
	#define PUBLIC __attribute__((visibility("default")))
#endif

void PUBLIC * my_av_rdft_init( int nbits, int trans )  { return av_rdft_init( nbits, trans ); }
void PUBLIC   my_av_rdft_calc( void * s, void * data ) {        av_rdft_calc( s, data );      }
void PUBLIC   my_av_rdft_end ( void * s )              {        av_rdft_end( s );             }

void PUBLIC ** my_av_rdft_exports( void ) {
	static void *ExportedFunctions[] = { my_av_rdft_init, my_av_rdft_calc, my_av_rdft_end, 0 };
	return( ExportedFunctions );
}

