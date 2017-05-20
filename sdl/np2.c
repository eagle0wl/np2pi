#include "compiler.h"
// #include <sys/time.h>
// #include <signal.h>
// #include <unistd.h>
#include	"strres.h"
#include	"np2.h"
#include	"dosio.h"
#include	"commng.h"
#include	"fontmng.h"
#include	"inputmng.h"
#include	"mousemng.h"
#include	"scrnmng.h"
#include	"soundmng.h"
#include	"sysmng.h"
#include	"taskmng.h"
#include	"sdlkbd.h"
#include	"ini.h"
#include	"pccore.h"
#include	"iocore.h"
#include	"scrndraw.h"
#include	"s98.h"
#include	"diskdrv.h"
#include	"timing.h"
#include	"keystat.h"
#include	"vramhdl.h"
#include	"menubase.h"
#include	"sysmenu.h"


NP2OSCFG np2oscfg = {
	0,			/* NOWAIT */
	0,			/* DRAW_SKIP */
	0,			/* F12KEY */

	{ COMPORT_MIDI, 0, 0x3e, 19200, "", "", "", "" },	/* mpu */

	0,			/* resume */
	0,			/* jastsnd */

	{ "", "" }, 		/* MIDIDEV */
	0,			/* MIDIWAIT */

	KEY_KEY106,	/* KEYBOARD */
};
static	UINT		framecnt;
static	UINT		waitcnt;
static	UINT		framemax = 1;
static	char		datadir[MAX_PATH] = "./";


static void usage(const char *progname) {

	printf("Usage: %s [options]\n", progname);
	printf("\t--help   [-h]       : print this message\n");
}


// ---- resume

static void getstatfilename(char *path, const char *ext, int size) {

	file_cpyname(path, datadir, size);
	file_cutext(path);
	file_catname(path, "np2sdl.", size);
	file_catname(path, ext, size);
}

static int flagsave(const char *ext) {

	int		ret;
	char	path[MAX_PATH];

	getstatfilename(path, ext, sizeof(path));
	ret = statsave_save(path);
	if (ret) {
		file_delete(path);
	}
	return(ret);
}

static void flagdelete(const char *ext) {

	char	path[MAX_PATH];

	getstatfilename(path, ext, sizeof(path));
	file_delete(path);
}

static int flagload(const char *ext, const char *title, BOOL force) {

	int		ret;
	int		id;
	char	path[MAX_PATH];
	char	buf[1024];
	char	buf2[1024 + 256];

	getstatfilename(path, ext, sizeof(path));
	id = DID_YES;
	ret = statsave_check(path, buf, sizeof(buf));
	if (ret & (~STATFLAG_DISKCHG)) {
		menumbox("Couldn't restart", title, MBOX_OK | MBOX_ICONSTOP);
		id = DID_NO;
	}
	else if ((!force) && (ret & STATFLAG_DISKCHG)) {
		SPRINTF(buf2, "Conflict!\n\n%s\nContinue?", buf);
		id = menumbox(buf2, title, MBOX_YESNOCAN | MBOX_ICONQUESTION);
	}
	if (id == DID_YES) {
		statsave_load(path);
	}
	return(id);
}


// ---- proc

#define	framereset(cnt)		framecnt = 0

static void processwait(UINT cnt) {

	if (timing_getcount() >= cnt) {
		timing_setcount(0);
		framereset(cnt);
	}
	else {
		taskmng_sleep(1);
	}
}

int SDL_main(int argc, char **argv) {

	int		pos;
	char	*p;
	int		id;
	int		i, imagetype, drvfdd, drvhddSASI, drvhddSCSI;
	char	*ext;

	pos = 1;
	while(pos < argc) {
		p = argv[pos++];
		if ((!milstr_cmp(p, "-h")) || (!milstr_cmp(p, "--help"))) {
			usage(argv[0]);
			goto np2main_err1;
		}/*
		else {
			printf("error command: %s\n", p);
			goto np2main_err1;
		}*/
	}

	dosio_init();
	file_setcd(datadir);
	initload();
	
	drvhddSASI = drvhddSCSI = 0;
	for (i = 1; i < argc; i++) {
		if (OEMSTRLEN(argv[i]) < 5) {
			continue;
		}
		
		imagetype = IMAGETYPE_UNKNOWN;
		ext = argv[i] + OEMSTRLEN(argv[i]) - 4;
		if      (0 == milstr_cmp(ext, ".hdi"))	imagetype = IMAGETYPE_SASI_IDE; // SASI/IDE
		else if (0 == milstr_cmp(ext, ".thd"))	imagetype = IMAGETYPE_SASI_IDE;
		else if (0 == milstr_cmp(ext, ".nhd"))	imagetype = IMAGETYPE_SASI_IDE;
		else if (0 == milstr_cmp(ext, ".hdd"))	imagetype = IMAGETYPE_SCSI; // SCSI
		
		switch (imagetype) {
		case IMAGETYPE_SASI_IDE:
			if (drvhddSASI < 2) {
				milstr_ncpy(np2cfg.sasihdd[drvhddSASI], argv[i], MAX_PATH);
				drvhddSASI++;
			}
			break;
		case IMAGETYPE_SCSI:
			if (drvhddSCSI < 4) {
				milstr_ncpy(np2cfg.scsihdd[drvhddSASI], argv[i], MAX_PATH);
				drvhddSCSI++;
			}
			break;
		}
	}

	TRACEINIT();

	if (fontmng_init() != SUCCESS) {
		goto np2main_err2;
	}
	inputmng_init();
	keystat_initialize();

	if (sysmenu_create() != SUCCESS) {
		goto np2main_err3;
	}

	mousemng_initialize();

	scrnmng_initialize();
	if (scrnmng_create(FULLSCREEN_WIDTH, FULLSCREEN_HEIGHT) != SUCCESS) {
		goto np2main_err4;
	}

	sdlkbd_initialize();  // this must be after SDL_VIDEO initialized

	soundmng_initialize();
	commng_initialize();
	sysmng_initialize();
	taskmng_initialize();
	pccore_init();
	S98_init();

	mousemng_hidecursor();
	scrndraw_redraw();
	pccore_reset();

	if (np2oscfg.resume) {
		id = flagload(str_sav, str_resume, FALSE);
		if (id == DID_CANCEL) {
			goto np2main_err5;
		}
	}
	
	drvfdd = drvhddSASI = drvhddSCSI = 0;
	for (i = 1; i < argc; i++) {
		if (OEMSTRLEN(argv[i]) < 5) {
			continue;
		}
		
		imagetype = IMAGETYPE_UNKNOWN;
		ext = argv[i] + OEMSTRLEN(argv[i]) - 4;
		if      (0 == milstr_cmp(ext, ".d88")) imagetype = IMAGETYPE_FDD; // FDD
		else if (0 == milstr_cmp(ext, ".d98")) imagetype = IMAGETYPE_FDD;
		else if (0 == milstr_cmp(ext, ".fdi")) imagetype = IMAGETYPE_FDD;
		else if (0 == milstr_cmp(ext, ".hdm")) imagetype = IMAGETYPE_FDD;
		else if (0 == milstr_cmp(ext, ".xdf")) imagetype = IMAGETYPE_FDD;
		else if (0 == milstr_cmp(ext, ".dup")) imagetype = IMAGETYPE_FDD;
		else if (0 == milstr_cmp(ext, ".2hd")) imagetype = IMAGETYPE_FDD;
		
		if (imagetype == IMAGETYPE_UNKNOWN) {
			continue;
		}
		
		if (drvfdd < 4) {
			diskdrv_readyfdd(drvfdd, argv[i], 0);
			drvfdd++;
		}
		
	}
	
	while(taskmng_isavail()) {
		taskmng_rol();
		if (np2oscfg.NOWAIT) {
			pccore_exec(framecnt == 0);
			if (np2oscfg.DRAW_SKIP) {			// nowait frame skip
				framecnt++;
				if (framecnt >= np2oscfg.DRAW_SKIP) {
					processwait(0);
				}
			}
			else {							// nowait auto skip
				framecnt = 1;
				if (timing_getcount()) {
					processwait(0);
				}
			}
		}
		else if (np2oscfg.DRAW_SKIP) {		// frame skip
			if (framecnt < np2oscfg.DRAW_SKIP) {
				pccore_exec(framecnt == 0);
				framecnt++;
			}
			else {
				processwait(np2oscfg.DRAW_SKIP);
			}
		}
		else {								// auto skip
			if (!waitcnt) {
				UINT cnt;
				pccore_exec(framecnt == 0);
				framecnt++;
				cnt = timing_getcount();
				if (framecnt > cnt) {
					waitcnt = framecnt;
					if (framemax > 1) {
						framemax--;
					}
				}
				else if (framecnt >= framemax) {
					if (framemax < 12) {
						framemax++;
					}
					if (cnt >= 12) {
						timing_reset();
					}
					else {
						timing_setcount(cnt - framecnt);
					}
					framereset(0);
				}
			}
			else {
				processwait(waitcnt);
				waitcnt = framecnt;
			}
		}
	}

	pccore_cfgupdate();
	if (np2oscfg.resume) {
		flagsave(str_sav);
	}
	else {
		flagdelete(str_sav);
	}
	pccore_term();
	S98_trash();
	soundmng_deinitialize();

	if (sys_updates	& (SYS_UPDATECFG | SYS_UPDATEOSCFG)) {
		initsave();
	}

	scrnmng_destroy();
	sysmenu_destroy();
	TRACETERM();
	SDL_Quit();
	dosio_term();
	return(SUCCESS);

np2main_err5:
	pccore_term();
	S98_trash();
	soundmng_deinitialize();

np2main_err4:
	scrnmng_destroy();

np2main_err3:
	sysmenu_destroy();

np2main_err2:
	TRACETERM();
	SDL_Quit();
	dosio_term();

np2main_err1:
	return(FAILURE);
}

