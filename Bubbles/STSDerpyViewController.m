//
//  STSDerpyViewController.m
//  Bubbles
//
//  Created by Sophia Anopa on 7/8/14.
//  Copyright (c) 2014 STS. All rights reserved.
//

#import "STSDerpyViewController.h"
#import "STSDerpyGameScene.h"

@interface STSDerpyViewController () <UIAlertViewDelegate>
@property (nonatomic, strong) STSDerpyGameScene *game;
@property float period;
@property (nonatomic, strong) NSTimer *displayTimer;
@property (nonatomic, strong) NSDate *pauseStart;
@property (nonatomic, strong) NSDate *previousFireDate;
@end


@implementation STSDerpyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view = [[SKView alloc] init];
//        self.tabBarItem.title = @"Derpy Mode";
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!self.game) {
        self.game = [[STSDerpyGameScene alloc] initWithSize:self.view.frame.size];
        SKView *spriteView = (SKView *)self.view;
        [spriteView presentScene:self.game];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(gameOver:) userInfo:nil repeats:NO];
        self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 71, 300, 21)];
        
        //TIMER LABEL
        self.period = 30;
        self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                             target:self
                                                           selector:@selector(updateTime:)
                                                           userInfo:nil
                                                            repeats:YES];
        NSDate *myTimerDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval)self.period];
        NSTimeInterval timeLeft = [myTimerDate timeIntervalSinceNow];
        self.timerLabel.text = [NSString stringWithFormat:@"Time left: %.2f", timeLeft];
        [self.view addSubview:self.timerLabel];
        
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
        {
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        }

    }
}

- (void)gameOver:(id)sender
{
    [self.displayTimer invalidate];
    self.displayTimer = nil;
    self.timer = nil;
    
    NSInteger lowScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"lowScore"];
    UIAlertView *alert;
    if (self.game.points < lowScore)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:self.game.points forKey:@"lowScore"];
        alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                           message:[NSString stringWithFormat:@"New LOW Score: %d!", self.game.points]
                                          delegate:self
                                 cancelButtonTitle:@"Play Again"
                                 otherButtonTitles:@"Herp Derp", nil]
        ;
    } else {
        alert = [[UIAlertView alloc] initWithTitle:@"Game Over"
                                           message:[NSString stringWithFormat:@"Points: %d", self.game.points]
                                          delegate:self
                                 cancelButtonTitle:@"Play Again"
                                 otherButtonTitles:@"Herp Derp", nil];
    }

   
    [self.game.scoreLabel removeFromSuperview];
    [self.timerLabel removeFromSuperview];
    [self.game.lowScoreLabel removeFromSuperview];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.game removeFromParent];
        self.game = nil;
        [self viewWillAppear:YES];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
//    self.game = [[STSDerpyGameScene alloc] initWithSize:self.view.frame.size];
//    SKView *spriteView = (SKView *)self.view;
//    [spriteView presentScene:self.game];
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(gameOver:) userInfo:nil repeats:NO];
//    self.timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 31, 300, 21)];
//    
//    //TIMER LABEL
//    self.period = 30;
//    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:1
//                                                         target:self
//                                                       selector:@selector(updateTime:)
//                                                       userInfo:nil
//                                                        repeats:YES];
//    NSDate *myTimerDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval)self.period];
//    NSTimeInterval timeLeft = [myTimerDate timeIntervalSinceNow];
//    self.timerLabel.text = [NSString stringWithFormat:@"Time left: %.2f", timeLeft];
//    [self.view addSubview:self.timerLabel];
    
    
}

- (void)updateTime:(id)sender
{
    self.period--;
    NSDate *myTimerDate = [[NSDate alloc] initWithTimeIntervalSinceNow:(NSTimeInterval)self.period];
    NSTimeInterval timeLeft = [myTimerDate timeIntervalSinceNow];
    self.timerLabel.text = [NSString stringWithFormat:@"Time left: %.2f", timeLeft];
    //[self.view addSubview:self.timerLabel];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self pauseTimer:self.displayTimer];
//    [self pauseTimer:self.timer];
    [self.timerLabel removeFromSuperview];
    [self.game.scoreLabel removeFromSuperview];
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    
    [self.timer invalidate];
    [self.displayTimer invalidate];
}


//-(void) pauseTimer:(NSTimer *)timer {
//    
//    self.pauseStart = [[NSDate dateWithTimeIntervalSinceNow:0] copy];
//    
//    self.previousFireDate = [[timer fireDate] copy];
//    
//    [timer setFireDate:[NSDate distantFuture]];
//}
//
//-(void) resumeTimer:(NSTimer *)timer {
//    
//    float pauseTime = -1*[self.pauseStart timeIntervalSinceNow];
//    
//    [timer setFireDate:[self.previousFireDate initWithTimeInterval:pauseTime sinceDate:self.previousFireDate]];
//}

@end
