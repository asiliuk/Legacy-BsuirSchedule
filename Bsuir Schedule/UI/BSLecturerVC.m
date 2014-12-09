//
//  BSLecturerVC.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.12.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSLecturerVC.h"
#import "UIView+Screenshot.h"

@interface BSLecturerVC ()
@property (strong, nonatomic) IBOutlet UIImageView *lecturerIV;
@property (strong, nonatomic) IBOutlet UILabel *lecturerNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backIV;
@property (strong, nonatomic) IBOutlet UIView *centerView;

@property (strong, nonatomic) UIImageView *previewIV;
@property (strong, nonatomic) BSLecturer *lecturer;
@property (assign, nonatomic) CGRect startFrame;

@property (nonatomic, assign) CGRect originalBounds;
@property (nonatomic, assign) CGPoint originalCenter;

@property (nonatomic) UIDynamicAnimator *animator;
@property (nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property (nonatomic) UIPushBehavior *pushBehavior;
@property (nonatomic) UIDynamicItemBehavior *itemBehavior;

@property (assign, nonatomic) BOOL dismissing;
@end

@implementation BSLecturerVC
- (instancetype)initWithLecturer:(BSLecturer*)lecturer startFrame:(CGRect)startFrame
{
    self = [super initWithNibName:NSStringFromClass([BSLecturerVC class]) bundle:nil];
    if (self) {
        self.lecturer = lecturer;
        self.startFrame = startFrame;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backIV.image = [[[UIApplication sharedApplication] keyWindow] bluredScreenshot];
    self.lecturerIV.image = [self.lecturer thumbnail];
    self.lecturerNameLabel.text = [NSString stringWithFormat:@"%@ %@ %@",self.lecturer.lastName, self.lecturer.firstName, self.lecturer.middleName];
    
    self.previewIV = [[UIImageView alloc] initWithFrame:self.startFrame];
    self.previewIV.image = [self.lecturer thumbnail];
    self.previewIV.contentMode = UIViewContentModeScaleAspectFill;
    self.previewIV.layer.cornerRadius = self.previewIV.frame.size.width / 2.0;
    self.previewIV.layer.masksToBounds = YES;
    [self.view addSubview:self.previewIV];
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
}

#define HORISONTAL_OFFSET 20.0
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.backIV.alpha = 0.0;
    self.centerView.alpha = 0.0;
    UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect centerViewFrame = self.centerView.frame;
    CGFloat newWidth = CGRectGetWidth(frontWindow.frame) - 2*HORISONTAL_OFFSET;
    centerViewFrame.size.height *= (newWidth / centerViewFrame.size.width);
    centerViewFrame.size.width = newWidth;
    self.centerView.frame = centerViewFrame;
    self.centerView.center = CGPointMake(frontWindow.frame.size.width / 2.0, frontWindow.frame.size.height / 2.0);
}

#define LECTURER_VC_ANIMATION_DURATION 0.3
#define LECTURER_NAME_ANIMATION_DURATION 0.2
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showCenterView];
    self.originalBounds = self.centerView.bounds;
    self.originalCenter = self.centerView.center;

}
- (void)showCenterView {

    [UIView animateWithDuration:LECTURER_VC_ANIMATION_DURATION animations:^{
        self.previewIV.frame = [self.view convertRect:self.lecturerIV.frame fromView:self.centerView];
        self.previewIV.layer.cornerRadius = 0.0;
        self.backIV.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:LECTURER_NAME_ANIMATION_DURATION animations:^{
            self.centerView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.previewIV removeFromSuperview];
        }];
    }];
}

- (void)dismiss {
    if (!self.dismissing) {
        self.dismissing = YES;
        [UIView animateWithDuration:LECTURER_VC_ANIMATION_DURATION animations:^{
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
    }
}

//===============================================GUSETURE RECOGNISER===========================================
#pragma mark - Guesture recogniser

static const CGFloat ThrowingThreshold = 5000;
static const CGFloat ThrowingVelocityPadding = 35;

- (IBAction) handleTapGesture:(UITapGestureRecognizer*)gesture {
    [self dismiss];
}

- (IBAction) handleAttachmentGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self.view];
    CGPoint boxLocation = [gesture locationInView:self.centerView];

    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
            [self.view removeConstraints:self.centerView.constraints];
            [self.view setNeedsDisplay];
            [self.animator removeAllBehaviors];
            UIOffset centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(self.centerView.bounds),
                                                 boxLocation.y - CGRectGetMidY(self.centerView.bounds));
            self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.centerView
                                                                offsetFromCenter:centerOffset
                                                                attachedToAnchor:location];
            [self.animator addBehavior:self.attachmentBehavior];
            break;
        }
        case UIGestureRecognizerStateEnded: {
            [self.animator removeBehavior:self.attachmentBehavior];
             
             //1
             CGPoint velocity = [gesture velocityInView:self.view];
             CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
             magnitude *= 3;
             if (magnitude > ThrowingThreshold) {
                 //2
                 UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]
                                                 initWithItems:@[self.centerView]
                                                 mode:UIPushBehaviorModeInstantaneous];
                 pushBehavior.pushDirection = CGVectorMake((velocity.x ) , (velocity.y ));
                 pushBehavior.magnitude = magnitude / ThrowingVelocityPadding;
                 __weak typeof(self) weakSelf = self;
                 pushBehavior.action = ^{
                     typeof(weakSelf) self = weakSelf;
                     CGFloat minX = 0.0;
                     CGFloat maxX = CGRectGetMaxX(self.view.frame);
                     CGFloat minY = 0.0;
                     CGFloat maxY = CGRectGetMaxY(self.view.frame);
                     CGPoint centerCenter = self.centerView.center;
                     BOOL inView = (minX < centerCenter.x && maxX > centerCenter.x) && (minY < centerCenter.y && maxY > centerCenter.y);
                     if (!inView) {
                         [self dismiss];
                     }
                 };
                 self.pushBehavior = pushBehavior;
                 [self.animator addBehavior:self.pushBehavior];
                 NSLog(@"magn : %f vx: %f vy: %f", magnitude, velocity.x, velocity.y);
                 
                 CGPoint center = CGPointMake(self.centerView.bounds.size.width / 2.0, self.centerView.bounds.size.width / 2.0);
                 CGPoint location = [gesture locationInView:self.centerView];
                 location.x -= center.x;
                 location.y -= center.y;
                 CGFloat locMod = sqrtf(location.x * location.x + location.y * location.y);
                 CGPoint velPoint = CGPointMake(location.x + velocity.x - center.x, location.y + velocity.y - center.y);

                 CGFloat space = (velPoint.y*(location.x - velPoint.x) - velPoint.x*(location.y - velPoint.y))/ 2.0;
                 
                 CGFloat angularVelocity =  space / 25000.0;
                 
                 self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.centerView]];
                 self.itemBehavior.friction = 0.2;
                 self.itemBehavior.allowsRotation = YES;
                 [self.itemBehavior addAngularVelocity:angularVelocity forItem:self.centerView];
                 [self.animator addBehavior:self.itemBehavior];
                 
                 [self performSelector:@selector(resetDemo) withObject:nil afterDelay:0.4];
             }
             
             else {
                 [self resetDemo];
             }
            break;
        }
        default:
            [self.attachmentBehavior setAnchorPoint:[gesture locationInView:self.view]];
            break;
    }
}

- (void)resetDemo
{
    [self.animator removeAllBehaviors];
    
    [UIView animateWithDuration:0.45 animations:^{
        self.centerView.bounds = self.originalBounds;
        self.centerView.center = self.originalCenter;
        self.centerView.transform = CGAffineTransformIdentity;
    }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
@end
