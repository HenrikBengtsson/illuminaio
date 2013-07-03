/* des.h --- DES cipher implementation.
 * Copyright (C) 2005, 2007 Free Software Foundation, Inc.
 *
 * This file is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation; either version 2, or (at your
 * option) any later version.
 *
 * This file is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this file; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 *
 */

/* Adapted for illuminaio by Mike Smith, based on Libgcrypt. */

#ifndef DES_H
# define DES_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

/*
 * Encryption/Decryption context of DES
 */
typedef struct
{
  uint32_t encrypt_subkeys[32];
  uint32_t decrypt_subkeys[32];
} gl_des_ctx;


/* Fill a DES context CTX with subkeys calculated from 64bit KEY.
 * Does not check parity bits, but simply ignore them.  Does not check
 * for weak keys. */
extern void
gl_des_setkey (gl_des_ctx *ctx, const char * key);


/* Electronic Codebook Mode DES encryption/decryption of data
 * according to 'mode'. */
extern void
gl_des_ecb_crypt (gl_des_ctx *ctx, const char * from,  char * to, int mode);

#define gl_des_ecb_encrypt(ctx, from, to)  gl_des_ecb_crypt(ctx, from, to, 0)
#define gl_des_ecb_decrypt(ctx, from, to)  gl_des_ecb_crypt(ctx, from, to, 1)


#endif /* DES_H */
