#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGCommentThreadViewController

- (void)commentController:(id)controller didTapLikeForComment:(id)comment {
    // Create a popup (UIAlertController) with options
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Like or Share Comment"
                                                                             message:@"Tweak by Raul"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

    // Add "Like Comment" option
    UIAlertAction *likeAction = [UIAlertAction actionWithTitle:@"Like Comment"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        // Call the original didTapLikeForComment method
        %orig(controller, comment);
    }];

    // Add "Share Comment" option
    UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"Share Comment"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action) {
        // Call didTapShareSheetWithComment if ShareComment condition is met
        if ([SCIManager ShareComment]) {
            [self commentController:controller didTapShareSheetWithComment:comment];
        } else {
            NSLog(@"ShareComment is not enabled or appropriate.");
        }
    }];

    // Add "Cancel" option
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];

    // Add actions to the alertController
    [alertController addAction:likeAction];
    [alertController addAction:shareAction];
    [alertController addAction:cancelAction];

    // Present the popup (alertController)
    [self presentViewController:alertController animated:YES completion:nil];
}

%end
