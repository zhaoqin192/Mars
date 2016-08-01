//
//  NTESMeetingActorsView.m
//  NIMMeetingDemo
//
//  Created by fenric on 16/4/9.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESMeetingActorsView.h"
#import "NTESMeetingRolesManager.h"
#import "UIView+NTES.h"
#import "NTESGLView.h"

#define NTESMeetingMaxActors 4

@interface NTESMeetingActorsView()<NIMNetCallManagerDelegate>
{
    NSMutableArray *_actorViews;
    NSMutableArray *_actors;
    NSMutableArray *_backgroundViews;
}

@property (nonatomic, weak) CALayer *localVideoLayer;

@end

@implementation NTESMeetingActorsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _actorViews = [NSMutableArray array];
        _backgroundViews = [NSMutableArray array];
        
        UIImage *backgroundImage = [UIImage imageNamed:@"meeting_background"];
        
        for (int i = 0; i < NTESMeetingMaxActors; i++) {
            UIImageView *background = [[UIImageView alloc] initWithImage:backgroundImage];
            [self addSubview:background];
            [_backgroundViews addObject:background];
            
            NTESGLView *view = [[NTESGLView alloc] initWithFrame:self.bounds];
            view.contentMode = UIViewContentModeScaleAspectFill;
            
            view.backgroundColor = [UIColor clearColor];
            [view render:nil width:0 height:0];
            [self addSubview:view];
            [_actorViews addObject:view];
        }
        [self updateActors];
        [[NIMSDK sharedSDK].netCallManager addDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [[NIMSDK sharedSDK].netCallManager removeDelegate:self];
}

- (void)onLocalPreviewReady:(CALayer *)layer
{
    if ([NTESMeetingRolesManager sharedInstance].myRole.isActor) {
        [self startLocalPreview:layer];
    }
    else {
        _localVideoLayer = layer;
    }
}

- (void)onRemoteYUVReady:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height
                    from:(NSString *)user
{
    if (_actors.count == 0) {
        return;
    }
    
    NSUInteger viewIndex = [_actors indexOfObject:user];
    if (viewIndex != NSNotFound && viewIndex < NTESMeetingMaxActors) {
        NTESGLView *view = _actorViews[viewIndex];
        [view render:yuvData width:width height:height];
    }
}


- (void)startLocalPreview:(CALayer *)layer
{
    [self stopLocalPreview];
    
    DDLogInfo(@"Start local preview");

    _localVideoLayer = layer;
    
    UIView *localView = _actorViews[[self localViewIndex]];
    [localView.layer addSublayer:_localVideoLayer];

    [self layoutLocalPreviewLayer];
}


-(void)stopLocalPreview
{
    DDLogInfo(@"Stop local preview");
    if (_localVideoLayer) {
        [_localVideoLayer removeFromSuperlayer];
    }
}

- (void)layoutLocalPreviewLayer
{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    CGFloat rotateDegree;
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateDegree = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            rotateDegree = M_PI_2;
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateDegree = M_PI_2 * 3.0;
            break;
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationUnknown:
            rotateDegree = 0;
            break;
    }
    
    [_localVideoLayer setAffineTransform:CGAffineTransformMakeRotation(rotateDegree)];
    
    UIView *localView = _actorViews[[self localViewIndex]];
    _localVideoLayer.frame = localView.bounds;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (int i = 0; i < NTESMeetingMaxActors; i ++) {
        UIView *view = _actorViews[i];
        view.width = self.width / 2;
        view.height = self.height / 2;
        view.top = i < 2 ? 0 : self.height / 2;
        view.left = (i + 1) % 2 ? 0 : self.width / 2;
        
        UIImageView *backgound = _backgroundViews[i];
        backgound.frame = view.frame;
    }
}

- (void)updateActors
{
    NSMutableArray *actors = [NSMutableArray arrayWithArray:[[NTESMeetingRolesManager sharedInstance] allActorsByName:NO]];
    
    [actors sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *actor1  = obj1;
        NSString *actor2  = obj2;
        NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
        NTESMeetingRole *role1 = [[NTESMeetingRolesManager sharedInstance] role:actor1];
        NTESMeetingRole *role2 = [[NTESMeetingRolesManager sharedInstance] role:actor2];

        //Manager排第一
        if (role1.isManager) {
            return NSOrderedAscending;
        }
        else if (role2.isManager) {
            return NSOrderedDescending;
        }
        
        //自己排第二（如果自己不是Manager）
        if ([actor1 isEqualToString:myUid]) {
            return NSOrderedAscending;
        }
        else if ([actor2 isEqualToString:myUid]) {
            return NSOrderedDescending;
        }

        return NSOrderedAscending;

    }];

    if (actors.count != _actors.count) {
        for (NTESGLView *view in _actorViews) {
            [view render:nil width:0 height:0];
        }
    }
    
    _actors = actors;
    
    if (_localVideoLayer) {
        if ([NTESMeetingRolesManager sharedInstance].myRole.videoOn) {
            [self onLocalPreviewReady:_localVideoLayer];
        }
        else {
            [self stopLocalPreview];
        }
    }
}

-(NSUInteger)localViewIndex
{
    NSString *myUid = [[NIMSDK sharedSDK].loginManager currentAccount];
    if (_actors.count) {
        return [_actors indexOfObject:myUid];
    }
    else {
        return NSNotFound;
    }
}

@end
