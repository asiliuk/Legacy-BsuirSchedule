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
#import "UIImage+Thumbnail.h"
#import "BSConstants.h"

#import "SDImageCache.h"

static NSString * const kNoavatar = @"noavatar";

@implementation BSLecturer (Thumbnail)

#define LECTURER_ID_KEY @"lecturerID"
- (void)loadLecturerImageIn:(UIImageView *)imageView {
    [self loadLecturerImageIn:imageView thumb:YES];
}
- (void)loadLecturerImageIn:(UIImageView *)imageView thumb:(BOOL)thumb {
    if ([[NSUserDefaults sharedDefaults] boolForKey:kEasterEggMode]) {
        [imageView setImage:[UIImage imageNamed:@"my_face.jpg"]];
        return;
    }
    NSString *imageName = [[NSString stringWithFormat:@"%@_%@_%@", self.lastName, self.firstName, self.middleName] toLatinWithDictionary];
    NSString *thumbName = [imageName stringByAppendingString:@"_thumb"];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:(thumb) ? thumbName : imageName];
    if (image) {
        [imageView setImage:image];
    }  else if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:(thumb) ? thumbName : imageName]) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:(thumb) ? thumbName : imageName];
        [imageView setImage:image];
    } else {
        UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        av.center = CGPointMake(imageView.bounds.size.width / 2.0, imageView.bounds.size.height / 2.0);
        [imageView addSubview:av];
        [av startAnimating];        
        [imageView setImage:[UIImage imageNamed:kNoavatar]];
        PFQuery *query = [PFQuery queryWithClassName:NSStringFromClass([BSLecturer class])];
        [query whereKey:@"lecturerID" equalTo:self.lecturerID];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{

                if ([objects count] > 0) {
                    PFObject *lecturer = [objects firstObject];
                    PFFile *imageFile = lecturer[@"image"];
                    NSData *imageData = [imageFile getData];
                    UIImage *image = [UIImage imageNamed:kNoavatar];
                    if (imageData.length > 0) {
                        image = [UIImage imageWithData:imageData];
                    } else if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:imageName]){
                        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageName];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIImage *thumb = [image thumbnail];
                        [[SDImageCache sharedImageCache] storeImage:image forKey:imageName toDisk:YES];
                        [[SDImageCache sharedImageCache] storeImage:thumb forKey:thumbName toDisk:YES];

                        [imageView setImage:(thumb) ? thumb : image];
                        [av removeFromSuperview];
                    });

                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [av removeFromSuperview];
                    });
                }
            });
        }];
    }
    
}

@end
