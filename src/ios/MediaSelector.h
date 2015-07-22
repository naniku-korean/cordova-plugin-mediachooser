#import <Cordova/CDVPlugin.h>
#import "UzysAssetsPickerController.h"

@interface MediaSelector : CDVPlugin <UzysAssetsPickerControllerDelegate> {}

@property (nonatomic, copy) NSString* callbackId;
@property (nonatomic, assign) NSInteger maximumNumberOfSelectionMedia;

- (void)getPictures:(CDVInvokedUrlCommand*)command;
@end
