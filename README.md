# MaterialKit

### CocoaPods Support

MaterialKit is on CocoaPods under the name [MK][1].

### Basic MaterialView

To get started, let's introduce MaterialView, a lightweight UIView Object that has flexibility in mind. Common controls have been added to make things easier. For example, let's make a circle view that has a shadow, border, and image.

![MaterialKitPreview][image-1]

```swift
`let v: MaterialView = MaterialView(frame: CGRectMake(100, 100, 200, 200))
v.shape = .Circle
v.shadowDepth = .Depth2
v.borderWidth = .Border1
v.image = UIImage(named: "focus")

// Add to UIViewController.
view.addSubview(v)
```
`
### Animated MaterialPulseView

Let's expand on the basic MaterialView and use an animated MaterialPulseView. In this example, we will make the shape a square with some rounded corners.

![MaterialKitPreview][image-2]

```swift
`let v: MaterialPulseView = MaterialPulseView(frame: CGRectMake(100, 100, 200, 200))
v.shape = .Square
v.cornerRadius = .Radius2
v.shadowDepth = .Depth2
v.image = UIImage(named: "focus")

// Add to UIViewController.
view.addSubview(v)
```
`
### Simple FlatButton

A FlatButton is the best place to start when introducing MaterialKit buttons. It is simple, clean, and very effective. Below is an example of a FlatButton in action.

![MaterialKitPreview][image-3]

```swift
`let v: FlatButton = FlatButton(frame: CGRectMake(100, 100, 200, 64))
v.setTitle("Flat", forState: .Normal)
v.titleLabel!.font = RobotoFont.mediumWithSize(32)

// Add to UIViewController.
view.addSubview(v)
```
`
### Noticeable RaisedButton

A RaisedButton is sure to get attention. Take a look at the following code sample.

![MaterialKitPreview][image-4]

```swift
`let v: RaisedButton = RaisedButton(frame: CGRectMake(100, 100, 200, 64))
v.setTitle("Raised", forState: .Normal)
v.titleLabel!.font = RobotoFont.mediumWithSize(32)

// Add to UIViewController.
view.addSubview(v)
```
`
### Actionable FabButton

A FabButton is essential to Material Design's overall look. I leave this example as simple as possible to showcase its beauty.

![MaterialKitPreview][image-5]

```swift
`let v: FabButton = FabButton(frame: CGRectMake(100, 100, 64, 64))
v.setImage(UIImage(named: "ic\_create\_white"), forState: .Normal)
v.setImage(UIImage(named: "ic\_create\_white"), forState: .Highlighted)

// Add to UIViewController.
view.addSubview(v)
```
`
### Sleek NavigationBarView

A NavigationBarView is a very common UI element and the more presentable it is, the better. The following example shows how to setup a NavigationBarView on the fly.

![MaterialKitPreview][image-6]

```swift
`let v: NavigationBarView = NavigationBarView(titleLabel: MaterialLabel())!
v.backgroundColor = MaterialColor.blue.accent3
v.statusBarStyle = .LightContent

v.titleLabel!.text = "Title"
v.titleLabel!.textAlignment = .Center
v.titleLabel!.textColor = MaterialColor.white
v.titleLabel!.font = RobotoFont.regularWithSize(20)

let b1: FlatButton = FlatButton()
b1.setTitle("B1", forState: .Normal)
b1.setTitleColor(MaterialColor.white, forState: .Normal)
b1.pulseColor = MaterialColor.white

let b2: FlatButton = FlatButton()
b2.setTitle("B2", forState: .Normal)
b2.setTitleColor(MaterialColor.white, forState: .Normal)
b2.pulseColor = MaterialColor.white

v.leftButtons = [b1, b2]

let b3: FlatButton = FlatButton()
b3.setTitle("B3", forState: .Normal)
b3.setTitleColor(MaterialColor.white, forState: .Normal)
b3.pulseColor = MaterialColor.white

let b4: FlatButton = FlatButton()
b4.setTitle("B4", forState: .Normal)
b4.setTitleColor(MaterialColor.white, forState: .Normal)
b4.pulseColor = MaterialColor.white

v.rightButtons = [b3, b4]

// Add to UIViewController.
view.addSubview(v)
```
`
### Flexible BasicCardView

A BasicCardView is super flexible with all its options - including a title, detail, left buttons, and right buttons. Below is an example of a simple setup.

![MaterialKitPreview][image-7]

```swift
`let v: BasicCardView = BasicCardView(titleLabel: UILabel(), detailLabel: UILabel())!
v.backgroundColor = MaterialColor.blueGrey.darken1
v.dividerColor = MaterialColor.blueGrey.base

v.titleLabel!.textColor = MaterialColor.white
v.titleLabel!.font = RobotoFont.regularWithSize(18)
v.titleLabel!.text = "Card Title"

v.detailLabel!.textColor = MaterialColor.white
v.detailLabel!.font = RobotoFont.regularWithSize(14)
v.detailLabel!.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little code to use effectively."

let b1: FlatButton = FlatButton()
b1.setTitle("Button 1", forState: .Normal)
b1.setTitleColor(MaterialColor.amber.darken1, forState: .Normal)
b1.setTitleColor(MaterialColor.amber.lighten1, forState: .Highlighted)
b1.pulseColor = MaterialColor.white

let b2: FlatButton = FlatButton()
b2.setTitle("Button 2", forState: .Normal)
b2.setTitleColor(MaterialColor.amber.darken1, forState: .Normal)
b2.setTitleColor(MaterialColor.amber.lighten1, forState: .Highlighted)
b2.pulseColor = MaterialColor.white

v.leftButtons = [b1, b2]

// Add to UIViewController.
view.addSubview(v)
v.translatesAutoresizingMaskIntoConstraints = false
MaterialLayout.alignToParentHorizontallyWithInsets(view, child: v, left: 20, right: 20)
MaterialLayout.alignFromTop(view, child: v, top: 100)
```
`
A BasicCardView can easily add an image as its background, below is the code that shows how to do this.

![MaterialKitPreview][image-8]

```swift
`let v: BasicCardView = BasicCardView(titleLabel: UILabel(), detailLabel: UILabel())!

v.image = UIImage(named: "forest")

v.titleLabel!.textColor = MaterialColor.white
v.titleLabel!.font = RobotoFont.regularWithSize(18)
v.titleLabel!.text = "Card Title"

v.detailLabel!.textColor = MaterialColor.white
v.detailLabel!.font = RobotoFont.regularWithSize(14)
v.detailLabel!.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little code to use effectively."

// Add to UIViewController.
view.addSubview(v)
v.translatesAutoresizingMaskIntoConstraints = false
MaterialLayout.alignToParentHorizontallyWithInsets(view, child: v, left: 20, right: 20)
MaterialLayout.alignFromTop(view, child: v, top: 100)
```
`
### Easy MaterialAnimation

Animations are a wonderful way to add life to your application. MaterialAnimation is a lightweight API for constructing complex animations. Below is an example of an animation.

![MaterialKitPreview][image-9]

```swift
`let v: MaterialPulseView = MaterialPulseView(frame: CGRectMake(50, 50, 200, 200))
v.shape = .Circle
v.shadowDepth = .Depth2
v.borderWidth = .Border1
v.backgroundColor = MaterialColor.blue.accent3

// Add to UIViewController.
view.addSubview(v)

// Play a group of animations.
v.animation(MaterialAnimation.animationGroup([
MaterialAnimation.rotation(3),
MaterialAnimation.position(CGPointMake(225, 400)),
MaterialAnimation.cornerRadius(30),
MaterialAnimation.backgroundColor(MaterialColor.red.darken1)
], duration: 1))
```
`### License

[AGPLv3][2]

### Contributors

* [Daniel Dahan][3]
* [Adam Dahan][4]
* [Michael Reyder][5]

[1]:	https://cocoapods.org/?q=MK
[2]:	http://choosealicense.com/licenses/agpl-3.0/
[3]:	https://github.com/danieldahan
[4]:	https://github.com/adamdahan
[5]:	https://github.com/michaelReyder

[image-1]:	http://www.materialkit.io/github/img1.png
[image-2]:	http://www.materialkit.io/github/img2.gif
[image-3]:	http://www.materialkit.io/github/img3.gif
[image-4]:	http://www.materialkit.io/github/img4.gif
[image-5]:	http://www.materialkit.io/github/img5.gif
[image-6]:	http://www.materialkit.io/github/img6.gif
[image-7]:	http://www.materialkit.io/github/img7.gif
[image-8]:	http://www.materialkit.io/github/img8.gif
[image-9]:	http://www.materialkit.io/github/img9.gif