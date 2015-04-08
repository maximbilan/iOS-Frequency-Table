//
//  FrequencyTable.m
//  ios_frequency_table
//
//  Created by Maxim on 10/19/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "FrequencyTable.h"

static const NSInteger kFrequencyTableMaxRecordCount = 10;

static NSString * const kFrequencyTableDefaultFont	= @"TrebuchetMS";
static const CGFloat kFrequencyTableRecordFontSize	= 16;
static const CGFloat kFrequencyTableHeaderFontSize	= 18;
static const CGFloat kFrequencyTableLineWidth		= 1.0;

static const CGFloat kFrequencyTableXOffset			= 10;
static const CGFloat kFrequencyTableYOffset			= 30;
static const CGFloat kFrequencyTableYWideOffset		= 40;
static const CGFloat kFrequencyTableNameWidth		= 140;
static const CGFloat kFrequencyTablePercentWidth	= 45;
static const CGFloat kFrequencyTableValueWidth		= 85;
static const CGFloat kFrequencyTableCellHeight		= 25;
static const CGFloat kFrequencyTableCellWideHeight	= 30;
static const CGFloat kFrequencyTableTotalOffsetY	= 10;

static NSString * const kFrequencyTableTitleName		= @"Category";
static NSString * const kFrequencyTableTitlePercent     = @"%";
static NSString * const kFrequencyTableTitleValue       = @"total";

static NSString * const kFrequencyTableValueFormat      = @"%.01f";
static NSString * const kFrequencyTablePercentFormat	= @"%.01f";

@implementation FrequencyTableRecord

@end

@implementation FrequencyTableRecordDerived

@end

@interface FrequencyTable ()
{
    CGFloat	posX;
    CGFloat	posY;
    CGFloat totalData;
    NSMutableArray *data;
}

- (NSDictionary *)generateAttributes:(NSString *)fontName withFontSize:(CGFloat)fontSize withColor:(UIColor *)color withAlignment:(NSTextAlignment)textAlignment;
- (void)addRecordToTableData:(NSString *)name withValue:(CGFloat)value withTotal:(CGFloat)total;

@property (NS_NONATOMIC_IOSONLY, readonly) CGRect computeFrameRect;

@end

@implementation FrequencyTable

- (instancetype)init
{
	self = [self initWithPositionWithX:0.0 withY:0.0 isWideScreen:NO];
	return self;
}

- (instancetype)initWithPositionWithX:(CGFloat)x withY:(CGFloat)y isWideScreen:(BOOL)isWide
{
	posX = x;
	posY = y;
	self.isWideScreen = isWide;
	
	CGFloat cellHeight = (_isWideScreen) ? kFrequencyTableCellWideHeight : kFrequencyTableCellHeight;
	CGFloat tableYOffset = (_isWideScreen) ? kFrequencyTableYWideOffset : kFrequencyTableYOffset;
	CGFloat width = (2 * kFrequencyTableXOffset) + kFrequencyTableNameWidth + kFrequencyTablePercentWidth + kFrequencyTableValueWidth;
	CGFloat height = cellHeight * self.maxRecordCount + (2 * tableYOffset) + kFrequencyTableTotalOffsetY;
	
	self = [self initWithFrame:CGRectMake(x, y, width, height)];
	return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        data = [[NSMutableArray alloc] init];
		totalData = 0.0;
		self.title = kFrequencyTableTitleName;
        self.maxRecordCount = kFrequencyTableMaxRecordCount;
        self.nameWidth = kFrequencyTableNameWidth;
        self.percentWidth = kFrequencyTablePercentWidth;
        self.valueWidth = kFrequencyTableValueWidth;
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    posX = self.frame.origin.x;
    posY = self.frame.origin.y;
    data = [[NSMutableArray alloc] init];
    totalData = 0.0;
    self.title = kFrequencyTableTitleName;
    self.maxRecordCount = kFrequencyTableMaxRecordCount;
    self.isWideScreen = YES;
    self.nameWidth = kFrequencyTableNameWidth;
    self.percentWidth = kFrequencyTablePercentWidth;
    self.valueWidth = kFrequencyTableValueWidth;
}

- (CGRect)computeFrameRect
{
	CGFloat cellHeight = (_isWideScreen) ? kFrequencyTableCellWideHeight : kFrequencyTableCellHeight;
	CGFloat tableYOffset = (_isWideScreen) ? kFrequencyTableYWideOffset : kFrequencyTableYOffset;
	CGFloat width = (2 * kFrequencyTableXOffset) + self.nameWidth + self.percentWidth + self.valueWidth;
	CGFloat height = cellHeight * self.maxRecordCount + (2 * tableYOffset) + kFrequencyTableTotalOffsetY;
	
	return CGRectMake(posX, posY, width, height);
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect(context, rect);
	
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextFillRect(context, rect);
	
	// Define general sizes
	CGFloat viewWidth = CGRectGetWidth(rect);
    CGFloat cellNameWidth = self.nameWidth;
	CGFloat cellValueWidth = self.valueWidth;
	CGFloat cellPercentWidth = self.percentWidth;
	CGFloat cellHeight = (_isWideScreen) ? kFrequencyTableCellWideHeight : kFrequencyTableCellHeight;
	CGFloat tableXOffset = kFrequencyTableXOffset;
	CGFloat tableYOffset = (_isWideScreen) ? kFrequencyTableYWideOffset : kFrequencyTableYOffset;
	CGFloat tableTotalYOffset = kFrequencyTableTotalOffsetY;
	CGFloat tableMaxRecords = self.maxRecordCount;
	
	// Define attributes
	NSDictionary *attributesTitleLeft = [self generateAttributes:kFrequencyTableDefaultFont
													withFontSize:kFrequencyTableHeaderFontSize
													   withColor:[UIColor blackColor]
												   withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentLeft)];
	
	NSDictionary *attributesTitleRight = [self generateAttributes:kFrequencyTableDefaultFont
													 withFontSize:kFrequencyTableHeaderFontSize
														withColor:[UIColor blackColor]
													withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentRight)];
	
	NSDictionary *attributesBlackLeft = [self generateAttributes:kFrequencyTableDefaultFont
													withFontSize:kFrequencyTableRecordFontSize
													   withColor:[UIColor blackColor]
												   withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentLeft)];
	
	NSDictionary *attributesBlackRight = [self generateAttributes:kFrequencyTableDefaultFont
													 withFontSize:kFrequencyTableRecordFontSize
														withColor:[UIColor blackColor]
													withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentRight)];
	
	// Draw lines
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, kFrequencyTableLineWidth);
    CGContextMoveToPoint(context, 0, cellHeight);
    CGContextAddLineToPoint(context, viewWidth, cellHeight);
	CGContextStrokePath(context);
	
	CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor( context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, kFrequencyTableLineWidth);
    CGContextMoveToPoint(context, 0, cellHeight * tableMaxRecords + tableYOffset);
    CGContextAddLineToPoint(context, viewWidth, cellHeight * tableMaxRecords + tableYOffset);
	CGContextStrokePath(context);
	
	// Draw titles
	[self.title drawInRect:CGRectMake(tableXOffset, 0, cellNameWidth, cellHeight) withAttributes:attributesTitleLeft];
	
	NSString *percentTitle = kFrequencyTableTitlePercent;
	[percentTitle drawInRect:CGRectMake(cellNameWidth + tableXOffset, 0, cellPercentWidth, cellHeight) withAttributes:attributesTitleRight];
	
	NSString *valueTitle = kFrequencyTableTitleValue;
	[valueTitle drawInRect:CGRectMake(cellNameWidth + cellPercentWidth + tableXOffset, 0, cellValueWidth, cellHeight) withAttributes:attributesTitleRight];
	
	// Draw table
	CGFloat x = tableXOffset;
	CGFloat y = tableYOffset;
    for(FrequencyTableRecordDerived *record in data) {
		NSString *name = record.name;
		NSString *percent = [NSString stringWithFormat:kFrequencyTablePercentFormat, record.percent];
		NSString *value = [NSString stringWithFormat:kFrequencyTableValueFormat, record.value];
		
		[name drawInRect:CGRectMake(x, y, cellNameWidth, cellHeight) withAttributes:attributesBlackLeft];
		[percent drawInRect:CGRectMake(x + cellNameWidth, y, cellPercentWidth, cellHeight) withAttributes:attributesBlackRight];
		[value drawInRect:CGRectMake(x + cellNameWidth + cellPercentWidth,y, cellValueWidth, cellHeight) withAttributes:attributesBlackRight];
		
		y += cellHeight;
	}
	
	// Draw total value
	NSString *totalValue = [NSString stringWithFormat:kFrequencyTableValueFormat, totalData];
	[totalValue drawInRect:CGRectMake(x + cellNameWidth + cellPercentWidth, cellHeight * tableMaxRecords + tableYOffset + tableTotalYOffset, cellValueWidth, cellPercentWidth)
            withAttributes:attributesBlackRight];
}

- (void)setData:(NSArray *)array withTotal:(CGFloat)total
{
	[data removeAllObjects];
	
    NSSortDescriptor *sortDescriptorValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO];
	NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = @[sortDescriptorValue, sortDescriptorName];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
	NSInteger index = 0;
	CGFloat otherValue = 0.0;
	BOOL moreThanMaxRecordsCount = NO;
	for (FrequencyTableRecord *record in sortedArray) {
		if (index >= self.maxRecordCount - 1) {
			moreThanMaxRecordsCount = YES;
			otherValue += record.value;
		}
		else {
			[self addRecordToTableData:record.name withValue:record.value withTotal:total];
		}
		
		++index;
	}
	
	if (moreThanMaxRecordsCount) {
		[self addRecordToTableData:@"Other" withValue:otherValue withTotal:total];
	}
	
	totalData = total;
	
	[self setNeedsDisplay];
}

- (void)addRecordToTableData:(NSString *)name withValue:(CGFloat)value withTotal:(CGFloat)total
{
	FrequencyTableRecordDerived* derivedRecord = [[FrequencyTableRecordDerived alloc] init];
	derivedRecord.name = name;
	derivedRecord.value = value;
	derivedRecord.percent = (derivedRecord.value * 100.0) / total;
	
	[data addObject:derivedRecord];
}

- (NSDictionary *)generateAttributes:(NSString *)fontName withFontSize:(CGFloat)fontSize withColor:(UIColor *)color withAlignment:(NSTextAlignment)textAlignment
{
	NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setAlignment:textAlignment];
	[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	
	NSDictionary * attrs = @{
							 NSFontAttributeName : [UIFont fontWithName:fontName size:fontSize],
							 NSForegroundColorAttributeName : color,
							 NSParagraphStyleAttributeName : paragraphStyle
							 };
	
	return attrs;
}

- (void)setIsWideScreen:(BOOL)isWideScreen
{
	_isWideScreen = isWideScreen;
	self.frame = [self computeFrameRect];
	[self setNeedsDisplay];
}

@end
