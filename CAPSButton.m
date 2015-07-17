//
//  CAPSButton.m
//  Designables
//
//  Created by Niklas Fahl on 7/14/15.
//  Copyright (c) 2015 CAPS. All rights reserved.
//

#import "CAPSButton.h"

#pragma mark - UIColor - ColorModifications

@interface UIColor (ColorModifications)

+ (BOOL)isColorLight:(UIColor *)color;
+ (UIColor *)getColorForBrightness:(BOOL)isLight withColor:(UIColor *)color;

@end

@implementation UIColor (ColorModifications)

+ (BOOL)isColorLight:(UIColor *)color
{
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    
    CGFloat colorBrightness = ((componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114)) / 1000;
    if (colorBrightness < 0.35)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

+ (UIColor *)getColorForBrightness:(BOOL)isLight withColor:(UIColor *)color
{
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    
    UIColor *newColor;
    
    if (isLight) {
        newColor = [UIColor colorWithRed:componentColors[0] > 0.2 ? componentColors[0] - 0.2 : 0.0 green:componentColors[1] > 0.2 ? componentColors[1] - 0.2 : 0.0 blue:componentColors[2] > 0.2 ? componentColors[2] - 0.2 : 0.0 alpha:componentColors[3]];
    } else {
        newColor = [UIColor colorWithRed:componentColors[0] < 0.8 ? componentColors[0] + 0.2 : 1.0 green:componentColors[1] < 0.8 ? componentColors[1] + 0.2 : 1.0 blue:componentColors[2] < 0.8 ? componentColors[2] + 0.2 : 1.0 alpha:componentColors[3]];
    }
    
    return newColor;
}

@end

#pragma mark - CAPS Button

@interface CAPSButton ()
{
    UIColor *_highlightedColor;
    UIColor *_defaultTextColor;
    UIColor *_disabledTextColor;
    
    UIColor *_fillColor;
    UIColor *_borderColor;
    UIColor *_borderTextColor;
    
    CGFloat _cornerRadius;
    CGFloat _borderWidth;
    
    BOOL _hasBorderFill;
    BOOL _isPill;
    BOOL _isEnabled;
    BOOL _isLightColor;
    
    BOOL _isTapping;
}

@end

@implementation CAPSButton

#pragma mark - Initializers

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        // set defaults
        [self setPropertyDefaults];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // set defaults
        [self setPropertyDefaults];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        // set defaults
        [self setPropertyDefaults];
    }
    
    return self;
}

#pragma mark - Default Property Values

- (void)setPropertyDefaults
{
    _fillColor = [UIColor whiteColor];
    _borderColor = [UIColor blackColor];
    _borderTextColor = _fillColor;
    _cornerRadius = 0;
    _borderWidth = 0;
    
    _hasBorderFill = NO;
    _isPill = NO;
    _isEnabled = YES;
    
    _isLightColor = YES;
    _highlightedColor = [UIColor getColorForBrightness:_isLightColor withColor:_fillColor];
    
    _isTapping = NO;
}

#pragma mark - Update Button UI

- (void)updateButtonUserInterface
{
    self.layer.masksToBounds = YES;
    
    if (!_isTapping) {
        self.layer.borderWidth = _borderWidth;
        
        if (_isPill)
        {
            self.layer.cornerRadius = MIN(self.bounds.size.width, self.bounds.size.height) / 2.0;
        }
        else
        {
            self.layer.cornerRadius = _cornerRadius;
        }
        
        if (_isEnabled)
        {
            self.backgroundColor = _fillColor;
            
            [self setTitleColor:_defaultTextColor forState:UIControlStateNormal];
            self.layer.borderColor = _borderColor.CGColor;
        }
        else
        {
            self.backgroundColor = _highlightedColor;
            
            [self setTitleColor:_disabledTextColor forState:UIControlStateNormal];
            self.layer.borderColor = [UIColor getColorForBrightness:[UIColor isColorLight:_borderColor] withColor:_borderColor].CGColor;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self updateButtonUserInterface];
}

#pragma mark - Setters

- (void)setIsEnabled:(BOOL)isEnabled
{
    _isEnabled = isEnabled;
    [self updateButtonUserInterface];
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    [self updateButtonUserInterface];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    [self updateButtonUserInterface];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    if (_hasBorderFill) {
        _highlightedColor = _borderColor;
    }
    [self updateButtonUserInterface];
}

- (void)setHasBorderFill:(BOOL)hasBorderFill
{
    _hasBorderFill = hasBorderFill;
    if (hasBorderFill) {
        _highlightedColor = _borderColor;
    }
    [self updateButtonUserInterface];
}

- (void)setIsPill:(BOOL)isPill
{
    _isPill = isPill;
    [self updateButtonUserInterface];
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
    _highlightedColor = [UIColor getColorForBrightness:[UIColor isColorLight:fillColor] withColor:fillColor];
    _borderTextColor = _fillColor;
    [self updateButtonUserInterface];
}

- (void)setTextColor:(UIColor *)textColor
{
    _defaultTextColor = textColor;
    _disabledTextColor = [UIColor getColorForBrightness:[UIColor isColorLight:textColor] withColor:textColor];
    [self updateButtonUserInterface];
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isEnabled) {
        _isTapping = YES;
        
        self.backgroundColor = _highlightedColor;
        
        if (_hasBorderFill) {
            [self setTitleColor:_borderTextColor forState:UIControlStateNormal];
        }
        
        [super touchesBegan:touches withEvent:event];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isEnabled) {
        _isTapping = NO;
        
        self.backgroundColor = _fillColor;
        
        if (_hasBorderFill) {
            [self setTitleColor:_defaultTextColor forState:UIControlStateNormal];
        }
        
        [super touchesEnded:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isEnabled) {
        _isTapping = NO;
        
        self.backgroundColor = _fillColor;
        
        if (_hasBorderFill) {
            [self setTitleColor:_defaultTextColor forState:UIControlStateNormal];
        }
        
        [super touchesCancelled:touches withEvent:event];
    }
}


@end
