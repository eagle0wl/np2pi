#include	"compiler.h"
// #include	<signal.h>
#include	"inputmng.h"
#include	"taskmng.h"
#include	"sdlkbd.h"
#include	"vramhdl.h"
#include	"menubase.h"
#include	"sysmenu.h"
#include	"mousemng.h"


	BOOL	task_avail;


void sighandler(int signo) {

	(void)signo;
	task_avail = FALSE;
}


void taskmng_initialize(void) {

	task_avail = TRUE;
}

void taskmng_exit(void) {

	task_avail = FALSE;
}

void taskmng_rol(void) {

	SDL_Event	e;

	if ((!task_avail) || (!SDL_PollEvent(&e))) {
		return;
	}
	switch(e.type) {
		case SDL_MOUSEMOTION:
			if (menuvram == NULL)
				mousemng_onmove(&e.motion);
			else
				menubase_moving(e.motion.x, e.motion.y, 0);
			break;

		case SDL_MOUSEBUTTONUP:
			if (menuvram == NULL) {
				if (e.button.button == SDL_BUTTON_MIDDLE)
					sysmenu_menuopen(0, e.button.x, e.button.y);
				else
					mousemng_buttonevent(&e.button);
			}
            else {
				switch (e.button.button) {
				case SDL_BUTTON_LEFT:
					menubase_moving(e.button.x, e.button.y, 2);
					break;
				case SDL_BUTTON_MIDDLE:
					menubase_close();
					break;
				}
			}
			break;

		case SDL_MOUSEBUTTONDOWN:
			if (menuvram == NULL)
				mousemng_buttonevent(&e.button);
            else {
				if (e.button.button == SDL_BUTTON_LEFT)
					menubase_moving(e.button.x, e.button.y, 1);
			}
			break;

		case SDL_KEYDOWN:
			if (e.key.keysym.sym == SDLK_F11) {
				if (menuvram == NULL) {
					sysmenu_menuopen(0, 0, 0);
				}
				else {
					menubase_close();
				}
			}
			else {
				sdlkbd_keydown(e.key.keysym.sym);
			}
			break;

		case SDL_KEYUP:
			sdlkbd_keyup(e.key.keysym.sym);
			break;

		case SDL_QUIT:
			task_avail = FALSE;
			break;
	}
}

BOOL taskmng_sleep(UINT32 tick) {

	UINT32	base;

	base = GETTICK();
	while((task_avail) && ((GETTICK() - base) < tick)) {
		taskmng_rol();
#ifndef WIN32
		usleep(960);
#else
		Sleep(1);
#endif
	}
	return(task_avail);
}

