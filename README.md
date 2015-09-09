# MaterialKit

### Build Beautiful Software

* [CocoaPods (MK)](https://cocoapods.org/?q=MK)

### CocoaPods Support
MaterialKit is now on CocoaPods under the name [MK](https://cocoapods.org/?q=MK).

### Floating Action Button

Make a call to action with a Floating Action Button.


![MaterialKitPreview](http://www.materialkit.io/fabbuttonpreview.gif)


```swift
var button: FabButton = FabButton()
button.setTitle("+", forState: .Normal)
button.titleLabel!.font = Roboto.lightWithSize(16)

// layout
view.addSubview(button)
Layout.size(view, child: button, width: 60, height: 60)
```

### Raised Button

Use a Raised Button to capture attention.


![MaterialKitPreview](http://www.materialkit.io/raisedbuttonpreview.gif)


```swift
var button: RaisedButton = RaisedButton()
button.setTitle("Raised", forState: .Normal)

// layout
view.addSubview(button)
Layout.size(view, child: button, width: 200, height: 60)
```

### Flat Button

Keep it simple and elegant with a Flat Button.


![MaterialKitPreview](http://www.materialkit.io/flatbuttonpreview.gif)


```swift
var button: FlatButton = FlatButton()
button.setTitle("Flat", forState: .Normal)

// layout
view.addSubview(button)
Layout.size(view, child: button, width: 200, height: 60)
```

### Basic Card

Easily make cards with fully customizable components.


![MaterialKitPreview](http://www.materialkit.io/basiccardpreview.gif)


```swift
var card: BasicCardView = BasicCardView()

// title
card.titleLabel = UILabel()
card.titleLabel!.text = "Card Title"

// details
card.detailLabel = UILabel()
card.detailLabel!.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little markup to use effectively."

// divider
card.divider = UIView()

// buttons
var cancelButton: FlatButton = FlatButton()
cancelButton.pulseColor = MaterialTheme.blueGrey.darken3
cancelButton.setTitle("Cancel", forState: .Normal)
cancelButton.setTitleColor(MaterialTheme.yellow.darken3, forState: .Normal)

var okButton: FlatButton = FlatButton()
okButton.pulseColor = MaterialTheme.blueGrey.darken3
okButton.setTitle("Okay", forState: .Normal)
okButton.setTitleColor(MaterialTheme.yellow.darken3, forState: .Normal)

card.leftButtons = [cancelButton, okButton]

// layout
view.addSubview(card)
view.addConstraints(Layout.constraint("H:|-(pad)-[child]-(pad)-|", options: nil, metrics: ["pad": 20], views: ["child": card]))
view.addConstraints(Layout.constraint("V:|-(pad)-[child]", options: nil, metrics: ["pad": 100], views: ["child": card]))
```

### Image Card

Add photos with an Image Card.


![MaterialKitPreview](http://www.materialkit.io/imagecardpreview.gif)


```swift
var card: ImageCardView = ImageCardView()
card.imageView = UIImageView(image: UIImage(named: "photo.jpg"))

// layout
view.addSubview(card)
view.addConstraints(Layout.constraint("H:|-(pad)-[child]-(pad)-|", options: nil, metrics: ["pad": 20], views: ["child": card]))
view.addConstraints(Layout.constraint("V:|-(pad)-[child]", options: nil, metrics: ["pad": 100], views: ["child": card]))
```

### Full Image Card

Allow the Image Card to really shine by adding a title, some details, and buttons.


![MaterialKitPreview](http://www.materialkit.io/imagecardfullpreview.gif)


```swift
var card: ImageCardView = ImageCardView()
card.imageView = UIImageView(image: UIImage(named: "photo.jpg"))

// title
card.titleLabel = UILabel()
card.titleLabel!.text = "Card Title"

// details
card.detailLabel = UILabel()
card.detailLabel!.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little markup to use effectively."

// divider
card.divider = UIView()

// buttons
var cancelButton: FlatButton = FlatButton()
cancelButton.pulseColor = MaterialTheme.blueGrey.darken3
cancelButton.setTitle("Cancel", forState: .Normal)
cancelButton.setTitleColor(MaterialTheme.yellow.darken3, forState: .Normal)

var okButton: FlatButton = FlatButton()
okButton.pulseColor = MaterialTheme.blueGrey.darken3
okButton.setTitle("Okay", forState: .Normal)
okButton.setTitleColor(MaterialTheme.yellow.darken3, forState: .Normal)

card.leftButtons = [cancelButton, okButton]

// layout
view.addSubview(card)
view.addConstraints(Layout.constraint("H:|-(pad)-[child]-(pad)-|", options: nil, metrics: ["pad": 20], views: ["child": card]))
view.addConstraints(Layout.constraint("V:|-(pad)-[child]", options: nil, metrics: ["pad": 100], views: ["child": card]))
```

### Side Navigation

Add a sleek Side Navigation to give your users a wonderful experience.


![MaterialKitPreview](http://www.materialkit.io/sidenavpreview.gif)


```swift
func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
	sideNav = SideNavigationViewController(mainViewController: MainViewController(), leftViewController: LeftViewController(), rightViewController: RightViewController())
	sideNav!.delegate = self
	window = UIWindow(frame: UIScreen.mainScreen().bounds)
	window!.rootViewController = sideNav
	window!.makeKeyAndVisible()
	return true
}
```

### Material Themes

Beautify your app with color. All Material Design color palettes are supported.

[Color Palettes](http://www.google.com/design/spec/style/color.html)

```swift
var button: RaisedButton = RaisedButton()
button.setTitle("Raised", forState: .Normal)
button.setTitleColor(MaterialTheme.blue.darken3, forState: .Normal)
button.backgroundColor = MaterialTheme.yellow.darken3
button.pulseColor = MaterialTheme.blueGrey.color
```

### License


[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)


### Contributors


* [Daniel Dahan](https://github.com/danieldahan)
* [Adam Dahan](https://github.com/adamdahan)
* [Michael Reyder](https://github.com/mishaGK)
