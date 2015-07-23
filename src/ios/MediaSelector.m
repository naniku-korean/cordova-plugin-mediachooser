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
        NSString* docsPath             = [NSTemporaryDirectory()stringByStandardizingPath];
        NSFileManager* fileMgr         = [[NSFileManager alloc] init];
        ALAsset* asset                 = nil;
        NSString* filePath;

        for (asset in assets) {
		
            int i = 0;
            do {
		if( [[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"] ){
			filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, @"jpg"];
		} else {
			filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, @"mov"];
		}
                
            } while ([fileMgr fileExistsAtPath:filePath]);
            
            [resultStrings addObject:[[NSURL fileURLWithPath:filePath] absoluteString]];
        }
        
        if ([resultStrings count] > 0) {
            NSString* complete = [resultStrings componentsJoinedByString:@", "];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:
                      [NSString stringWithFormat:@"{ value: true, cancelled: false, paths: [ %@ ]}", complete]];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:
                      @"{ value: false }"];
        }

        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }];
}

@end
