#include	"compiler.h"
#include	"oemtext.h"

#if defined(OSLANG_UTF8)

#include	<iconv.h>

static UINT oemtext_iconv(iconv_t cd, char *dst, UINT dcnt, char *src, UINT scnt) {

	UINT	orgdcnt;
	UINT	orgscnt;
	char	work[4];

	if (src == NULL)
		return 0;
	if (dcnt == 0) {
		dst = NULL;
		dcnt = (UINT)-1;
	}
	orgdcnt = dcnt;
	orgscnt = scnt;
	if ((SINT)scnt < 0) {
		scnt = strlen(src);
		dcnt--;
	}

	while (scnt > 0 && dcnt > 0) {
		char* pwork = work;
		size_t n = iconv(cd, &src, &scnt, dst ? &dst : &pwork, &dcnt);
		if (n == (size_t)-1)
			break;
	}
	if (dst != NULL) {
		if ((SINT)orgscnt < 0 || dcnt)
			*dst = '\0';
	}
	return orgdcnt - dcnt;
}

UINT oemtext_utf8tosjis(char *dst, UINT dcnt, const char *src, UINT scnt) {

	iconv_t	cd;
	UINT	result;

	cd = iconv_open("CP932", "UTF-8");
	if (cd == (iconv_t)-1)
		return 0;
	result = oemtext_iconv(cd, dst, dcnt, (char *)src, scnt);
	iconv_close(cd);
	return result;
}

UINT oemtext_sjistoutf8(char *dst, UINT dcnt, const char *src, UINT scnt) {

	iconv_t	cd;
	UINT	result;

	cd = iconv_open("UTF-8", "CP932");
	if (cd == (iconv_t)-1)
		return 0;
	result = oemtext_iconv(cd, dst, dcnt, (char *)src, scnt);
	iconv_close(cd);
	return result;
}

#endif
