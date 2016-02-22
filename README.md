![Material](http://www.cosmicmind.io/MK/Material.png)

# Welcome to Material

Express your creativity with Material, an animation and graphics framework for Google's Material Design and Apple's Flat UI in Swift.

![MaterialApp](http://www.cosmicmind.io/MK/MaterialApp.gif)

## Features

- [x] Fully Configurable UI Components
- [x] Grid System For Complex UIs
- [x] Layout Library To Simplify AutoLayout
- [x] Base Material Layers & Material Views To Create New UI Components
- [x] Navigation Controllers
- [x] Material Buttons
- [x] Material Switch
- [x] Material Card Views
- [x] Menu Toolset To Create Animated Menus
- [x] Camera / Video Extension With Extensive Functionality
- [x] Animation Extension To Create Intricate Animations
- [x] Complete Material Color Library
- [x] Example Projects
- [x] And More...

## Requirements

* iOS 8.0+
* Xcode 7.2+

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cosmicmind). (Tag 'cosmicmind')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/cosmicmind).
- If you **found a bug**, _and can provide steps to reliably reproduce it_, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8.**
> - [Download Material](https://github.com/CosmicMind/Material/archive/master.zip)

Visit the [Installation](https://github.com/CosmicMind/Material/wiki/Installation) page to learn how to install Material using [CocoaPods](http://cocoapods.org) and [Carthage](https://github.com/Carthage/Carthage).

## Changelog

Material is a growing project and will encounter changes throughout its development. It is recommended that the [Changelog](https://github.com/CosmicMind/Material/wiki/Changelog) be reviewed prior to updating versions.

## Examples

* Visit the Examples directory to see example projects using Material.
* The [Installation](https://github.com/CosmicMind/Material/wiki/Installation) page has documentation on how to run the example projects.

## A Tour  

#### Colors

* [MaterialColor](#materialcolor)

#### Base Layers & Views

* [MaterialLayer](#materiallayer)
* [MaterialView](#materialview)
* [MaterialPulseView](#materialpulseview)

#### Text

* [TextField](#textfield)
* [TextView](#textview)

#### Buttons

* MaterialButton
* [FlatButton](#flatbutton)
* [RaisedButton](#raisedbutton)
* [FabButton](#fabbutton)

#### Control

* [MaterialSwitch](#materialswitch) (New)

#### Collection Management

* [Menu](#menu) (New)

#### Layout

* [Grid](#grid) (New)
* MaterialLayout

#### Collections

* [MaterialTableViewCell](#materialtableviewcell) (New)

#### Cards

* [CardView](#cardview) (New)
* [ImageCardView](#imagecardview)

#### Navigation

* [MenuView](#menuview) (New)
* [MenuViewController](#menuviewcontroller) (New)
* [NavigationBarView](#navigationbarview) (New)
* [NavigationBarViewController](#navigationbarviewcontroller) (New)
* [SearchBarView](#searchbarview) (New)
* [SearchBarViewController](#searchbarviewcontroller) (New)
* [SideNavigationViewController](#sidenavigationviewcontroller)

#### Photo / Video Camera

* [CaptureView](#captureview)

#### Upcoming

* TabView
* TabViewController
* Scrolling Techniques
* Snackbar
* Advanced Camera / Audio Toolset & Views
* More Examples

<a name="materialcolor"></a>
#### MaterialColor

MaterialColor is a complete Material Design color library. It uses base color values that expand to a range of lighter and darker shades, with the addition of accents.

![MaterialMaterialColorPalette](http://www.cosmicmind.io/MK/MaterialMaterialColorPalette.png)

[Learn More About MaterialColor](https://github.com/CosmicMind/Material/wiki/MaterialColor)

<a name="materiallayer"></a>
#### MaterialLayer

MaterialLayer is a lightweight CAShapeLayer used throughout Material. It is designed to easily take shape, depth, and animations.

![MaterialMaterialLayer](http://www.cosmicmind.io/MK/MaterialMaterialLayer.gif)

[Learn More About MaterialLayer](https://github.com/CosmicMind/Material/wiki/MaterialLayer)

<a name="materialview"></a>
#### MaterialView

MaterialView is the base UIView class used throughout Material. Like MaterialLayer, it is designed to easily take shape, depth, and animations. The major difference is that MaterialView has all the added features of the UIView class.

![MaterialMaterialView](http://www.cosmicmind.io/MK/MaterialMaterialView.gif)

[Learn More About MaterialView](https://github.com/CosmicMind/Material/wiki/MaterialView)

<a name="materialpulseview"></a>
#### MaterialPulseView

MaterialPulseView is at the heart of all pulse animations. Any view that subclasses MaterialPulseView instantly inherits the pulse animation with full customizability.

![MaterialMaterialPulseView](http://www.cosmicmind.io/MK/MaterialMaterialPulseView.gif)

[Learn More About MaterialPulseView](https://github.com/CosmicMind/Material/wiki/MaterialPulseView)

<a name="textfield"></a>
#### TextField

A TextField is an excellent way to improve UX. TextFields offer details
that describe the usage and input results of text. For example, when a
user enters an incorrect email, it is possible to display an error message
under the TextField.

![MaterialTextField](http://www.cosmicmind.io/MK/MaterialTextField.gif)

[Learn More About TextField](https://github.com/CosmicMind/Material/wiki/TextField)

<a name="textview"></a>
#### TextView

A TextView is an excellent way to improve UX. TextViews offer details that describe the usage of text. In addition, TextViews may easily match any regular expression pattern in a body of text. Below is an example of the default hashtag pattern matching.

![MaterialTextView](http://www.cosmicmind.io/MK/MaterialTextView.gif)

[Learn More About TextView](https://github.com/CosmicMind/Material/wiki/TextView)

<a name="flatbutton"></a>
#### FlatButton

A FlatButton is simple, clean, and very effective. Below is an example of a FlatButton in action.

![MaterialFlatButton](http://www.cosmicmind.io/MK/MaterialFlatButton.gif)

[Learn More About FlatButton](https://github.com/CosmicMind/Material/wiki/FlatButton)

<a name="raisedbutton"></a>
#### RaisedButton

A RaisedButton is sure to get attention. Take a look at the following animation example.

![MaterialRaisedButton](http://www.cosmicmind.io/MK/MaterialRaisedButton.gif)

[Learn More About RaisedButton](https://github.com/CosmicMind/Material/wiki/RaisedButton)

<a name="fabbutton"></a>
#### FabButton

A FabButton is essential to Material Design's overall look. Below showcases its beauty.

![MaterialFabButton](http://www.cosmicmind.io/MK/MaterialFabButton.gif)

[Learn More About FabButton](https://github.com/CosmicMind/Material/wiki/FabButton)

<a name="materialswitch"></a>
#### MaterialSwitch

MaterialSwitch is a fully customizable UIControl. It has auto centre alignment when using AutoLayout, and makes for a great addition to the UIControl family of components.

![MaterialMaterialSwitch](http://www.cosmicmind.io/MK/MaterialMaterialSwitch.gif)

[Learn More About MaterialSwitch](https://github.com/CosmicMind/Material/wiki/MaterialSwitch)

<a name="menu"></a>
#### Menu

A Menu manages a group of UIViews that may be animated open in the Up, Down, Left, and Right directions. The animations are fully customizable.

Below is an example using FlatButtons.

![MaterialFlatMenu](http://www.cosmicmind.io/MK/MaterialFlatMenu.gif)

Below is an example using FlatButtons with images.

![MaterialFlashMenu](http://www.cosmicmind.io/MK/MaterialFlashMenu.gif)

[Learn More About Menu](https://github.com/CosmicMind/Material/wiki/Menu)

<a name="grid"></a>
#### Grid

Grid is an extension of UIView that enables any collection of subviews to be managed in a flexible grid system, independent of other views that would need to be freely moving. Below are examples of using Grid. In the Examples/Programmatic directory, there are examples using this wonderful feature.

Below is an example of a small CardView using Grid.

![MaterialSmallCardView](http://www.cosmicmind.io/MK/MaterialGridSmallCardView.gif)

Below is an example of a medium CardView using Grid.

![MaterialGridMediumCardView](http://www.cosmicmind.io/MK/MaterialGridMediumCardView.gif)

Below is an example of a large CardView using Grid.

![MaterialGridLargeCardView](http://www.cosmicmind.io/MK/MaterialGridLargeCardView.gif)

[Learn More About Grid](https://github.com/CosmicMind/Material/wiki/Grid)

<a name="materialtableviewcell"></a>
#### MaterialTableViewCell

UITableViewCell is a popular and widely used view in iOS. Now the pulse animation and core Material features have been made available for the UITableViewCell.

![MaterialMaterialTableViewCell](http://www.cosmicmind.io/MK/MaterialMaterialTableViewCell.gif)

[Learn More About MaterialTableViewCell](https://github.com/CosmicMind/Material/wiki/MaterialTableViewCell)

<a name="cardview"></a>
#### CardView

Right out of the box to a fully customizable configuration, CardView always stands out. Take a look at a few examples in action.

![MaterialCardView](http://www.cosmicmind.io/MK/MaterialCardView.gif)

Easily remove the pulse animation and add a background image for an entirely new feel.

![MaterialCardViewFavorite](http://www.cosmicmind.io/MK/MaterialCardViewFavorite.gif)

Add any UIView as the detail to a CardView. For example, a UITableView.

![MaterialTableCardView](http://www.cosmicmind.io/MK/MaterialTableCardView.gif)

CardViews are so flexible they create entirely new components by removing all but certain elements. For example, bellow is a button bar by only setting the button values of the CardView.

![MaterialCardViewButtonBar](http://www.cosmicmind.io/MK/MaterialCardViewButtonBar.gif)

[Learn More About CardView](https://github.com/CosmicMind/Material/wiki/CardView)

<a name="imagecardview"></a>
#### ImageCardView

Bold and attractive, ImageCardView is the next step from a CardView. Below are some animations to give you an idea of the possibilities the ImageCardView has to offer.

![MaterialImageCardView](http://www.cosmicmind.io/MK/MaterialImageCardView.gif)

Remove elements, such as details to create a fresh look for your images.

![MaterialImageCardViewBackgroundImage](http://www.cosmicmind.io/MK/MaterialImageCardViewBackgroundImage.gif)

[Learn More About ImageCardView](https://github.com/CosmicMind/Material/wiki/ImageCardView)

#### Navigation

Navigation controls create smooth transitions between UIViewControllers. They may be used individually or stacked. Transitions are customizable and dimensions are flexible with auto management for both Portrait and Landscape modes.

<a name="menu"></a>
#### MenuView

A MenuView is a UIView wrapper around a Menu control. It allows a stack of UIViews to be coordinated by a single view. This is good for Menus that are within flexible view hierarchies.

Below is an example using FabButtons.

![MaterialFabMenu](http://www.cosmicmind.io/MK/MaterialFabMenu.gif)

<a href="#menuviewcontroller"></a>
#### MenuViewController

A MenuViewController manages UIViewControllers using a MenuView component.

![MaterialMenuViewController](http://www.cosmicmind.io/MK/MaterialMenuViewController.gif)

<a name="navigationbarview"></a>
#### NavigationBarView

A NavigationBarView is a fully featured navigation bar that supports orientation changes, background images, title and detail labels, both left and right UIControl sets, and status bar settings.

![MaterialNavigationBarView](http://www.cosmicmind.io/MK/MaterialNavigationBarView.gif)

[Learn More About NavigationBarView](https://github.com/CosmicMind/Material/wiki/NavigationBarView)

<a href="#navigationbarviewcontroller"></a>
#### NavigationBarViewController

A NavigationBarViewController manages UIViewControllers using a NavigationBarView component.

![MaterialNavigationBarViewController](http://www.cosmicmind.io/MK/MaterialNavigationBarViewController.gif)

<a name="searchbarview"></a>
#### SearchBarView

A SearchBarView is a fully featured search bar that supports orientation changes, background images, title and detail labels, both left and right UIControl sets, and status bar settings.

![MaterialSearchBarView](http://www.cosmicmind.io/MK/MaterialSearchBarView.gif)

[Learn More About SearchBarView](https://github.com/CosmicMind/Material/wiki/SearchBarView)

<a href="#searchbarviewcontroller"></a>
#### SearchBarViewController

A SearchBarViewController manages UIViewControllers using a SearchBarView component.

![MaterialSearchBarViewController](http://www.cosmicmind.io/MK/MaterialSearchBarViewController.gif)

<a href="#sidenavigationviewcontroller"></a>
#### SideNavigationViewController

A SideNavigationViewController manages UIViewControllers that are available as hidden drawers on the left and right of the view port.

![MaterialSideNavigationViewController](http://www.cosmicmind.io/MK/MaterialSideNavigationViewController.gif)

<a name="captureview"></a>
#### CaptureView

Add a new dimension of interactivity with CaptureView. CaptureView is a fully functional camera that is completely customizable.

![MaterialCaptureView](http://www.cosmicmind.io/MK/MaterialCaptureView.jpg)

[Learn More About CaptureView](https://github.com/CosmicMind/Material/wiki/CaptureView)

## License

Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

*   Redistributions of source code must retain the above copyright notice, this     
    list of conditions and the following disclaimer.

*   Redistributions in binary form must reproduce the above copyright notice,
    this list of conditions and the following disclaimer in the documentation
    and/or other materials provided with the distribution.

*   Neither the name of Material nor the names of its
    contributors may be used to endorse or promote products derived from
    this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
