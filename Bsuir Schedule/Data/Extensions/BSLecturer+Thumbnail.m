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

    NSString *imageURL = self.avatarURL ?: @"";
    NSString *thumbName = [imageURL stringByAppendingString:@"_thumb"];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:(thumb) ? thumbName : imageURL];
    
    if (image) {
        [imageView setImage:image];
    }  else if ([[SDImageCache sharedImageCache] diskImageExistsWithKey:(thumb) ? thumbName : imageURL]) {
        image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:(thumb) ? thumbName : imageURL];
        [imageView setImage:image];
    } else {
        UIActivityIndicatorView *av = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        av.center = CGPointMake(imageView.bounds.size.width / 2.0, imageView.bounds.size.height / 2.0);
        [imageView addSubview:av];
        [av startAnimating];        
        [imageView setImage:[UIImage imageNamed:kNoavatar]];

        [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:imageURL] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [av removeFromSuperview];
            });

            UIImage *image = [UIImage imageWithData:data];

            if (!image || error) { return; }

            UIImage *thumb = [image thumbnail];
            [[SDImageCache sharedImageCache] storeImage:image forKey:imageURL toDisk:YES];
            [[SDImageCache sharedImageCache] storeImage:thumb forKey:thumbName toDisk:YES];

            [imageView setImage:(thumb) ? thumb : image];

        }] resume];
    }
    
}

@end
