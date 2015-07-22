#import <AVFoundation/AVFoundation.h>
#import "MediaSelector.h"

#define CDV_PHOTO_PREFIX @"cdv_photo_"

@implementation MediaSelector

- (void)getPictures:(CDVInvokedUrlCommand*)command
{
    [self.commandDelegate runInBackground:^{
        self.callbackId = command.callbackId;

        self.maximumNumberOfSelectionMedia = [[[command arguments] objectAtIndex:0] integerValue];

        // initialize Picker
		UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];		
        picker.delegate = self;
		
		picker.maximumNumberOfSelectionMedia = self.maximumNumberOfSelectionMedia;

        // show Picker
        [self.viewController presentViewController:picker animated:YES completion:^{
            // noop
        }];
    }];
}

- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [self.commandDelegate runInBackground:^{
        CDVPluginResult* result        = nil;
        NSMutableArray *resultStrings  = [[NSMutableArray alloc] init];
        NSData* data                   = nil;
        NSString* docsPath             = [NSTemporaryDirectory()stringByStandardizingPath];
        NSError* err                   = nil;
        NSFileManager* fileMgr         = [[NSFileManager alloc] init];
        ALAsset* asset                 = nil;
        UIImageOrientation orientation = UIImageOrientationUp;
        CGSize targetSize              = CGSizeMake(2048, 2048);
        NSString* filePath;

        for (ALAsset *asset in assets) {
		
            int i = 1;
            do {
				if( [[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"] ){
					filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, @"jpg"];
				} else {
					filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, @"mov"];
				}
                
            } while ([fileMgr fileExistsAtPath:filePath]);

            @autoreleasepool {
                ALAssetRepresentation *assetRep = [asset defaultRepresentation];
                CGImageRef imgRef = NULL;

                if (![data writeToFile:filePath options:NSAtomicWrite error:&err]) {
                    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_IO_EXCEPTION messageAsString:[err localizedDescription]];
                    break;
                } else {
                    [resultStrings addObject:[[NSURL fileURLWithPath:filePath] absoluteString]];
                }
            }

        }

        if (nil == result) {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:resultStrings];
        }

        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }];
}

@end