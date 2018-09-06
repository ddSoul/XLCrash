//
//  Person.m
//  XLCrashDemo
//
//  Created by ddSoul on 2018/9/6.
//  Copyright © 2018年 dxl. All rights reserved.
//

#import "Person.h"
#import "Student.h"

#import <objc/runtime.h>

@implementation Person

//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//
//    Method exchangeM = class_getInstanceMethod([self class], @selector(eatWithPersonName:));
//    class_addMethod([self class], sel, class_getMethodImplementation(self, @selector(eatWithPersonName:)),method_getTypeEncoding(exchangeM));
//    return YES;
//
//}


//- (void)eatWithPersonName:(NSString *)name {
//    NSLog(@"Person %@ start eat ",name);
//}


/*
 *
 */
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    
//    Class MyClass = objc_allocateClassPair([NSObject class], "MyClass", 0);
//    class_addMethod(MyClass, aSelector, (IMP)addMethodForMyClass, "V@:");
//
//     id myObjc = [[MyClass alloc] init];
//    if ([myObjc respondsToSelector:aSelector]) {
//        return myObjc;
//    }
//
//    return nil;
//}

//static void addMethodForMyClass(id self, SEL _cmd, NSString *test) {
//    // 获取类中指定名称实例成员变量的信息
//    Ivar ivar = class_getInstanceVariable([self class], "test");
//    // 获取整个成员变量列表
//    //   Ivar * class_copyIvarList ( Class cls, unsigned intint * outCount );
//    // 获取类中指定名称实例成员变量的信息
//    //   Ivar class_getInstanceVariable ( Class cls, const charchar *name );
//    // 获取类成员变量的信息
//    //   Ivar class_getClassVariable ( Class cls, const charchar *name );
//    
//    // 返回名为test的ivar变量的值
//    id obj = object_getIvar(self, ivar);
//    NSLog(@"%@",obj);
//    NSLog(@"addMethodForMyClass:参数：%@",test);
//    NSLog(@"ClassName：%@",NSStringFromClass([self class]));
//}


@end
