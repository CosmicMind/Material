![Motion Logo](http://www.cosmicmind.com/motion/logo/motion_logo.png)

# Motion

Welcome to **Motion,** a library used to create beautiful animations and transitions for views, layers, and view controllers.

## Photos Sample

Take a look at a sample [Photos](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Photos) project to get started.

![Photos](http://www.cosmicmind.com/motion/projects/photos.gif)

* [Photos Sample](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Photos)

### Who is Motion for?

Motion is designed for beginner to expert developers. For beginners, you will be exposed to very powerful APIs that would take time and experience to develop on your own, and experts will appreciate the time saved by using Motion.

### What you will learn

You will learn how to use Motion with a general introduction to fundamental concepts and easy to use code snippets.

# Transitions

Motion transitions a source view to a destination view using a linking identifier property named `motionIdentifier`.

| Match | Translate | Rotate | Arc | Scale |
|:---:|:---:|:---:|:---:|:---:|
| ![Match](http://www.cosmicmind.com/motion/transitions_identifier/match.gif) |  ![Translate](http://www.cosmicmind.com/motion/transitions_identifier/translate.gif) | ![Rotate](http://www.cosmicmind.com/motion/transitions_identifier/rotate.gif) | ![Arc](http://www.cosmicmind.com/motion/transitions_identifier/arc.gif) | ![Scale](http://www.cosmicmind.com/motion/transitions_identifier/scale.gif) |

### Example Usage

An example of transitioning from one view controller to another with transitions:

#### View Controller 1

```swift
greyView.motionIdentifier = "foo"
orangeView.motionIdentifier = "bar"
```

#### View Controller 2

```swift
isMotionEnabled = true
greyView.motionIdentifier = "foo"
orangeView.motionIdentifier = "bar"
orangeView.transition(.translate(x: -100))
```

The above code snippet tells the source views in `view controller 1` to link to the destination views in `view controller 2` using the `motionIdentifier`. Animations may be added to views during a transition using the **transition** method. The *transition* method accepts MotionTransition structs that configure the view's animation.

* [MotionTransition API](https://cosmicmind.gitbooks.io/motion/content/motion_transition_api.html)
* [Code Samples](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/TransitionsWithIdentifier)

## UINavigationController, UITabBarController, and UIViewController Transitions

Motion offers default transitions that may be used by UINavigationControllers, UITabBarControllers, and presenting UIViewControllers.

| Push | Slide | ZoomSlide | Cover | Page | Fade | Zoom |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| ![Push](http://www.cosmicmind.com/motion/transitions/push.gif)  | ![Slide](http://www.cosmicmind.com/motion/transitions/slide.gif)| ![Zoom Slide](http://www.cosmicmind.com/motion/transitions/zoom_slide.gif) | ![Cover](http://www.cosmicmind.com/motion/transitions/cover.gif) | ![Page](http://www.cosmicmind.com/motion/transitions/page_in.gif) | ![Fade](http://www.cosmicmind.com/motion/transitions/fade.gif) | ![Zoom](http://www.cosmicmind.com/motion/transitions/zoom.gif)|

### Example Usage

An example of transitioning from one view controller to another using a UINavigationController with a zoom transition:

#### UINavigationController

```swift
class AppNavigationController: UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        isMotionEnabled = true
        motionNavigationTransitionType = .zoom
    }
}
```

To add an automatic reverse transition, use `autoReverse`.

```swift
motionNavigationTransitionType = .autoReverse(presenting: .zoom)
```

* [Code Samples](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Transitions)

# Animations

Motion provides the building blocks necessary to create stunning animations without much effort. Motion's animation API will make maintenance a breeze and changes even easier. To create an animation, use the **animate** method of a view or layer and pass in a list of MotionAnimation structs. MotionAnimation structs are configurable values that describe how to animate a property or group of properties.

| Background Color | Corder Radius | Fade | Rotate | Size | Spring |
|:---:|:---:|:---:|:---:|:---:|:---:|
| ![Background Color](http://www.cosmicmind.com/motion/animations/background_color.gif) | ![Corner Radius](http://www.cosmicmind.com/motion/animations/corner_radius.gif) | ![Fade](http://www.cosmicmind.com/motion/animations/fade.gif) | ![Rotate](http://www.cosmicmind.com/motion/animations/rotate.gif) | ![Size](http://www.cosmicmind.com/motion/animations/size.gif) | ![Spring](http://www.cosmicmind.com/motion/animations/spring.gif) |

| Border Color & Border Width | Depth | Position | Scale | Spin | Translate |
|:---:|:---:|:---:|:---:|:---:|:---:|
|![Border Color & Border Width](http://www.cosmicmind.com/motion/animations/border_color.gif) | ![Depth](http://www.cosmicmind.com/motion/animations/depth.gif) | ![Position](http://www.cosmicmind.com/motion/animations/position.gif) | ![Scale](http://www.cosmicmind.com/motion/animations/scale.gif) | ![Spin](http://www.cosmicmind.com/motion/animations/spin.gif) | ![Translate](http://www.cosmicmind.com/motion/animations/translate.gif) |

### Example Usage

```swift
let box = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
box.backgroundColor = .blue

box.animate(.background(color: .red), .rotate(180), .delay(1))
```

In the above code example, a box view is created with a width of 100, height of 100, and an initial background color of blue. Following the general creation of the view, the _Motion animate_ method is passed _MotionAnimation structs_ that tell the view to animate to a red background color and rotate 180 degrees after a delay of 1 second. That's pretty much the general idea of creating animations.

* [MotionAnimation API](https://cosmicmind.gitbooks.io/motion/content/motion_animation_api.html)
* [Code Samples](https://github.com/CosmicMind/Samples/tree/master/Projects/Programmatic/Animations)

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

> **Embedded frameworks require a minimum deployment target of iOS 8.**
> - [Download Motion](https://github.com/CosmicMind/Motion/archive/master.zip)

Read [Material - It's time to download](https://www.cosmicmind.com/danieldahan/lesson/6) to learn how to install Material using [GitHub](http://github.com), [CocoaPods](http://cocoapods.org), and [Carthage](https://github.com/Carthage/Carthage).

## Change Log

Motion is a growing project and will encounter changes throughout its development. It is recommended that the [Change Log](https://github.com/CosmicMind/Motion/blob/master/CHANGELOG.md) be reviewed prior to updating versions.

## License

The MIT License (MIT)

Copyright (C) 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
