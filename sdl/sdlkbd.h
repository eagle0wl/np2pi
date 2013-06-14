enum {
	KEY_KEY106,
	KEY_KEY101,
	KEY_TYPEMAX
};

void sdlkbd_initialize(void);
void sdlkbd_keydown(UINT key);
void sdlkbd_keyup(UINT key);
void sdlkbd_resetf12(void);

