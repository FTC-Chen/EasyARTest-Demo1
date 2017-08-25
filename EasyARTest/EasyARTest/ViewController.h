//
//  ViewController.h
//  EasyARTest
//
//  Created by anyongxue on 2017/8/24.
//  Copyright © 2017年 cc. All rights reserved.
//

#import <GLKit/GLKViewController.h>
#import <AVFoundation/AVFoundation.h>
@class VideoPlayView;

@interface ViewController : GLKViewController

@property (nonatomic,strong)AVPlayerItem *playerItem;
@property(nonatomic,strong)VideoPlayView *playerView;

@end

