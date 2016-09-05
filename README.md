iOS Frequency Table
===================

Frequency simple table control.<br><br><br>
![alt tag](https://raw.github.com/maximbilan/ios_frequency_table/master/img/img1.png)
## Installation
Add to your project the next source files: <br>
<pre>
FrequencyTable.h
FrequencyTable.m
</pre>

## Using

You can add view in the Interface builder and set class to <i>FrequencyTable</i> or create in the code: <br>
<pre>
FrequencyTable *frequencyTable = [[FrequencyTable alloc] initWithPositionWithX:0
                                                                         withY:0
                                                                  isWideScreen:YES];
[self.view addSubview:frequencyTable];
</pre>
For adding table data, you can use the following code: <br>
<pre>
NSMutableArray *array = [[NSMutableArray alloc] init];
  
float total = 0.0;
for (NSInteger i = 0; i &#60; 50; ++i) {
  FrequencyTableRecord *record = [[FrequencyTableRecord alloc] init];
  record.name = [NSString stringWithFormat:@"Item %d", i];
  record.value = RAND_FROM_TO(1, 500);
  total += record.value;
  [array addObject:record];
}
  
[self.frequencyTable setData:array withTotal:total];
</pre>
