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
    
    [self unrecognizedCrash];
}

#pragma mark - initUI
- (void)initUI {
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)layoutCustomViews {
    
}

#pragma mark - delegate Methods

#pragma mark - custom Methods
- (void)unrecognizedCrash {
    Person *person = [Person new];
    [person study];
}

#pragma mark - touch events

#pragma mark - setter,getter


@end
