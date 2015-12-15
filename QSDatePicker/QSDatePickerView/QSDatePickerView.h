//
//  QSDatePickerView.h
//  QSDatePicker
//
//  Created by 齐志坚 on 15/12/14.
//  Copyright © 2015年 齐志坚. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QSDatePickerViewDelegate;

@interface QSDatePickerView : UIView

@property (nonatomic,weak) id<QSDatePickerViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withBaseView:(UIViewController *)viewController;

- (void)show;

@end

@protocol QSDatePickerViewDelegate <NSObject>

@optional
- (void)QSDatePickerViewDidSelect:(NSString *)string;

@end
