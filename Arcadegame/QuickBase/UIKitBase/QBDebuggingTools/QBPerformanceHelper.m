//
//  QBPerformanceHelper.m
//  QuickBase
//
//  Created by Abner on 2019/12/28.
//  Copyright © 2019 Abner. All rights reserved.
//

#import "QBPerformanceHelper.h"
#import <mach/mach.h>

@interface QBPerformanceHelper ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

@implementation QBPerformanceHelper

- (void)dealloc{
    
}

- (instancetype)initAndRecordPerformance{
    
    if(self = [super init]){
        
        NSThread *performanceThread = [[NSThread alloc] initWithTarget:self selector:@selector(performanceThreadAction) object:nil];
        
        [performanceThread start];
    }
    
    return self;
}

- (void)performanceThreadAction{
    
}

#pragma mark - Device

+ (NSString *)performanceForMemory{
    
    int64_t memoryUsageInByte = 0;
    task_vm_info_data_t vmInfo;
    mach_msg_type_number_t count = TASK_VM_INFO_COUNT;
    kern_return_t kernelReturn = task_info(mach_task_self(), TASK_VM_INFO, (task_info_t) &vmInfo, &count);
    if(kernelReturn == KERN_SUCCESS) {
        memoryUsageInByte = (int64_t) vmInfo.phys_footprint;
        DLOG(@"Memory in use (in bytes): %lld", memoryUsageInByte);
    } else {
        DLOG(@"Error with task_info(): %s", mach_error_string(kernelReturn));
    }
    
    double mem = memoryUsageInByte / (1024.0 * 1024.0);
    NSString *memToString;
    memToString = [NSString stringWithFormat:@"%.1lf", mem];

    return memToString;
}

+ (NSString *)performanceForCPU{
    
    kern_return_t kr;
    task_info_data_t tinfo;
    mach_msg_type_number_t task_info_count;

    task_info_count = TASK_INFO_MAX;
    kr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)tinfo, &task_info_count);
    if (kr != KERN_SUCCESS) {
        return [ NSString stringWithFormat: @"%d" ,-1];
    }

    task_basic_info_t      basic_info;
    thread_array_t         thread_list;
    mach_msg_type_number_t thread_count;

    thread_info_data_t     thinfo;
    mach_msg_type_number_t thread_info_count;

    thread_basic_info_t basic_info_th;
    uint32_t stat_thread = 0; // Mach threads

    basic_info = (task_basic_info_t)tinfo;

    // get threads in the task
    kr = task_threads(mach_task_self(), &thread_list, &thread_count);
    if (kr != KERN_SUCCESS) {
        return [ NSString stringWithFormat: @"%d" ,-1];
    }
    if (thread_count > 0)
        stat_thread += thread_count;

    long tot_sec = 0;
    long tot_usec = 0;
    float tot_cpu = 0;
    int j;

    for (j = 0; j < thread_count; j++)
    {
        thread_info_count = THREAD_INFO_MAX;
        kr = thread_info(thread_list[j], THREAD_BASIC_INFO,
                         (thread_info_t)thinfo, &thread_info_count);
        if (kr != KERN_SUCCESS) {
            tot_cpu = -1;
            //return -1;
        }

        basic_info_th = (thread_basic_info_t)thinfo;

        if (!(basic_info_th->flags & TH_FLAGS_IDLE)) {
            tot_sec = tot_sec + basic_info_th->user_time.seconds + basic_info_th->system_time.seconds;
            tot_usec = tot_usec + basic_info_th->user_time.microseconds + basic_info_th->system_time.microseconds;
            tot_cpu = tot_cpu + basic_info_th->cpu_usage / (float)TH_USAGE_SCALE * 100.0;
        }

    } // for each thread

    kr = vm_deallocate(mach_task_self(), (vm_offset_t)thread_list, thread_count * sizeof(thread_t));
    assert(kr == KERN_SUCCESS);

    NSString *toString = nil ;
    toString = [ NSString stringWithFormat: @"%.1f", tot_cpu];
    DLOG(@"performance  cpu:%@",toString);

    return toString;
}

+ (NSString *)performanceForBattery{
    
    NSString *batteryLevelString = [NSString stringWithFormat:@"%.1f", [UIDevice currentDevice].batteryLevel * 100.f];
    
    return batteryLevelString;
}

+ (NSString *)performanceForDevicesName{
    
    NSString *devicesName = [UIDevice currentDevice].name;
    DLOG(@"performance  devicesName:%@", devicesName);
    
    return devicesName;
}

+ (NSString *)performanceForSystemVersion{
    
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;
    DLOG(@"performance  systemVersion:%@", systemVersion);
    
    return systemVersion;
}

- (NSString *)performanceForUUID{
    
    NSString *uuid = [UIDevice currentDevice].identifierForVendor.UUIDString;
    DLOG(@"performance  UUID:%@", uuid);
    
    return uuid;
}

- (NSString *)getCurrentVCName{
    
    __block NSString *currentVCName = @"";
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        currentVCName = NSStringFromClass([HelpTools activityViewController].class);
    });
    
    return currentVCName;
}

@end
