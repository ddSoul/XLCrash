//
//  NextViewController.m
//  XLCrashDemo
//
//  Created by ddSoul on 2018/9/12.
//  Copyright © 2018年 dxl. All rights reserved.
//

#import "NextViewController.h"
#import "Person.h"

@interface NextViewController ()

@end

@implementation NextViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpViews];
    // Do any additional setup after loading the view.
}
- (void)setUpViews {
    self.title = @"crash";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - public methods
#pragma mark - private methods
- (void)kvoCrash {
    
    Person *person = [Person new];
    [person addObserver:self
             forKeyPath:@"name"
                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                context:nil];
    
    person.name = @"zs";
}


#pragma mark - delegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"name"]) {
        NSLog(@"%@", change);
    }
}

#pragma mark - selector
#pragma mark - getters and setters

@end
