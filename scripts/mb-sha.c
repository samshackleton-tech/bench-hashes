// Benchmark adapter only. ISA-L Crypto performs standard multi-buffer SHA-256.
// This deliberately does not use its different mh_sha256 construction.
#include <isa-l_crypto/sha256_mb.h>
#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>

typedef struct {
    ISAL_SHA256_HASH_CTX_MGR manager;
    ISAL_SHA256_HASH_CTX *contexts;
    size_t count;
} Batch;
static void check(int status) {if(status)abort();}
void *mb_create(size_t count) {
    Batch *b=0;check(posix_memalign((void**)&b,64,sizeof(*b)));
    b->count=count;check(posix_memalign((void**)&b->contexts,64,count*sizeof(*b->contexts)));
    check(isal_sha256_ctx_mgr_init(&b->manager));
    for(size_t j=0;j<count;j++)isal_hash_ctx_init(&b->contexts[j]);
    return b;
}
void mb_destroy(void *opaque) {Batch *b=opaque;free(b->contexts);free(b);}
void mb_layout(void) {fprintf(stderr,"manager %zu align %zu; context %zu align %zu; standard SHA256 multi-buffer\n",sizeof(ISAL_SHA256_HASH_CTX_MGR),_Alignof(ISAL_SHA256_HASH_CTX_MGR),sizeof(ISAL_SHA256_HASH_CTX),_Alignof(ISAL_SHA256_HASH_CTX));}
static void store(Batch *b,ISAL_SHA256_HASH_CTX *ctx,unsigned char (*out)[32]) {
    assert(isal_hash_ctx_complete(ctx)&&!isal_hash_ctx_error(ctx));
    ptrdiff_t j=ctx-b->contexts;assert(j>=0&&(size_t)j<b->count);
    for(size_t w=0;w<8;w++) {
        uint32_t x=ctx->job.result_digest[w];
        out[j][4*w]=(unsigned char)(x>>24);out[j][4*w+1]=(unsigned char)(x>>16);
        out[j][4*w+2]=(unsigned char)(x>>8);out[j][4*w+3]=(unsigned char)x;
    }
}
void mb_hash(void *opaque,const unsigned char *const *data,const size_t *lengths,unsigned char (*out)[32]) {
    Batch *b=opaque;ISAL_SHA256_HASH_CTX *returned=0;size_t done=0;
    for(size_t j=0;j<b->count;j++) {
        assert(lengths[j]<=UINT32_MAX);
        check(isal_sha256_ctx_mgr_submit(&b->manager,&b->contexts[j],&returned,data[j],(uint32_t)lengths[j],ISAL_HASH_ENTIRE));
        if(returned){store(b,returned,out);done++;}
    }
    do {
        check(isal_sha256_ctx_mgr_flush(&b->manager,&returned));
        if(returned){store(b,returned,out);done++;}
    }while(returned);
    assert(done==b->count);
}
