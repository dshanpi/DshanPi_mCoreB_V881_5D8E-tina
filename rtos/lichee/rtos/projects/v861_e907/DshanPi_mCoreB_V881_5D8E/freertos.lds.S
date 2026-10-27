OUTPUT_ARCH("riscv")
OUTPUT_FORMAT("elf32-littleriscv","elf32-littleriscv","elf32-littleriscv")

/* Linker script to configure memory regions. */
MEMORY
{
    RAM (rwx)   : ORIGIN = CONFIG_ARCH_START_ADDRESS, LENGTH = CONFIG_ARCH_MEM_LENGTH
}

__RAM_BASE = ORIGIN(RAM);
__MSP_STACK_LENGTH = 0x100;

/* Linker script to place sections and symbol values. Should be used together
 * with other linker script that defines memory regions FLASH and RAM.
 * It references following symbols, which must be defined in code:
 *   Reset_Handler : Entry of reset handler
 *
 * It defines following symbols, which code can use without definition:
 *   __exidx_start
 *   __exidx_end
 *   __etext
 *   __data_start__
 *   __preinit_array_start
 *   __preinit_array_end
 *   __init_array_start
 *   __init_array_end
 *   __fini_array_start
 *   __fini_array_end
 *   __data_end__
 *   __bss_start__
 *   __bss_end__
 *   __end__
 *   end
 *   __HeapLimit
 *   __StackLimit
 *   __StackTop
 *   __stack
 *   _estack
 */
ENTRY(_start)

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        __text_start__ = .;
        KEEP(*(.start))
        *(.vectors)
        *(*.text)
        *(.text*)
        *(.nonxip_text*)
        *(.sram_text*)
        KEEP(*(.init))
        KEEP(*(.fini))

        /* .ctors */
        *crtbegin.o(.ctors)
        *crtbegin?.o(.ctors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .ctors)
        *(SORT(.ctors.*))
        *(.ctors)

        /* .dtors */
        *crtbegin.o(.dtors)
        *crtbegin?.o(.dtors)
        *(EXCLUDE_FILE(*crtend?.o *crtend.o) .dtors)
        *(SORT(.dtors.*))
        *(.dtors)

        *(.rodata*)
        *(.srodata*)
        *(.nonxip_rodata*)
        *(.sram_rodata*)

        KEEP(*(.eh_frame*))

#ifdef CONFIG_PMP_ADDR_ALIGN
	. = ALIGN(CONFIG_PMP_ADDR_ALIGN);
#else
        . = ALIGN(4);
#endif
        __text_end__ = .;
    } > RAM

    __etext = .;
    _sidata = .;

#ifdef CONFIG_PM_STANDBY_MEMORY
#define RTOS_TARGET_PROJECT_PATH v821_e907_perf2
    .data_unsaved :
    {
        . = ALIGN(4);
        __stby_unsaved_data_start__ = .;
        *(.standby_unsaved_data*)
        *build/RTOS_TARGET_PROJECT_PATH/drivers/rtos-hal/hal/source/ccmu/?*(.data*)
        *build/RTOS_TARGET_PROJECT_PATH/components/common/aw/multi_console/?* (.data*)
        *build/RTOS_TARGET_PROJECT_PATH/components/common/thirdparty/openamp/?* (.data*)
        *build/RTOS_TARGET_PROJECT_PATH/components/common/aw/rpbuf/?* (.data*)
        . = ALIGN(16);
        __init_process_stack_start__ = .;
        . += 4096;
        __init_process_stack_end__ = .;
        . = ALIGN(16);
        __freertos_irq_stack_bottom = .;
        . += 4096;
        __freertos_irq_stack_top = .;
        PROVIDE( __global_pointer$ = . + 0x400 );
        __stby_unsaved_data_end__ = .;
    } > RAM

    .bss_unsaved :
    {
        . = ALIGN(4);
        __stby_unsaved_bss_start__ = .;
        *(.standby_unsaved_bss*)
        *build/RTOS_TARGET_PROJECT_PATH/drivers/rtos-hal/hal/source/ccmu/?*(.bss*)
        *build/RTOS_TARGET_PROJECT_PATH/components/common/aw/multi_console/?* (.bss*)
        *build/RTOS_TARGET_PROJECT_PATH/components/common/thirdparty/openamp/?* (.bss*)
        *build/RTOS_TARGET_PROJECT_PATH/components/common/aw/rpbuf/?* (.bss*)
        __stby_unsaved_bss_end__ = .;
    } > RAM
#endif

    .data :
    {
        . = ALIGN(4);
        __data_start__ = .;
        _sdata = .;

        *(vtable)
        *(.data*)
        *(.sdata*)
        *(.nonxip_data*)
        *(.sram_data*)

        . = ALIGN(4);
        /* preinit data */
        PROVIDE_HIDDEN (__preinit_array_start = .);
        KEEP(*(.preinit_array))
        PROVIDE_HIDDEN (__preinit_array_end = .);

        . = ALIGN(4);
        /* init data */
        PROVIDE_HIDDEN (__init_array_start = .);
        PROVIDE(__ctors_start__ = .);
        KEEP(*(SORT(.init_array.*)))
        KEEP(*(.init_array))
        PROVIDE(__ctors_end__ = .);
        PROVIDE_HIDDEN (__init_array_end = .);

        . = ALIGN(4);
        /* finit data */
        PROVIDE_HIDDEN (__fini_array_start = .);
        KEEP(*(SORT(.fini_array.*)))
        KEEP(*(.fini_array))
        PROVIDE_HIDDEN (__fini_array_end = .);

        KEEP(*(.jcr*))

#ifndef CONFIG_PM_STANDBY_MEMORY
        . = ALIGN(16);
        __init_process_stack_start__ = .;
        . += 4096;
        __init_process_stack_end__ = .;
        . = ALIGN(16);
        __freertos_irq_stack_bottom = .;
        . += 4096;
        __freertos_irq_stack_top = .;
        PROVIDE( __global_pointer$ = . + 0x400 );
#endif
        . = ALIGN(4);
        __data_end__ = .;
        _edata = .;
    } > RAM

    .version_table : {
	KEEP(*(.version_table))
   } > RAM

    .resource_table : {
	KEEP(*(.resource_table))
   } > RAM

    .digest : ALIGN(4)
  {
    _digest_start = ABSOLUTE(.);
    KEEP (*(.digest))
    . = ALIGN (4);
    _digest_end = ABSOLUTE(.);
  } > RAM

   .FSymTab : {
        _syscall_table_begin = .;
	KEEP(*(FSymTab))
	_syscall_table_end = .;
   } > RAM

   .VSymTab : {
        __vsymtab_start = .;
	KEEP(*(VSymTab))
	__vsymtab_end = .;
   } > RAM

   .ttcall : {
        _tt_begin = .;
	KEEP(*(ttcall))
	_tt_end = .;
   } > RAM

#ifdef CONFIG_COMPONENTS_AMP_USER_RESOURCE
    .amp_user_rsc (NOLOAD):
    {
        . = ALIGN(4);
        __amp_user_rsc_start__ = .;
        *(.amp_user_rsc)
        . = ALIGN(4);
        __amp_user_rsc_end__ = .;
    } > RAM
#endif

    .heap (COPY):
    {
        __end__ = .;
        __heap_start__ = .;
        _heap_start = .;
        end = __end__;
        *(.heap*)
        __HeapLimit = .;
    } > RAM

    /* .stack_dummy section doesn't contains any symbols. It is only
     * used for linker to calculate size of stack sections, and assign
     * values to stack symbols later */
    .stack_dummy (COPY):
    {
        *(.stack*)
    } > RAM

    .bss (NOLOAD):
    {
        . = ALIGN(4);
        __bss_start__ = .;
        _sbss = .;
        *(.bss*)
        *(.sbss*)
        *(COMMON)
        *(.nonxip_bss*)
        *(.sram_bss*)

        . = ALIGN(4);
        __bss_end__ = .;
        _ebss = .;
    } > RAM

    . = ALIGN(8);

    /* Set stack top to end of RAM, and stack limit move down by
     * size of stack_dummy section */
    __StackTop = ORIGIN(RAM) + LENGTH(RAM);
    _estack = __StackTop;
    __heap_end__ = _estack - __MSP_STACK_LENGTH;
    _heap_end = __heap_end__;
    __StackLimit = __StackTop - SIZEOF(.stack_dummy);
    PROVIDE(__stack = __StackTop);

    /* Check if data + heap + stack exceeds RAM limit */
    ASSERT(__StackLimit >= __HeapLimit, "region RAM overflowed with stack")
}
