#import "SettingsViewController.h"

@interface SCISettingsViewController ()
@property (nonatomic, assign) BOOL hasDynamicSpecifiers;
@property (nonatomic, retain) NSMutableDictionary *dynamicSpecifiers;
@end

@implementation SCISettingsViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"RaulGram";
        [self.navigationController.navigationBar setPrefersLargeTitles:false];
    }
    return self;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleInsetGrouped;
}

// Pref Section
- (PSSpecifier *)newSectionWithTitle:(NSString *)header footer:(NSString *)footer {
    PSSpecifier *section = [PSSpecifier preferenceSpecifierNamed:header target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
    if (footer != nil) {
        [section setProperty:footer forKey:@"footerText"];
    }
    return section;
}

// Pref Switch Cell
- (PSSpecifier *)newSwitchCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText key:(NSString *)keyText defaultValue:(BOOL)defValue changeAction:(SEL)changeAction {
    PSSpecifier *switchCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
    
    [switchCell setProperty:keyText forKey:@"key"];
    [switchCell setProperty:keyText forKey:@"id"];
    [switchCell setProperty:@YES forKey:@"big"];
    [switchCell setProperty:SCISwitchTableCell.class forKey:@"cellClass"];
    [switchCell setProperty:NSBundle.mainBundle.bundleIdentifier forKey:@"defaults"];
    [switchCell setProperty:@(defValue) forKey:@"default"];
    [switchCell setProperty:NSStringFromSelector(changeAction) forKey:@"switchAction"];
    if (detailText != nil) {
        [switchCell setProperty:detailText forKey:@"subtitle"];
    }
    return switchCell;
}

// Pref Button Cell
- (PSSpecifier *)newButtonCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText dynamicRule:(NSString *)rule action:(SEL)action {
    PSSpecifier *buttonCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSButtonCell edit:nil];
    
    [buttonCell setButtonAction:action];
    [buttonCell setProperty:@YES forKey:@"big"];
    [buttonCell setProperty:SCIButtonTableViewCell.class forKey:@"cellClass"];
    if (detailText != nil ){
        [buttonCell setProperty:detailText forKey:@"subtitle"];
    }
    if (rule != nil) {
        [buttonCell setProperty:@44 forKey:@"height"];
        [buttonCell setProperty:rule forKey:@"dynamicRule"];
    }
    return buttonCell;
}

// Pref Link Cell
- (PSSpecifier *)newLinkCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText url:(NSString *)url iconURL:(NSString *)iconURL {
    PSSpecifier *LinkCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSButtonCell edit:nil];
    
    [LinkCell setButtonAction:@selector(hb_openURL:)];
    [LinkCell setProperty:HBLinkTableCell.class forKey:@"cellClass"];
    [LinkCell setProperty:url forKey:@"url"];
    if (detailText != nil) {
        [LinkCell setProperty:detailText forKey:@"subtitle"];
    }
    if (iconURL != nil) {
        [LinkCell setProperty:iconURL forKey:@"iconURL"];
        [LinkCell setProperty:@YES forKey:@"iconCircular"];
        [LinkCell setProperty:@YES forKey:@"big"];
        [LinkCell setProperty:@56 forKey:@"height"];
    }
    return LinkCell;
}

// Tweak settings
- (NSArray *)specifiers {
    if (!_specifiers) {        
        _specifiers = [NSMutableArray arrayWithArray:@[
            // Section 1: Developer Options
            [self newSectionWithTitle:@"Hidden Developer Options" footer:nil],
            [self newSwitchCellWithTitle:@"Enable Internal Settings" detailTitle:@"Enables internal/employee only settings" key:@"dev_options" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"Enable music stickers" detailTitle:@"Adds new stickers to music in story" key:@"music_stickers" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"Share comment" detailTitle:@"Shows sharesheet to share a comment" key:@"share_comment" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"Share location" detailTitle:@"Share location in chat" key:@"share_loc" defaultValue:false changeAction:nil],

            // Section 2: Debugging
            [self newSectionWithTitle:@"Debugging" footer:nil],
            [self newSwitchCellWithTitle:@"Enable FLEX gesture" detailTitle:@"Allows you to hold 5 fingers on the screen to open the FLEX explorer" key:@"flex_instagram" defaultValue:false changeAction:@selector(FLEXAction:)],

            // Section 3: Credits
            [self newSectionWithTitle:@"Credits" footer:[NSString stringWithFormat:@"SCInsta %@\n\nInstagram v%@", SCIVersionString, [SCIUtils IGVersionString]]],
            [self newLinkCellWithTitle:@"Developer" detailTitle:@"Raul Fernandes" url:@"https://github.com/RaulTheMiner17" iconURL:@"https://imgur.com/RVhZZhy.png"],
            [self newLinkCellWithTitle:@"View Repo" detailTitle:@"View the tweak's source code on GitHub" url:@"https://github.com/RaulTheMiner17/RaulGram" iconURL:nil]
        ]];
        
        [self collectDynamicSpecifiersFromArray:_specifiers];
    }
    
    return _specifiers;
}

- (void)reloadSpecifiers {
    [super reloadSpecifiers];
    
    [self collectDynamicSpecifiersFromArray:self.specifiers];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasDynamicSpecifiers) {
        PSSpecifier *dynamicSpecifier = [self specifierAtIndexPath:indexPath];
        BOOL __block shouldHide = false;
        
        [self.dynamicSpecifiers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableArray *specifiers = obj;
            if ([specifiers containsObject:dynamicSpecifier]) {
                shouldHide = [self shouldHideSpecifier:dynamicSpecifier];
                
                UITableViewCell *specifierCell = [dynamicSpecifier propertyForKey:PSTableCellKey];
                specifierCell.clipsToBounds = shouldHide;
            }
        }];
        if (shouldHide) {
            return 0;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (void)collectDynamicSpecifiersFromArray:(NSArray *)array {
    if (!self.dynamicSpecifiers) {
        self.dynamicSpecifiers = [NSMutableDictionary new];
        
    } else {
        [self.dynamicSpecifiers removeAllObjects];
    }
    
    for (PSSpecifier *specifier in array) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        
        if (dynamicSpecifierRule.length > 0) {
            NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];
            
            if (ruleComponents.count == 3) {
                NSString *opposingSpecifierID = [ruleComponents objectAtIndex:0];
                if ([self.dynamicSpecifiers objectForKey:opposingSpecifierID]) {
                    NSMutableArray *specifiers = [[self.dynamicSpecifiers objectForKey:opposingSpecifierID] mutableCopy];
                    [specifiers addObject:specifier];
                    
                    
                    [self.dynamicSpecifiers removeObjectForKey:opposingSpecifierID];
                    [self.dynamicSpecifiers setObject:specifiers forKey:opposingSpecifierID];
                } else {
                    [self.dynamicSpecifiers setObject:[NSMutableArray arrayWithArray:@[specifier]] forKey:opposingSpecifierID];
                }
                
            } else {
                [NSException raise:NSInternalInconsistencyException format:@"dynamicRule key requires three components (Specifier ID, Comparator, Value To Compare To). You have %ld of 3 (%@) for specifier '%@'.", ruleComponents.count, dynamicSpecifierRule, [specifier propertyForKey:PSTitleKey]];
            }
        }
    }
    
    self.hasDynamicSpecifiers = (self.dynamicSpecifiers.count > 0);
}
- (DynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string {
    NSDictionary *operatorValues = @{ @"==" : @(EqualToOperatorType), @"!=" : @(NotEqualToOperatorType), @">" : @(GreaterThanOperatorType), @"<" : @(LessThanOperatorType) };
    return [operatorValues[string] intValue];
}
- (BOOL)shouldHideSpecifier:(PSSpecifier *)specifier {
    if (specifier) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];
        
        PSSpecifier *opposingSpecifier = [self specifierForID:[ruleComponents objectAtIndex:0]];
        id opposingValue = [self readPreferenceValue:opposingSpecifier];
        id requiredValue = [ruleComponents objectAtIndex:2];
        
        if ([opposingValue isKindOfClass:NSNumber.class]) {
            DynamicSpecifierOperatorType operatorType = [self operatorTypeForString:[ruleComponents objectAtIndex:1]];
            
            switch (operatorType) {
                case EqualToOperatorType:
                    return ([opposingValue intValue] == [requiredValue intValue]);
                    break;
                    
                case NotEqualToOperatorType:
                    return ([opposingValue intValue] != [requiredValue intValue]);
                    break;
                    
                case GreaterThanOperatorType:
                    return ([opposingValue intValue] > [requiredValue intValue]);
                    break;
                    
                case LessThanOperatorType:
                    return ([opposingValue intValue] < [requiredValue intValue]);
                    break;
            }
        }
        
        if ([opposingValue isKindOfClass:NSString.class]) {
            return [opposingValue isEqualToString:requiredValue];
        }
        
        if ([opposingValue isKindOfClass:NSArray.class]) {
            return [opposingValue containsObject:requiredValue];
        }
    }
    
    return NO;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    [Prefs setValue:value forKey:[specifier identifier]];

    NSLog(@"[SCInsta] Set user default. Key: %@ | Value: %@", [specifier identifier], value);
    
    if (self.hasDynamicSpecifiers) {
        NSString *specifierID = [specifier propertyForKey:PSIDKey];
        PSSpecifier *dynamicSpecifier = [self.dynamicSpecifiers objectForKey:specifierID];
        
        if (dynamicSpecifier) {
            [self.table beginUpdates];
            [self.table endUpdates];
        }
    }
}
- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    return [Prefs valueForKey:[specifier identifier]]?:[specifier properties][@"default"];
}

- (void)FLEXAction:(UISwitch *)sender {
    if (sender.isOn) {
        [[objc_getClass("FLEXManager") sharedManager] showExplorer];

        NSLog(@"[SCInsta] FLEX explorer: Enabled");
    }
    else {
        [[objc_getClass("FLEXManager") sharedManager] hideExplorer];

        NSLog(@"[SCInsta] FLEX explorer: Disabled");
    }
}
@end

@implementation SCIButtonTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];
    if (self) {
        NSString *subTitle = [specifier.properties[@"subtitle"] copy];
        BOOL isBig = specifier.properties[@"big"] ? ((NSNumber *)specifier.properties[@"big"]).boolValue : NO;
        self.detailTextLabel.text = subTitle;
        self.detailTextLabel.numberOfLines = isBig ? 0 : 1;
        self.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    }
    return self;
}

@end

@implementation SCISwitchTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier])) {
        NSString *subTitle = [specifier.properties[@"subtitle"] copy];
        BOOL isBig = specifier.properties[@"big"] ? ((NSNumber *)specifier.properties[@"big"]).boolValue : NO;
        self.detailTextLabel.text = subTitle;
        self.detailTextLabel.numberOfLines = isBig ? 0 : 1;
        self.detailTextLabel.textColor = [UIColor secondaryLabelColor];
        
        if (specifier.properties[@"switchAction"]) {
            UISwitch *targetSwitch = ((UISwitch *)[self control]);
            NSString *strAction = [specifier.properties[@"switchAction"] copy];
            [targetSwitch addTarget:[self cellTarget] action:NSSelectorFromString(strAction) forControlEvents:UIControlEventValueChanged];
        }
    }
    return self;
}
@end