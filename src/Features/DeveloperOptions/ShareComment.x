#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGCommentThreadViewController

- (void)commentController:(id)controller didTapLikeForComment:(id)comment {
    // Call the original method
    %orig(controller, comment);

    // Check if sharing is enabled or appropriate
    if ([SCIManager ShareComment]) {
        // Trigger didTapShareSheetWithComment if the condition is met
        [self commentController:controller didTapShareSheetWithComment:comment];
    } else {
        // Optionally handle the case where sharing is not enabled
        NSLog(@"ShareComment is not enabled or appropriate.");
    }
}
%end
