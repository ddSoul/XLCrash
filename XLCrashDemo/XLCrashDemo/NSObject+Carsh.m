//
//  NSObject+Carsh.m
//  XLCrashDemo
//
//  Created by ddSoul on 2018/9/6.
//  Copyright © 2018年 dxl. All rights reserved.
//

#import "NSObject+Carsh.h"
#import <objc/runtime.h>

@implementation NSObject (Carsh)


+ (void)load {
    swizzleMethod([self class], @selector(forwardingTargetForSelector:), @selector(xl_forwardingTargetForSelector:));
}

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

- (void)unrecognizedHandler {
    NSLog(@"___________拦截到unrecognized方法并实现了");
}


@end
