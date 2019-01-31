//
//  ViewController.m
//  Osiris12JB
//
//  Created by GeoSn0w on 1/30/19.
//

#import "ViewController.h"
#include "offsets.h"
#include "kmem.h"
#include "user_client.h"
#include "voucher_swap.h"
#include "kutils.h"
#include "beginOsiris.h"
#include "stdlib.h"
#include "QiLin.h"
#include <string.h>
#include <unistd.h>
#include <mach/mach.h>
#include <sys/utsname.h>

//For iOS version detection
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)rollOne:(id)sender {
    printf("OSIRIS JAILBREAK For iOS 12.x | WIP!\nBy GeoSn0w (@FCE365) With exploit by @_bazad\n\n");
    printf("[i] Detecting device type first!\n");
    [self beginWithDeviceCheck];
    [self.jbYolo setTitle:@"Running sploit..." forState:UIControlStateNormal];
    [self beginNow];
}
-(void) beginNow{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (begin() == 0) {
            NSString *cat = [NSString stringWithFormat:@"Kern Task Port: 0x%x", tfp0];
            [self.jbYolo setTitle:cat forState:UIControlStateNormal];
            sleep(1);
            [self getRootorGetLeft];
        } else {
            [self fail];
        }
    });
}
-(void) getRootorGetLeft {
    [self.jbYolo setTitle:@"Getting ROOT!" forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (GetRootOrGetLeft(tfp0) == 0){
            [self QiLinBeginNow];
        } else {
            [self fail];
        }
    });
}
-(void) QiLinBeginNow{
    [self.jbYolo setTitle:@"Starting QiLin..." forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (beginQiLin() == 0){
            [self shaiHuludME];
        } else {
            [self fail];
        }
    });
}
-(void) shaiHuludME{
   [self.jbYolo setTitle:@"Escaping SandBox!" forState:UIControlStateNormal];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        if (shaiHuludMeMoar() == 0){
            _jbYolo.enabled = false;
            [self.jbYolo setTitle:@"Exploit Suck Sid!" forState:UIControlStateNormal];
            sleep(1);
            [self.jbYolo setTitle:@"Done!" forState:UIControlStateDisabled];
            [self done];
        } else {
            [self fail];
        }
    });
}
-(void) done {

    NSString *message = [NSString stringWithFormat:@"Successfully got ROOT and escaped SandBox! Still, more things are needed for the jailbreak to be a jailbreak. The kernel task port (tfp0) is 0x%x by the way.", tfp0];
    UIAlertController * done_alert = [UIAlertController
                                         alertControllerWithTitle:@"Exploit succeeded!"
                                         message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Dismiss"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 [self respringAndGiveBackCreds];
                                 exit(EXIT_SUCCESS);
                             }];
    
    
    [done_alert addAction:cancel];
    [self presentViewController:done_alert animated:YES completion:nil];
    
}
-(void) respringAndGiveBackCreds {
    if(reSpring() == 0){
        printf("[i] Giving process' credentials back. We don't need kernel's anymore and it's safe to give them back!\n");
        //Give back the process creds.
        //restore_credentials(ucred_field, ucred);
        
    }
}
-(void) fail{
    [self.jbYolo setTitle:@"We failed!" forState:UIControlStateNormal];
    UIAlertController * failure_alert = [UIAlertController
                                         alertControllerWithTitle:@"Jailbreak failed!"
                                         message:@"Please reboot your iPhone and try again!"
                                         preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Dismiss"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
                                 exit(EXIT_FAILURE);
                             }];
    
    
    [failure_alert addAction:cancel];
    
    [self presentViewController:failure_alert animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)beginWithDeviceCheck{
    struct utsname u = { 0 };
    uname(&u);
    printf("%s %s %s %s %s\n", u.machine, u.nodename, u.release, u.sysname, u.version);
    
    size_t kern_psize = 0;
    host_page_size(mach_host_self(), &kern_psize);
    
    if (kern_psize == 0x4000) {
        printf("This is a 16K Kernel Memory Page Size Device!\n");
        
    } else if (kern_psize == 0x1000) {
        printf("This is a 4K Kernel Memory Page Size Device!\n");
        
    } else {
        printf("I have no idea what's the deal with this device's memory page size. TF?\n");
        // Will continue anyways
    }
    if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
        printf("[-] You are running a way too old version. This is very likely not supported! \n");
        return;
    }
    
    if (SYSTEM_VERSION_GREATER_THAN(@"12.1.2")) {
        printf("[-] You are running a version on which this exploit was patched! This is not supported! \n");
        return;
    }
}
@end
