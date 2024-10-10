#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGDirectComposerButton

- (void)layoutSubviews {
    %orig(); // Call the original implementation

    // Check if this button's accessibilityIdentifier is "Sticker-Button"
    if ([self.accessibilityIdentifier isEqualToString:@"Sticker-Button"]) {
        // Add the long-press gesture recognizer if it’s not already added
        for (UIGestureRecognizer *gesture in self.gestureRecognizers) {
            if ([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
                return; // Gesture already added
            }
        }
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressOnStickersButton)];
        [self addGestureRecognizer:longPress];
    }
}

%new - (void)handleLongPressOnStickersButton {
    NSLog(@"[SCInsta] Stickers button long press detected");

    // Check if ShareLoc is available
    if ([SCIManager ShareLoc]) {
        NSLog(@"[SCInsta] ShareLoc is available");

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil 
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleActionSheet];

        UIAlertAction *shareLocationAction = [UIAlertAction actionWithTitle:@"Share Location" 
                                                                      style:UIAlertActionStyleDefault 
                                                                    handler:^(UIAlertAction *action) {
                                                                        NSLog(@"[SCInsta] Share Location selected");

                                                                        UIView *currentView = self;
                                                                        for (int i = 0; i < 3; i++) {
                                                                            if (currentView.superview) {
                                                                                currentView = currentView.superview;
                                                                            } else {
                                                                                NSLog(@"Unable to traverse the view hierarchy further.");
                                                                                return;
                                                                            }
                                                                        }
                                                                        // Get the IGDirectComposer instance
                                                                        IGDirectComposer *composer = (IGDirectComposer *)currentView;

                                                                        // Call the custom method to share location
                                                                        [(IGDirectComposer *)composer shareLocation];
                                                                    }];

        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" 
                                                               style:UIAlertActionStyleCancel 
                                                             handler:nil];

        [alertController addAction:shareLocationAction];
        [alertController addAction:cancelAction];

        UIViewController *rootController = [[UIApplication sharedApplication] delegate].window.rootViewController;
        [rootController presentViewController:alertController animated:YES completion:nil];
    } else {
        NSLog(@"[SCInsta] ShareLoc is not available");
    }
}

%end

%hook IGDirectComposer

%new - (void)shareLocation {
    [self _didTapLocationSharingButton:nil];
}

%end
