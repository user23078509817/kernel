#include <stdint.h>
#include "memlayout.h"
#include "kmalloc.h"
#include "printf.h"
#include "string.h"
#include "console.h"
#include "graphics.h"
#include "globals.h"

typedef struct {
    int signature;
	uint16_t version;			// VBE version; high byte is major version, low byte is minor version
	uint32_t oem;			// segment:offset pointer to OEM
	uint32_t capabilities;		// bitfield that describes card capabilities
	uint32_t video_modes;		// segment:offset pointer to list of supported video modes
	uint16_t video_memory;		// amount of video memory in 64KB blocks
	uint16_t software_rev;		// software revision
	uint32_t vendor;			// segment:offset to card vendor string
	uint32_t product_name;		// segment:offset to card model name
	uint32_t product_rev;		// segment:offset pointer to product revision
	char reserved[222];		// reserved for future expansion
	char oem_data[256];		// OEM BIOSes store their strings in this area
} __attribute__ ((packed))  vbe_info_structure;

typedef struct {
    uint16_t ModeAttributes;
    uint8_t  WinAAttributes;
    uint8_t  WinBAttributes;
    uint16_t WinGranularity;
    uint16_t WinSize;
    uint16_t WinASegment;
    uint16_t WinBSegment;
    uint32_t WinFuncPtr;
    uint16_t BytesPerScanLine;
    uint16_t XResolution;
    uint16_t YResolution;
    uint8_t  XCharSize;
    uint8_t  YCharSize;
    uint8_t  NumberOfPlanes;
    uint8_t  BitsPerPixel;
    uint8_t  NumberOfBanks;
    uint8_t  MemoryModel;
    uint8_t  BankSize;
    uint8_t  NumberOfImagePages;
    uint8_t  Reserved1;
    uint8_t  RedMaskSize;
    uint8_t  RedFieldPosition;
    uint8_t  GreenMaskSize;
    uint8_t  GreenFieldPosition;
    uint8_t  BlueMaskSize;
    uint8_t  BlueFieldPosition;
    uint8_t  RsvdMaskSize;
    uint8_t  RsvdFieldPosition;
    uint8_t  DirectColorModeInfo;
    uint32_t PhysBasePtr;
    uint32_t OffScreenMemOffset;
    uint16_t OffScreenMemSize;
    uint8_t  Reserved2[206];
} __attribute__((packed)) VbeModeInfoBlock;

void kernel_main() {

    kmalloc_init((char*) KMALLOC_START, KMALLOC_LENGTH);

    console_t* console = console_init();
    console_setref(console);

    vbe_info_structure* vbeinfo = 0x1005c;
    VbeModeInfoBlock *info = 0x10258;

    video_buffer = info->PhysBasePtr;

    printf("%s\n", &vbeinfo->signature);
    printf("%x\n", vbeinfo->version);

    printf("%x %u\n", info->PhysBasePtr, info->BitsPerPixel);
    printf("%u %u %u\n", info->RedMaskSize, info->GreenMaskSize, info->BlueMaskSize);
    printf("%u %u %u\n", info->RedFieldPosition, info->GreenFieldPosition, info->BlueFieldPosition);
    printf("%u \n", info->BytesPerScanLine);
    
    for(int i = 0; i < video_yres; i++){
        graphics_draw_pixel(i,i, 0xffff0000);
    }
    for(;;){
        
    }
}