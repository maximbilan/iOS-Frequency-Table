//
//  ViewController.m
//  ios_frequency_table
//
//  Created by Maxim Bilan on 1/25/14.
//  Copyright (c) 2014 Maxim Bilan. All rights reserved.
//

#import "ViewController.h"

#import "FrequencyTable.h"

#define RAND_FROM_TO(min,max) (min + arc4random_uniform(max - min + 1))

@interface ViewController ()

@property (weak, nonatomic) IBOutlet FrequencyTable *frequencyTable;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL isWide = (BOOL)(fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON);
    self.frequencyTable.isWideScreen = (isWide || ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad));
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    float total = 0.0;
    for (NSInteger i = 0; i < 50; ++i) {
        FrequencyTableRecord *record = [[FrequencyTableRecord alloc] init];
        record.name = [NSString stringWithFormat:@"Item %d", i];
        record.value = RAND_FROM_TO(1, 500);
        total += record.value;
        [array addObject:record];
    }
    
    [self.frequencyTable setData:array withTotal:total];
    
	[self.view addSubview:self.frequencyTable];
}

@end
