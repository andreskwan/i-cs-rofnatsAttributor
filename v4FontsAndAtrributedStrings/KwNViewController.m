//
//  KwNViewController.m
//  v4FontsAndAtrributedStrings
//
//  Created by Andres Kwan on 11/20/13.
//  Copyright (c) 2013 Kwan. All rights reserved.
//

#import "KwNViewController.h"


@interface KwNViewController ()
@property (weak, nonatomic) IBOutlet UITextView *body;
@property (weak, nonatomic) IBOutlet UILabel    *headLine;
@property (weak, nonatomic) IBOutlet UILabel    *bodySelectedText;
@property (weak, nonatomic) IBOutlet UIButton   *outlineButton;


@end

@implementation KwNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //1 create a attributed string for the buttonTitle
    NSMutableAttributedString * buttonTitle =
    [[NSMutableAttributedString alloc] initWithString:self.outlineButton.currentTitle];
    
    //2 set attributes for the buttonTitle
    [buttonTitle setAttributes:@{NSStrokeWidthAttributeName: @4,
                                  NSStrokeColorAttributeName: self.outlineButton.tintColor}
                          range:NSMakeRange(0, [buttonTitle length])];
     
    //3 set back the button title with the attributes configured here
    [self.outlineButton setAttributedTitle:buttonTitle forState:UIControlStateNormal];
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(preferredFontsChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (void)preferredFontsChanged:(NSNotification *)notification
{
    [self usePreferredFonts];
}


- (void) usePreferredFonts
{
    self.body.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.headLine.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}


- (IBAction)changeBodySelectionColorToMatchBackgroundOfButton:(UIButton *)sender {
    NSDictionary * attributesToSet = @{NSForegroundColorAttributeName : sender.backgroundColor};
    
    //I'm taking all the attributes of the all textStorage
    //I just have to take the one that correspond to the selection
    NSDictionary * currentAttributes = [self.body.textStorage attributesAtIndex:0 longestEffectiveRange:nil inRange:self.body.selectedRange];
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:currentAttributes];
    
    [newAttributes addEntriesFromDictionary:attributesToSet];

    
    NSString * aStrig = [[self.body.textStorage attributedSubstringFromRange:self.body.selectedRange] string];
    
    [self.body.textStorage addAttributes:[newAttributes copy]
                                  range:self.body.selectedRange];
    
    [self changeTextAttributesOfLabelToMatchSelectedBodyString:aStrig
                                                withAttributes:[newAttributes copy]];
    
    currentAttributes = [self.body.textStorage attributesAtIndex:0 effectiveRange:NULL];
    
//    [self.body.textStorage addAttribute:NSForegroundColorAttributeName
//                                  value:sender.backgroundColor
//                                  range:self.body.selectedRange];

}
- (IBAction)outlineBodyTextSelection {
    NSDictionary * attributesToSet = @{NSStrokeWidthAttributeName : @-3,
                                       NSStrokeColorAttributeName :[UIColor blackColor]};

    NSDictionary * currentAttributes = [self.body.textStorage attributesAtIndex:1
                                                          longestEffectiveRange:nil
                                                                        inRange:self.body.selectedRange];
    
    NSMutableDictionary *newAttributes = [[NSMutableDictionary alloc] initWithDictionary:currentAttributes];
    
    [newAttributes addEntriesFromDictionary:attributesToSet];
    
    
    NSString * aStrig = [[self.body.textStorage attributedSubstringFromRange:self.body.selectedRange] string];
    
    [self.body.textStorage addAttributes:newAttributes
                                   range:self.body.selectedRange];
    
    
    
    [self changeTextAttributesOfLabelToMatchSelectedBodyString:aStrig
                                                withAttributes:newAttributes];
    
//    currentAttributes = [self.body.textStorage attributesAtIndex:1
//                                           longestEffectiveRange:nil
//                                                         inRange:self.body.selectedRange];
    
}

- (IBAction)unoutlineBodyTextSelection {
    [self.body.textStorage removeAttribute:NSStrokeWidthAttributeName range:self.body.selectedRange];

}

#pragma mark - UILabel 
- (void)changeTextAttributesOfLabelToMatchSelectedBodyString:(NSString *)aString withAttributes:(NSDictionary *)attributes
{
    //1 create a attributed string
    NSMutableAttributedString * text =
    [[NSMutableAttributedString alloc] initWithString:aString];
    
    //2 set attributes
    [text setAttributes:attributes
                  range:NSMakeRange(0, [aString length])];
    
    //3 set back the button title with the attributes configured here
    [self.bodySelectedText setAttributedText:text];
}
@end
