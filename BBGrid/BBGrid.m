
#import "BBGrid.h"
#import "BBLabel.h"

@interface BBGrid()

@property CGFloat labelWidth;
@property CGFloat labelHeight;
@property CGPoint boxDimen;

@property NSMutableArray *gridArr;
@property CGRect buttonCGRect;
@property SKColor *color;
@property BBLabel *labelBox;
@property BBLabel *replacementBox;
@property float labelFontSize;
@property BOOL isMoving;

@end

@implementation BBGrid

-(id)initWithBoardRect:(CGRect)buttonRect color:(SKColor *)color fontSize:(float)fntSize labelDimension:(CGPoint)dim {
    
    if((self = [super init])) {
        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        
        self.labelWidth = screenRect.size.width/dim.x;
        self.labelHeight = (screenRect.size.height-30.0f)/dim.y;
        self.boxDimen = dim;
        
        self.color = color;
        self.buttonCGRect = buttonRect;
        self.isMoving = NO;
        
        [self setUserInteractionEnabled:NO];
        CGMutablePathRef rectPath = CGPathCreateMutable();
        CGPathAddRect(rectPath, NULL, buttonRect);
        self.path = rectPath;
        self.strokeColor = [SKColor yellowColor];
        self.lineWidth=1;
        self.antialiased = NO;
        self.alpha = 1.0f;
        self.labelFontSize = fntSize;
        self.fillColor = self.color;
        CGPathRelease(rectPath);
        
        self.gridArr = [NSMutableArray new];
        for (int i=0; i<dim.x; i++) {
            NSMutableArray *col = [NSMutableArray array];
            [self.gridArr addObject:col];
            for(int j=0; j<dim.y; j++) {
                
                int ran = arc4random() % 26;
                self.labelBox = [[BBLabel alloc]initWithFontNamed:@"Arial" position:CGPointMake(i*self.labelWidth+(self.labelWidth/2.0f), j*self.labelHeight+(self.labelHeight/2.0f)) text:[NSString stringWithFormat:@"%c", 65+ran] coordinate:CGPointMake((int)i, (int)j) boxDimension:self.boxDimen];
                
                self.labelBox.delegate = self;
                self.labelBox.name = [NSString stringWithFormat:@"%c", 65+ran];
                self.labelBox.userInteractionEnabled = YES;
                self.labelBox.label.fontSize = self.labelFontSize;
                [self addChild:self.labelBox];
                [col addObject:self.labelBox];
            }
        }
    }
    return self;
    
}

- (int)getCompassDirection:(float)movingCoord XerY:(int)xy {
    if (movingCoord>0.0f && xy == 0) {
        return 0;
    }
    else if (movingCoord<0.0f && xy == 0) {
        return 2;
    }
    else if (movingCoord>0.0f && xy == 1) {
        return 1;
    }
    else if (movingCoord<0.0f && xy == 1) {
        return 3;
    }
    return 0;
}

- (void)sendDataBack:(int)PoserNeg XerY:(int)xy gridIdentity:(CGPoint)boxCoords{
    
    if (xy == 0) {
        
        if (PoserNeg == 1) {
            
            BBLabel *temB = (BBLabel *)[[self.gridArr objectAtIndex:(int)boxCoords.x]objectAtIndex:self.boxDimen.y-1];
            self.replacementBox = [[BBLabel alloc]initWithFontNamed:temB.label.fontName position:CGPointMake(temB.position.x, (self.labelHeight/2.0f)) text:temB.label.text coordinate:CGPointMake((int)boxCoords.x, 0) boxDimension:self.boxDimen];
            self.replacementBox.label.fontSize = self.labelFontSize;
            self.replacementBox.delegate = self;
            
            NSMutableArray *tempArr = (NSMutableArray *)[self.gridArr objectAtIndex:(int)boxCoords.x];
            [[tempArr objectAtIndex:self.boxDimen.y-1]removeFromParent];
            for (int i=self.boxDimen.y-1; i>0; i--) {
                [tempArr replaceObjectAtIndex:i withObject:[tempArr objectAtIndex:i-1]];
                BBLabel *curB = (BBLabel *)[tempArr objectAtIndex:i];
                [curB setPosition:CGPointMake(curB.position.x, curB.position.y + self.labelHeight)];
                curB->labelCoordinate.y++;
            }
            [tempArr replaceObjectAtIndex:0 withObject:self.replacementBox];
            [self addChild:self.replacementBox];
        }
        
        if (PoserNeg == 0) {
            
            BBLabel *temB = (BBLabel *)[[self.gridArr objectAtIndex:(int)boxCoords.x]objectAtIndex:0];
            self.replacementBox = [[BBLabel alloc]initWithFontNamed:temB.label.fontName position:CGPointMake(temB.position.x, self.boxDimen.y*self.labelHeight-(self.labelHeight/2.0f)) text:temB.label.text coordinate:CGPointMake((int)boxCoords.x, self.boxDimen.y-1) boxDimension:self.boxDimen];
            self.replacementBox.label.fontSize = self.labelFontSize;
            self.replacementBox.delegate = self;
            
            NSMutableArray *tempArr = (NSMutableArray *)[self.gridArr objectAtIndex:(int)boxCoords.x];
            [[tempArr objectAtIndex:0]removeFromParent];
            for (int i=0; i<self.boxDimen.y-1; i++) {
                [tempArr replaceObjectAtIndex:i withObject:[tempArr objectAtIndex:i+1]];
                BBLabel *curB = (BBLabel *)[tempArr objectAtIndex:i];
                [curB setPosition:CGPointMake(curB.position.x, curB.position.y - self.labelHeight)];
                curB->labelCoordinate.y--;
            }
            [tempArr replaceObjectAtIndex:self.boxDimen.y-1 withObject:self.replacementBox];
            [self addChild:self.replacementBox];
        }
    }
    
    if (xy == 1) {
        
        if (PoserNeg == 1) {
            BBLabel *temB = (BBLabel *)[[self.gridArr objectAtIndex:self.boxDimen.x-1]objectAtIndex:(int)boxCoords.y];
            self.replacementBox = [[BBLabel alloc]initWithFontNamed:temB.label.fontName position:CGPointMake((self.labelWidth/2.0f),  temB.position.y) text:temB.label.text coordinate:CGPointMake(0, (int)boxCoords.y) boxDimension:self.boxDimen];
            self.replacementBox.label.fontSize = self.labelFontSize;
            self.replacementBox.delegate = self;
            
            [[[self.gridArr objectAtIndex:self.boxDimen.x-1] objectAtIndex:(int)boxCoords.y]removeFromParent];
            for (int i=self.boxDimen.x-1; i>0; i--) {
                    [[self.gridArr objectAtIndex:i] replaceObjectAtIndex:(int)boxCoords.y withObject:[[self.gridArr objectAtIndex:i-1] objectAtIndex:(int)boxCoords.y]];
                    BBLabel *curB = (BBLabel *)[[self.gridArr objectAtIndex:i] objectAtIndex:(int)boxCoords.y];
                    [curB setPosition:CGPointMake(curB.position.x + self.labelWidth, curB.position.y)];
                    curB->labelCoordinate.x++;
            }
            NSMutableArray *tempArr = (NSMutableArray *)[self.gridArr objectAtIndex:0];
            [tempArr replaceObjectAtIndex:(int)boxCoords.y withObject:self.replacementBox];
            [self addChild:self.replacementBox];
        }
        
        if (PoserNeg == 0) {
            BBLabel *temB = (BBLabel *)[[self.gridArr objectAtIndex:0]objectAtIndex:(int)boxCoords.y];
            self.replacementBox = [[BBLabel alloc]initWithFontNamed:temB.label.fontName position:CGPointMake(self.boxDimen.x*self.labelWidth-(self.labelWidth/2.0f),  temB.position.y) text:temB.label.text coordinate:CGPointMake(self.boxDimen.x-1, (int)boxCoords.y) boxDimension:self.boxDimen];
            self.replacementBox.label.fontSize = self.labelFontSize;
            self.replacementBox.delegate = self;
            
            [[[self.gridArr objectAtIndex:0] objectAtIndex:(int)boxCoords.y]removeFromParent];
            for (int i=0; i<self.boxDimen.x-1; i++) {
                [[self.gridArr objectAtIndex:i] replaceObjectAtIndex:(int)boxCoords.y withObject:[[self.gridArr objectAtIndex:i+1] objectAtIndex:(int)boxCoords.y]];
                BBLabel *curB = (BBLabel *)[[self.gridArr objectAtIndex:i] objectAtIndex:(int)boxCoords.y];
                [curB setPosition:CGPointMake(curB.position.x - self.labelWidth, curB.position.y)];
                curB->labelCoordinate.x--;
            }
            NSMutableArray *tempArr = (NSMutableArray *)[self.gridArr objectAtIndex:self.boxDimen.x-1];
            [tempArr replaceObjectAtIndex:(int)boxCoords.y withObject:self.replacementBox];
            [self addChild:self.replacementBox];
        }
    }
}

-(void)dragEnded:(CGPoint)boxCoords movingCoord:(float)dirCoord XerY:(int)xy {
    
}

- (void)checkForWordsOn:(CGPoint)boxCoords {
    NSLog(@"%f %f", boxCoords.x, boxCoords.y);
    BBLabel *curB = (BBLabel *)[[self.gridArr objectAtIndex:boxCoords.x] objectAtIndex:(int)boxCoords.y];
    [self searchForWord:boxCoords];
    //NSLog(@"%@", curB.label.text);
}

- (int)searchForWord:(CGPoint)ptToSearch {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Scrabble"
                                                         ofType:@"txt"];
    NSError *error = nil;
    NSString *fileContent = [NSString stringWithContentsOfFile:filePath
                                                      encoding:NSUTF8StringEncoding
                                                         error:&error];
    NSScanner *scanner = [NSScanner scannerWithString: fileContent];
    NSCharacterSet *whitespace = [NSCharacterSet newlineCharacterSet];
    NSString *tempstringOut;
    
    BOOL DIP = NO;
    for (int i=0; i<ptToSearch.x-1; i++) {
        NSMutableString *temp = [NSMutableString new];
        BBLabel *curB;
        for (int j=i; j<=ptToSearch.x; j++) {
            curB = (BBLabel *)[[self.gridArr objectAtIndex:j] objectAtIndex:ptToSearch.y];
            [temp appendString:curB.label.text];
        }
        //NSLog(@"%@", temp);
        while ([scanner isAtEnd] == NO) {
            [scanner scanUpToCharactersFromSet:whitespace intoString:&tempstringOut];
            if ([tempstringOut isEqualToString:temp]) {
                NSLog(@"%@ \n 1 \n", tempstringOut);
                DIP = YES;
                break;
            }
        }
        scanner.scanLocation = 0;
        if (DIP == YES) {
            break;
        }
    }
    
    return 0;
}

@end
