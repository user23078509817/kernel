#pragma once

void kmalloc_init(char* start, int len);
void* kmalloc(int length);
void kfree(void* ptr);