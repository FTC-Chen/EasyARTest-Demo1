
#import "VideoPlayView.h"

@interface VideoPlayView()

// 播放器的Layer
@property (weak, nonatomic) AVPlayerLayer *playerLayer;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *cacheProgressView;

@property (assign, nonatomic) BOOL isShowToolView;// 记录当前是否显示了工具栏
@property (nonatomic, strong) NSTimer *progressTimer;/* 定时器 */
@property (nonatomic,assign)NSTimeInterval interval;

#pragma mark - 监听事件的处理
- (IBAction)playOrPause:(UIButton *)sender;
- (IBAction)switchOrientation:(UIButton *)sender;
- (IBAction)slider;
- (IBAction)startSlider;
- (IBAction)tapAction:(UITapGestureRecognizer *)sender;
- (IBAction)sliderValueChange;

@end

@implementation VideoPlayView

// 快速创建View的方法
+ (instancetype)videoPlayView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"VideoPlayView" owner:nil options:nil] firstObject];
}

#pragma mark - 通知
//添加通知
-(void)addNotification{
    //添加AVPlayerItem播放结束通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playBackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
}

-(void)playBackFinished:(NSNotification *)notification{
    
    [self.player seekToTime:CMTimeMake(0, self.playerItem.duration.timescale)];
    self.playOrPauseBtn.selected = NO;
}

- (void)awakeFromNib{
    
    self.player = [[AVPlayer alloc] init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    //AVLayerVideoGravityResizeAspect  按比例缩放
    self.self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
   
    [self.imageView.layer addSublayer:self.playerLayer];
   
    self.toolView.alpha = 0;
    self.isShowToolView = NO;
    
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"thumbImage"] forState:UIControlStateNormal];
    //[self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"MaximumTrackImage"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"MinimumTrackImage"] forState:UIControlStateNormal];
    
    [self removeProgressTimer];
    [self addProgressTimer];
    
    self.playOrPauseBtn.selected = YES;
    [self addNotification];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.playerLayer.frame = self.bounds;
}

#pragma mark - 设置播放的视频
- (void)setPlayerItem:(AVPlayerItem *)playerItem{
    
    _playerItem = playerItem;
    [self.player replaceCurrentItemWithPlayerItem:playerItem];
    //[self.player play];
}

#pragma mark ------添加的手势
- (IBAction)rightSwipAction:(UISwipeGestureRecognizer *)sender{
    
    NSLog(@"执行向右清扫");
    
    NSLog(@"%f",self.progressSlider.value);
    //获取当前时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * (self.progressSlider.value+0.1);
    
    NSLog(@"%f",self.progressSlider.value);
    
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
    
    //去掉定时器
    [self removeProgressTimer];
    //设置时间 播放
    [self addProgressTimer];
    
    //NSLog(@"1```%f",self.player.currentItem.duration.value);
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
}

- (IBAction)leftSwipAction:(UISwipeGestureRecognizer *)sender {
    
    NSLog(@"%f",self.progressSlider.value);
    
    //获取当前时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * (self.progressSlider.value-0.1);
    
    NSLog(@"%f",self.progressSlider.value);
    
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
    
    //去掉定时器
    [self removeProgressTimer];
    
    //设置时间 播放
    [self addProgressTimer];
    
    //NSLog(@"1```%f",self.player.currentItem.duration.value);
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
}


// 是否显示工具的View
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        if (self.isShowToolView) {
            self.toolView.alpha = 0;
            self.isShowToolView = NO;
        } else {
            self.toolView.alpha = 0.8;
            self.isShowToolView = YES;
        }
    }];
}

// 暂停按钮的监听
- (IBAction)playOrPause:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (sender.selected) {
        [self.player play];
        
        [self addProgressTimer];
    } else {
        [self.player pause];
        
        [self removeProgressTimer];
    }
}

#pragma mark - 定时器操作
- (void)addProgressTimer{
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(updateProgressInfo) userInfo:nil
                                                         repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}

- (void)removeProgressTimer{
    
    [self.progressTimer invalidate];//失效
    self.progressTimer = nil;
}

- (void)updateProgressInfo{
    
    // 1.更新时间
    self.timeLabel.text = [self timeString];
    
    // 2.设置进度条的value
    self.progressSlider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
    
    NSString * alltime = [NSString stringWithFormat:@"%lld",self.playerItem.duration.value/ self.playerItem.duration.timescale];
    NSInteger allTimInteger = [alltime integerValue];
    NSLog(@"%ld",(long)allTimInteger);
    
    NSTimeInterval cacheTime = [self availableDuration];
    NSLog(@"缓冲 cache----- %f",cacheTime);
    
    [self.cacheProgressView setProgress:cacheTime/allTimInteger animated:YES];
}

- (NSString *)timeString{
    
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    return [self stringWithCurrentTime:currentTime duration:duration];
}

// 切换屏幕的方向
- (IBAction)switchOrientation:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if ([self.delegate respondsToSelector:@selector(videoplayViewSwitchOrientation:)]) {
        [self.delegate videoplayViewSwitchOrientation:sender.selected];
    }
}

- (IBAction)slider{
    
    [self addProgressTimer];
    
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    
    //NSLog(@"1```%f",self.player.currentItem.duration.value);
    
    NSLog(@"2```%f",currentTime);
    
    // 设置当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    
    [self.player play];
}

- (IBAction)startSlider{
    
    [self removeProgressTimer];
}

- (IBAction)sliderValueChange{
   
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * self.progressSlider.value;
    
    NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
    
    self.timeLabel.text = [self stringWithCurrentTime:currentTime duration:duration];
}

//timelabel 显示的内容
- (NSString *)stringWithCurrentTime:(NSTimeInterval)currentTime duration:(NSTimeInterval)duration{
    
    NSInteger dMin = duration / 60;
    NSInteger dSec = (NSInteger)duration % 60;
    
    NSInteger cMin = currentTime / 60;
    NSInteger cSec = (NSInteger)currentTime % 60;
    
    NSString *durationString = [NSString stringWithFormat:@"%02ld:%02ld", dMin, dSec];
    NSString *currentString = [NSString stringWithFormat:@"%02ld:%02ld", cMin, cSec];
    
    return [NSString stringWithFormat:@"%@/%@", currentString, durationString];
}

- (NSString*)convertMovieTimeToText:(CGFloat)time{
    
    //把秒数转换成文字
    return [NSString stringWithFormat:@"%.0f",time];
}

- (NSString *)getPlayerCurrenttime{
    //获取当前时间
    CMTime currentTime = self.playerItem.currentTime;
    //转成秒数
    CGFloat currentPlayTime = (CGFloat)currentTime.value/currentTime.timescale;
    return  [self convertMovieTimeToText:currentPlayTime];
}

- (void)closeplayer{
    
    [self.player  pause];
    
    [self removeProgressTimer];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)seektoplaytimer:(CGFloat)time{
   
    [self.player seekToTime:CMTimeMakeWithSeconds(time,1) completionHandler:^(BOOL finished) {
        [self.player play];
    }];
}

//返回 当前 视频 缓存时长
- (NSTimeInterval)availableDuration{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    
    return result;
}


@end
