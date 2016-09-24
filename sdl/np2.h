
typedef struct {
	BYTE	port;
	BYTE	def_en;
	BYTE	param;
	UINT32	speed;
	char	mout[MAX_PATH];
	char	min[MAX_PATH];
	char	mdl[64];
	char	def[MAX_PATH];
} COMCFG;

typedef struct {
	BYTE	NOWAIT;
	BYTE	DRAW_SKIP;
	BYTE	F12KEY;

	COMCFG	mpu;

	BYTE	resume;
	BYTE	jastsnd;

	char	MIDIDEV[2][MAX_PATH];
	UINT32	MIDIWAIT;

	BYTE	KEYBOARD;
} NP2OSCFG;


#if defined(SIZE_QVGA)
enum {
	FULLSCREEN_WIDTH	= 320,
	FULLSCREEN_HEIGHT	= 240
};
#else
enum {
	FULLSCREEN_WIDTH	= 640,
	FULLSCREEN_HEIGHT	= 400
};
#endif

extern	NP2OSCFG	np2oscfg;

enum {
	IMAGETYPE_UNKNOWN	= 0,
	IMAGETYPE_FDD		= 1,
	IMAGETYPE_SASI_IDE	= 2,
	IMAGETYPE_SCSI		= 3,
};
