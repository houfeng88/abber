/* md5.h
** interface to MD5 hash function
**
** This code is in the Public Domain.
*/

/** @file
 *  MD5 hash API.
 */

#ifndef MD5_H
#define MD5_H

/* we use the uint32_t type from stdint.h
 * if it is not available, add a typedef here:
 */
/* make sure the stdint.h types are available */
#if defined(_MSC_VER) /* Microsoft Visual C++ */
  typedef unsigned int              uint32_t;
#else
#include <stdint.h>
#endif

typedef struct {
	uint32_t buf[4];
	uint32_t bits[2];
	unsigned char in[64];
} md5_ctx_t ;

void md5_init(md5_ctx_t *context);
void md5_update(md5_ctx_t *context, unsigned char const *buf,
	       uint32_t len);
void md5_final(unsigned char digest[16], md5_ctx_t *context);
void md5_transform(uint32_t buf[4], const unsigned char in[64],
			md5_ctx_t *ctx);

#ifdef DEBUG_MD5
void md5_dump_bytes(unsigned char *b, int len);
#endif

#endif /* !MD5_H */
