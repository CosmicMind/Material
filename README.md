![Material](http://www.cosmicmind.com/material/github/material-logo.png)

# Material

Welcome to **Material,** a UI/UX framework for creating beautiful applications. Material's animation system has been completely reworked to take advantage of [Motion](https://github.com/CosmicMind/Motion), a library dedicated to animations and transitions.

[![Carthage compatible](https://img.shields.io/badge/Carthage-Compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Accio supported](https://img.shields.io/badge/Accio-supported-0A7CF5.svg?style=flat)](https://github.com/JamitLabs/Accio)
[![Version](https://img.shields.io/cocoapods/v/Material.svg?style=flat)](http://cocoapods.org/pods/Material)
[![License](https://img.shields.io/cocoapods/l/Material.svg?style=flat)](https://github.com/CosmicMind/Material/blob/master/LICENSE.md)
![Xcode 8.2+](https://img.shields.io/badge/Xcode-8.2%2B-blue.svg)
![iOS 8.0+](https://img.shields.io/badge/iOS-8.0%2B-blue.svg)
![Swift 4.0+](https://img.shields.io/badge/Swift-4.0%2B-orange.svg)
[![Donate](https://img.shields.io/badge/Donate-PayPal-blue.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=9D6MURMLLUNQ2)

## Photos Sample

Take a look at a sample [Photos](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Photos) project to get started.

![Photos](http://www.cosmicmind.com/motion/projects/photos.gif)

## Sample Projects

Take a look at [Sample Projects](https://github.com/CosmicMind/Samples) to get your projects started.

## Features

- [x] Completely Customizable
- [x] [Motion Animations & Transitions](https://github.com/CosmicMind/Motion)
- [x] Layout Tools for AutoLayout & Grid Systems
- [x] Color Library
- [x] Cards
- [x] FABMenu
- [x] Icons
- [x] TextField
- [x] Snackbar
- [x] Tabs
- [x] Chips
- [x] SearchBar
- [x] NavigationController
- [x] NavigationDrawer
- [x] BottomNavigationBar
- [x] [Sample Projects](https://github.com/CosmicMind/Samples)
- [x] And More...

## Requirements

* iOS 8.0+
* Xcode 8.0+

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cosmicmind). (Tag 'cosmicmind')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cosmicmind).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8+.**
> - [Download Material](https://github.com/CosmicMind/Material/archive/master.zip)

## CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate Material's core features into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Material', '~> 3.1.0'
```

Then, run the following command:

```bash
$ pod install
```

## Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

```bash
$ brew update
$ brew install carthage
```
To integrate Material into your Xcode project using Carthage, specify it in your Cartfile:

```bash
github "CosmicMind/Material"
```

Run `carthage update` to build the framework and drag the built `Material.framework` into your Xcode project.

## Change Log

Material is a growing project and will encounter changes throughout its development. It is recommended that the [Change Log](https://github.com/CosmicMind/Material/blob/master/CHANGELOG.md) be reviewed prior to updating versions.

## Icons

Icons is a library of Google and CosmicMind icons that are available for use within your iOS applications.

![Icon](http://www.cosmicmind.com/gifs/marketplace/icons.png)

[Learn More](https://github.com/CosmicMind/Material/blob/master/Sources/iOS/Icon/Icon.swift)

## Colors

Try the Material Colors app to see the wonderful colors available in Material, or use the online version at [MaterialColor.com](http://materialcolor.com).

![MaterialColors](http://www.cosmicmind.com/gifs/shared/colors.gif)

* [Material Colors iOS App](https://itunes.apple.com/app/x/id1111994400?mt=8)

## TextField

A TextField is an excellent way to improve UX. It allows for a placeholder and additional hint details.

![TextField](http://www.cosmicmind.com/gifs/white/text-field.gif)

* [TextField Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/TextField)

## Button

A button is used to trigger an action through a touch event. Material comes with a foundational button, and 4 specialized buttons that can be stylized in any way.

![Material Image](http://www.cosmicmind.com/material/white/button.gif)

* [Button Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Button)

## Switch

A switch is a control component that toggles between on and off states.

![Material Image](http://www.cosmicmind.com/material/white/switch.gif)

* [Switch Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Switch)

## Card

A Card is a flexible component that may be configured in any way you like. It has a Toolbar, Bar, and content area that may utilize any UIView type.

![Material Image](http://www.cosmicmind.com/gifs/white/card.gif)

* [Card Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Card)

## ImageCard

An ImageCard is an expansion of the base Card. The Toolbar overlays an image area that sits above the dynamic content area.

![Image Card Sample](http://www.cosmicmind.com/gifs/white/image-card.gif)

* [ImageCard Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/ImageCard)

## PresenterCard

The PresenterCard is a completely new card style. It allows for a primary presentation area that may be any UIView type in addition to the content area, Toolbar, and Bar components. The options for this card are endless.

![Presenter Card Sample](http://www.cosmicmind.com/gifs/white/presenter-card.gif)

* [PresenterCard Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/PresenterCard)

## FABMenu

A FABMenu manages a collection of views. A new MenuItem type has been added that manages a title and button to improve UX and visual beauty.

![Material Image](http://www.cosmicmind.com/material/white/menu-controller.gif)

* [FABMenu Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/FABMenuController)

## Toolbar

Toolbars are super flexible and add excellent control to your navigation flow. They manage a set of left and right views with auto aligning title and detail labels.

![Material Image](http://www.cosmicmind.com/gifs/white/toolbar-controller.gif)

* [Toolbar Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/ToolbarController)

## SearchBar

A SearchBar is a powerful navigation tool that allows for user's input with an instant visual response. A set of left and right views may be added to expand functionality.

![SearchBarController](http://www.cosmicmind.com/gifs/shared/search-bar-controller.gif)

* [SearchBar Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Search)

## Tabs

Tabs is a new component that links a customizable TabBar to a stack of view controllers making a powerful and visually pleasing component to have in any application.

![Tabs](http://www.cosmicmind.com/material/white/page-tab-bar-controller.gif)

* [Tabs Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/TabsController)

## NavigationController

A NavigationController is a specialized view controller that manages a hierarchy of content efficiently, making it easier for users to move within an application.

![Material Image](http://www.cosmicmind.com/gifs/white/navigation-controller.gif)

* [NavigationController Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/NavigationController)

## NavigationDrawer

A NavigationDrawer slides in from the left or right and contains the navigation destinations for your application.

![Material Image](http://www.cosmicmind.com/material/shared/navigation-drawer-controller.gif)

* [NavigationDrawer Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/NavigationDrawerController)

## Snackbar

A Snackbar is a new component that is very simple in its behavior and very powerful in its message. It can be used application wide, or isolated to specific view controllers.

![Material Image](http://www.cosmicmind.com/material/white/snackbar-controller.gif)

* [Snackbar Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/SnackbarController)

## Sticker Sheet

To help template your project, checkout Material Sticker Sheet.

![MaterialStickerSheet](http://www.cosmicmind.com/MK/material_iso_1.png)

* [Material Sticker Sheet](http://www.materialup.com/posts/material-design-sticker-sheets)

## Much More...

So much more inside. Enjoy!

## License

The MIT License (MIT)

Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
