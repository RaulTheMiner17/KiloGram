#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGRegistrationWelcomeViewController

- (void)viewDidLoad {
    %orig;
    
    // Check if DevOptions is enabled using SCIManager
    if ([SCIManager DevOptions]) {
        if ([self respondsToSelector:@selector(_developerOptionsView)]) {
            UIViewController *developerOptionsView = [self _developerOptionsView];
            
            if (developerOptionsView) {
                [self presentViewController:developerOptionsView animated:YES completion:nil];
            }
        }
    }
}

%end


%hook IGUser

// Hooking into the -[IGUser isEmployeeOrTestUserWithUserFeatureSet:] method
- (bool)isEmployeeOrTestUserWithUserFeatureSet:(id)featureSet {
    // Call the original method to get the original return value
    bool originalResult = %orig(featureSet);

    // Add custom logic here
    // For example, you could modify the result based on specific conditions
    bool customResult = originalResult;
    customResult = true;
    

    // Log or debug the feature set if needed
    NSLog(@"[Tweak] Feature Set: %@", featureSet);
    NSLog(@"[Tweak] Original Result: %d", originalResult);
    NSLog(@"[Tweak] Custom Result: %d", customResult);

    // Return the custom result
    return customResult;
}

%end

%hook IGSeenStateStore

- (instancetype)initWithDependencies:(id)dependencies isEmployee:(bool)employee {
    // Call the original initializer with `isEmployee` set to YES
    self = %orig(dependencies, YES);
    if (self) {
        // Use Objective-C runtime to access and set _isEmployee
        Ivar isEmployeeIvar = class_getInstanceVariable([self class], "_isEmployee");
        if (isEmployeeIvar) {
            object_setIvar(self, isEmployeeIvar, @(YES));
        }
    }
    return self;
}

%end





%hook IGBugReportMenuViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = %orig;

    // Check if the cell corresponds to "Internal Settings"
    if ([[cell textLabel].text isEqualToString:@"Internal Settings"]) {
        // Add custom logic here if needed
        NSLog(@"Internal Settings cell detected");
        
        // Optionally, you can simulate a tap on the "Internal Settings" cell here
        // [self openInternalSettings];
    }

    return cell;
}

- (BOOL)canRespondToGesture:(id)gesture {
    // Set the boolean to true
    return YES;
}
%end

%hook BCNComposerController

// Hook the getter to always return NO
- (BOOL)employeeInternalOnlyEnabled {
    return NO;
}
%end