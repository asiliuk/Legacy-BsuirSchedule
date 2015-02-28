//
//  BSLecturer+Thumbnail.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 18.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSLecturer+Thumbnail.h"
#import "NSString+Transiterate.h"
#import "NSUserDefaults+Share.h"
#import "BSConstants.h"

static NSString * const kNoavatar = @"noavatar";

@implementation BSLecturer (Thumbnail)

#define LECTURER_ID_KEY @"lecturerID"
- (void)loadLecturerImageIn:(PFImageView *)imageView {
    PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([BSLecturer class])];
    [query whereKey:LECTURER_ID_KEY equalTo:self.lecturerID];
    [query fromLocalDatastore];
    __weak typeof(self) weakself = self;
    imageView.image = [UIImage imageNamed:kNoavatar];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        typeof(weakself) self = weakself;
        if ([objects count] == 0) {
            UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            ai.center = CGPointMake(imageView.bounds.size.width / 2.0, imageView.bounds.size.width / 2.0);
            [imageView addSubview:ai];
            [ai startAnimating];
            PFQuery *gquery = [PFQuery queryWithClassName:NSStringFromClass([BSLecturer class])];
            [gquery whereKey:LECTURER_ID_KEY equalTo:self.lecturerID];
            [gquery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                [ai removeFromSuperview];
                if (!error) {
                    PFObject *lecturerObj = [objects firstObject];
                    PFFile *imageFile = lecturerObj[@"image"];
                    imageView.file = imageFile;
                    [imageView loadInBackground];
                    [lecturerObj pinInBackground];
                }
            }];
        }
        PFObject *lecturerObj = [objects firstObject];
        PFFile *imageFile = lecturerObj[@"image"];
        imageView.file = imageFile;
        [imageView loadInBackground];
    }];
}
@end
