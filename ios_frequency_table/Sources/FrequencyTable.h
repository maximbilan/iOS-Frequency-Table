//
//  FrequencyTable.h
//  ios_frequency_table
//
//  Created by Maxim on 10/19/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrequencyTableRecord : NSObject

@property (nonatomic, strong)  NSString *name;
@property (nonatomic) float value;

@end

@interface FrequencyTableRecordDerived : FrequencyTableRecord

@property (nonatomic) float percent;

@end

@interface FrequencyTable : UIView

- (id)initWithPositionWithX:(CGFloat)x withY:(CGFloat)y isWideScreen:(BOOL)isWide;
- (void)setData:(NSArray *)array withTotal:(float)total;

@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL isWideScreen;

@end
