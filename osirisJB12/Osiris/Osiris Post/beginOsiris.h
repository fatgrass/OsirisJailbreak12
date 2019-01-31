//
//  beginOsiris.h
//  Osiris12JB
//
//  Created by GeoSn0w on 1/30/19.
//

#ifndef beginOsiris_h
#define beginOsiris_h

#include <stdio.h>
#include "voucher_swap.h"
#include <mach/mach.h>
#include "kutils.h"
#include "kmem.h"
#include "offsets.h"
#include "patchfinder64.h"
#include "exploit_additions.h"
#include <spawn.h>
#include "kernel_memory.h"
#include <mach/mach.h>
#include "kexecute.h"
#include <sys/stat.h>
#include "user_client.h"
#include "QiLin.h"

extern int begin(void);
extern int GetRootOrGetLeft(mach_port_t kern_task_port);
extern int shaiHuludMeMoar(void);
extern int beginQiLin(void);
extern int execprog(const char *prog, const char* args[]);
extern uint64_t ucred_field, ucred;
#endif /* beginOsiris_h */
