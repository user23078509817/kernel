#include "kmalloc.h"

#define KUNIT sizeof(struct kmalloc_chunk)

#define KMALLOC_STATE_FREE 0xa1a1a1a1
#define KMALLOC_STATE_USED 0xdfdfdfdf

struct kmalloc_chunk{
    int state;
    int length;
    struct kmalloc_chunk* next;
    struct kmalloc_chunk* prev;
};

static struct kmalloc_chunk* head;

void kmalloc_init(char *start, int len){
    head = (struct kmalloc_chunk*) start;
    head->length = len;
    head->state = KMALLOC_STATE_FREE;
    head->prev = 0;
    head->next = 0;
}

static void kmalloc_split(struct kmalloc_chunk* c, int length){
    struct kmalloc_chunk* next = (c + length);

    next->state = KMALLOC_STATE_FREE;
    next->length = c->length - length;
    next->next = 0;
    next->prev = c;

    if(c->next){
        c->next->prev = next;
    }

    c->next = next;
    c->length = length;
}

void *kmalloc(int length){

    int e = length % KUNIT;
    if(e)
        length += (KUNIT - e);

    length += KUNIT;

    struct kmalloc_chunk* c = head;

    while(1){
        if(c->state == KMALLOC_STATE_FREE && c->length >= length){
            break;
        }
        c = c->next;
    }

    kmalloc_split(c, length);

    c->state = KMALLOC_STATE_USED;

    return (c + 1);
}

void kmalloc_merge(struct kmalloc_chunk* c){

}

void kfree(void *ptr){
}
