
#include	"codecnv.h"

#if defined(OSLANG_EUC)
#define	oemtext_oemtosjis(a, b, c, d)	codecnv_euctosjis(a, b, c, d)
#define	oemtext_sjistooem(a, b, c, d)	codecnv_sjistoeuc(a, b, c, d)
#define oemtext_oemtoucs2	codecnv_euctoucs2
#elif defined(OSLANG_UTF8)
#define oemtext_oemtosjis	oemtext_utf8tosjis
#define oemtext_sjistooem	oemtext_sjistoutf8
#define oemtext_oemtoucs2	codecnv_utf8toucs2

UINT oemtext_utf8tosjis(char *dst, UINT dcnt, const char *src, UINT scnt);
UINT oemtext_sjistoutf8(char *dst, UINT dcnt, const char *src, UINT scnt);
#endif
