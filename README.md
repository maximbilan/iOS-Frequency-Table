iOS Frequency Table
===================

Frequency simple table component.<br><br><br>
![alt tag](https://raw.github.com/maximbilan/ios_frequency_table/master/img/img1.png)

<b>How to use:</b>
<br>
Add to your project source files: <br>
<pre>
FrequencyTable.h
FrequencyTable.m
</pre>
You can add view in the Interface builder and set class to FrequencyTable or create in the code: <br>
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

Apps using frequency table
============

<a href="https://itunes.apple.com/us/app/wymg/id769463031">Wymg</a> - Where your money goes? Want to know? Easiest way to track your expenses, use wymg. Designed with simplicity and usability. With just a few taps you can track your expense or check purchases.

