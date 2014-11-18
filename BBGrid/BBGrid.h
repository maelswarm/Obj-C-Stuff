
#import <SpriteKit/SpriteKit.h>
#import "BBLabel.h"

@interface BBGrid : SKShapeNode <testdelegate>

-(id)initWithBoardRect:(CGRect)buttonRect color:(SKColor *)color fontSize:(float)fntSize labelDimension:(CGPoint)dim;

@end
