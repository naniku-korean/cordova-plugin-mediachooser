#import <AVFoundation/AVFoundation.h>
#import "MediaSelector.h"

#define CDV_PHOTO_PREFIX @"cmc_photo_"
#define CDV_VIDEO_PREFIX @"cmc_video_"

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
        int i = 0;
        
        for (asset in assets) {

            if( [[asset valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"] ){
                filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_PHOTO_PREFIX, i++, @"jpg"];
            } else {
                filePath = [NSString stringWithFormat:@"%@/%@%03d.%@", docsPath, CDV_VIDEO_PREFIX, i++, @"mov"];
            }

            ALAssetsLibrary *assetLibrary=[[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:asset.defaultRepresentation.url resultBlock:^(ALAsset *asset)
             {
                 ALAssetRepresentation *rep = [asset defaultRepresentation];
                 Byte *buffer = (Byte*)malloc(rep.size);
                 NSUInteger buffered = [rep getBytes:buffer fromOffset:0 length:rep.size error:nil];
                 NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];//this is NSData may be what you want
                 [data writeToFile:filePath atomically:YES];//you can save image later
             }
                         failureBlock:^(NSError *err)
             {
                 NSLog(@"Error: %@",[err localizedDescription]);
                 
             }];
            
            NSString* nPath = [NSString stringWithFormat: @"\"%@\"",  filePath];

            [resultStrings addObject:nPath];
        }
        
        if ([resultStrings count] > 0) {
            NSString* complete = [resultStrings componentsJoinedByString:@", "];
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:
                      [NSString stringWithFormat:@"{\"value\":\"true\", \"cancelled\":\"false\", \"paths\":[ %@ ]}", complete]];
        } else {
            result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:
                      @"{\"value\":\"false\"}"];
        }

        [self.viewController dismissViewControllerAnimated:YES completion:nil];
        [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
    }];
}


- (void)uzysAssetsPickerControllerDidExceedMaximumNumberOfSelection:(UzysAssetsPickerController *)picker {
    NSString* resultString = [NSString stringWithFormat:@"Exceed Maximum number of Selection (%ld)", (long)self.maximumNumberOfSelectionMedia];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning" message:resultString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}

- (void)uzysAssetsPickerControllerDidCancel:(UzysAssetsPickerController *)picker {
    CDVPluginResult* result;
    //user cancel
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:
              @"{\"value\":\"true\", \"cancelled\":\"false\"}"];
    
    [self.commandDelegate sendPluginResult:result callbackId:self.callbackId];
}

@end