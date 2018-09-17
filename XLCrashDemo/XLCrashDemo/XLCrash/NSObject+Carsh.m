//
//  NSObject+Carsh.m
//  XLCrashDemo
//
//  Created by ddSoul on 2018/9/6.
//  Copyright © 2018年 dxl. All rights reserved.
//

#import "NSObject+Carsh.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static char KVOHashTableKey;

@implementation NSObject (Carsh)


+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleMethod([self class], @selector(forwardingTargetForSelector:), @selector(xl_forwardingTargetForSelector:));
        swizzleMethod([self class], @selector(addObserver:forKeyPath:options:context:), @selector(xl_CrashProtectaddObserver:forKeyPath:options:context:));
        swizzleMethod([self class], @selector(removeObserver:forKeyPath:), @selector(xl_CrashProtectremoveObserver:forKeyPath:));
    });
}

#pragma mark - 公共方法
void swizzleMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    // the method might not exist in the class, but in its superclass
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    // class_addMethod will fail if original method already exists
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    // the method doesn’t exist and we just added one
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }
    else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (NSInteger)xl_CrashProtectHash:(NSObject *)observer :(NSString *)keyPath{
    
    NSArray *KVOContentArr = @[observer,keyPath];
    NSInteger hash = [KVOContentArr hash];
    return hash;
}

- (id)xl_forwardingTargetForSelector:(SEL)sel {
    
    Class MyClass = objc_allocateClassPair([NSObject class], "MyClass", 0);
    class_addMethod(MyClass, sel, class_getMethodImplementation([self class], @selector(unrecognizedHandler)), "V@:");
    //
    id myObjc = [[MyClass alloc] init];
    if ([myObjc respondsToSelector:sel]) {
        return myObjc;
    }
    
    return nil;
}

#pragma mark - 需要交换的方法
- (void)unrecognizedHandler {
}

- (void)xl_CrashProtectaddObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
    if ([observer isKindOfClass:[UIViewController class]]) {
        
        @synchronized (self) {
            NSInteger kvoHash = [self xl_CrashProtectHash:observer :keyPath];
            
            if (!self.KVOHashTable) {
                self.KVOHashTable = [NSHashTable hashTableWithOptions:NSPointerFunctionsStrongMemory];
            }
            
            if (![self.KVOHashTable containsObject:@(kvoHash)]) {
                [self.KVOHashTable addObject:@(kvoHash)];
                [self xl_CrashProtectaddObserver:observer forKeyPath:keyPath options:options context:context];
            }
        }
        
    }else{
        [self xl_CrashProtectaddObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)xl_CrashProtectremoveObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    
    if ([observer isKindOfClass:[UIViewController class]]) {
        
        @synchronized (self) {
            
            if (!observer) {
                return;
            }
            NSInteger kvoHash = [self xl_CrashProtectHash:observer :keyPath];
            NSHashTable *hashTable = [self KVOHashTable];
            if (!hashTable) {
                return;
            }
            
            
            if ([hashTable containsObject:@(kvoHash)]) {
                [hashTable removeObject:@(kvoHash)];
                [self xl_CrashProtectremoveObserver:observer forKeyPath:keyPath];
            }
        }
    }else{
        
        [self xl_CrashProtectremoveObserver:observer forKeyPath:keyPath];
    }
}

#pragma mark - setter、getter
- (void)setKVOHashTable:(NSHashTable *)KVOHasTable{
    objc_setAssociatedObject(self, &KVOHashTableKey, KVOHasTable, OBJC_ASSOCIATION_RETAIN);
}
- (NSHashTable *)KVOHashTable{
    return objc_getAssociatedObject(self, &KVOHashTableKey);
}


@end
