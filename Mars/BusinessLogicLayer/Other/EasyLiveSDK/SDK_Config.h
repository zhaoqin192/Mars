//
//  SDK_Config.h
//  yizhiboEngine
//
//  Created by gaopeirong on 15/11/3.
//  Copyright © 2015年 cloudfocus. All rights reserved.
//

#ifndef SDK_Config_h
#define SDK_Config_h

typedef NS_ENUM(NSInteger, CCLiveMode)
{
    CCLiveModeVideo = 0,
    CCLiveModeAudioOnly
};

typedef NS_ENUM(NSInteger, CCLiveViewMode )
{
    CCLiveViewVertical = 0,
    CCLiveViewHorizonal
};

typedef NS_ENUM(NSInteger, CCSMSType)
{
    CCSMSTypeRegist = 0
};

// authtype
typedef NS_ENUM(NSInteger, CCAuthType)
{
    CCAuthTypePhone,
};

#endif /* SDK_Config_h */
