# MaterialKit

### CocoaPods Support

MaterialKit is on CocoaPods under the name [MK](https://cocoapods.org/?q=MK).

### Basic MaterialView

To get started, let's introduce MaterialView, a lightweight UIView Object that has flexibility in mind. Common controls have been added to make things easier. For example, let's make a circle view that has a shadow, border, and image.

![MKPreview](http://www.materialkit.io/github/vid1.gif)

```swift
let v: MaterialView = MaterialView(frame: CGRectMake(107, 107, 200, 200))
v.shape = .Circle
v.shadowDepth = .Depth3
v.borderWidth = .Border4
v.borderColor = MaterialColor.blue.accent4
v.image = UIImage(named: "img2")

// Add to UIViewController.
view.addSubview(v)
```

### Animated MaterialPulseView

Let's expand on the basic MaterialView and use an animated MaterialPulseView. In this example, we will make the shape a square with some rounded corners.

![MKPreview](http://www.materialkit.io/github/vid2.gif)

```swift
let v: MaterialPulseView = MaterialPulseView(frame: CGRectMake(107, 107, 200, 200))
v.shape = .Square
v.shadowDepth = .Depth3
v.cornerRadius = .Radius3
v.image = UIImage(named: "img2")

// Add to UIViewController.
view.addSubview(v)
```

### Simple FlatButton

A FlatButton is the best place to start when introducing MaterialKit buttons. It is simple, clean, and very effective. Below is an example of a FlatButton in action.

![MKPreview](http://www.materialkit.io/github/vid3.gif)

```swift
let v: FlatButton = FlatButton(frame: CGRectMake(107, 107, 200, 200))
v.setTitle("Flat", forState: .Normal)
v.titleLabel!.font = RobotoFont.mediumWithSize(32)

// Add to UIViewController.
view.addSubview(v)
```

### Noticeable RaisedButton

A RaisedButton is sure to get attention. Take a look at the following code sample.

![MKPreview](http://www.materialkit.io/github/vid4.gif)

```swift
let v: RaisedButton = RaisedButton(frame: CGRectMake(107, 107, 200, 200))
v.setTitle("Raised", forState: .Normal)
v.titleLabel!.font = RobotoFont.mediumWithSize(32)

// Add to UIViewController.
view.addSubview(v)
```

### Actionable FabButton

A FabButton is essential to Material Design's overall look. I leave this example as simple as possible to showcase its beauty.

![MKPreview](http://www.materialkit.io/github/vid5.gif)

```swift
let v: FabButton = FabButton(frame: CGRectMake(175, 175, 64, 64))
v.setImage(UIImage(named: "ic_create_white"), forState: .Normal)
v.setImage(UIImage(named: "ic_create_white"), forState: .Highlighted)

// Add to UIViewController.
view.addSubview(v)
```

### Sleek NavigationBarView

A NavigationBarView is a very common UI element and the more presentable it is, the better. The following example shows how to setup a NavigationBarView on the fly.

![MKPreview](http://www.materialkit.io/github/vid6.gif)

```swift
let v: NavigationBarView = NavigationBarView(titleLabel: MaterialLabel())!
v.backgroundColor = MaterialColor.blue.accent3
v.statusBarStyle = .LightContent

v.titleLabel!.text = "Title"
v.titleLabel!.textAlignment = .Center
v.titleLabel!.textColor = MaterialColor.white
v.titleLabel!.font = RobotoFont.regularWithSize(20)
v.titleLabelInsetsRef = (top: 12, left: 0, bottom: 0, right: 0)

v.detailLabel = MaterialLabel()
v.detailLabel!.text = "Detail Text"
v.detailLabel!.textAlignment = .Center
v.detailLabel!.textColor = MaterialColor.white
v.detailLabel!.font = RobotoFont.regularWithSize(12)

// left buttons
let b1: FlatButton = FlatButton()
b1.pulseScale = false
b1.pulseFill = true
b1.pulseColor = MaterialColor.white
b1.setImage(UIImage(named: "ic_menu_white"), forState: .Normal)
b1.setImage(UIImage(named: "ic_menu_white"), forState: .Highlighted)

v.leftButtons = [b1]

// right buttons
let b2: FlatButton = FlatButton()
b2.pulseScale = false
b2.pulseFill = true
b2.pulseColor = MaterialColor.white
b2.setImage(UIImage(named: "ic_check_circle_white"), forState: .Normal)
b2.setImage(UIImage(named: "ic_check_circle_white"), forState: .Highlighted)

let b3: FlatButton = FlatButton()
b3.pulseScale = false
b3.pulseFill = true
b3.pulseColor = MaterialColor.white
b3.setImage(UIImage(named:  "ic_stars_white"), forState: .Normal)
b3.setImage(UIImage(named:  "ic_stars_white"), forState: .Highlighted)

v.rightButtons = [b2, b3]

// Add to UIViewController.
view.addSubview(v)
```

### Flexible BasicCardView

A BasicCardView is super flexible with all its options - including a title, detail, left buttons, and right buttons. Below is an example of a simple setup.

![MKPreview](http://www.materialkit.io/github/vid7.gif)

```swift
let v: BasicCardView = BasicCardView(titleLabel: UILabel(), detailLabel: UILabel())!
v.backgroundColor = MaterialColor.blueGrey.darken1
v.dividerColor = MaterialColor.blueGrey.base

v.titleLabel!.textColor = MaterialColor.white
v.titleLabel!.font = RobotoFont.regularWithSize(24)
v.titleLabel!.text = "Card Title"

v.detailLabel!.textColor = MaterialColor.white
v.detailLabel!.lineBreakMode = .ByWordWrapping
v.detailLabel!.numberOfLines = 0
v.detailLabel!.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little code to use effectively."

let b1: FlatButton = FlatButton()
b1.setTitle("Btn 1", forState: .Normal)
b1.setTitleColor(MaterialColor.amber.darken1, forState: .Normal)
b1.setTitleColor(MaterialColor.amber.lighten1, forState: .Highlighted)
b1.pulseColor = MaterialColor.white

let b2: FlatButton = FlatButton()
b2.setTitle("Btn 2", forState: .Normal)
b2.setTitleColor(MaterialColor.amber.darken1, forState: .Normal)
b2.setTitleColor(MaterialColor.amber.lighten1, forState: .Highlighted)
b2.pulseColor = MaterialColor.white

v.leftButtons = [b1, b2]

let b3: FlatButton = FlatButton()
b3.setTitle("Btn 3", forState: .Normal)
b3.setTitleColor(MaterialColor.amber.darken1, forState: .Normal)
b3.setTitleColor(MaterialColor.amber.lighten1, forState: .Highlighted)
b3.pulseColor = MaterialColor.white

let b4: FlatButton = FlatButton()
b4.setTitle("Btn 4", forState: .Normal)
b4.setTitleColor(MaterialColor.amber.darken1, forState: .Normal)
b4.setTitleColor(MaterialColor.amber.lighten1, forState: .Highlighted)
b4.pulseColor = MaterialColor.white

v.rightButtons = [b3, b4]

// Add to UIViewController.
view.addSubview(v)
v.translatesAutoresizingMaskIntoConstraints = false
MaterialLayout.alignToParentHorizontallyWithInsets(view, child: v, left: 20, right: 20)
MaterialLayout.alignFromTop(view, child: v, top: 100)
```

A BasicCardView can easily add an image as its background, below is the code that shows how to do this.

![MKPreview](http://www.materialkit.io/github/vid8.gif)

```swift
let v: BasicCardView = BasicCardView(image: UIImage(named: "img2"), titleLabel: MaterialLabel(), detailLabel: MaterialLabel())!
v.spotlight = true
v.divider = false

v.titleLabel!.textColor = MaterialColor.white
v.titleLabel!.font = RobotoFont.regularWithSize(24)
v.titleLabel!.text = "Card Title"

v.detailLabel!.textColor = MaterialColor.white
v.detailLabel!.lineBreakMode = .ByWordWrapping
v.detailLabel!.numberOfLines = 0
v.detailLabel!.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little code to use effectively."

let b1: FlatButton = FlatButton()
b1.setImage(UIImage(named:  "ic_star_white"), forState: .Normal)
b1.setImage(UIImage(named:  "ic_star_white"), forState: .Highlighted)
b1.pulseColor = MaterialColor.white

v.rightButtons = [b1]

// Add to UIViewController
view.addSubview(v)
v.translatesAutoresizingMaskIntoConstraints = false
MaterialLayout.alignToParentHorizontallyWithInsets(view, child: v, left: 20, right: 20)
MaterialLayout.alignFromTop(view, child: v, top: 100)
```

### Wonderful ImageCardView

An ImageCardView is a great way to enclose many components into a single and presentable layout. Below is an example of setting one up.

![MKPreview](http://www.materialkit.io/github/vid9.gif)

```swift
let v: ImageCardView = ImageCardView(image: UIImage(named: "img2"))!
v.pulseColor = MaterialColor.blueGrey.lighten4
v.pulseFill = true

v.titleLabel = MaterialLabel()
v.titleLabel!.textColor = MaterialColor.white
v.titleLabel!.font = RobotoFont.regularWithSize(24)
v.titleLabel!.text = "Card Title"

v.detailLabel = MaterialLabel()
v.detailLabel!.lineBreakMode = .ByWordWrapping
v.detailLabel!.numberOfLines = 0
v.detailLabel!.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little code to use effectively."

let b1: FlatButton = FlatButton()
b1.setTitle("Btn 1", forState: .Normal)

let b2: FlatButton = FlatButton()
b2.setTitle("Btn 2", forState: .Normal)

v.leftButtons = [b1, b2]

let b3: FlatButton = FlatButton()
b3.setImage(UIImage(named:  "ic_star_blue_grey"), forState: .Normal)
b3.setImage(UIImage(named:  "ic_star_blue_grey"), forState: .Highlighted)
b3.pulseColor = MaterialColor.blueGrey.darken4

v.rightButtons = [b3]

// Add to UIViewController.
view.addSubview(v)
v.translatesAutoresizingMaskIntoConstraints = false
MaterialLayout.alignToParentHorizontallyWithInsets(view, child: v, left: 20, right: 20)
MaterialLayout.alignFromTop(view, child: v, top: 100)
```

### Easy MaterialAnimation

Animations are a wonderful way to add life to your application. MaterialAnimation is a lightweight API for constructing complex animations. Below is an example of an animation.

![MKPreview](http://www.materialkit.io/github/vid10.gif)

```swift
let v: MaterialPulseView = MaterialPulseView(frame: CGRectMake(107, 107, 200, 200))
v.spotlight = true
v.shape = .Circle
v.shadowDepth = .Depth3
v.borderWidth = .Border5
v.borderColor = MaterialColor.blue.accent4
v.backgroundColor = MaterialColor.amber.base

// Add to UIViewController.
view.addSubview(v)

// Play animation group.
v.animation(MaterialAnimation.animationGroup([
	MaterialAnimation.rotation(3),
	MaterialAnimation.position(CGPointMake(207, 400)),
	MaterialAnimation.cornerRadius(30),
	MaterialAnimation.backgroundColor(MaterialColor.red.darken1)
], duration: 1))
```

### License

[AGPL-3.0](http://choosealicense.com/licenses/agpl-3.0/)
