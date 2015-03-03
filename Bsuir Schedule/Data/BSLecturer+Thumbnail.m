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

#import "SDImageCache.h"

static NSString * const kNoavatar = @"noavatar";

@implementation BSLecturer (Thumbnail)

#define LECTURER_ID_KEY @"lecturerID"
- (void)loadLecturerImageIn:(UIImageView *)imageView {
    if ([[NSUserDefaults sharedDefaults] boolForKey:kEasterEggMode]) {
        [imageView setImage:[UIImage imageNamed:@"my_face.jpg"]];
        return;
    }
    NSString *thumbName = [[NSString stringWithFormat:@"%@_%@_%@", self.lastName, self.firstName, self.middleName] toLatinWithDictionary];
    if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:thumbName]) {
        [imageView setImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbName]];
    } else {
        UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        av.center = CGPointMake(imageView.bounds.size.width / 2.0, imageView.bounds.size.height / 2.0);
        [imageView addSubview:av];
        [av startAnimating];        
        [imageView setImage:[UIImage imageNamed:kNoavatar]];
        PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([BSLecturer class])];
        [query whereKey:@"lecturerID" equalTo:self.lecturerID];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

                if ([objects count] > 0) {
                    PFObject *lecturer = [objects firstObject];
                    PFFile *imageFile = lecturer[@"image"];
                    NSData *imageData = [imageFile getData];
                    UIImage *image = [UIImage imageNamed:kNoavatar];
                    if (imageData.length > 0) {
                        image = [UIImage imageWithData:imageData];
                    } else if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:thumbName]){
                        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:thumbName];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[SDImageCache sharedImageCache] storeImage:image forKey:thumbName toDisk:YES];
                        [imageView setImage:image];
                        [av removeFromSuperview];
                    });

                }
            });
        }];
    }
    
}

@end
