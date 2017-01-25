//
//  KBTextView.h
//  BluetoothCheck
//
//  Created by Kamal on 6/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^callTagPressed)(NSString* tag);

IB_DESIGNABLE

@interface KBTextView : UITextView

@property (nonatomic, retain) IBInspectable UIColor *borderClolor;
@property (assign, nonatomic) IBInspectable CGFloat borderWidth;
@property (assign, nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic, retain) IBInspectable UIColor *hashTagColor;
@property (nonatomic, retain) IBInspectable UIColor *atSignColor;
@property (nonatomic, retain) IBInspectable UIColor *preferredTextColor;

@property (nonatomic, assign) IBInspectable BOOL enableHashTag;
@property (nonatomic, assign) IBInspectable BOOL enableAtSign;

@property (nonatomic, assign) UIFont *specialFont;

@property (copy, nonatomic) callTagPressed callBackAction;

- (void)setText:(NSString *)text withImage:(UIImage *)image;

@end
