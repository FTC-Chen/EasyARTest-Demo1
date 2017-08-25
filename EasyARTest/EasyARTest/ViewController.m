//
//  ViewController.m
//  EasyARTest
//
//  Created by anyongxue on 2017/8/24.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "ViewController.h"
#import "OpenGLView.h"
#import "VideoPlayView.h"

#define KScreenWidth [[UIScreen mainScreen] bounds].size.width
#define KScreenHeight [[UIScreen mainScreen] bounds].size.height
#define KRGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KRGB_ACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

@interface ViewController ()<VideoPlayViewDelegate>

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *showImageView;
@property(nonatomic,strong)UIImageView *showImageView2;
@property(nonatomic,strong)UILabel *titleLabel;//说明性文字
@property(nonatomic,strong)UILabel *detailLabel;//详情说明
@property(nonatomic,assign)BOOL showBgView;

@end

@implementation ViewController
{
    
    OpenGLView *glView;
}

- (void)loadView {
    self->glView = [[OpenGLView alloc] initWithFrame:CGRectZero];
    self.view = self->glView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self->glView setOrientation:self.interfaceOrientation];
    
    //创建显示图片imageView
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    self.bgView.backgroundColor = KRGB_ACOLOR(0, 0, 0, 0.57);
    [self.view addSubview:self.bgView];
    
    //说明文字
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 40, KScreenWidth-40, 30)];
    self.titleLabel.font = [UIFont systemFontOfSize:21];
    self.titleLabel.text = @"相关说明:";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.bgView addSubview:self.titleLabel];
    
    //详情说明
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.titleLabel.frame)+15, KScreenWidth-40, 120)];
    self.detailLabel.font = [UIFont systemFontOfSize:18.5];
    self.detailLabel.text = @"详情说明测试文字详情说明测试文字详情说明测试文字详情说明测试文字详情说明测试文字详情说明测试文字详情说明测试文字详情说明测试文字详情说明测试文字详情说明测试文字";
    self.detailLabel.numberOfLines = 0;
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.textColor = [UIColor whiteColor];
    [self.bgView addSubview:self.detailLabel];
    
    //显示图片
    self.showImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.detailLabel.frame)+20, (KScreenWidth-40-15)/2, (KScreenWidth-40)*9/16)];
    self.showImageView.image = [UIImage imageNamed:@"show.jpg"];
    [self.bgView addSubview:self.showImageView];
    
    self.showImageView2=[[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.showImageView.frame)+15, CGRectGetMaxY(self.detailLabel.frame)+20, (KScreenWidth-40-15)/2, (KScreenWidth-40)*9/16)];
    self.showImageView2.image = [UIImage imageNamed:@"show2.jpg"];
    [self.bgView addSubview:self.showImageView2];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PRScuccess) name:@"PicRecognitionSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PRFail) name:@"PicRecognitionFail" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self->glView start];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self->glView stop];
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self->glView resize:self.view.bounds orientation:self.interfaceOrientation];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
    [self->glView setOrientation:toInterfaceOrientation];
}

//识别成功
- (void)PRScuccess{
    NSLog(@"显示图片");
    //self.showImageView.hidden = NO;
    if (self.showBgView==NO) {
        self.bgView.hidden = NO;
        
        //视频播放
        self.playerView = [VideoPlayView videoPlayView];
        self.playerView.delegate = self;
        self.playerView.backgroundColor = [UIColor redColor];
        self.playerView.frame = CGRectMake(20, CGRectGetMaxY(self.showImageView.frame)+30,KScreenWidth-40, (KScreenWidth-40)*9/16);
        [self.bgView addSubview:self.playerView];
        
        NSString *path = [[NSBundle mainBundle]pathForResource:@"Miniature" ofType:@"mp4"];
        self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:path]];
        [self.playerView setPlayerItem:self.playerItem];
        [self.playerView.player seekToTime:CMTimeMakeWithSeconds(0, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
        [self.playerView.player play];
       
        self.showBgView = YES;
    }
}

- (void)PRFail{
    //self.showImageView.hidden = YES;
    if (self.showBgView==YES) {
        self.bgView.hidden = YES;
        [self.playerView closeplayer];
        self.showBgView= NO;
    }else{
        self.bgView.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
