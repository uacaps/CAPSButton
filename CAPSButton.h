//
//  CAPSButton.h
//  Designables
//
//  Created by Niklas Fahl on 7/14/15.
//  Copyright (c) 2015 CAPS. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CAPSButton : UIButton

@property (nonatomic) IBInspectable BOOL isEnabled;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable BOOL hasBorderFill;

@property (nonatomic) IBInspectable BOOL isPill;

@property (nonatomic, strong) IBInspectable UIColor *fillColor;
@property (nonatomic, strong) IBInspectable UIColor *textColor;

@end
