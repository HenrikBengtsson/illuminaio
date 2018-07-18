#include <stdlib.h> // for NULL
#include <R_ext/Rdynload.h>

/* .C calls */
extern void decrypt(void *, void *);

static const R_CMethodDef CEntries[] = {
  {"decrypt", (DL_FUNC) &decrypt, 2},
  {NULL, NULL, 0}
};

void R_init_illuminaio(DllInfo *dll)
{
    R_registerRoutines(dll, CEntries, NULL, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
