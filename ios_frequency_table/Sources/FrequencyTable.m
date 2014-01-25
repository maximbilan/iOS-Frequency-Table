//
//  FrequencyTable.m
//  ios_frequency_table
//
//  Created by Maxim on 10/19/13.
//  Copyright (c) 2013 Maxim. All rights reserved.
//

#import "FrequencyTable.h"

static const int FrequencyTableMaxRecordCount		= 10;

static NSString * const FrequencyTableDefaultFont	= @"TrebuchetMS";
static const CGFloat FrequencyTableRecordFontSize	= 16;
static const CGFloat FrequencyTableHeaderFontSize	= 18;
static const CGFloat FrequencyTableLineWidth		= 1.0f;

static const CGFloat FrequencyTableXOffset			= 10;
static const CGFloat FrequencyTableYOffset			= 30;
static const CGFloat FrequencyTableYWideOffset		= 40;
static const CGFloat FrequencyTableNameWidth		= 150;
static const CGFloat FrequencyTablePercentWidth		= 45;
static const CGFloat FrequencyTableValueWidth		= 65;
static const CGFloat FrequencyTableCellHeight		= 25;
static const CGFloat FrequencyTableCellWideHeight	= 30;
static const CGFloat FrequencyTableTotalOffsetY		= 10;

static NSString * const FrequencyTableTitleName		= @"Category";
static NSString * const FrequencyTableTitlePercent	= @"%";
static NSString * const FrequencyTableTitleValue	= @"total";

static NSString * const FrequencyTableValueFormat	= @"%.01f";
static NSString * const FrequencyTablePercentFormat	= @"%.01f";

@implementation FrequencyTableRecord

@synthesize name;
@synthesize value;

@end

@implementation FrequencyTableRecordDerived

@synthesize percent;

@end

@interface FrequencyTable ()

- (NSDictionary *)generateAttributes:(NSString *)fontName withFontSize:(CGFloat)fontSize withColor:(UIColor *)color withAlignment:(NSTextAlignment)textAlignment;
- (void)addRecordToTableData:(NSString *)name withValue:(float)value withTotal:(float)total;
- (CGRect)computeFrameRect;

@end

@implementation FrequencyTable

@synthesize title = _title;
@synthesize isWideScreen = _isWideScreen;

- (id)init
{
	self = [self initWithPosition:0 y:0 isWideScreen:NO];
	return self;
}

- (id)initWithPosition:(CGFloat)x y:(CGFloat)y isWideScreen:(BOOL)isWide
{
	posX = x;
	posY = y;
	_isWideScreen = isWide;
	
	CGFloat cellHeight = ( _isWideScreen ) ? FrequencyTableCellWideHeight : FrequencyTableCellHeight;
	CGFloat tableYOffset = ( _isWideScreen ) ? FrequencyTableYWideOffset : FrequencyTableYOffset;
	CGFloat width = ( 2 * FrequencyTableXOffset ) + FrequencyTableNameWidth + FrequencyTablePercentWidth + FrequencyTableValueWidth;
	CGFloat height = cellHeight * FrequencyTableMaxRecordCount + ( 2 * tableYOffset ) + FrequencyTableTotalOffsetY;
	
	self = [self initWithFrame:CGRectMake( x, y, width, height)];
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if( self )
	{
        data = [[NSMutableArray alloc] init];
		totalData = 0.0f;
		_title = FrequencyTableTitleName;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _isWideScreen = YES;
}

- (CGRect)computeFrameRect
{
	CGFloat cellHeight = ( _isWideScreen ) ? FrequencyTableCellWideHeight : FrequencyTableCellHeight;
	CGFloat tableYOffset = ( _isWideScreen ) ? FrequencyTableYWideOffset : FrequencyTableYOffset;
	CGFloat width = ( 2 * FrequencyTableXOffset ) + FrequencyTableNameWidth + FrequencyTablePercentWidth + FrequencyTableValueWidth;
	CGFloat height = cellHeight * FrequencyTableMaxRecordCount + ( 2 * tableYOffset ) + FrequencyTableTotalOffsetY;
	
	return CGRectMake( posX, posY, width, height );
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextClearRect( context, rect );
	
	CGContextSetFillColorWithColor( context, [UIColor whiteColor].CGColor );
	CGContextFillRect( context, rect );
	
	// Define general sizes
	CGFloat viewWidth = CGRectGetWidth( rect );
	CGFloat cellNameWidth = FrequencyTableNameWidth;
	CGFloat cellValueWidth = FrequencyTableValueWidth;
	CGFloat cellPercentWidth = FrequencyTablePercentWidth;
	CGFloat cellHeight = ( _isWideScreen ) ? FrequencyTableCellWideHeight : FrequencyTableCellHeight;
	CGFloat tableXOffset = FrequencyTableXOffset;
	CGFloat tableYOffset = ( _isWideScreen ) ? FrequencyTableYWideOffset : FrequencyTableYOffset;
	CGFloat tableTotalYOffset = FrequencyTableTotalOffsetY;
	CGFloat tableMaxRecords = FrequencyTableMaxRecordCount;
	
	// Define attributes
	NSDictionary *attributesTitleLeft = [self generateAttributes:FrequencyTableDefaultFont
													withFontSize:FrequencyTableHeaderFontSize
													   withColor:[UIColor blackColor]
												   withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentLeft)];
	
	NSDictionary *attributesTitleRight = [self generateAttributes:FrequencyTableDefaultFont
													 withFontSize:FrequencyTableHeaderFontSize
														withColor:[UIColor blackColor]
													withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentRight)];
	
	NSDictionary *attributesBlackLeft = [self generateAttributes:FrequencyTableDefaultFont
													withFontSize:FrequencyTableRecordFontSize
													   withColor:[UIColor blackColor]
												   withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentLeft)];
	
	NSDictionary *attributesBlackRight = [self generateAttributes:FrequencyTableDefaultFont
													 withFontSize:FrequencyTableRecordFontSize
														withColor:[UIColor blackColor]
													withAlignment:NSTextAlignmentFromCTTextAlignment(kCTTextAlignmentRight)];
	
	// Draw lines
	CGContextSetFillColorWithColor( context, [UIColor blackColor].CGColor );
	CGContextSetLineCap( context, kCGLineCapSquare );
    CGContextSetStrokeColorWithColor( context, [UIColor blackColor].CGColor );
    CGContextSetLineWidth( context, FrequencyTableLineWidth );
    CGContextMoveToPoint( context, 0, cellHeight );
    CGContextAddLineToPoint( context, viewWidth, cellHeight );
	CGContextStrokePath( context );
	
	CGContextSetFillColorWithColor( context, [UIColor blackColor].CGColor );
	CGContextSetLineCap( context, kCGLineCapSquare );
    CGContextSetStrokeColorWithColor( context, [UIColor blackColor].CGColor );
    CGContextSetLineWidth( context, FrequencyTableLineWidth );
    CGContextMoveToPoint( context, 0, cellHeight * tableMaxRecords + tableYOffset );
    CGContextAddLineToPoint( context, viewWidth, cellHeight * tableMaxRecords + tableYOffset );
	CGContextStrokePath( context );
	
	// Draw titles
	[_title drawInRect:CGRectMake( tableXOffset, 0, cellNameWidth, cellHeight) withAttributes:attributesTitleLeft];
	
	NSString *percentTitle = FrequencyTableTitlePercent;
	[percentTitle drawInRect:CGRectMake( cellNameWidth + tableXOffset, 0, cellPercentWidth, cellHeight ) withAttributes:attributesTitleRight];
	
	NSString *valueTitle = FrequencyTableTitleValue;
	[valueTitle drawInRect:CGRectMake( cellNameWidth+cellPercentWidth + tableXOffset, 0, cellValueWidth, cellHeight) withAttributes:attributesTitleRight];
	
	// Draw table
	CGFloat x = tableXOffset;
	CGFloat y = tableYOffset;
    for( FrequencyTableRecordDerived *record in data )
	{
		NSString *name = record.name;
		NSString *percent = [NSString stringWithFormat:FrequencyTablePercentFormat, record.percent];
		NSString *value = [NSString stringWithFormat:FrequencyTableValueFormat, record.value];
		
		[name drawInRect:CGRectMake( x, y, cellNameWidth, cellHeight ) withAttributes:attributesBlackLeft];
		[percent drawInRect:CGRectMake( x + cellNameWidth, y, cellPercentWidth, cellHeight ) withAttributes:attributesBlackRight];
		[value drawInRect:CGRectMake( x + cellNameWidth + cellPercentWidth,y, cellValueWidth, cellHeight ) withAttributes:attributesBlackRight];
		
		y += cellHeight;
	}
	
	// Draw total value
	NSString *totalValue = [NSString stringWithFormat:FrequencyTableValueFormat, totalData];
	[totalValue drawInRect:CGRectMake(x + cellNameWidth + cellPercentWidth, cellHeight * tableMaxRecords + tableYOffset + tableTotalYOffset, cellValueWidth, cellPercentWidth )
            withAttributes:attributesBlackRight];
}

- (void)setData:(NSArray *)array withTotal:(float)total
{
	[data removeAllObjects];
	
    NSSortDescriptor *sortDescriptorValue = [[NSSortDescriptor alloc] initWithKey:@"value" ascending:NO];
	NSSortDescriptor *sortDescriptorName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:NO];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptorValue, sortDescriptorName, nil];
    NSArray *sortedArray = [array sortedArrayUsingDescriptors:sortDescriptors];
    
	int index = 0;
	float otherValue = 0.0f;
	BOOL moreThanMaxRecordsCount = NO;
	for( FrequencyTableRecord *record in sortedArray )
	{
		if( index >= FrequencyTableMaxRecordCount - 1 )
		{
			moreThanMaxRecordsCount = YES;
			otherValue += record.value;
		}
		else
		{
			[self addRecordToTableData:record.name withValue:record.value withTotal:total];
		}
		
		++index;
	}
	
	if( moreThanMaxRecordsCount )
	{
		[self addRecordToTableData:@"Other" withValue:otherValue withTotal:total];
	}
	
	totalData = total;
	
	[self setNeedsDisplay];
}

- (void)addRecordToTableData:(NSString *)name withValue:(float)value withTotal:(float)total
{
	FrequencyTableRecordDerived* derivedRecord = [[FrequencyTableRecordDerived alloc] init];
	derivedRecord.name = name;
	derivedRecord.value = value;
	derivedRecord.percent = ( derivedRecord.value * 100.0f ) / total;
	
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
