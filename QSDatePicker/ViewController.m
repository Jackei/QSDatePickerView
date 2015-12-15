//
//  ViewController.m
//  QSDatePicker
//
//  Created by 齐志坚 on 15/12/14.
//  Copyright © 2015年 齐志坚. All rights reserved.
//

#import "ViewController.h"
#import "QSDatePickerView.h"

@interface ViewController () <QSDatePickerViewDelegate>

@end

@implementation ViewController
{
    QSDatePickerView *dateView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    dateView = [[QSDatePickerView alloc] initWithFrame:self.view.bounds withBaseView:self];
    dateView.delegate = self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [dateView show];
}

- (void)QSDatePickerViewDidSelect:(NSString *)string
{
    NSLog(@"%@",string);
}

@end
