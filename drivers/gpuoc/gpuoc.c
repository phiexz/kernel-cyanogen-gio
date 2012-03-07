/*
 * Author: Jesus David <D4rKn3sSyS at xda-developers>
 *
 *  This program is free software; you can redistribute  it and/or modify it
 *  under  the terms of  the GNU General  Public License as published by the
 *  Free Software Foundation;  either version 2 of the  License, or (at your
 *  option) any later version.
 *
 */

#include <linux/module.h>
#include <linux/kernel.h>

// defines
#define D4_MODULE_NAME 			"tassgpuoc"
#define D4_PROCFS_NAME 			"tassgpuoc"				
#define Tass

// patch offsets

#ifdef Tass
#define DEVICE_NAME				"Tass"
#define OFS_KALLSYMS_LOOKUP_NAME	0xc00d2b1c			// kallsyms_lookup_name
#endif

static int __init gpuoc_init(void)
{

/*int clkg = clk_get_rate(kgsl_driver.grp_clk);
int clki = clk_get_rate(kgsl_driver.imem_clk);
int clke = clk_get_rate(kgsl_driver.ebi1_clk);*/

// this will get the clock rate & print it in the kernel log
printk(KERN_INFO D4_MODULE_NAME ": Module loaded. Built for target device: " DEVICE_NAME", Enjoy!");
/*printk(KERN_INFO D4_MODULE_NAME "- kgsl: grp_clock = %d", clkg);
printk(KERN_INFO D4_MODULE_NAME "- kgsl: imem_clock = %d", clki);
printk(KERN_INFO D4_MODULE_NAME "- kgsl: ebi1_clock = %d", clke);*/
	return 0;
}


// exit module - will most likely not be called
static void __exit gpuoc_exit(void)
{
	printk(KERN_INFO D4_MODULE_NAME ": Module sucessfully unloaded\n");
}

module_init(gpuoc_init);
module_exit(gpuoc_exit);

MODULE_DESCRIPTION("GPU OC For X10 Mini Pro (MSM7227)");
MODULE_LICENSE("GPL");
