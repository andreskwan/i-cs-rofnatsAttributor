//
//  TextStatsViewController.m
//  v4FontsAndAtrributedStrings
//
//  Created by Andres Kwan on 10/27/14.
//  Copyright (c) 2014 Kwan. All rights reserved.
//

#import "TextStatsViewController.h"

@interface TextStatsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *colorfulCharactersLabel;
@property (weak, nonatomic) IBOutlet UILabel *outlinedCharactersLabel;

@end

@implementation TextStatsViewController

-(void)setTextToAnalyze:(NSAttributedString *)textToAnalyze
{
    _textToAnalyze = textToAnalyze;
    if (self.view.window) {
        [self updateUI];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@",@"viewWillAppear");
    [self updateUI];
}

-(void)updateUI
{
    //1 identify chars with attribute XXX
    //2 length of the string with characters that share the same attribute
    //3 pass this lenght to the label
    self.colorfulCharactersLabel.text =  [NSString stringWithFormat:@"%lu colorful characters", (unsigned long)[[self charactersWithAttribute:NSForegroundColorAttributeName] length] ];
    self.outlinedCharactersLabel.text =  [NSString stringWithFormat:@"%lu outlined characters", (unsigned long)[[self charactersWithAttribute:NSStrokeWidthAttributeName] length] ];
}

-(NSAttributedString *)charactersWithAttribute:(NSString *) attributedName
{
    //local var to pollulled with data from the inspection of the
    //specific attribute described by attributedName
    NSMutableAttributedString * characters = [[NSMutableAttributedString alloc]init];
    
    //now analyze to identify the range of chars that chare the same attributedName

    int index = 0;
    while (index < [self.textToAnalyze length]) {
        NSRange range;
        id value = [self.textToAnalyze attribute:attributedName
                                         atIndex:index
                                  effectiveRange:&range];

        //if value is nill didnt find any character with
        //the specified attributedName
        if (value) {
            //append an attributed string to the characters
            //attributed string
            [characters appendAttributedString:
             //extract the range of characters with the attribute
             //specified.
             [self.textToAnalyze attributedSubstringFromRange:range]];
            //set the new index after the range
            index = range.location + range.length;
        } else {
            //if not found at this index, go to the next.
            index++;
        }
    }
    return characters;
}

@end
