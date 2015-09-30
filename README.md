# MaterialKit

### CocoaPods Support

MaterialKit is on CocoaPods under the name [MK](https://cocoapods.org/?q=MK).

### Basic MaterialView

To get started, let's introduce MaterialView, a lightweight UIView Object that has flexibility in mind. Common controls have been added to make things easier. For example, let's make a circle view that has a shadow, border, and image.

![MaterialKitPreview](http://www.materialkit.io/github/img1.png)

```swift
let v: MaterialView = MaterialView(frame: CGRectMake(100, 100, 200, 200))
v.shape = .Circle
v.shadowDepth = .Depth2
v.borderWidth = .Border1
v.image = UIImage(named: "focus")

// Add to UIViewController
view.addSubview(v)
```

### Animated MaterialPulseView

Let's expand on the basic MaterialView and use an animated MaterialPulseView. In this example, we will make the shape a square with some rounded corners.

![MaterialKitPreview](http://www.materialkit.io/github/img2.gif)

```swift
let v: MaterialPulseView = MaterialPulseView(frame: CGRectMake(100, 100, 200, 200))
v.shape = .Square
v.cornerRadius = .Radius2
v.shadowDepth = .Depth2
v.image = UIImage(named: "focus")

// Add to UIViewController
view.addSubview(v)
```

### Simple FlatButton

A FlatButton is the best place to start when introducing MaterialKit buttons. It is simple, clean, and very effective. Below is an example of a FlatButton in action.

![MaterialKitPreview](http://www.materialkit.io/github/img3.gif)

```swift
let v: FlatButton = FlatButton(frame: CGRectMake(100, 100, 200, 64))
v.setTitle("Flat", forState: .Normal)
v.titleLabel!.font = RobotoFont.mediumWithSize(32)

// Add to UIViewController
view.addSubview(v)
```

### Noticeable RaisedButton

A RaisedButton is sure to get attention. Take a look at the following code sample.

![MaterialKitPreview](http://www.materialkit.io/github/img4.gif)

```swift
let v: RaisedButton = RaisedButton(frame: CGRectMake(100, 100, 200, 64))
v.setTitle("Raised", forState: .Normal)
v.titleLabel!.font = RobotoFont.mediumWithSize(32)

// Add to UIViewController
view.addSubview(v)
```

### Actionable FabButton

A FabButton is essential to Material Design's overall look. I leave this example as simple as possible to showcase its beauty.

![MaterialKitPreview](http://www.materialkit.io/github/img5.gif)

```swift
let v: FabButton = FabButton(frame: CGRectMake(100, 100, 64, 64))
v.setImage(UIImage(named: "ic_create_white"), forState: .Normal)
v.setImage(UIImage(named: "ic_create_white"), forState: .Highlighted)

// Add to UIViewController
view.addSubview(v)
```

### Sleek NavigationBarView

A NavigationBarView is a very common UI element and the more presentable it is, the better. The following example shows how to setup a NavigationBarView on the fly.

![MaterialKitPreview](http://www.materialkit.io/github/img6.gif)

```swift
let v: NavigationBarView = NavigationBarView(titleLabel: MaterialLabel())!
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

// Add to UIViewController
view.addSubview(v)
```

### Flexible BasicCardView

A BasicCardView is super flexible with all its options - including a title, detail, left buttons, and right buttons. Below is an example of a simple setup.

![MaterialKitPreview](http://www.materialkit.io/github/img7.gif)

```swift
let v: BasicCardView = BasicCardView(titleLabel: UILabel(), detailLabel: UILabel())!
v.backgroundColor = MaterialColor.blueGrey.darken1
v.dividerColor = MaterialColor.blueGrey.base

v.titleLabel!.lineBreakMode = .ByWordWrapping
v.titleLabel!.numberOfLines = 0
v.titleLabel!.textColor = MaterialColor.white
v.titleLabel!.font = RobotoFont.regularWithSize(18)
v.titleLabel!.text = "Card Title"

v.detailLabel!.lineBreakMode = .ByWordWrapping
v.detailLabel!.numberOfLines = 0
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

// Add to UIViewController
view.addSubview(v)
v.translatesAutoresizingMaskIntoConstraints = false
MaterialLayout.alignToParentHorizontallyWithInsets(view, child: v, left: 20, right: 20)
MaterialLayout.alignFromTop(view, child: v, top: 100)
```


A BasicCardView can easily add an image as its background, below is the code that shows how to do this.

![MaterialKitPreview](http://www.materialkit.io/github/img8.gif)

```swift
let v: BasicCardView = BasicCardView(titleLabel: UILabel(), detailLabel: UILabel())!

v.image = UIImage(named: "forest")

v.titleLabel!.lineBreakMode = .ByWordWrapping
v.titleLabel!.numberOfLines = 0
v.titleLabel!.textColor = MaterialColor.white
v.titleLabel!.font = RobotoFont.regularWithSize(18)
v.titleLabel!.text = "Card Title"

v.detailLabel!.lineBreakMode = .ByWordWrapping
v.detailLabel!.numberOfLines = 0
v.detailLabel!.textColor = MaterialColor.white
v.detailLabel!.font = RobotoFont.regularWithSize(14)
v.detailLabel!.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little code to use effectively."

// Add to UIViewController
view.addSubview(v)
v.translatesAutoresizingMaskIntoConstraints = false
MaterialLayout.alignToParentHorizontallyWithInsets(view, child: v, left: 20, right: 20)
MaterialLayout.alignFromTop(view, child: v, top: 100)
```

### License

[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)

### Contributors

* [Daniel Dahan](https://github.com/danieldahan)
* [Adam Dahan](https://github.com/adamdahan)
* [Michael Reyder](https://github.com/mishaGK)
