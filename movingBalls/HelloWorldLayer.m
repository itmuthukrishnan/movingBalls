//
//  HelloWorldLayer.m
//  movingBalls
//
//  Created by Muthu Krishnan on 12/08/15.
//  Copyright Muthu Krishnan 2015. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer
{
    CCNode *_leftScreen;
    CCNode *_rightScreen;
    
    CCSprite *background;
    CCSprite *background2;
    
    CCSprite *rightViewbackground1;
    CCSprite *rightViewbackground2;
    
    NSMutableArray *countArray;
}
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    // always call "super" init
    // Apple recommends to re-assign "self" with the "super's" return value
    if( (self=[super init]) ) {
        
        countArray=[[NSMutableArray alloc]init];
        CGSize cs = self.contentSize; // Get the Screen Size
        
        // Create the node representing the left side of the screen and define its size (1/2 screen)
        _leftScreen = [CCNode node];
        _leftScreen.contentSize = CGSizeMake(cs.width / 2, cs.height);
        _leftScreen.position = ccp(0.0, 0.0); // Position on the left
        
        
        
        background = [CCSprite spriteWithFile:@"scrollBg1.png"];
        background2 = [CCSprite spriteWithFile:@"scrollBg1.png"];
        [background.texture setAliasTexParameters];
        [background2.texture setAliasTexParameters];
        
        //position background sprites
        background.position = ccp(background.contentSize.width/2,background.contentSize.height/2);
        background2.position = ccp(_leftScreen.contentSize.height,0);
        
        //schedule to move background sprites
        [self schedule:@selector(scroll:)];
        
        //adding them to the main layer
        [_leftScreen addChild:background z:0];
        [_leftScreen addChild:background2 z:0];
        
        CCSprite  *_leftBall=[CCSprite spriteWithFile:@"leftBall.png"];
        _leftBall.position=ccp(_leftScreen.contentSize.width/2, 100);
        _leftBall.scale=0.8;
        _leftBall.tag=111;
        [self addChild:_leftBall z:2];
        
        
        // Create the node representing the right side of the screen and define its size (1/2 screen)
        _rightScreen = [CCNode node];
        _rightScreen.contentSize = CGSizeMake(cs.width / 2, cs.height);
        _rightScreen.position = ccp(cs.width / 2, 0.0); // Position on the right
        
        CCSprite  *_rightBall=[CCSprite spriteWithFile:@"rightBall.png"];
        _rightBall.position=ccp(_leftScreen.contentSize.width+_leftScreen.contentSize.width/2, 100);
        _rightBall.scale=0.8;
        _rightBall.tag=112;
        [self addChild:_rightBall z:2];
        
        // aNode.positionType = CCPositionTypeNormalized;
        //  aNode.position = position;
        //  [_leftScreen addChild:aNode];
        
        
        rightViewbackground1 = [CCSprite spriteWithFile:@"scrollBg2.png"];//[self blankSpriteWithSize1:CGSizeMake(1024, 768)];
        rightViewbackground2 = [CCSprite spriteWithFile:@"scrollBg2.png"];//[self blankSpriteWithSize2:CGSizeMake(1024, 768)];
        [rightViewbackground1.texture setAliasTexParameters];
        [rightViewbackground2.texture setAliasTexParameters];
        
        //position background sprites
        rightViewbackground1.position = ccp(rightViewbackground1.contentSize.width/2,rightViewbackground1.contentSize.height/2);
        rightViewbackground2.position = ccp(_rightScreen.contentSize.height,0);
        
        
        //adding them to the main layer
        [_rightScreen addChild:rightViewbackground1 z:0];
        [_rightScreen addChild:rightViewbackground2 z:0];
        
        [self addChild:_leftScreen];
        [self addChild:_rightScreen];
        [self addBlocks:rightViewbackground1];
        
        // [self scheduleOnce:@selector(scrollBlocks:) delay:0.5];
        //[self schedule:@selector(scrollBlocks:) interval:1.5];
        self.touchEnabled=YES;
        
        [self addBlocks:background2];
        [self addBlocks:background];
    }
    return self;
}

-(void) scroll:(ccTime)dt
{
    //move 30*dt px vertically
    if (background.position.y<background2.position.y){
        background.position = ccp(background.contentSize.width/2,background.position.y - 30*dt);
        background2.position = ccp(background2.contentSize.width/2,background.position.y+background.contentSize.height);
    }else{
        background2.position = ccp(background2.contentSize.width/2,background2.position.y - 30*dt);
        background.position = ccp(background.contentSize.width/2,background2.position.y+background2.contentSize.height);
        //[self addBlocks:background];
        
        
    }
    
    //reset offscreen position
    if (background.position.y <-background.contentSize.height/2)
    {
        background.position = ccp(background.contentSize.height/2,background2.position.y+background2.contentSize.height);
        [background2 removeAllChildren];
        [background removeAllChildren];
        [countArray removeAllObjects];
        
        [self addBlocks:background];
        [self addBlocks:background2];
        
    }else if (background2.position.y < -background2.contentSize.height/2)
    {
        background2.position = ccp(background2.contentSize.height/2,background.position.y+background.contentSize.height);
        [background removeAllChildren];
        [background2 removeAllChildren];
        [countArray removeAllObjects];
        
        [self addBlocks:background2];
        [self addBlocks:background];
        
    }
}

-(void)addBlocks:(CCSprite *)s
{
    int y=0;
    for(int i=1; i<=5; i++)
    {
        CCSprite *block=[CCSprite spriteWithFile:@"block.png"];
        block.position=ccp(s.contentSize.width/2,y+(i*150));
        [s addChild:block];
        [countArray addObject:s];
    }
    
    NSLog(@"CountArray:%d",countArray.count);
}
-(void)scrollBlocks:(ccTime)dt
{
    CCSprite *s=[CCSprite spriteWithFile:@"block.png"];
    s.position=ccp(_leftScreen.contentSize.width/2,850);
    [_leftScreen addChild:s z:1];
    CCMoveTo *move=[CCMoveTo actionWithDuration:6.0 position:ccp(_leftScreen.contentSize.width/2, -100)];
    CCCallFuncND *callFunction=[CCCallFuncND actionWithTarget:self selector:@selector(removeball:) data:s];
    CCSequence *complete=[CCSequence actions:move,callFunction, nil];
    
    
    [s runAction:complete];
}

-(void)removeball:(CCSprite *)s
{
    [_leftScreen removeChild:s cleanup:YES];
}
// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
    // in case you have something to dealloc, do it in this method
    // in this particular example nothing needs to be released.
    // cocos2d will automatically release all the children (Label)
    
    // don't forget to call "super dealloc"
    [super dealloc];
}
-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    // location= [self convertTouchToNodeSpace:touch];
    NSLog(@"touch:%@",NSStringFromCGPoint(location));
    CCSprite *c2=(CCSprite *)[self getChildByTag:112];
    if (CGRectContainsPoint(c2.boundingBox, location))
    {
        c2.position=location;
    }
    
}
-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    // location= [self convertTouchToNodeSpace:touch];
    NSLog(@"touch:%@",NSStringFromCGPoint(location));
    
    CCSprite *c2=(CCSprite *)[self getChildByTag:112];
    if (CGRectContainsPoint(c2.boundingBox, location))
    {
        c2.scale=0.6;
        c2.position=location;
    }
    
}
-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    NSLog(@"touch:%@",NSStringFromCGPoint(location));
    
    CCSprite *c1=(CCSprite *)[self getChildByTag:111];
    CCSprite *c2=(CCSprite *)[self getChildByTag:112];
    
    if (CGRectContainsPoint(c2.boundingBox, location))
    {
        location= [self convertTouchToNodeSpace:touch];
        
        
        CGPoint jumpPosition1=ccp(_rightScreen.contentSize.width+_rightScreen.contentSize.width/2,c2.position.y+20);
        CGPoint jumpPosition2=ccp(_rightScreen.contentSize.width+_rightScreen.contentSize.width/2,c2.position.y);
        id jumpAct1 = [CCJumpTo actionWithDuration:0.5f position:jumpPosition1 height:2 jumps:1];
        id jumpAct2 = [CCJumpTo actionWithDuration:0.5f position:jumpPosition2 height:2 jumps:1];
        [c2 runAction:[CCSequence actions:jumpAct1,jumpAct2, nil]];
        c2.scale=0.8;
        
        
        
        if (c2.position.y>600)
        {
            NSLog(@"background1: %@",NSStringFromCGPoint(rightViewbackground1.position));
            NSLog(@"background2: %@",NSStringFromCGPoint(rightViewbackground2.position));
            
            if (rightViewbackground1.position.y == 384)
            {    rightViewbackground2.position=ccp(256,768);
                [self addBlocks:rightViewbackground2];
                id move1 =[CCMoveTo actionWithDuration:1.0 position:ccp(256,0)];
                id move2 =[CCMoveTo actionWithDuration:1.0 position:ccp(256,384)];
                id ballmove =[CCMoveTo actionWithDuration:2.0 position:ccp(_rightScreen.contentSize.width+_rightScreen.contentSize.width/2,50)];
                //  background.position = ccp(background.contentSize.height/2,background2.position.y+background2.contentSize.height);
                [rightViewbackground1 runAction:move1];
                [rightViewbackground2 runAction:move2];
                rightViewbackground2.position=ccp(256,768);
                [c2 runAction:ballmove];
                
                
            } else if (rightViewbackground2.position.y == 384)
            {
                rightViewbackground1.position=ccp(256,768);
                [self addBlocks:rightViewbackground1];
                id move1 =[CCMoveTo actionWithDuration:1.0 position:ccp(256,0)];
                id move2 =[CCMoveTo actionWithDuration:1.0 position:ccp(256,384)];
                id ballmove =[CCMoveTo actionWithDuration:2.0 position:ccp(_rightScreen.contentSize.width+_rightScreen.contentSize.width/2,50)];
                
                //  background.position = ccp(background.contentSize.height/2,background2.position.y+background2.contentSize.height);
                [rightViewbackground2 runAction:move1];
                [rightViewbackground1 runAction:move2];
                rightViewbackground1.position=ccp(256,768);
                [c2 runAction:ballmove];
                
                
            }
            
        }
        return;
    }
    else if (CGRectContainsPoint(c1.boundingBox, location))
    {
        NSLog(@"11111111");
        return;
    }
    
    for (CCSprite *block in countArray)
    {
        
        if (CGRectContainsPoint(block.boundingBox, location))
        {
            CGPoint jumpPosition1=ccp(c1.position.x,block.position.y+15);
            CGPoint jumpPosition2=ccp(c1.position.x,c1.position.y);
            
            c1.scale=0.5;
            id jumpAct1 = [CCJumpTo actionWithDuration:0.5f position:jumpPosition1 height:2 jumps:1];
            // id jumpAct2 = [CCJumpTo actionWithDuration:0.5f position:jumpPosition2 height:2 jumps:1];
            CCCallFuncN *callfunction=[CCCallFuncND actionWithTarget:self selector:@selector(ballJumpCompleted:) data:c1];
            // CCEaseInOut *easeMoveUp = [CCEaseInOut actionWithAction:jumpAct1 rate:3.0];
            //CCAction *easeMoveDown = [easeMoveUp reverse];
            [c1 runAction:[CCSequence actions:jumpAct1,callfunction, nil]];
            return;
        }
    }
    
    
    
}

-(void)ballJumpCompleted:(CCSprite *)s
{
    s.scale=0.8;
    CCMoveTo *move=[CCMoveTo actionWithDuration:0.5 position:ccp(s.position.x,100)];
    //  [s runAction:move];
}


@end
