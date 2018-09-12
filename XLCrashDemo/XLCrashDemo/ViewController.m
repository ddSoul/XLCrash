//
//  ViewController.m
//  XLCrashDemo
//
//  Created by ddSoul on 2018/9/6.
//  Copyright © 2018年 dxl. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    
    [self kvoCrash];
//    [self unrecognizedCrash];
}

#pragma mark - initUI
- (void)initUI {
    self.view.backgroundColor = UIColor.whiteColor;
}
- (void)layoutCustomViews {
    
}

#pragma mark - delegate Methods
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"name"]) {
//        NSLog(@"%@", change);
//    }
//}

#pragma mark - custom Methods
- (void)unrecognizedCrash {
    Person *person = [Person new];
    [person study];
}
- (void)kvoCrash {
    

    
    Person *person = [Person new];
    
    [person removeObserver:self forKeyPath:@"name"];
    
//    [person addObserver:self
//             forKeyPath:@"name"
//                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
//                context:nil];
    
    
}
#pragma mark - touch events

#pragma mark - setter,getter


@end
