
#import <SpriteKit/SpriteKit.h>

@protocol testdelegate <NSObject>

@required
- (void)sendDataBack:(int)PoserNeg XerY:(int)xy gridIdentity:(CGPoint)boxCoords;
- (void)dragEnded:(CGPoint)boxcoords movingCoord:(float)dirCoord XerY:(int)xy;
- (void)didClick:(CGPoint)boxCoords;

@end


@interface BBLabel : SKSpriteNode {
@public
    CGPoint tappedCoord;
    CGPoint labelCoordinate;
}

@property SKLabelNode *label;
@property (weak) id <testdelegate> delegate;

-(id)initWithFontNamed:(NSString *)fontName position:(CGPoint)pos text:(NSString *)txt coordinate:(CGPoint)coord boxDimension:(CGPoint)bDim;

@end
