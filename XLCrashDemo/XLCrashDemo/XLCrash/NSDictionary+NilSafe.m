//
//  NSDictionary+NilSafe.h
//  XLListViewDemo
//
//  Created by ddSoul on 2018/11/21.
//  Copyright © 2018 dxl. All rights reserved.
//

#import <objc/runtime.h>
#import "NSDictionary+NilSafe.h"

#pragma mark  设置通用的交换方法
@implementation NSObject (Swizzling)

#pragma mark 进行方法的交换
+ (BOOL)dd_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
    
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    
    if (!origMethod || !altMethod) {
        return NO;
    }

    BOOL ori = class_addMethod(self,
                               origSel,
                               class_getMethodImplementation(self, origSel),
                               method_getTypeEncoding(origMethod));
    NSLog(@"原方法添加：%@",ori?@"yes":@"no");
    
    BOOL alt = class_addMethod(self,
                               altSel,
                               class_getMethodImplementation(self, altSel),
                               method_getTypeEncoding(altMethod));
    
    NSLog(@"新方法添加：%@",alt?@"yes":@"no");

    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)dd_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel {
    return [object_getClass((id)self) dd_swizzleMethod:origSel withMethod:altSel];
}

@end


#pragma mark 设置不可变字典的崩溃处理
@implementation NSDictionary (NilSafe)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self dd_swizzleMethod:@selector(initWithObjects:forKeys:count:) withMethod:@selector(dd_initWithObjects:forKeys:count:)];
        
        [self dd_swizzleClassMethod:@selector(dictionaryWithObjects:forKeys:count:) withMethod:@selector(dd_dictionaryWithObjects:forKeys:count:)];
    });
}

+ (instancetype)dd_dictionaryWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        
        if (!key || !obj) {
            /*
             break是结束整个循环，而continue是结束本次循环（跳过下一步），
             为了循环的继续，我们就必须选择continue.
             */
            continue;
        }
        
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    
    return [self dd_dictionaryWithObjects:safeObjects forKeys:safeKeys count:j];
}

- (instancetype)dd_initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    id safeObjects[cnt];
    id safeKeys[cnt];
    NSUInteger j = 0;
    for (NSUInteger i = 0; i < cnt; i++) {
        id key = keys[i];
        id obj = objects[i];
        if (!key || !obj) {
            continue;
        }
        if (!obj) {
            obj = [NSNull null];
        }
        safeKeys[j] = key;
        safeObjects[j] = obj;
        j++;
    }
    return [self dd_initWithObjects:safeObjects forKeys:safeKeys count:j];
}

@end





#pragma mark 设置可变字典的崩溃处理
@implementation NSMutableDictionary (NilSafe)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

        Class class = NSClassFromString(@"__NSDictionaryM");
        [class dd_swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(dd_setObject:forKey:)];
        [class dd_swizzleMethod:@selector(setObject:forKeyedSubscript:) withMethod:@selector(dd_setObject:forKeyedSubscript:)];
    });
}

- (void)dd_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    
    if (!aKey || !anObject) {
        return;
    }
    [self dd_setObject:anObject forKey:aKey];
}

- (void)dd_setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {

    if (!key || !obj) {
        return;
        
    }
    [self dd_setObject:obj forKeyedSubscript:key];
}

@end
