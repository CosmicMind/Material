![MaterialKit](http://www.materialkit.io/MK/MaterialKit.png)

# Welcome to MaterialKit

MaterialKit is a graphics and animation framework based on Google's Material Design. A major goal in the design of MaterialKit is to allow the creativity of others to easily be expressed.

## Features

- [x] Fully Configurable UI Components
- [x] Base Material Layers & Material Views To Create New UI Components
- [x] Side Navigation View Controller
- [x] Navigation Bar View
- [x] Material Buttons
- [x] Material Card Views
- [x] Camera / Video Extension With Extensive Functionality
- [x] Layout Library To Simplify AutoLayout
- [x] Animation Extension To Create Intricate Animations
- [x] Complete Material Color Library
- [x] Example Projects

## Requirements

* iOS 8.0+
* Xcode 7.2+

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/materialkit). (Tag 'materialkit')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/materialkit).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation
> **Embedded frameworks require a minimum deployment target of iOS 8.**
> - [Download MaterialKit](https://github.com/CosmicMind/MaterialKit/archive/master.zip)

## CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build MaterialKit 1.0.0+.

To integrate MaterialKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'MK', '~> 1.0'
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
To integrate MaterialKit into your Xcode project using Carthage, specify it in your Cartfile:

```bash
github "CosmicMind/MaterialKit"
```

Run `carthage update` to build the framework and drag the built `MaterialKit.framework` into your Xcode project.

## Changelog

MaterialKit is a growing project and will encounter changes throughout its development. It is recommended that the [Changelog](https://github.com/CosmicMind/MaterialKit/wiki/Changelog) be reviewed prior to updating versions.

## Examples

* Visit the Examples directory to see example projects using MaterialKit.

## A Tour  

* [SideNavigationViewController](#sidenavigationviewcontroller)
* [NavigationBarView](#navigationbarview)
* [TextField](#textfield)
* [TextView](#textview)
* [MaterialLayer](#materiallayer)
* [MaterialView](#materialview)
* [MaterialPulseView](#materialpulseview)
* [FlatButton](#flatbutton)
* [RaisedButton](#raisedbutton)
* [FabButton](#fabbutton)
* [CardView](#cardview)
* [ImageCardView](#imagecardview)
* [CaptureView](#captureview)
* [MaterialColor](#materialcolor)

## Upcoming

* SearchBarView
* SearchBarViewController
* TabView
* TabViewController
* Scrolling Techniques
* Dialogs
* Snackbar
* ProgressBar (circular and horizontal)
* DatePicker
* TimePicker
* More Examples

<a name="sidenavigationviewcontroller"></a>
## SideNavigationViewController

The SideNavigationViewController is an app wide navigation pattern. It generally provides overall app navigation with other useful items.

![MaterialKitSideNavigationViewController](http://www.materialkit.io/MK/MaterialKitSideNavigationViewController.gif)

[Learn More About SideNavigationViewController](https://github.com/CosmicMind/MaterialKit/wiki/SideNavigationViewController)

<a name="navigationbarview"></a>
## NavigationBarView

A NavigationBarView is a fully featured navigation bar that supports orientation changes, background images, title and detail labels, both left and right button sets, and status bar settings.

![MaterialKitNavigationBarView](http://www.materialkit.io/MK/MaterialKitNavigationBarView.gif)

[Learn More About NavigationBarView](https://github.com/CosmicMind/MaterialKit/wiki/NavigationBarView)

<a name="textfield"></a>
## TextField

A TextField is an excellent way to improve UX. TextFields offer details
that describe the usage and input results of text. For example, when a
user enters an incorrect email, it is possible to display an error message
under the TextField.

![MaterialKitTextField](http://www.materialkit.io/MK/MaterialKitTextField.gif)

[Learn More About TextField](https://github.com/CosmicMind/MaterialKit/wiki/TextField)

<a name="textview"></a>
## TextView

A TextView is an excellent way to improve UX. TextViews offer details that describe the usage of text. In addition, TextViews may easily match any regular expression pattern in a body of text. Below is an example of the default hashtag pattern matching.

![MaterialKitTextView](http://www.materialkit.io/MK/MaterialKitTextView.gif)

[Learn More About TextView](https://github.com/CosmicMind/MaterialKit/wiki/TextView)

<a name="materiallayer"></a>
## MaterialLayer

MaterialLayer is a lightweight CAShapeLayer used throughout MaterialKit. It is designed to easily take shape, depth, and animations.

![MaterialKitMaterialLayer](http://www.materialkit.io/MK/MaterialKitMaterialLayer.gif)

[Learn More About MaterialLayer](https://github.com/CosmicMind/MaterialKit/wiki/MaterialLayer)

<a name="materialview"></a>
## MaterialView

MaterialView is the base UIView class used throughout MaterialKit. Like MaterialLayer, it is designed to easily take shape, depth, and animations. The major difference is that MaterialView has all the added features of the UIView class.

![MaterialKitMaterialView](http://www.materialkit.io/MK/MaterialKitMaterialView.gif)

[Learn More About MaterialView](https://github.com/CosmicMind/MaterialKit/wiki/MaterialView)

<a name="materialpulseview"></a>
## MaterialPulseView

MaterialPulseView is at the heart of all pulse animations. Any view that subclasses MaterialPulseView instantly inherits the pulse animation with full customizability.

![MaterialKitMaterialPulseView](http://www.materialkit.io/MK/MaterialKitMaterialPulseView.gif)

[Learn More About MaterialPulseView](https://github.com/CosmicMind/MaterialKit/wiki/MaterialPulseView)

<a name="flatbutton"></a>
## FlatButton

A FlatButton is simple, clean, and very effective. Below is an example of a FlatButton in action.

![MaterialKitFlatButton](http://www.materialkit.io/MK/MaterialKitFlatButton.gif)

[Learn More About FlatButton](https://github.com/CosmicMind/MaterialKit/wiki/FlatButton)

<a name="raisedbutton"></a>
## RaisedButton

A RaisedButton is sure to get attention. Take a look at the following animation example.

![MaterialKitRaisedButton](http://www.materialkit.io/MK/MaterialKitRaisedButton.gif)

[Learn More About RaisedButton](https://github.com/CosmicMind/MaterialKit/wiki/RaisedButton)

<a name="fabbutton"></a>
## FabButton

A FabButton is essential to Material Design's overall look. Below showcases its beauty.

![MaterialKitFabButton](http://www.materialkit.io/MK/MaterialKitFabButton.gif)

[Learn More About FabButton](https://github.com/CosmicMind/MaterialKit/wiki/FabButton)

<a name="cardview"></a>
## CardView

Right out of the box to a fully customizable configuration, CardView always stands out. Take a look at a few examples in action.

![MaterialKitCardView](http://www.materialkit.io/MK/MaterialKitCardView.gif)

[Learn More About CardView](https://github.com/CosmicMind/MaterialKit/wiki/CardView)

Easily remove the pulse animation and add a background image for an entirely new feel.

![MaterialKitCardViewFavorite](http://www.materialkit.io/MK/MaterialKitCardViewFavorite.gif)

Adjust the alignment of the UI elements to create different configurations of the CardView.

![MaterialKitCardViewDataDriven](http://www.materialkit.io/MK/MaterialKitCardViewDataDriven.gif)

CardViews are so flexible they create entirely new components by removing all but certain elements. For example, bellow is a button bar by only setting the button values of the CardView.

![MaterialKitCardViewButtonBar](http://www.materialkit.io/MK/MaterialKitCardViewButtonBar.gif)

<a name="imagecardview"></a>
## ImageCardView

Bold and attractive, ImageCardView is the next step from a CardView. Below are some animations to give you an idea of the possibilities the ImageCardView has to offer.

![MaterialKitImageCardView](http://www.materialkit.io/MK/MaterialKitImageCardView.gif)

[Learn More About ImageCardView](https://github.com/CosmicMind/MaterialKit/wiki/ImageCardView)

Remove elements, such as details to create a fresh look for your images.

![MaterialKitImageCardViewBackgroundImage](http://www.materialkit.io/MK/MaterialKitImageCardViewBackgroundImage.gif)

<a name="captureview"></a>
## CaptureView

Add a new dimension of interactivity with CaptureView. CaptureView is a fully functional camera that is completely customizable.

![MaterialKitCaptureView](http://www.materialkit.io/MK/MaterialKitCaptureView.jpg)

[Learn More About CaptureView](https://github.com/CosmicMind/MaterialKit/wiki/CaptureView)

<a name="materialcolor"></a>
## MaterialColor

MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.

![MaterialKitMaterialColorPalette](http://www.materialkit.io/MK/MaterialKitMaterialColorPalette.png)

[Learn More About MaterialColor](https://github.com/CosmicMind/MaterialKit/wiki/MaterialColor)

## License

Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

*   Redistributions of source code must retain the above copyright notice, this     
    list of conditions and the following disclaimer.

*   Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

*   Neither the name of MaterialKit nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
