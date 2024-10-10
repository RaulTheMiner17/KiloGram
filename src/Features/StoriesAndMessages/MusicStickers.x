#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGMusicStickerEditorStylePicker

- (void)scrollingSelectorView:(id)scrollingSelectorView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // Call the original method with the correct parameters
    %orig(scrollingSelectorView, indexPath);
    
    // Check if SCIManager allows modification of styleList
    if ([SCIManager MusicStickers]) {
        // Create the new style list array
        NSArray *newStyleList = @[@6, @0, @1, @2, @3, @4, @5, @7, @8, @9];
        
        // Use the setStyleList: method to update the styleList
        [self setStyleList:newStyleList];
        
        NSLog(@"[SCInsta] styleList has been updated to %@", newStyleList);
    } else {
        NSLog(@"[SCInsta] SCIManager prevented modification of styleList");
    }
}

// Override the setStyleList: method to apply custom behavior
- (void)setStyleList:(NSArray *)styleList {
    // Call the original setStyleList: method with the modified list
    %orig(styleList);
    
    NSLog(@"[SCInsta] setStyleList: was called with %@", styleList);
}

%end
