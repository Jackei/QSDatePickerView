//
//  QSDatePickerView.m
//  QSDatePicker
//
//  Created by 齐志坚 on 15/12/14.
//  Copyright © 2015年 齐志坚. All rights reserved.
//

#import "QSDatePickerView.h"

static CGFloat const pickerViewHeight = 196.0f;

typedef NS_ENUM(NSInteger, DateFormatterType) {
    DateFormatterTypeNormal = 0,
    DateFormatterTypeHours,
    DateFormatterTypeMinutes,
    DateFormatterTypeSeconds,
};

@interface QSDatePickerView () <UIPickerViewDataSource,UIPickerViewDelegate>

@end

@implementation QSDatePickerView
{
    UIViewController *baseViewController;
    
    UIPickerView *_pickerView;
    
    NSMutableArray *array1;
    NSMutableArray *array2;
    NSMutableArray *array3;
    
    NSString *today;
}

- (id)initWithFrame:(CGRect)frame withBaseView:(UIViewController *)viewController
{
    self = [super initWithFrame:frame];
    if (self)
    {
        baseViewController = viewController;
        
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.3];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSelf)]];
        
        array1 = [[NSMutableArray alloc] init];
        array2 = [[NSMutableArray alloc] init];
        array3 = [[NSMutableArray alloc] init];
        
        [self getNormalDate];

        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame), CGRectGetWidth(frame), pickerViewHeight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.delegate = self;
        [self addSubview:_pickerView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 100, 100);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)getSpecialHoursAndMinutesDate
{
    [array2 removeAllObjects];
    [array3 removeAllObjects];
    
    for (int i = 0;i<=23;i++)
    {
        [array2 addObject:[NSString stringWithFormat:@"%.2d点",i]];
    }
    
    for (int i = 0;i<=50;i+=10)
    {
        [array3 addObject:[NSString stringWithFormat:@"%.2d分",i]];
    }
    
    [_pickerView reloadAllComponents];
}

- (void)getSpecialMinutesDate
{
    [array3 removeAllObjects];
    
    for (int i = 0;i<=50;i+=10)
    {
        [array3 addObject:[NSString stringWithFormat:@"%.2d分",i]];
    }
    
    [_pickerView reloadAllComponents];
}

- (void)getNormalDate
{
    [array1 removeAllObjects];
    [array2 removeAllObjects];
    [array3 removeAllObjects];
    
    for (int i = 0;i<7;i++)
    {
        NSDate *date = [self getRealDateWithLazyDay:i];
        NSString *string = [self getRealTimeWithType:DateFormatterTypeNormal withDateString:date];
        
        [array1 addObject:string];
        
        if (i == 0)
        {
            today = string;
            
            NSString *minutes = [self getRealTimeWithType:DateFormatterTypeMinutes withDateString:date];
            NSString *hours = [self getRealTimeWithType:DateFormatterTypeHours withDateString:date];
            
            int beginHours = ([minutes intValue]+30)<50?[hours intValue]:[hours intValue]+1;
            if (beginHours == 24)
            {
                [self getNextDate];
                break;
            }
            for (int i = beginHours; i <= 23;i++)
            {
                [array2 addObject:[NSString stringWithFormat:@"%.2d点",i]];
            }
            
            int m = [minutes intValue]<30?([minutes intValue]+30):([minutes intValue]+30)-60;
            int m1 = 0;
            if (m == 0)
            {
                m1 = 0;
            }
            else
            {
               m1 = (m/10+1)*10;
            }
            if (m1 == 60) m1 = 0;
            for (int i = m1;i<=50;i+=10)
            {
                [array3 addObject:[NSString stringWithFormat:@"%.2d分",i]];
            }
        }
    }
    
    [_pickerView reloadAllComponents];
}

- (void)getNextDate
{
    [array1 removeAllObjects];
    
    for (int i = 0;i<7;i++)
    {
        [array1 addObject:[self getRealTimeWithType:DateFormatterTypeNormal withDateString:[self getRealDateWithLazyDay:i+1]]];
    }
    
    [self getSpecialHoursAndMinutesDate];
}

- (NSDate *)getRealDateWithLazyDay:(int)day
{
    NSCalendar *greCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *calendarDate = [[NSDateComponents alloc] init];
    [calendarDate setDay:day];
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    NSDate *publishDate = [date dateByAddingTimeInterval:interval];
    
    NSDate *realDate = [greCalendar dateByAddingComponents:calendarDate toDate:publishDate options:0];
    return realDate;
}

- (NSString *)getRealTimeWithType:(DateFormatterType)type withDateString:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    
    switch (type) {
        case DateFormatterTypeNormal:
            [formatter setDateFormat:@"MM月-dd日"];
            break;
        case DateFormatterTypeHours:
            [formatter setDateFormat:@"HH"];
            break;
        case DateFormatterTypeMinutes:
            [formatter setDateFormat:@"mm"];
            break;
        case DateFormatterTypeSeconds:
            [formatter setDateFormat:@"ss"];
            break;
        default:
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            break;
    }
    NSString *string = [formatter stringFromDate:date];
    return string;
}

#pragma mark - UIPickerViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) return array1.count;
    else if (component == 1) return array2.count;
    else if (component == 2) return array3.count;
    else return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return  self.frame.size.width/3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) return [[array1 objectAtIndex:row] isEqualToString:today]?@"今天":[array1 objectAtIndex:row];
    else if (component == 1) return [array2 objectAtIndex:row];
    else if (component == 2) return [array3 objectAtIndex:row];
    else return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        if (row == 0)
        {
            [self getNormalDate];
//            [pickerView selectRow:0 inComponent:1 animated:YES];
//            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        else
        {
            [self getSpecialHoursAndMinutesDate];
//            [pickerView selectRow:0 inComponent:1 animated:YES];
//            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }
    else if (component == 1)
    {
        if (row == 0)
        {
            NSInteger i = [_pickerView selectedRowInComponent:0];
            if (i == 0) [self getNormalDate];
//            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
        else
        {
            [self getSpecialMinutesDate];
//            [pickerView selectRow:0 inComponent:2 animated:YES];
        }
    }
}

#pragma mark - show & hide

- (void)show
{
    [baseViewController.view addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
       
        _pickerView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-pickerViewHeight, CGRectGetWidth(self.frame), pickerViewHeight);
        
    }];
}

- (void)dismissSelf
{
    [UIView animateWithDuration:0.25 animations:^{
        
        _pickerView.frame = CGRectMake(0, CGRectGetHeight(self.frame), CGRectGetWidth(self.frame), pickerViewHeight);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

- (void)buttonClick
{
    NSInteger i = [_pickerView selectedRowInComponent:0];
    NSInteger j = [_pickerView selectedRowInComponent:1];
    NSInteger k = [_pickerView selectedRowInComponent:2];

    if ([_delegate respondsToSelector:@selector(QSDatePickerViewDidSelect:)])
    {
        [_delegate QSDatePickerViewDidSelect:[NSString stringWithFormat:@"%@ %@ %@",[array1 objectAtIndex:i],[array2 objectAtIndex:j],[array3 objectAtIndex:k]]];
    }
    [self dismissSelf];
}

@end
