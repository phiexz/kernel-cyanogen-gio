/*
 * This file contains miscellaneous low-level functions.
 *    Copyright (C) 1995-1996 Gary Thomas (gdt@linuxppc.org)
 *
 * Largely rewritten by Cort Dougan (cort@cs.nmt.edu)
 * and Paul Mackerras.
 *
 * Adapted for iSeries by Mike Corrigan (mikejc@us.ibm.com)
 * PPC64 updates by Dave Engebretsen (engebret@us.ibm.com)
 *
 * setjmp/longjmp code by Paul Mackerras.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version
 * 2 of the License, or (at your option) any later version.
 */
#include <asm/ppc_asm.h>
#include <asm/unistd.h>
#include <asm/asm-compat.h>
#include <asm/asm-offsets.h>

	.text

/*
 * Returns (address we are running at) - (address we were linked at)
 * for use before the text and data are mapped to KERNELBASE.
 */

_GLOBAL(reloc_offset)
	mflr	r0
	bl	1f
1:	mflr	r3
	PPC_LL	r4,(2f-1b)(r3)
	subf	r3,r4,r3
	mtlr	r0
	blr

	.align	3
2:	PPC_LONG 1b

/*
 * add_reloc_offset(x) returns x + reloc_offset().
 */
_GLOBAL(add_reloc_offset)
	mflr	r0
	bl	1f
1:	mflr	r5
	PPC_LL	r4,(2f-1b)(r5)
	subf	r5,r4,r5
	add	r3,r3,r5
	mtlr	r0
	blr

	.align	3
2:	PPC_LONG 1b

_GLOBAL(kernel_execve)
	li	r0,__NR_execve
	sc
	bnslr
	neg	r3,r3
	blr

_GLOBAL(setjmp)
	mflr	r0
	PPC_STL	r0,0(r3)
	PPC_STL	r1,SZL(r3)
	PPC_STL	r2,2*SZL(r3)
	mfcr	r0
	PPC_STL	r0,3*SZL(r3)
	PPC_STL	r13,4*SZL(r3)
	PPC_STL	r14,5*SZL(r3)
	PPC_STL	r15,6*SZL(r3)
	PPC_STL	r16,7*SZL(r3)
	PPC_STL	r17,8*SZL(r3)
	PPC_STL	r18,9*SZL(r3)
	PPC_STL	r19,10*SZL(r3)
	PPC_STL	r20,11*SZL(r3)
	PPC_STL	r21,12*SZL(r3)
	PPC_STL	r22,13*SZL(r3)
	PPC_STL	r23,14*SZL(r3)
	PPC_STL	r24,15*SZL(r3)
	PPC_STL	r25,16*SZL(r3)
	PPC_STL	r26,17*SZL(r3)
	PPC_STL	r27,18*SZL(r3)
	PPC_STL	r28,19*SZL(r3)
	PPC_STL	r29,20*SZL(r3)
	PPC_STL	r30,21*SZL(r3)
	PPC_STL	r31,22*SZL(r3)
	li	r3,0
	blr

_GLOBAL(longjmp)
	PPC_LCMPI r4,0
	bne	1f
	li	r4,1
1:	PPC_LL	r13,4*SZL(r3)
	PPC_LL	r14,5*SZL(r3)
	PPC_LL	r15,6*SZL(r3)
	PPC_LL	r16,7*SZL(r3)
	PPC_LL	r17,8*SZL(r3)
	PPC_LL	r18,9*SZL(r3)
	PPC_LL	r19,10*SZL(r3)
	PPC_LL	r20,11*SZL(r3)
	PPC_LL	r21,12*SZL(r3)
	PPC_LL	r22,13*SZL(r3)
	PPC_LL	r23,14*SZL(r3)
	PPC_LL	r24,15*SZL(r3)
	PPC_LL	r25,16*SZL(r3)
	PPC_LL	r26,17*SZL(r3)
	PPC_LL	r27,18*SZL(r3)
	PPC_LL	r28,19*SZL(r3)
	PPC_LL	r29,20*SZL(r3)
	PPC_LL	r30,21*SZL(r3)
	PPC_LL	r31,22*SZL(r3)
	PPC_LL	r0,3*SZL(r3)
	mtcrf	0x38,r0
	PPC_LL	r0,0(r3)
	PPC_LL	r1,SZL(r3)
	PPC_LL	r2,2*SZL(r3)
	mtlr	r0
	mr	r3,r4
	blr

_GLOBAL(__setup_cpu_power7)
_GLOBAL(__restore_cpu_power7)
	/* place holder */
	blr

/*
 * Get a minimal set of registers for our caller's nth caller.
 * r3 = regs pointer, r5 = n.
 *
 * We only get R1 (stack pointer), NIP (next instruction pointer)
 * and LR (link register).  These are all we can get in the
 * general case without doing complicated stack unwinding, but
 * fortunately they are enough to do a stack backtrace, which
 * is all we need them for.
 */
_GLOBAL(perf_arch_fetch_caller_regs)
	mr	r6,r1
	cmpwi	r5,0
	mflr	r4
	ble	2f
	mtctr	r5
1:	PPC_LL	r6,0(r6)
	bdnz	1b
	PPC_LL	r4,PPC_LR_STKOFF(r6)
2:	PPC_LL	r7,0(r6)
	PPC_LL	r7,PPC_LR_STKOFF(r7)
	PPC_STL	r6,GPR1-STACK_FRAME_OVERHEAD(r3)
	PPC_STL	r4,_NIP-STACK_FRAME_OVERHEAD(r3)
	PPC_STL	r7,_LINK-STACK_FRAME_OVERHEAD(r3)
	blr
