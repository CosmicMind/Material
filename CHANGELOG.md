## 3.1.8

- [pr-1269](https://github.com/CosmicMind/Material/pull/1269): Fixed Xcode 11 crash, where layoutMargins are not available before iOS 13.
- [pr-1270](https://github.com/CosmicMind/Material/pull/1270): Fixed missing argument in Swift Package Manager.
* Updated to [Motion 3.1.3](https://github.com/CosmicMind/Motion/releases/tag/3.1.3). 

## 3.1.7

* Fixed Grid issues, where the layout calculations were being deferred and causing inconsistencies in layouts.
* Updated to [Motion 3.1.2](https://github.com/CosmicMind/Motion/releases/tag/3.1.2).

## 3.1.6
- [issue-1245](https://github.com/CosmicMind/Material/issues/1245): Fixed issue where completion block was not executed when calling Switch.toggle.

## 3.1.5

- [pr-1248](https://github.com/CosmicMind/Material/pull/1248): Exposed Obj-C methods for NavigationDrawerController.
  - [issue-1247](https://github.com/CosmicMind/Material/issues/1247): Several methods in NavigationDrawerController not visible in Obj-C.

## 3.1.4

- [pr-1239](https://github.com/CosmicMind/Material/pull/1239): Fixed regression with intrinsic content sizing in Switch control. 
- [pr-1240](https://github.com/CosmicMind/Material/pull/1240): Fixed prepare method called twice.
  - [issue-1215](https://github.com/CosmicMind/Material/issues/1215): prepare() is called twice on NavigationDrawerController.
  
## 3.1.3

* Added installation instructions to README.

- [pr-1236](https://github.com/CosmicMind/Material/pull/1236): Added Layout relations.
  - [issue-1220](https://github.com/CosmicMind/Material/issues/1220): Support all relations for Layout constraints.

## 3.1.2

- [pr-1233](https://github.com/CosmicMind/Material/pull/1233): Fixed Layout breaks - subview ordering.
  - [issue-1232](https://github.com/CosmicMind/Material/issues/1232): Layout breaks view arrangements.
  
## 3.1.1

- [pr-2131](https://github.com/CosmicMind/Material/pull/2131): Storyboard TextField fixes.
  - [issue-1229](https://github.com/CosmicMind/Material/issues/1229): TextField's tintColor doesn't support user setting.
  - [issue-1230](https://github.com/CosmicMind/Material/issues/1230): Button's title font doesn't support user setting.

## 3.1.0

- Updated to swift 5.

## 3.0.0

- Updated to swift 4.2.
- [pr-1124](https://github.com/CosmicMind/Material/pull/1124): Fixed issue-1123, TextField is not scrolling.
  - [issue-1123](https://github.com/CosmicMind/Material/issues/1123): TextField is not scrolling when inputing characters and using a large Font size.
- [pr-1126](https://github.com/CosmicMind/Material/pull/1126): Cleaned up TextField.
- [pr-1130](https://github.com/CosmicMind/Material/pull/1130): Addressed multiple issues.
  - [issue-1125](https://github.com/CosmicMind/Material/issues/1125): TextView with animated placeholder.
  - [issue-1127](https://github.com/CosmicMind/Material/issues/1127): TextView auto-adjust height based on text lines.
  - [issue-1128](https://github.com/CosmicMind/Material/issues/1128): TextField animates weird when text alignment is .right and we have textInset.
  - Removed `textInset: CGFloat` and added `textInsets: EdgeInsets` to `TextField`.
- [pr-1134](https://github.com/CosmicMind/Material/pull/1134): Added swipe feature to BottomNavigationController.
  - [issue-1132](https://github.com/CosmicMind/Material/issues/1132): BottomNavigationController same swipe behaviour as TabsController.
- [pr-1147](https://github.com/CosmicMind/Material/pull/1147): Allow framework to be linked from extensions.
- [pr-1151](https://github.com/CosmicMind/Material/pull/1151): New features.
  - Added `left/right/above/below` directions to `DepthPreset`.
  - Added `.custom(x)` case for `HeightPreset`.
  - Added support for `heightPreset` in `BottomNavigationController`. [issue-1150](https://github.com/CosmicMind/Material/issues/1150)
- [pr-1165](https://github.com/CosmicMind/Material/pull/1165): Added interactive swipe.
  - [issue-1135](https://github.com/CosmicMind/Material/issues/1135): Convert swiping in TabsController and BottomNavigationController to interactive.
- [pr-1115](https://github.com/CosmicMind/Material/pull/1115): Introducing Theming to Material.
- [pr-1173](https://github.com/CosmicMind/Material/pull/1173): Added dialogs.
- [pr-1174](https://github.com/CosmicMind/Material/pull/1174): Added disabling theming globally and per-class.
- [pr-1183](https://github.com/CosmicMind/Material/pull/1183): Added global theme font.
- [pr-1185](https://github.com/CosmicMind/Material/pull/1185): Reworked layout system.
- [pr-1186](https://github.com/CosmicMind/Material/pull/1186): Fixed SnackBar laid out incorrectly.
- [pr-1187](https://github.com/CosmicMind/Material/pull/1187): Added option for disabling snackbar layout edge inset calculation 

## 2.17.0

* Updated for Swift 4.2.
* Updated to [Motion 1.5.0](https://github.com/CosmicMind/Motion/releases/tag/1.5.0)

## 2.16.4

* [pr-1120](https://github.com/CosmicMind/Material/pull/1120): Fixed issue where TextField cursor was not being repositioned correctly.
  * [issue-1119](https://github.com/CosmicMind/Material/issues/1119): Cursor position was incorrectly being positioned when toggling security entry.

## 2.16.3

* Updated to [Motion 1.4.3](https://github.com/CosmicMind/Motion/releases/tag/1.4.3)
* [pr-1116](https://github.com/CosmicMind/Material/pull/1116): ViewController-oriented clean up.
* [pr-1117](https://github.com/CosmicMind/Material/pull/1117): Fixed TextView font issue with emojis.
  * [issue-838](https://github.com/CosmicMind/Material/issues/838): TextView's font breaks when you type emoji.

## 2.16.2

* [pr-1113](https://github.com/CosmicMind/Material/pull/1113): Added update() to Grid.
* [pr-1112](https://github.com/CosmicMind/Material/pull/1112): Added tab bar centering.
  * [issue-926](https://github.com/CosmicMind/Material/issues/926): TabsController - centering TabItem after selection.
* [pr-1114](https://github.com/CosmicMind/Material/pull/1114): Added option to adjust tabBar line width.
  * [issue-1109](https://github.com/CosmicMind/Material/issues/1109): Want to change TabBar line width.

## 2.16.1

* [issue-1110](https://github.com/CosmicMind/Material/issues/1110): Fixed an issue where the depth of a view was being clipped incorrectly. 
* [pr-1111](https://github.com/CosmicMind/Material/pull/1111): Fixed TabItem - was not being changed on swipe.
* [pr-1106](https://github.com/CosmicMind/Material/pull/1106): Added ability to show visibility and clear button at the same time.
  * [issue-992](https://github.com/CosmicMind/Material/issues/992): Visibility & Clear Button can't be shown in TextField at the same time.
* [pr-1104](https://github.com/CosmicMind/Material/pull/1104): Added missing devices.
* [pr-1101](https://github.com/CosmicMind/Material/pull/1101): Enum for support iPhoneX.

## 2.16.0

* Updated to [Motion 1.4.2](https://github.com/CosmicMind/Motion/releases/tag/1.4.2).
* [pr-1004](https://github.com/CosmicMind/Material/pull/1004): Added RadioButton/CheckButton and RadioButtonGroup/CheckButtonGroup.
  * [issue-505](https://github.com/CosmicMind/Material/issues/505): Add RadioButton and Checkbox.
* Updated to [Motion 1.4.0](https://github.com/CosmicMind/Motion/releases/tag/1.4.0). 
  * [issue-1078](https://github.com/CosmicMind/Material/issues/1078): Update Motion Dependency.  
* [pr-1047](https://github.com/CosmicMind/Material/pull/1047): Document material color codes.
  * [issue-1000](https://github.com/CosmicMind/Material/issues/1000): Color: Document mapping from codes (e.g. a400) to names (e.g. accent1).  
* [pr-1055](https://github.com/CosmicMind/Material/pull/1055): Open up FABMenu a little bit.  
* Updated Copyright years.
* [pr-1079](https://github.com/CosmicMind/Material/pull/1079): Added custom navigationBarClass support to NavigationController.
  * [issue-1074](https://github.com/CosmicMind/Material/issues/1074): Need to use a NavigationBar subclass with NavigationController.
* [pr-1080](https://github.com/CosmicMind/Material/pull/1080): Fixed license badge href.
* [pr-1046](https://github.com/CosmicMind/Material/pull/1046): Added ShouldOpen and ShouldClose delegate methods to FABMenuDelegate.
  * [issue-1043](https://github.com/CosmicMind/Material/issues/1043): ShouldOpen and ShouldClose delegate methods FABMenu.
* [pr-1086](https://github.com/CosmicMind/Material/pull/1086): Fix delegations never fired on tab swipe.
  * [issue-1087](https://github.com/CosmicMind/Material/issues/1087): TabBar item is selected even though TabsController delegate shouldSelect always returns false.
  * [issue-1056](https://github.com/CosmicMind/Material/issues/1056): Delegation methods never fired on Tab swipe.
* [pr-1088](https://github.com/CosmicMind/Material/pull/1088): Removed unnecessary convenience initializers.
    * [issue-1085](https://github.com/CosmicMind/Material/issues/1085): `convenience init()` across the framework prevents generic initialization of the components.
* [pr-1082](https://github.com/CosmicMind/Material/pull/1082): Added ErrorTextField validation.
  * [issue-1017](https://github.com/CosmicMind/Material/issues/1017): Can we make the error detail for textfields dynamic?
  * [issue-1053](https://github.com/CosmicMind/Material/issues/1053): TextField Detail Label not Layed-Out correctly with Left-Image.
* [pr-1103](https://github.com/CosmicMind/Material/pull/1103): Added ability to change password visibility icons.
* [pr-1097](https://github.com/CosmicMind/Material/pull/1097):: Added new extensions: UIColor(argb:), UIColor(rgb:), UIButton.fontSize, UILabel.fontSize.
* [pr-1093](https://github.com/CosmicMind/Material/pull/1093):: Fix TextField placeholderLabel position.
  * [issue-1092](https://github.com/CosmicMind/Material/issues/1092): TextField.placeholderLabel is positioned higher than before in version 2.x.x.
* [pr-1103](https://github.com/CosmicMind/Material/pull/1103): Added ability to change password visibility icons.
  * [issue-1012](https://github.com/CosmicMind/Material/issues/1012): Can we set visibility icon custom for password textfield.


## 2.15.0

* [issue-1057](https://github.com/CosmicMind/Material/issues/1057): Added image states for TabItems used in TabBar and TabsController.

## 2.14.0

* [issue-995](https://github.com/CosmicMind/Material/issues/995): Updated iOS 11 layout margins for NavigationBar.
* [pr-1038](https://github.com/CosmicMind/Material/pull/1038): Merged PR for iOS 11 layout margins fix. 

## 2.13.7

* Updated TabsController to no longer force the default animation to change between tabs and not return to normal behavior.  
* [issue-1044](https://github.com/CosmicMind/Material/issues/1044): Fixed issue where TabBar items were not correctly laying out. 

## 2.13.6

* [issue-841](https://github.com/CosmicMind/Material/issues/841): Adjusted default sizing for Switch to be more like the original sizing.
* [pr-1030](https://github.com/CosmicMind/Material/pull/1032): Added workaround for known issue where trailing whitespace is apparent in UITextField.
* Updated to [Motion 1.3.5](https://github.com/CosmicMind/Motion/releases/tag/1.3.5). 

## 2.13.5

* [pr-1019](https://github.com/CosmicMind/Material/pull/1019): Added swipe gesture handling to TabsController.
* Updated to [Motion 1.3.4](https://github.com/CosmicMind/Motion/releases/tag/1.3.4).

## 2.13.4

* [issue-1016](https://github.com/CosmicMind/Material/issues/1016): Updated hierarchy traversal for TransitionController types to no longer skip over non TransitionController types. 

## 2.13.3

* [issue-1015](https://github.com/CosmicMind/Material/issues/1015): Fixed regression where view lifecycle functions were not being called.
* Motion disabled by default for NavigationController to avoid unbalanced calls to view lifecycle when presenting a NavigationController modally. 
* Updated to [Motion 1.3.3](https://github.com/CosmicMind/Motion/releases/tag/1.3.3).

## 2.13.2

* Updated to [Motion 1.3.2](https://github.com/CosmicMind/Motion/releases/tag/1.3.2).
* Fixed unbalanced calls in Motion transitions.

## 2.13.1

* Updated to [Motion 1.3.1](https://github.com/CosmicMind/Motion/releases/tag/1.3.1). 

## 2.13.0

* Updated to [Motion 1.3.0](https://github.com/CosmicMind/Motion/releases/tag/1.3.0). 

## 2.12.19

* [issue-997](https://github.com/CosmicMind/Material/issues/977): Fixed NavigationDrawerController where swiping off device caused a partial correct state.

## 2.12.18

* Fixed layout issues in CollectionView, where the sizing was not correctlly being initialized.
* [issue-495](https://github.com/CosmicMind/Material/issues/495): Made TextField.textInset available in Obj-C.

## 2.12.17

* [pr-979](https://github.com/CosmicMind/Material/pull/979): Added `visibilityOff` icon and updated `TextField` to utilize it.
* [issue-982](https://github.com/CosmicMind/Material/issues/982): Updated Icon let declarations to var declarations to allow custom icon sets. 
* [issue-980](https://github.com/CosmicMind/Material/issues/980): Added `@objc` to extension properties in Material+UIView.
* [issue-650](https://github.com/CosmicMind/Material/issues/650): Fixed issue where `NavigationBar.backButton` would incorrectly be laid out when caching view controllers.
* [issue-973](https://github.com/CosmicMind/Material/issues/973): Fixed issue where `Button.prepare` was not being called in the correct order.

## 2.12.16

* [issue-965](https://github.com/CosmicMind/Material/issues/965): Removed duplicate `prepare` call in initializer.
* Rework of Layout's internal process - removed an async call to layout views.
* Updated the layout calls for FABMenu's fabButton.

## 2.12.15

* [issue-957](https://github.com/CosmicMind/Material/issues/957): Fixed StatusBar height issue in iOS 9 and iOS 10. 

## 2.12.14

* [samples issue-95](https://github.com/CosmicMind/Samples/issues/95): Fixed TabBar image colors that were not correctly being set for a given state.
* Fixed layout issue, where the calculation of the layout item was not being set in the current render cycle.

## 2.12.13

* Fixed issue where sizing of pulse was incorrectly animating when using the NavigationController on iOS 11.

## 2.12.12

* [issue-924](https://github.com/CosmicMind/Material/issues/924):  Fixed NavigationController display in iOS 10.

## 2.12.11

* Fixed iPhoneX topLayoutGuide constraints not properly being set for StatusBarController types.
* Fixed iOS 11 layout issues for NavigationController.
* [pr-945](https://github.com/CosmicMind/Material/pull/945): iPhoneX update for TabBar bottom line alignment. 

## 2.12.10

* [samples-issue-78](https://github.com/CosmicMind/Samples/issues/78): Fixed iPhoneX bottomLayoutGuide constraints not properly being set.

## 2.12.9

* Fixed breaking change to loading the TabsController.

## 2.12.8

* [issue-933](https://github.com/CosmicMind/Material/issues/933): Fixed issue where `NavigationDrawerController` was not displaying the `leftViewController` and `rightViewController`.
* [issue-940](https://github.com/CosmicMind/Material/issues/940): Fixed an issue where the `TransitionController` was not executing the lifecycle functions for the initial `rootViewController`. 

## 2.12.7

* [pr-938](https://github.com/CosmicMind/Material/pull/938): An expansion on this PR to fix the lifecycle issues with transitions.

## 2.12.6

* Fixed issue where TabBar.lineColor was incorrectly being updated.

## 2.12.5

* Updated to [Motion 1.2.4](https://github.com/CosmicMind/Motion/releases/tag/1.2.4).
* [issue-937](https://github.com/CosmicMind/Material/issues/937): Added @objc to `TabBar.lineColor` for access availability.
* [pr-934](https://github.com/CosmicMind/Material/pull/934): Added access to the `TabBar.line` view.

## 2.12.4

* Updated to [Motion 1.2.3](https://github.com/CosmicMind/Motion/releases/tag/1.2.3).
* [issue-919](https://github.com/CosmicMind/Material/issues/919): Fixed issue where lifecycle methods were being called on tab item view controllers prematurely.
* [pr-923](https://github.com/CosmicMind/Material/pull/923): Merge PR that fixes [issue-919](https://github.com/CosmicMind/Material/issues/919).
* [issue-931](https://github.com/CosmicMind/Material/issues/931): Fixed issue where selectedTabItem was not updated correctly during a porgrammatic transition. 

## 2.12.3

* [issue-907](https://github.com/CosmicMind/Material/issues/907): Fixed Layout ordering issues.

## 2.12.2

* [issue-860](https://github.com/CosmicMind/Material/issues/860): Updated TabBar color states and added an independent line color state.

## 2.12.1

* [issue-911](https://github.com/CosmicMind/Material/issues/911): Added @objc to TabBar.tabItems for visibility in Obj-C.

## 2.12.0

* [issue-860](https://github.com/CosmicMind/Material/issues/860): Added `TabBar` color states.

## 2.11.4

* Added Cartfile for Carthage package manager, which includes the Motion dependency.

## 2.11.3

* Updated Motion submodule to use `https` over `git@`. 

## 2.11.2

* Updated to [Motion 1.2.2](https://github.com/CosmicMind/Motion/releases/tag/1.2.2).

## 2.11.1

* Fixed duplicate `prepare` call in `TabsController`.

## 2.11.0

* Updated the installation guide for Material, [Material - It's time to download](https://www.cosmicmind.com/danieldahan/lesson/6). Material now uses [Motion](https://github.com/CosmicMind/Motion) as a submodule and CocoaPods dependancy. 
* [samples issue-70](https://github.com/CosmicMind/Samples/issues/70#issuecomment-335533243): Made an internal `_TabBarDelegate` to avoid needing to override the `TabBarDelegate` in `TabsController`. 

## 2.10.4

* [issue-891](https://github.com/CosmicMind/Material/pull/891): Fixed conflict with addAttributes method in the NSMutableAttributedString extension.

## 2.10.3

* [issue-773](https://github.com/CosmicMind/Material/pull/773): Added `Swift 4` support.
* [pr-873](https://github.com/CosmicMind/Material/pull/873): Fixes PlaceholderLabel position when right-aligned - iOS 11.0
* [issue-886](https://github.com/CosmicMind/Material/issues/886): Fixed a memory leak within Motion's references to previous `UINavigationControllerDelegate` and `UITabBarControllerDelegate`.
* [issue-861](https://github.com/CosmicMind/Material/pull/861): Fixed `NavigationBar` being `nil` in some cases.
* [issue-845](https://github.com/CosmicMind/Material/pull/845): Fixed ambiguity issues with all properties.

## 2.10.2

* [issue-849](https://github.com/CosmicMind/Material/issues/849): Fixed issue where `TextView.placeholderNormalColor` was not correctly displaying. Renamed `TextView.placeholderNormalColor` to `TextView.placeholderColor`.
* [issue-856](https://github.com/CosmicMind/Material/issues/856): Fixed issue where `TextField.placeholderAnimation = .hidden` was not correctly being displayed when text was set to nil.
* All default instances of `Color.grey.lighten3` have been switched to `Color.grey.lighten2`.

## 2.10.1

* [issue-833](https://github.com/CosmicMind/Material/issues/833): `TabsController` now be selected programmatically.
* [issue-859](https://github.com/CosmicMind/Material/issues/859): `TabsController` now has a delegation protocol `TabsControllerDelegate`.
* [issue-830](https://github.com/CosmicMind/Material/issues/830): Bug fix where `TabsController` did not animate to the correct tab when programmatically set.

## 2.10.0

* [issue-857](https://github.com/CosmicMind/Material/issues/857): Fixed an issue where setting the `statusBar` property for the `ToolbarController` was not updating the background color correctly.
* [issue-858](https://github.com/CosmicMind/Material/issues/858): Fixed `Photos` sample project that was not updated to reflect the changes in the `TabBar`.
* [pr-715](https://github.com/CosmicMind/Material/pull/715): Added `isPlaceholderUppercasedWhenEditing` property to `TextField`.
* [pr-721](https://github.com/CosmicMind/Material/pull/721): Added `FABMenuItemTitleLabelPosition` which allows the `FABMenu` to place its `FABBMenuItems` to either the `left` or `right` position of the `FABButton`.
* [pr-851](https://github.com/CosmicMind/Material/pull/851): Added `placeholderHorizontalOffset` property to `TextField`.
* [pr-847](https://github.com/CosmicMind/Material/pull/847): Added `placeholderActiveScale` property to `TextField`.
* [pr-848](https://github.com/CosmicMind/Material/pull/848): Natural motion transition added to `TabsController` when view controller `motionModalTransitionType` is set to `.auto`.
* `Card` types default to a `depthPreset` of `.none`.
* Added `shouldSelect` method to `TabBarDelegate`.
* Updated `TabsController` to use `TabBarDelegate` rather than button handlers.
* Updated `EdgeInsetsPreset` values to:

```swift
.square1: EdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
.square2: EdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
.square3: EdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
.square4: EdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
.square5: EdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
.square6: EdgeInsets(top: 28, left: 28, bottom: 28, right: 28)
.square7: EdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
.square8: EdgeInsets(top: 36, left: 36, bottom: 36, right: 36)
.square9: EdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
.square10: EdgeInsets(top: 44, left: 44, bottom: 44, right: 44)
.square11: EdgeInsets(top: 48, left: 48, bottom: 48, right: 48)
.square12: EdgeInsets(top: 52, left: 52, bottom: 52, right: 52)
.square13: EdgeInsets(top: 56, left: 56, bottom: 56, right: 56)
.square14: EdgeInsets(top: 60, left: 60, bottom: 60, right: 60)
.square15: EdgeInsets(top: 64, left: 64, bottom: 64, right: 64)
```

## 2.9.4

* Added `ToolbarAlignment` to allow placement of the `Toolbar` at the top or bottom of the view controller.
* Added `SearchBarAlignment` to allow placement of the `SearchBar` at the top or bottom of the view controller.

## 2.9.3

* Renamed `TabBarController` to `TabsController` to avoid name confusion with iOS `UITabBarController` helper properties.
* Updated layout with `TabsController` to properly adjust during orientation changes.

## 2.9.2

* `TabBarController` now subclasses `TransitionController` to minimize code.
* Fixed regression in `TabBarController` where line was incorrectly animation upon initial interaction.

## 2.9.1

* Renamed `TabsController` to `TabBarController`.
* Renamed `ChipsController` to `ChipBarController`.
* [issue-832](https://github.com/CosmicMind/Material/issues/832): Fixed issue where `TabBar` line was incorrectly laying out.

## 2.9.0

* Replaced `RootController` with `TransitionController`.
* Updated CharacterAttribute API.
* Added Chips - alpha phase.
* [issue-824](https://github.com/CosmicMind/Material/issues/824): Fixed issue where `TabBar` line alignment was not correctly animating when initial engaged.
* [issue-820](https://github.com/CosmicMind/Material/issues/820): Fixed retain cycle found in FABMenuController.

## 2.8.1

* [issue-815](https://github.com/CosmicMind/Material/issues/815): Fixed the TabBar line alignment issue when rotating the device orientation.

## 2.8.0

Removed PageTabBarController and added the TabsController. Now removing the following issues and feature requests:

* [issue-642](https://github.com/CosmicMind/Material/issues/642)
* [issue-742](https://github.com/CosmicMind/Material/issues/742)
* [issue-768](https://github.com/CosmicMind/Material/issues/768)
* [issue-605](https://github.com/CosmicMind/Material/issues/605)
* [issue-743](https://github.com/CosmicMind/Material/issues/743)
* [issue-619](https://github.com/CosmicMind/Material/issues/619)

## 2.7.1

* [issue-811](https://github.com/CosmicMind/Material/issues/811): Removed scrollable TabBar style, until feature is ready.

## 2.7.0

* Added [Motion](https://github.com/CosmicMind/Motion) framework to Material as new animation and transitions library.
* Removed `Capture`.
* Removed `PhotoLibrary`.
* Removed `Reminders`.
* [issue-809](https://github.com/CosmicMind/Material/issues/809): Fixed detailTextLabel visibility issue.
* [issue-797](https://github.com/CosmicMind/Material/issues/797): Added `back button` hiding features to `NavigationController`.
* [issue-552](https://github.com/CosmicMind/Material/issues/552): Fixed `@objc` declaration issues.
* [pr-662](https://github.com/CosmicMind/Material/pull/662): Added the ability to set a text inset for a `TextField`.
* [pr-707](https://github.com/CosmicMind/Material/pull/707): Moved the `statusBarStyle` extension to `NavigationController` from `UINavigationController`.
* Updated `Display` to `DisplayStyle` and renamed corresponding properties, in `ToolbarController`, `StatusBarController`, `SearchBarController`, `CaptureController`, and `ImageCard`.

## 2.6.3

* Fixed an issue where using child view controllers would break `presenting` and `dismissing` transition animations.

## 2.6.2

* [issue-608](https://github.com/CosmicMind/Material/issues/608): Updated `PageTabBarController` to allow programmatic selection of the current index using the `selectedIndex` property.

## 2.6.1

* Updated for Xcode 8.3.

## 2.6.0

* [issue-704](https://github.com/CosmicMind/Material/issues/704): Fixed an issue where `TextView.clipsToBounds` was revealing the scrollable text.
* [issue-663](https://github.com/CosmicMind/Material/issues/663): Added the ability to add insets for the `TextView`.
* [issue-598](https://github.com/CosmicMind/Material/issues/598): Added a placeholder to the `TextView`.
* Removed `Editor` and added all the necessary functionality in `TextView`.

## 2.5.2

* [issue-695](https://github.com/CosmicMind/Material/issues/695): Fixed issue with [pr-696](https://github.com/CosmicMind/Material/pull/696), where FABMenu was incorrectly being displayed used the SpringAnimation API.

## 2.5.1

* [issue-681](https://github.com/CosmicMind/Material/issues/681): Fixed regression where `NavigationBar` was not properly setting the background color.
* Fixed issue where transitions using `UINavigationController` would sometimes flicker.

## 2.5.0

* Renamed `FabButton` to `FABButton`.
* Moved `Menu` to `FABMenu`.
* Moved `MenuController` to `FABMenuController`.
* Added `FABMenuBacking` enum type to set a `blur` or `fade` for the opened `FABMenu` state using a `FABMenuController`.
* Renamed `MenuItem` to `FABMenuItem`.
* Added `SpringAnimation` animation API.
* [issue-641](https://github.com/CosmicMind/Material/issues/641): Added a new `PulseAnimation.tap` type, which has an instant feedback response when tapping.
* Updated `Toolbar.display` to `Toolbar.toolbarDisplay`.
* Updated `SearchBar.display` to `SearchBar.searchBarDisplay`.
* Added `StatusBar.statusBarDisplay`.
* Added `MotionAnimation` enum type and helper methods to `CALayer` and `UIView` as extensions.
* Added [Motion](https://github.com/CosmicMind/Motion) to Material.

## 2.4.19

* [issue-692](https://github.com/CosmicMind/Material/issues/692): Fixed issue where Carthage was failing to build the macOS target for Material.

## 2.4.18

* Removed macOS support.

## 2.4.17

* Updated Material.podspec to fix potential macOS issue.

## 2.4.16

* [issue-678](https://github.com/CosmicMind/Material/issues/678): Fixed issue where `Card` was incorrectly displaying its `contentView`.

## 2.4.15

* Fixed an issue where the `Card` was not displaying the `contentView` and `presenterView` correctly on initial load.

## 2.4.14

* Added missing `UIView` properties to `Material+UIView` extension that are used in the [Motion](https://github.com/CosmicMind/Motion) [PhotoCollection](https://github.com/CosmicMind/Samples/tree/master/Motion/PhotoCollection) sample.

## 2.4.13

* Added [Motion](https://github.com/CosmicMind/Motion) as a separate framework from [Material](https://github.com/CosmicMind/Material).

## 2.4.12

* [issue-676](https://github.com/CosmicMind/Material/issues/676): Fixed an issue where `Card` types were not adjusting size correctly when using `UILabels`.

## 2.4.11

* [issue-658](https://github.com/CosmicMind/Material/issues/658): Added `TextFieldPlaceholderAnimation` enum type to enable `TextField` to have different animations.

## 2.4.10

* Fixed an issue where `TabBar` was not correctly setting the `contentEdgeInsets*` and `interimSpace*`.

## 2.4.9

* [issue-655](https://github.com/CosmicMind/Material/issues/655): Updated date for release in README to 2017.

## 2.4.8

* [issue-653](https://github.com/CosmicMind/Material/issues/653): Fixed a `TextField` issue where the animation was not correctly responding to a programmatic text update.

## 2.4.7

* Updated README release dates.

## 2.4.6

* [issue-640](https://github.com/CosmicMind/Material/issues/640): Fixed an issue where `TextField` was not laying out correctly when setting the text programmatically.

## 2.4.5

* [issue-646](https://github.com/CosmicMind/Material/issues/646): Fixed an issue where calling `TextField.becomeFirstResponder` in `viewDidLoad` would cause a layout issue.

## 2.4.4

* [issue-644](https://github.com/CosmicMind/Material/issues/644): Fixed issue where `Switch.isOn` and `Switch.switchState` were not updating correctly.

## 2.4.3

* [issue-643](https://github.com/CosmicMind/Material/issues/643): Fixed an issue where `Layout` was not anchoring correctly for `View` subclasses.

## 2.4.2

* Fixed double `Menu.hitTest` call that was causing the delegation method to be fired more than once.
* Updated `Toolbar.title`, `Toolbar.titleLabel`, `Toolbar.detail`, and `Toolbar.detailLabel` to be `@IBInspectable`.

## 2.4.1

* [issue-194](https://github.com/CosmicMind/Material/issues/194): Fixed an issue where hitTest was failing after translation animation.
* [issue-624](https://github.com/CosmicMind/Material/issues/624): Updated `Switch` & `TabBar` control to only call the delegation methods when the control is updated through a user interaction.
* Renamed `Switch.on` to `Switch.isOn`.
* Removed `Switch.setOn` function.
* [issue-630](https://github.com/CosmicMind/Material/issues/630): Added `Reminders` and `RemindersController`.
* Added `isDividerHidden` for the `Divider UIView` extension.

## 2.4.0

* [issue-551](https://github.com/CosmicMind/Material/issues/551): Fixed issue where `TabBar` was not laying out buttons correctly when more than 6 were used.
* [issue-618](https://github.com/CosmicMind/Material/issues/618): Updated `Grid` and `Layout` to solve a `Toolbar` layout challenge.
* [issue-620](https://github.com/CosmicMind/Material/issues/620): Fixed issue where setting the `CAAnimation.delegate` was causing an animation issue.

## 2.3.22

* [issue-597](https://github.com/CosmicMind/Material/issues/597): Fixed an issue where `NavigationBar` was not adjusting to all sizes correctly when using modal presentation styles.
* Fixed an issue when `cornerRadius` was not being calculated correctly when the `CALayer` was rotated.

## 2.3.21

* [issue-612](https://github.com/CosmicMind/Material/issues/612): Fixed issue where SnackbarController was not resizing correctly.
* [issue-615](https://github.com/CosmicMind/Material/issues/615): Added `snackbarEdgeInsets` and `snackbarEdgeInsetsPreset` to position the `Snackbar` from the `SnackbarController's` edges.

## 2.3.20

* [issue-613](https://github.com/CosmicMind/Material/issues/613): Fixed an issue where the Grid system was not laying out in all cases that it should.
* Removed `statusBarStyle` and `isStatusBarHidden` properties from `RootController` types, in favor of using the `Application` class. `StatusBarController` now provides `statusBarStyle` and `isStatusBarHidden` properties.

## 2.3.19

* [issue-553](https://github.com/CosmicMind/Material/issues/553): Fixed an issue where the `NavigationDrawerController.leftViewController` was sizing incorrectly.

## 2.3.18

* [issue-610](https://github.com/CosmicMind/Material/issues/610): Fixed issue where the `RootController.rootViewController` was not transitioning correctly when using certain UIViewController types.

## 2.3.17

* Added the ability to modify the `contentViewAlignment` of a `NavigationItem` dynamically.
* Renamed the `ContentViewAlignment.any` value to `ContentViewAlignment.full`.

## 2.3.16

* Minor updates to `Card` types for code clarity.

## 2.3.15

* Fixed issue where `ImageCard` was not ordering the `UIImageView` behind the `Toolbar` correctly.

## 2.3.14

* Fixed an issue where iOS animations with `Motion` were not correctly writing their end value using `CAAnimationDelegate`.

## 2.3.13

* Fixed an issue where the `NavigationBar.backButton` was not placed at the most left position when present.

## 2.3.12

* Updates `Motion.translation*` to `Motion.translate*`.
* [issue-595](https://github.com/CosmicMind/Material/issues/595): Fixed issue where CAAnimations for iOS 10 were not working correctly.
* [issue-600](https://github.com/CosmicMind/Material/issues/600): Fixed issue where `Carthage` was not able to build due to failing to recognize the `NavigationDrawerController` gesture recognizer.

## 2.3.11

* [issue-600](https://github.com/CosmicMind/Material/issues/600): Fixed issue where `Carthage` was not able to build due to failing to recognize the `NavigationDrawerController` gesture recognizer.

## 2.3.10

* [issue-583](https://github.com/CosmicMind/Material/issues/583): Fixed issue where `TextField.detail` was not being displayed unless it was set upon preparation time.
* [issue-594](https://github.com/CosmicMind/Material/issues/594): Added feature request to set the `TextField.leftView` coloring based on the `normal` or `active` states, using the `TextField.detail .leftViewNormalColor` and `TextField.detail .leftViewActiveColor` properties respectively.

## 2.3.9

* [issue-584](https://github.com/CosmicMind/Material/issues/584): Added enum types for `Device.model` value.
* Divided `Device` into `Application`, `Device`, and `Screen`. This is for expansion of their APIs.
* Fixed issue where `NavigationDrawer` and `RootController` types would conflict when showing the statusBar.

## 2.3.8

* [issue-588](https://github.com/CosmicMind/Material/issues/588): removed memory leaks that surround Grid.
* `Grid` is now a struct from a class type.
* `Divider` is now a struct from a class type.
* `Pulse` is now a struct and views that have pulse now conform to the `Pulseable` protocol.

## 2.3.7

* [issue-592](https://github.com/CosmicMind/Material/issues/592): fixed `NavigationDrawerController` regression, where transitioning the `rootViewController` would go behind the `contentViewController`.

## 2.3.6

* Updated blur logic.

## 2.3.5

* [issue-591](https://github.com/CosmicMind/Material/issues/591): Fixed `blur` calculation complexity for `Carthage` compilation.

## 2.3.4

* [issue-588](https://github.com/CosmicMind/Material/issues/588): Fixed GridAxis memory leak issue.

## 2.3.3

* [issue-568](https://github.com/CosmicMind/Material/issues/568): fixed issue where `placeholderActiveColor` was not being set correctly when `TextField` was in an active state.
* [issue-568](https://github.com/CosmicMind/Material/issues/568): fixed issue where setting `text` to `nil` broke the `TextField` layout.
* [issue-581](https://github.com/CosmicMind/Material/issues/568): Added `UIImage.blur` extension.

## 2.3.2

* Fixed [issue-557](https://github.com/CosmicMind/Material/issues/577) where the transitioned view controller was overlapping the `RootController` type controls.

## 2.3.1

* Added `Capture` delegation methods that notify when `videoOrientation` changes.

## 2.3.0

* Merged in [PR-566](https://github.com/CosmicMind/Material/pull/566) to move `CAAnimation` String constants to enum types.
* Renamed the `Animation` struct to `Motion`, in order to initiate the expansion of the Motion library within Material.
* Fixed [issue-573](https://github.com/CosmicMind/Material/issues/573) where sample had incorrect spelling for `Material`.
* Updated `Bar` type layout mathematics.
* Updated `FabButton` default `backgroundColor` to `white`.
* Updated `Capture` API with [sample project](https://github.com/CosmicMind/Samples/tree/master/Material/Programmatic/CaptureController).

## 2.2.5

* Merged in [PR-563](https://github.com/CosmicMind/Material/pull/563) for [issue-549](https://github.com/CosmicMind/Material/issues/549), where Privacy related features are now using CocoaPods subspecs.

## 2.2.4

* Fixed issue where `ImageCard` `top` and `bottom` `EdgeInsets` were not being applied correctly.

## 2.2.3

* Updated Card internals for better performance.
* Added sample [CardTableView](https://github.com/CosmicMind/Samples/tree/master/Graph/CardTableView).

## 2.2.2

We moved all sample projects to a separate repo named [Samples](https://github.com/CosmicMind/Samples) to allow their development to be independent of the Material framework. There has been instances where we needed to update the versions of the framework to accommodate changes that only occurred in the sample projects.

## 2.2.1

* Fixed recursion issue with `Snackbar` and reloading.
* issue-552: Removed extraneous @objc declarations.
* Added `dividerContentEdgeInsets` and `dividerContentEdgeInsetsPreset` to Material+UIView extension.

## 2.2.0

* Updated default `pulseColor` to `Color.grey.base`.
* Added `HeightPreset` type to dynamically set the height of the `CALayer` & `UIView` types.
* `UIImage.tintWithColor(color: UIColor)` is now `UIImage.tint(with color: UIColor)` and always returns with `.alwaysOriginal` rendering mode.
* `UIImage.imageWithColor(color: UIColor)` is now `UIImage.image(with color: UIColor)` and always returns with `.alwaysOriginal` rendering mode.
* Merged in [PR 544](https://github.com/CosmicMind/Material/pull/544#pullrequestreview-3892111), which allows for the left view to be used in the `TextField`.
* Updated the `TextField` example project to reflect [PR 544](https://github.com/CosmicMind/Material/pull/544#pullrequestreview-3892111).
* Reworked `TextField`.
* Added `contentEdgeInsets` to `Divider`.
* Fixed issue where `pulse layer` was covering `Button` images when engaged.
* For `Divider`, renamed `dividerHeight` to `dividerThickness` to accommodate alignment logic.
* Added SearchBar delegation methods for when text changes and for when the text has been cleared.

## 2.1.2

* Updated default `pulseColor` to `Color.white`.
* Updated [NavigationDrawerController Example Project](https://github.com/CosmicMind/Material/tree/master/Examples/Programmatic/NavigationDrawerController) to demonstrate how to transition the `rootViewController`, both with a `ToolbarController` and without, issue-546.

## 2.1.1

* Moved the Switch `trackLayer` property from a `CAShapeLayer` to a `UIView` that is now named `track`.
* Fixed an issue where `Switch` in a `Bar` type or `NavigationBar` would behave incorrectly, issue-540.
* Added a `ToolbarController` to the programmatic `NavigationDrawerController` example project.

## 2.1.0

* Added a new feature where `TextField`'s `placeholder` can be fixed at the top and not animated by setting the `isPlaceholderAnimated` property to `false` (issue-534).
* Added a new feature where a `centerViews` property is added to `Bar` types, to automatically align views in the center outward positions. Updated sample `Card` projects and `Bar` projects to reflect this.
* Added a new feature to `Grid`, where `columns` and `rows` are automatically set if their values have not been changed from the default `0` value.

## 2.0.0

* Renamed `MaterialColor` to `Color`.
* Renamed `MaterialIcon` to `Icon`.
* Renamed `MaterialSpacing` to `InterimSpacePreset`.
* Renamed `MaterialButton` to `Button`.
* Renamed `MaterialView` to `View`.
* Renamed `MaterialPulseView` to `PulseView`.
* Renamed `MaterialSwitch` to `Switch`.
* Renamed `MaterialLayer` to `Layer`.
* Renamed `MaterialFont` to `Font.
* Renamed `MaterialEdgeInset` to `EdgeInsetsPreset`.
* Renamed `MaterialDevice` to `Device`.
* Renamed `MaterialDepth` to `Depth`.
* Renamed `CaptureView` to `Capture`.
* Renamed `CardView` to `Card`.
* Renamed `ImageCardView` to `ImageCard`.
* Renamed `MaterialBorder` to `BorderWidthPreset`.
* Renamed `MaterialRadius` to `CornerRadiusPreset`.
* Renamed `MaterialDataSourceItem` to `DataSourceItem`.
* Renamed `MaterialTableViewCell` to `TableViewCell`.
* Renamed `shadowPathAutoSizeEnabled` to `isShadowPathAutoSizing`.

* Fixed issue where TextField placeholder was not respecting initial vertical offset (issue-469).
* Added @objc to all enums to allow Obj-C to see the enum types and associated methods (issue-472).

* Added `PageTabBarController`.
* Added `JSON` to simplify working with JSON objects.

## 1.42.9

* Fixed issue where `textColor` was not being respected in Storyboards for `TextField` (issue-487).

## 1.42.8

* Fixed issue where initially setting the `TextField` did not correctly align the `placeholder` offset (issue-469).

## 1.42.7

* Fixed issue where `TextField` alignment was incorrect with RTL (issue-456).

## 1.42.6

* Fixed issue where `StatusBarController` was not calling its `super.prepareView` method.

## 1.42.5

* Fixed issue where NavigationBar was not aligning correctly with Storyboards.
* Updated `CGRectZero` values to `CGRect.zero`.
* Minor cleanups.

## 1.42.4

* Fixed issue where left and right view controllers are not enabled on `NavigationDrawerController` (issue-452).

## 1.42.3

* Fixed an issue where `MaterialSwitch` was exposing a memory leak with its `delegate` (issue-449).
* Fixed a regression where FabButton was losing shape (issue-450).
* Updated property `enableHideStatusbar` to `enableHideStatusBar` for `NavigationDrawerController`.
* Updated `CGRectZero` to `CGRect.zero`.

## 1.42.2

* Fixed an issue where `Toolbar` and `NavigationBar` `title` alignment was off with a `detail` value of "" (issue-445).
* Fixed an issue where `NavigationDrawerController` was crashing when transitioning between `rootViewController` (issue-444).

## 1.42.1

* Fixed issue with NavigationDrawerController rightView not aligning correctly when rotating device.

## 1.42.0

* Update `shadowPath` animation to happen when laying out subviews, rather than when laying out sublayers.
* Renamed `MaterialLayout` to `Layout` for simplicity.
* Added `Layout` extension to ease the usage of AutoLayout.
* Added [Layout Documentation](http://www.cosmicmind.io/material/layout).
* Updated the `MaterialLayout` project to `Layout`.
* fixed width issue for all `ControlView` types when using dynamic `intrinsicContentSize` (issue-436).
* Renamed `SideNavigationController` to `NavigationDrawerController`.
* Removed `SideNavigationController` example project for both programmatic and storyboards.
* Added `NavigationDrawerController` example project for both programmatic.
* Added `StatusBarController` to manage a statusBarView.

## 1.41.8

* Fixed an issue where the `UINavigationItem.title` KVO would crash when releasing the instance. The fix completely removes KVO and utilizes Swift `nonobjc` tagging.

## 1.41.7

* Added `adjustOrientationForImage` to `CaptureSession` in order to fix image alignment issues.
* Updated `CaptureView` sample project to reflect changes made in `ToolbarController`.
* Updated `MaterialView` sample project to demonstrate aligning a `MaterialView` in the `center` of a view controller.
* Fixed issue where UINavigationItem.title was not updating the titleLabel text.

## 1.41.6

* Fixed issue with ellipses in NavigationBar showing when panning back to the backItem (pr-409).

## 1.41.5

* Added delegation method `menuViewDidTapOutside` to `MenuView` to support closing the `Menu`, `MenuView`, or `MenuController` items when opened and clicking on any area of the view (issue-406).

## 1.41.4

* Removed `statusBarStyle` from `BarView` types.
* Added `statusBarStyle` to BarController types.
* Added `layoutInset` to `Grid` for an additional layer of flexibility.
* Fixed an issue where BarControllers were not allowing `contentInset.top` to be used correctly.
* Updated projects to reflect framework changes.

## 1.41.3

* Fixed issue where `MaterialSwitch` was referencing self and creating a bad access (issue-399).
* Fixed issue where `TextField.secureTextEntry` would break the font being displayed (issue-400).
* Moved `MenuViewController` to `MenuController`.
* Updated `MenuController.itemViewSize` to `MenuController.itemSize`.
* Updated `MenuController.baseViewSize` to `MenuController.baseSize`.
* Updated all references to `unowned self` to `weak self`.
* Added convenience properties `title` and `detail` to the `Toolbar`, which reload the view when changed.
* Added convenience properties `title` and `detail` to UINavigationItem to easily handle text changes.
* added to `TextField` the `placeholderVerticalOffset` and `detailVerticalOffset` to determine the alignment during animations and loading of the `placeholderLabel` and `detailLabel`.

## 1.41.2

* Fixed issue where Toolbar was not respective the frame size set (issue-382).
* Fixed issue where Toolbar was not drawing the titleLabel and detailLabel text without left/right controls (issue-381).
* `StatusBarView` is now `BarView`.
* `StatusBarViewController` is now `BarViewController`.

## 1.41.1

* Fixed text alignment issue in NavigationBar and Toolbar.

## 1.41.0

* All references to `detailView` are now `contentView`.
* Updated NavigationBar interface.
* Reworked NavigationBar.
* Reworked Toolbar measurements.
* Reworked SearchBar measurements.

## 1.40.1

* Fixed issue where initializing a Toolbar in a method was causing an ambiguous initializer error (issue-363).
* Added Boolean properties to SideNavigationController to enable and disable gestures (issue-365).

```swift
sideNavigationController.enabled = true

sideNavigationController.enabledLeftView = true
sideNavigationController.enabledLeftTapGesture = true
sideNavigationController.enabledLeftPanGesture = true

sideNavigationController.enabledRightView = true
sideNavigationController.enabledRightTapGesture = true
sideNavigationController.enabledRightPanGesture = true
```

* Updated the SideNavigationController `leftThreshold` and `rightThreshold` to 64 as a default.
* Updated MaterialIcon images to work better with CocoaPods (issue-362).

## 1.40.0

* Added Google visibility icon to MaterialIcon.
* Added Google check icon to MaterialIcon.
* Reworked TextField with [documentation](http://www.cosmicmind.io/material/textfield).
* Added ErrorTextField.
* Added visibility button and clear button auto enabling without conflicting with iOS clearButton for TextField.
* Reworked pulse animations.
* Added `PulseAnimation` enum type to select the type of pulse animation.
* Added `IconButton` to simplify the usage of using icons and buttons.
* Fixed issue where panning gestures were conflicting with the SideNavigationController rootViewController (1ssue-322, issue-320).

## 1.39.17

* Updated MaterialDepth to more accurately express Material Design's shadows (issue-323).
* Fixed an issue where MaterialButtons could not update `textColor` (issue-333).

## 1.39.16

* Fixed issue where TextField `resignFirstResponder` was not hiding the `titleLabel` (issue-332).  
* TextField no longer needs to setup `detailLabel` property.
* TextField `detailLabel` now supports @IBInspectable.

## 1.39.15

* Fixed issue where TextField doesn't hide the titleLabel when programmatically cleared (issue-330) (pr-331).

## 1.39.14

* Added UIImage extension `tintWithColor`, which allows an image to be tinted with a passed in color.
* Added `pulseCenter` property, which forces the pulse animation to animate from the center of the view (pr-325).
* Updated `prepareView` to be public, which allows for better subclassing and preparation of views (pr-329).
* Fixed issue where TextField regressed when updating the `placeholder` value (issue-316).

## 1.39.13

* Fixed issue where TextField `placeholder` could be updated while a text value exists (issue-316).

## 1.39.12

* Updated Example/Programmatic/SideNavigationController project to demonstrate how to transition the rootViewController (issue-309).

## 1.39.11

* Added a link to download our sticker sheet.
* Updated App project with correct naming in AppDelegate file.

## 1.39.10

* README Update.

## 1.39.9

* Added storyboard CardView example with two CardViews (issue-304).

## 1.39.8

* Fixed issue where TextField animation references `unowned self` and should be `weak self` (issue-301) (pr-302).
* Added `lineLayerThickness` and `lineLayerActiveThickness` to TextField in order to adjust lineLayer during different states (issue-307).

## 1.39.7

* Fixed issue where TextField delegate method `textFieldShouldClear` was not being respected (issue-296).

## 1.39.6

* Updated TextField's default colors to the correct Material Design colors (pr-290).
* Added UIImage blur effect (pr-291).
* Added UIImage blur example project, FilterBlur.
* Added `SideNavigationController.statusBarUpdateAnimation` property to set the animation type when hiding the statusBar.
* Added `SideNavigationController.statusBarStyle` property to set the statusBar style.

## 1.39.5

* Added MaterialIcon example project.
* Added additional Google and CosmicMind icons.
* Added MaterialFontLoader to aid in loading packaged fonts with Material.
* Updated App project to properly handle SideNavigationController ```openLeftView``` if used.

## 1.39.4

* Updated the TextField animations.

## 1.39.3

* Fixed bundle identifier issue with CocoaPods and MaterialIcon.

## 1.39.2

* Updated Material bundle identifier.

## 1.39.1

* Updated TextField to match Material Design input text spec.

## 1.39.0

* Added early release of TabBar.
* Updated default `spacing` to `Spacing1` for Toolbar and SearchBar.
* Updated default `contentInsetPreset` to `Square1` for Toolbar, SearchBar, and NavigationBar.
* Updated ```MaterialGravityToString``` to ```MaterialGravityToValue```.
* TextField's ```clearButton``` no longer needs to be setup.
* TextField's ```titleLabel``` no longer needs to be setup (issue-241).
* TextField and SearchBar - added ```clearButtonAutoHandleEnabled``` flag that when set to ```false```, the handler for clearing text is removed (issue-229).
* TextField's ```titleLabelAnimationDistance``` is now 4 by default.
* TextField's ```titleLabel``` now floats when focused (issue-203).
* TextField's ```bottomBorderLayerDistance``` is now ```lineLayerDistance```.
* TextField now supports the ```lineLayerActiveColor```, which is set when the TextField is focused.
* TextField now supports the ```lineLayerDetailActiveColor```, which is set when the TextField detailLabel is displayed.
* Fixed issue-203, where TextField's ```lineLayer``` property was not the proper thickness when active.
* Fixed regression, where the TextField's ```bottomLayer``` color was not showing (issue-276).
* Removed shape code that was not needed in TextField and TextView.
* Updated example projects using SearchBar, and simplified the configuration for the SearchBar.
* Added OSX build target.
* Added MaterialColor to OSX.
* Added Google icons as default for ```MaterialIcon``` and additional CosmicMind icons with ```cm``` namespace (issue-285).

## 1.38.5

* Fix for MaterialIcon, [issue-279](https://github.com/CosmicMind/Material/issues/279).
* Fix for touch consumption, [issue-280](https://github.com/CosmicMind/Material/issues/280).

## 1.38.4

* Added custom icons to MaterialIcon.

## 1.38.3

* Updated App example project.
* Added MaterialCollectionView example project.
* Added NavigationController storyboard example project.
* Default colors for MaterialSwitch moved from MaterialColor.lightBlue.* to MaterialColor.blue.*.
* Updated MaterialColor with corrections to the colors from Material Design (issue-271).

## 1.38.2

* Switched BottomNavigationBar to BottomTabBar, as it is more appropriate in the context of iOS. BottomNavigationController will be comprised of a SnackBar (coming soon), and BottomTabBar.
* Added fix for Interface Builder, where MaterialSwitch was causing crashes (issue-259).
* Fixed issue where MaterialSwitch color was not propagating until engaged (issue-260).

## 1.38.1

* Added missing imports for UIKit in MaterialCollectionView classes.

## 1.38.0

* Added BottomNavigationBar.
* Added default Fade animation to BottomNavigationBar.
* Added programmatic BottomNavigationBar example project.
* Added storyboard BottomNavigationBar example project.
* Added BottomNavigationController.
* Added programmatic BottomNavigationController example.
* Removed c-style ```for``` loops.
* Updated bundle detection for MaterialIcon.
* References for `mainViewController` are now `rootViewController`.
* References for `transitionFromMainViewController` are now `transitionFromRootViewController`.
* The example App project demonstrates how to hide the `statusBar` without the `navigationBar` being animated.
* Fixed warnings for Swift 3.
* Added detection for latest iPad and iPhone.

## 1.37.3

* Fixed issue-244, where Test Coverage flag was causing an error.

## 1.37.2

* Updated the default width of the SideNavigationController to reflect the Material Design spec more accurately. For mobile, the default width is 280px, and for tablet, the default width is 320px.

## 1.37.1

* Removed SideNavigationControllerDelegate call from NavigationController class that was not used.

## 1.37.0

* Added `pulseFocus` Boolean flag that keeps the pulse displayed as the button is highlighted (issue-217).
* Switched `pulseColorOpacity` to `pulseOpacity`.
* Added @IBInspectable where appropriate (issue-151).
* Added @IBDesignable where appropriate (issue-151).
* Fixed an issue where the tests were being broken (issue-224).
* `NavigationBarView` is now called `Toolbar`.
* `SearchBarView` is now called `SearchBar`.
* `SideNavigationViewController` is now `SideNavigationController`.
* Added public `leftThreshold` and `rightThreshold` to `SideNavigationController` (issue-220).

## 1.36.0

* Added class NavigationBar and NavigationController.
* Added contentsGravityPreset where appropriate, and now contentsGravity takes a String.
* Fixed issue-213, `shadowPathAutoSizeEnabled` now defaults to true, from false.

## 1.35.3

* MaterialAnimation.rotate now accepts an `angle` parameter or a `rotation` parameter.
* Fixed issue-194, where the MaterialAnimation.translation animations were not capturing the final state value.
* Fixed issue-201, by guaranteeing that the minimal iOS version is 8.

## 1.35.2

* Updated storyboard NavigationBarView example project to correctly set the height of the NavigationBarView when rotating orientations on both iPad and iPhone.
* Removed NavigationBarViewDelegate and SearchBarViewDelegate.


## 1.35.1

* Fixed issue-195, where MaterialSwitch was switching the switchState automatically through the highlighted property.
* Fixed issue-196, where NavigationBarView was not sizing correctly on iPad.
* Added MaterialDevice helper class that provides useful values for orientation and bounds size.

## 1.35.0

* Removed backDropLayer for SideNavigationViewController. Now, the mainViewController.view property is set to 50% alpha when opened and 100% alpha when closed. The color is adopted from the backgroundColor of the mainViewController.view property.
* MenuViewController now animates its backdrop effect.

## 1.34.10

* Added `shadowPathAutoSizeEnabled` property that enables auto sizing for the shadowPath property. Defaults to false.

## 1.34.9

* Fixed shadowPath animation on rotation.
* Proposed fixed for NavigationBarView geometry issue.
* Updated CardView and ImageCardView to have a default rounded corner of .Radius1 as in the Material Design spec.
* Updated the example App project.

## 1.34.8

* Updated example App project.

## 1.34.7

* Updated App project example, by showing how to switch NavigationBarViewController's mainViewController from a SideNavigationViewController.
* Added a FeedViewController to the example App project that shows how to use CardViews in a MaterialCollectionView.
* Fixed a performance issue with shadows and animations, issue-186.

## 1.34.6

* Fixed issue with MaterialSwitch, issue-181.
* Fixed issue with NavigationBarView Geometry, issue-179.
* Added MaterialCollectionView, MaterialCollectionViewLayout, MaterialCollectionViewCell.
* Added enum MaterialSpacing type for spacing presets, spacingPreset.
* Added TextField storyboard example.
* Rework to better the performance of animations with depth.

## 1.34.5

* Fixed breaking examples.

## 1.34.4

* Added **NavigationBarViewControllerDelegate** that monitors the state of the `floatingViewController` property.
* Added **TextField** `detailLabelAutoHideEnabled`property that flags the animation to hide the detailLabel automatically when the text value has changed. Default is true.

## 1.34.3

* Added headers to public build phase.

## 1.34.2

* License text update.

## 1.34.1

* CaptureView example has been updated to use the latest NavigationBarView API.
* NavigationBarView default sizing:
    - Only titleLabel, font size is 20.
    - With titleLabel and detailLabel, font size is 17 for titleLabel, and 12 for detailLabel.
* Example projects updated.

## 1.34.0

* Added App example project in Examples/Programmatic.
* Added ControlView.
* Added StatusBarView.
* NavigationViewController is now NavigationBarViewController.
* Added StatusBarViewController.
* Added SearchBarViewController.
* MaterialSwitch now supports setting the "on", "selected", "highlighted", and "switchState" properties to toggle the state of the control.
* MaterialSwitch now supports setOn(on: Bool, animated: Bool) method to switch the state of the control.
* MaterialSwitch now supports 'on', 'highlighted', 'selected', 'state', and 'switchState' public mutators.
* MaterialSwitchDelegate updated 'materialSwitchStateChanged' delegation method to only pass a reference to the control, rather than control and state value.
* Added MenuViewController.
* SideNavigationBarViewController is now SideNavigationViewController.
* UIViewController Optional property sideNavigationBarViewController is now sideNavigationViewController.
* Added TextField placeholderTextColor property to set the placeholder text color.
* TextField detailLabel property hides automatically when typing.
* TextField now supports a custom clear UIButton by setting the clearButton property.

## 1.33.2

* Updated SerchBarView Example.
* A rotation issue is fixed when in landscape mode and toggling the SideNavigationViewController, where the statusBar would
* Added MaterialSwitch UIControl component with example projects in the Examples/Programmatic directory.
* MaterialEdgeInsetPreset is now MaterialEdgeInset.
* MaterialRadius preset values are now supported through the cornerRadiusPreset property. The cornerRadius property now supports CGFloat values directly.
* Updated TableCardView example.
* Added SearchBarView.
* Updated NavigationBarView API.
* Added NavigationViewController.
* Updated TextField and TextView issue, where letters such as "y g p" would not display correctly.
* MaterialButton has updated contentInsetPreset to contentEdgeInsetsPreset.
* Added MaterialTableViewCell with pulse animation.
* Updated SideNavigationViewController example project.

## 1.32.2

* Fixed an issue with MenuView, where outside views were not detected when touched.
* Updated API to reference views.

## 1.32.1

* MenuView wraps a Menu with a MaterialPulseView to ease the use of laying out menus, as well as, provide a more robust approach to Menus.
* Menus now hold an array of UIViews, allowing any UIView to be animated with Menu.
* The borderWidth property for Material views no longer uses an enum MaterialBorder type. It now supports the CGFloat type.

## 1.32.0

* CardView and ImageCardView no longer support the detailLabel property. Now, a detailView property has been added to allow any UIView, including UILabel to be added in the detail area.

## 1.31.6

* Grid now supports management of rows and columns in a single mapping.
* Updated Grid examples.
* Visit the Examples directory to see example projects using Material.

## 1.31.5

* Updated README.

## 1.31.4

* Updated Grid Example.
* Updated README.

## 1.31.3

* Updated Material usage description.

## 1.31.2

* Introducing Material Grid. A flexible grid system to handle complex layouts.
* Default depth is now .Depth1.

## 1.31.1

* Added two more examples using Menu.

## 1.31.0

* Added a new component, Menu!
* A Menu manages a group of UIButtons that may be animated open in the Up, Down, Left, and Right directions. The animations

## 1.30.2

* Fixed an issue where toggling the SideNavigationViewController enabled property caused the 'left' and 'right' view to stop

## 1.30.1

* Updated MaterialView example.

## 1.30.0

* Updated pulse animation to be a wave.
* Added `pulse` method to programmatically trigger the pulse animation.
* Updated examples to reflect pulse changes.
* Updated README to reflect pulse changes.
* Removed `pulseFill` and `spotlight` from pulse animatable views as they are no longer needed.

## 1.29.4

* Some minor updates to the internal references used for animations.
* Removed Task example to its own repository.

## 1.29.3

***This update is recommended.***

* Major update to SideNavigationViewController internals and animation.
* Added an additional duration parameter to setLeftViewWidth with animation and setRightViewWidth with animation.

## 1.29.2

***This is a recommended update.***

* Updated internal animations to handle UIView animations correctly.
* Updated SideNavigationViewController to allow quick swipe to close.
* Updated SideNavigationViewController to not block view touches when tap gesture is triggered.
* Updated workspace reference to Material project.

## 1.29.1

* To remove deprecated warnings, and provide an overall better solution, UIImage now utilizes NSURLSession for asynchronous image loading.
* The MaterialLayer example project demonstrates this feature update.

## 1.29.0

* SideNavigationViewController now supports the Right position for View Controllers.
* SideNavigationViewController API updates should be reviewed from the Class file.

## 1.28.1

* Updated README.

## 1.28.0

* Updated framework name to Material to avoid conflicts with other frameworks.
* Updated default TextField animation distance for titleLabel to 8.
* Updated default TextView animation distance for titleLabel to 8.

## 1.27.14

* The SideNavigationViewController example project has been updated.
* Updated README.

## 1.27.13

* An updated SideNavigationViewController example has been added to the Examples Programmatic directory. It includes a fresh new look and a reusable template for your applications.

## 1.27.12

* Updates to the TextView and TextField were made to follow Google's spacing guidelines.
* An issue with setting the TextView or TextField's text property has been fixed, where the title label was not being
* Additional updates were made to many of the example projects.

## 1.27.11

* Updated License Format.

## 1.27.10

* Updated License Format.

## 1.27.9

* Material is moving to a BSD license.

## 1.27.8

* Added @objc to TextView and TextViewDelegate to eliminate conflicts when using swift within an Objective-C project.
Below is an example of a medium CardView using Grid.

## 1.27.7

* Fixed an issue where the optional TextView.text property was being accessed and throwing an error when used in combination with Objective-C.

## 1.27.6

* Updated TextView internals to avoid optimization build issue with Carthage.
* Updated icon set in example projects.
* Updated Resources folder with latest graphics.
* Updated README.

## 1.27.4

* Removed the File Class.
* Updated README to correct TextField example.
Right out of the box to a fully customizable configuration, CardView always stands out. Take a look at a few examples in action.

### 1.27.2

* **titleLabelTextColor** is now **titleLabelColor**.
* **titleLabelActiveTextColor** is now **titleLabelActiveColor**.
* **detailLabelActiveTextColor** is now **detailLabelActiveColor**.
* **titleLabelTextColor** is now **titleLabelColor**.
* **titleLabelActiveTextColor** is now **titleLabelActiveColor**.

## 1.27.1

* Updated README to include Changelog link.

## 1.27.0

* Has been removed completely.
* **MaterialEdgeInsets** is now **MaterialEdgeInsetPreset**.
* **contentInsets** is now **contentInsetPreset**.
* **contentInsetsRef** is now **contentInset**.
* **dividerInsets** is now **dividerInsetPreset**.
* **dividerInsetRef** is now **dividerInset**.
* **contentInsets** is now **contentInsetPreset**.
* **contentInsetsRef** is now **contentInset**.
* **titleLabelInsets** is now **titleLabelInsetPreset**.
* **titleLabelInsetsRef** is now **titleLabelInset**.
* **detailLabelInsets** is now **detailLabelInsetPreset**.
* **detailLabelInsetsRef** is now **detailLabelInset**.
* **leftButtonsInsets** is now **leftButtonsInsetPreset**.
* **leftButtonsInsetsRef** is now **leftButtonsInset**.
* **rightButtonsInsets** is now **rightButtonsInsetPreset**.
* **rightButtonsInsetsRef** is now **rightButtonsInset**.
* **dividerInsets** is now **dividerInsetPreset**.
* **dividerInsetRef** is now **dividerInset**.
* **contentInsets** is now **contentInsetPreset**.
* **contentInsetsRef** is now **contentInset**.
* **titleLabelInsets** is now **titleLabelInsetPreset**.
* **titleLabelInsetsRef** is now **titleLabelInset**.
* **detailLabelInsets** is now **detailLabelInsetPreset**.
* **detailLabelInsetsRef** is now **detailLabelInset**.
* **leftButtonsInsets** is now **leftButtonsInsetPreset**.
* **leftButtonsInsetsRef** is now **leftButtonsInset**.
* **rightButtonsInsets** is now **rightButtonsInsetPreset**.
* **rightButtonsInsetsRef** is now **rightButtonsInset**.
* **shrink** is now **shrinkAnimation**.
* **wrapped** is no longer an Optional.
* **contentsScale** is no longer an Optional.
* **shrink** is now **shrinkAnimation**.
* **updatedPulseLayer** is now **updatePulseLayer**.
* **contentInsets** is now **contentInsetPreset**.
* **contentInsetsRef** is now **contentInset**.
* **titleLabelInsets** is now **titleLabelInsetPreset**.
* **titleLabelInsetsRef** is now **titleLabelInset**.
* **detailLabelInsets** is now **detailLabelInsetPreset**.
* **detailLabelInsetsRef** is now **detailLabelInset**.
* **leftButtonsInsets** is now **leftButtonsInsetPreset**.
* **leftButtonsInsetsRef** is now **leftButtonsInset**.
* **rightButtonsInsets** is now **rightButtonsInsetPreset**.
* **rightButtonsInsetsRef** is now **rightButtonsInset**.
* When setting the **enabled** property, gestures are removed and added appropriately.
* **titleLabelNormalColor** is now **titleLabelTextColor**.
* **titleLabelHighlightedColor** is now **titleLabelActiveTextColor**. 
