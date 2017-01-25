//
//  KBTextView.m
//  BluetoothCheck
//
//  Created by Kamal on 6/3/16.
//  Copyright © 2016 Oleg. All rights reserved.
//

#import "KBTextView.h"

@implementation KBTextView

- (void)awakeFromNib{
    
    self.layer.cornerRadius = self.cornerRadius;
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = self.borderClolor.CGColor;
    self.clipsToBounds = true;
    
    if (self.enableAtSign || self.enableHashTag){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    
    CGFloat fontSize = self.font.pointSize;
    self.specialFont = [UIFont italicSystemFontOfSize:fontSize-1];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesturAction:)];
    [self addGestureRecognizer:tap];
}

- (void)setText:(NSString *)text{
    
    self.attributedText = [self customAttributedText:text];
}

- (void)setText:(NSString *)text withImage:(UIImage *)image{
    
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithAttributedString:[self customAttributedText:text]];
    [myString appendAttributedString:attachmentString];
//    [myString appendAttributedString:[self customAttributedText:text]];
    [self setAttributedText:myString];
    
}
- (NSAttributedString *)customAttributedText:(NSString *)inputString{
    
    NSArray *words = [inputString componentsSeparatedByString:@" "];
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((@|#)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+))|(http(s)?://([A-Z0-9a-z._-]*(/)?)*)" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:inputString];
    [attrString addAttribute:NSForegroundColorAttributeName value:self.preferredTextColor range:[inputString rangeOfString:inputString]];
    
    NSUInteger startLocation = 0;
    
    for (NSString *word in words)
    {
        NSRange wordSearchRange = NSMakeRange(startLocation, ([inputString length] - startLocation));
        
        NSTextCheckingResult *match = [regex firstMatchInString:word options:0 range:NSMakeRange(0, [word length])];
        NSString *tappableWord = [word substringWithRange:match.range];
        if ([tappableWord length] > 0)
        {
            NSRange matchRange = [inputString rangeOfString:word options:NSLiteralSearch range:wordSearchRange];
            if ([tappableWord hasPrefix:@"@"])
            {
                [attrString addAttribute:NSForegroundColorAttributeName value:self.atSignColor range:matchRange];
                if (self.specialFont){
                    [attrString addAttribute:NSFontAttributeName value: self.specialFont range:matchRange];
                }
            }
            else if ([tappableWord hasPrefix:@"#"])
            {
                [attrString addAttribute:NSForegroundColorAttributeName value:self.hashTagColor range:matchRange];
                if (self.specialFont) {
                    [attrString addAttribute:NSFontAttributeName value: self.specialFont range:matchRange];
                }
            }
        }
        startLocation += [word length];
    }
    return attrString;
}


- (void)textViewTextChanged:(NSNotification *)notobject{
    NSString *inputString = [self.attributedText string];
    [self setText:inputString];
}

- (void)tapGesturAction:(UITapGestureRecognizer *)tap{
    
    NSLayoutManager *layoutManager = self.layoutManager;
    CGPoint location = [tap locationInView:self];
    location.x -= self.textContainerInset.left;
    location.y -= self.textContainerInset.top;
    
    // Find the character that's been tapped on
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:self.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (characterIndex < self.text.length)
    {
        
        NSRange range;
        
        // this is done to get range only
        id value = [self.attributedText attribute:@"text" atIndex:characterIndex effectiveRange:&range];
        value=nil;
        
        // Handle as required...
        NSString *currentContext=[[self.attributedText string] substringWithRange:range];
        if (self.callBackAction != nil){
            self.callBackAction(currentContext);
        }
    }
}

@end
