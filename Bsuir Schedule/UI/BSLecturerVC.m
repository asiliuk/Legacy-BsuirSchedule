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
    self.originalBounds = self.centerView.bounds;
    self.originalCenter = self.centerView.center;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showCenterView];
}

#define LECTURER_VC_ANIMATION_DURATION 0.3
- (void)showCenterView {
    self.backIV.alpha = 0.0;
    self.centerView.alpha = 0.0;
    [UIView animateWithDuration:LECTURER_VC_ANIMATION_DURATION animations:^{
        self.previewIV.frame = [self.view convertRect:self.lecturerIV.frame fromView:self.centerView];
        self.previewIV.layer.cornerRadius = 0.0;
        self.backIV.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:LECTURER_VC_ANIMATION_DURATION animations:^{
            self.centerView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [self.previewIV removeFromSuperview];
        }];
    }];
}

//===============================================GUSETURE RECOGNISER===========================================
#pragma mark - Guesture recogniser

static const CGFloat ThrowingThreshold = 5000;
static const CGFloat ThrowingVelocityPadding = 35;

- (IBAction) handleAttachmentGesture:(UIPanGestureRecognizer*)gesture
{
    CGPoint location = [gesture locationInView:self.view];
    CGPoint boxLocation = [gesture locationInView:self.centerView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:{
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
             
             if (magnitude > ThrowingThreshold) {
                 //2
                 UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]
                                                 initWithItems:@[self.centerView]
                                                 mode:UIPushBehaviorModeInstantaneous];
                 pushBehavior.pushDirection = CGVectorMake((velocity.x / 10) , (velocity.y / 10));
                 pushBehavior.magnitude = magnitude / ThrowingVelocityPadding;
                 
                 self.pushBehavior = pushBehavior;
                 [self.animator addBehavior:self.pushBehavior];
                 
                 //3
                 NSInteger angle = arc4random_uniform(20) - 10;
                 
                 self.itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.centerView]];
                 self.itemBehavior.friction = 0.2;
                 self.itemBehavior.allowsRotation = YES;
                 [self.itemBehavior addAngularVelocity:angle forItem:self.centerView];
                 [self.animator addBehavior:self.itemBehavior];
                 
                 //4
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

@end
