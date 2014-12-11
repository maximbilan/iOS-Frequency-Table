//
//  FrequencyTable.h
//  ios_frequency_table
//
//  Created by Maxim on 10/19/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrequencyTableRecord : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic) CGFloat value;

@end

@interface FrequencyTableRecordDerived : FrequencyTableRecord

@property (nonatomic) CGFloat percent;

@end

@interface FrequencyTable : UIView

- (instancetype)initWithPositionWithX:(CGFloat)x withY:(CGFloat)y isWideScreen:(BOOL)isWide;
- (void)setData:(NSArray *)array withTotal:(CGFloat)total;

@property (nonatomic, strong) NSString *title;
@property (nonatomic) BOOL isWideScreen;

@property (nonatomic) NSInteger maxRecordCount;

@property (nonatomic) CGFloat nameWidth;
@property (nonatomic) CGFloat percentWidth;
@property (nonatomic) CGFloat valueWidth;

@end
