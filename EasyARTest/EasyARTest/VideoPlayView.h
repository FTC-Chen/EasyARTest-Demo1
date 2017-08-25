
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

//导航栏隐藏前所需等待时间
#define CDPHideBarIntervalTime 9

@protocol VideoPlayViewDelegate <NSObject>

@optional

- (void)videoplayViewSwitchOrientation:(BOOL)isFull;

@end

@interface VideoPlayView : UIView

/* 播放器 */
@property (nonatomic, strong) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *browzerRecord;
@property(copy,nonatomic)void(^loadingBlock)(VideoPlayView *);

@property (weak, nonatomic) id<VideoPlayViewDelegate> delegate;
@property (nonatomic, strong) AVPlayerItem *playerItem;

+ (instancetype)videoPlayView;
-(NSString *)getPlayerCurrenttime;
-(void)closeplayer;
-(void)seektoplaytimer:(CGFloat)time;

@end
