
#import "BBLabel.h"

@interface BBLabel() {

}

@property float delta;
@property CGPoint lastMove;
@property CGPoint boxDimension;

@property BOOL directionCatch;
@property BOOL isHeadingVert;
@property BOOL isHeadingPos;
@property BOOL wasMoved;

@end

@implementation BBLabel

-(id)initWithFontNamed:(NSString *)fontName position:(CGPoint)pos text:(NSString *)txt coordinate:(CGPoint)coord boxDimension:(CGPoint)bDim{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat physicalWidth = screenRect.size.width/bDim.x;
    CGFloat physicalHeight = (screenRect.size.height-30.0f)/bDim.y;
    NSLog(@"%f", screenRect.size.height);
    
    if((self = [super init])) {
        [self setUserInteractionEnabled:YES];
        
        [self setSize:CGSizeMake(physicalWidth, physicalHeight)];
        self.position = pos;
        self.boxDimension = bDim;
        self.color = [SKColor greenColor];
        self.lastMove = CGPointZero;
        
        self.label = [SKLabelNode labelNodeWithFontNamed:fontName];
        self.label.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        self.label.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        self.label.text = txt;
        self->labelCoordinate = coord;
        [self addChild:self.label];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint tempP = [[touches anyObject]locationInNode:self];
    self->tappedCoord = tempP;
    //NSLog(@"%f %f %f", self->labelCoordinate.x, self->labelCoordinate.y, self->tappedCoord.y);
    self.directionCatch = NO;
    self.wasMoved = NO;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    CGPoint tempP = [[touches anyObject]locationInNode:self];
    //NSLog(@"%f %f", tempP.y, self->tappedCoord.y);
    self.wasMoved = YES;
    //NSLog(@"%i %i", self.isHeadingVert, self.isHeadingPos);
    if (!self.directionCatch) {
        if (abs(tempP.y - self->tappedCoord.y) > abs(tempP.x - self->tappedCoord.x)) {
            self.isHeadingVert = YES;
            if (tempP.y > self->tappedCoord.y) {
                self.isHeadingPos = YES;
                [self.delegate sendDataBack:1 XerY:0 gridIdentity:self->labelCoordinate];
            }
            else if (tempP.y < self->tappedCoord.y) {
                self.isHeadingPos = NO;
                [self.delegate sendDataBack:0 XerY:0 gridIdentity:self->labelCoordinate];
            }
        }
        if (abs(tempP.y - self->tappedCoord.y) < abs(tempP.x - self->tappedCoord.x)) {
            self.isHeadingVert = NO;
            if (tempP.x > self->tappedCoord.x) {
                self.isHeadingPos = YES;
                [self.delegate sendDataBack:1 XerY:1 gridIdentity:self->labelCoordinate];
            }
            if (tempP.x - self->tappedCoord.x < 0.0f) {
                self.isHeadingPos = NO;
                [self.delegate sendDataBack:0 XerY:1 gridIdentity:self->labelCoordinate];
            }
        }
        self.directionCatch = YES;
    }
    else {
        if (self.isHeadingVert == YES) {
            if (self.isHeadingPos == YES) {
                NSLog(@"%f %f", tempP.y - self->tappedCoord.y, self->tappedCoord.y);
                if (tempP.y >= self->tappedCoord.y) {
                    [self.delegate sendDataBack:1 XerY:0 gridIdentity:self->labelCoordinate];
                }
                else if(tempP.y-self->tappedCoord.y < self->tappedCoord.y-self.frame.size.height) {
                    self.isHeadingPos = NO;
                    self->tappedCoord = CGPointMake(self->tappedCoord.x, self->tappedCoord.y-self.frame.size.height);
                }
            }
            else if (self.isHeadingPos == NO) {
                if (tempP.y <= self->tappedCoord.y) {
                    [self.delegate sendDataBack:0 XerY:0 gridIdentity:self->labelCoordinate];
                }
                else if(tempP.y-self->tappedCoord.y > self->tappedCoord.y+self.frame.size.height) {
                    self.isHeadingPos = YES;
                    self->tappedCoord = CGPointMake(self->tappedCoord.x, self->tappedCoord.y+self.frame.size.height);
                }
            }
        }
        if (self.isHeadingVert == NO) {
            if (self.isHeadingPos == YES) {
                if (tempP.x >= self->tappedCoord.x) {
                    //NSLog(@"%f %f %f", tempP.y, self->tappedCoord.y, self.offset);
                    [self.delegate sendDataBack:1 XerY:1 gridIdentity:self->labelCoordinate];
                }
                else if(tempP.x-self->tappedCoord.x < self->tappedCoord.x-self.frame.size.width) {
                    self.isHeadingPos = NO;
                    self->tappedCoord = CGPointMake(self->tappedCoord.x-self.frame.size.width ,self->tappedCoord.y);
                }
            }
            else if (self.isHeadingPos == NO) {
                if (tempP.x <= self->tappedCoord.x) {
                    [self.delegate sendDataBack:0 XerY:1 gridIdentity:self->labelCoordinate];
                }
                else if(tempP.x-self->tappedCoord.x > self->tappedCoord.x+self.frame.size.width) {
                    self.isHeadingPos = YES;
                    self->tappedCoord = CGPointMake(self->tappedCoord.x+self.frame.size.width ,self->tappedCoord.y);
                }
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (self.wasMoved == NO) {
        [self.delegate didClick:self->labelCoordinate];
    }
}

@end
