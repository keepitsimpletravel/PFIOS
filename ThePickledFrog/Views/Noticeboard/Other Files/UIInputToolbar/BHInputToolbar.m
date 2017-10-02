/*
 *  UIInputToolbar.m
 *
 *  Created by Brandon Hamilton on 2011/05/03.
 *  Copyright 2011 Brandon Hamilton.
 *
 *  Permission is hereby granted, free of charge, to any person obtaining a copy
 *  of this software and associated documentation files (the "Software"), to deal
 *  in the Software without restriction, including without limitation the rights
 *  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  copies of the Software, and to permit persons to whom the Software is
 *  furnished to do so, subject to the following conditions:
 *
 *  The above copyright notice and this permission notice shall be included in
 *  all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 *  THE SOFTWARE.
 */

#import "BHInputToolbar.h"

@implementation BHInputToolbar

-(void)inputButtonPressed
{
    if ([self.inputDelegate respondsToSelector:@selector(inputButtonPressed:)])
    {
        [self.inputDelegate inputButtonPressed:self.textView.text];
    }

    /* Remove the keyboard and clear the text */
    [self.textView resignFirstResponder];
    [self.textView clearText];
}

-(void)inputCamButtonPressed
{
    NSLog(@"Cam Clicked");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SENDPHOTO" object:self];
}

-(void)setupToolbar:(NSString *)buttonLabel
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin; // ADDED THE CONSTRAINT TO PLACE AT THE BOTTOM
    self.tintColor = [UIColor lightGrayColor];
    
    /* Create custom send button*/
    UIImage *buttonImage = [UIImage imageNamed:@"send.png"];
    buttonImage          = [buttonImage stretchableImageWithLeftCapWidth:floorf(buttonImage.size.width/2) topCapHeight:floorf(buttonImage.size.height/2)];
    
    UIButton *button               = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font         = [UIFont boldSystemFontOfSize:15.0f];
    button.titleLabel.shadowOffset = CGSizeMake(0, -1);
    button.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    button.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
    button.contentMode             = UIViewContentModeScaleToFill;
    
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:buttonLabel forState:UIControlStateNormal];
    [button addTarget:self action:@selector(inputButtonPressed) forControlEvents:UIControlEventTouchDown];
    [button sizeToFit];
    
    self.inputButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.inputButton.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    /* Disable button initially */
    self.inputButton.enabled = NO;
    
    //Camera
    UIImage *buttonImageCam = [UIImage imageNamed:@"btnCamera.png"];
    buttonImageCam          = [buttonImageCam stretchableImageWithLeftCapWidth:floorf(buttonImageCam.size.width/2) topCapHeight:floorf(buttonImageCam.size.height/2)];
    
    UIButton *btnCam               = [UIButton buttonWithType:UIButtonTypeCustom];
    btnCam.titleLabel.font         = [UIFont boldSystemFontOfSize:15.0f];
    btnCam.titleLabel.shadowOffset = CGSizeMake(0, -1);
    btnCam.titleEdgeInsets         = UIEdgeInsetsMake(0, 2, 0, 2);
    btnCam.contentStretch          = CGRectMake(0.5, 0.5, 0, 0);
    btnCam.contentMode             = UIViewContentModeScaleToFill;
    
    [btnCam setBackgroundImage:buttonImageCam forState:UIControlStateNormal];
    [btnCam setTitle:buttonLabel forState:UIControlStateNormal];
    [btnCam addTarget:self action:@selector(inputCamButtonPressed) forControlEvents:UIControlEventTouchDown];
    [btnCam sizeToFit];
    
    self.inputButtonCam = [[UIBarButtonItem alloc] initWithCustomView:btnCam];
//    self.inputButtonCam.customView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    self.inputButtonCam.customView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    /* Disable button initially */
    self.inputButtonCam.enabled = YES;
    
    /* Create UIExpandingTextView input */
    self.textView = [[BHExpandingTextView alloc] initWithFrame:CGRectMake(40, 7, self.bounds.size.width - 70, 26)];
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
    self.textView.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    self.textView.delegate = self;
    [self addSubview:self.textView];
    
    /* Right align the toolbar button */
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSArray *items = [NSArray arrayWithObjects: flexItem, self.inputButton,self.inputButtonCam, nil];
    [self setItems:items animated:NO];
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //
    //    [[NSNotificationCenter defaultCenter] addObserver:self
    //                                             selector:@selector(changeInputMode:)
    //                                                 name:UITextInputCurrentInputModeDidChangeNotification object:nil];
}

-(id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        [self setupToolbar:@""];
    }
    return self;
}

-(id)init
{
    if ((self = [super init])) {
        [self setupToolbar:@""];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    /* Draw custon toolbar background */
    UIImage *backgroundImage = [UIImage imageNamed:@"toolbarbg.png"];
    backgroundImage = [backgroundImage stretchableImageWithLeftCapWidth:floorf(backgroundImage.size.width/2) topCapHeight:floorf(backgroundImage.size.height/2)];
    [backgroundImage drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];

    CGRect i = self.inputButton.customView.frame;
    i.origin.y = self.frame.size.height - i.size.height -3;
    i.origin.x = self.frame.size.width - i.size.width +1;
    self.inputButton.customView.frame = i;
    
    CGRect j = self.inputButtonCam.customView.frame;
    
    NSLog(@"x: %f", self.frame.size.width - j.size.width -285);
    NSLog(@"y: %f)", self.frame.size.height - j.size.height -3);
    
    
    j.origin.y = self.frame.size.height - j.size.height -3;
//    j.origin.x = self.frame.size.width - j.size.width -285;
    j.origin.x = 0;
    self.inputButtonCam.customView.frame = j;
}

#pragma mark -
#pragma mark UIExpandingTextView delegate

-(void)expandingTextView:(BHExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (self.textView.frame.size.height - height);
    CGRect r = self.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    self.frame = r;
    if ([self.inputDelegate respondsToSelector:_cmd]) {
        [self.inputDelegate expandingTextView:expandingTextView willChangeHeight:height];
    }
}

-(void)expandingTextViewDidChange:(BHExpandingTextView *)expandingTextView
{
    /* Enable/Disable the button */
    if ([expandingTextView.text length] > 0)
        self.inputButton.enabled = YES;
    else
        self.inputButton.enabled = NO;
    if ([self.inputDelegate respondsToSelector:@selector(expandingTextViewDidChange:)])
        [self.inputDelegate expandingTextViewDidChange:expandingTextView];
}

- (BOOL)expandingTextViewShouldReturn:(BHExpandingTextView *)expandingTextView
{
    if ([self.inputDelegate respondsToSelector:_cmd]) {
        return [self.inputDelegate expandingTextViewShouldReturn:expandingTextView];
    }
    
    return YES;
}

- (BOOL)expandingTextViewShouldBeginEditing:(BHExpandingTextView *)expandingTextView
{
    if ([self.inputDelegate respondsToSelector:_cmd]) {
        
        return [self.inputDelegate expandingTextViewShouldBeginEditing:expandingTextView];
    }
    return YES;
}

- (BOOL)expandingTextViewShouldEndEditing:(BHExpandingTextView *)expandingTextView
{
    if ([self.inputDelegate respondsToSelector:_cmd]) {
        return [self.inputDelegate expandingTextViewShouldEndEditing:expandingTextView];
    }
    return YES;
}

- (void)expandingTextViewDidBeginEditing:(BHExpandingTextView *)expandingTextView
{
    if ([self.inputDelegate respondsToSelector:_cmd]) {
        
        [self.inputDelegate expandingTextViewDidBeginEditing:expandingTextView];
    }
}

- (void)expandingTextViewDidEndEditing:(BHExpandingTextView *)expandingTextView
{
    if ([self.inputDelegate respondsToSelector:_cmd]) {
        [self.inputDelegate expandingTextViewDidEndEditing:expandingTextView];
    }
}

- (BOOL)expandingTextView:(BHExpandingTextView *)expandingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([self.inputDelegate respondsToSelector:_cmd]) {
        return [self.inputDelegate expandingTextView:expandingTextView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)expandingTextView:(BHExpandingTextView *)expandingTextView didChangeHeight:(float)height
{
    if ([self.inputDelegate respondsToSelector:_cmd]) {
        [self.inputDelegate expandingTextView:expandingTextView didChangeHeight:height];
    }
}

- (void)expandingTextViewDidChangeSelection:(BHExpandingTextView *)expandingTextView
{
    if ([self.inputDelegate respondsToSelector:_cmd]) {
        [self.inputDelegate expandingTextViewDidChangeSelection:expandingTextView];
    }
}

//- (void)keyboardWillChangeFrame:(NSNotification*)notification
//{
//    NSDictionary* keyboardInfo = [notification userInfo];
//    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
//    CGRect toolBarFrame = self.frame;
//    toolBarFrame.origin.y = keyboardFrameBeginRect.origin.y - toolBarFrame.size.height;
//    self.frame = toolBarFrame;
//}
//
//-(void)changeInputMode:(NSNotification *)notification
//{
//    NSString *inputMethod = [[UITextInputMode currentInputMode] primaryLanguage];
//    NSLog(@"inputMethod=%@",inputMethod);
//    
//    if ([inputMethod isEqualToString:@"emoji"]) {
//        self.frame = CGRectMake(0, 315-40, self.frame.size.width, self.frame.size.height);
//    }
//}
@end
