![MaterialKit](http://materialkit.io/MaterialKitLogo.png)

# Build Beautiful Software

* [CocoaPods (MK)](https://cocoapods.org/?q=MK)

### CocoaPods Support
MaterialKit is now on CocoaPods under the name [MK](https://cocoapods.org/?q=MK).


### Basic Card

Easily make cards with fully customizable components.

![MaterialKitPreview](http://sandbox.local:3000/basiccardpreview.gif)

```swift
var card: BasicCard = BasicCard()

// add a title
card.titleLabel = UILabel()
card.titleLabel!.text = "Card Title"

// add a body of text
card.detailTextLabel = UILabel()
card.detailTextLabel!.text = "I am a very simple card. I am good at containing small bits of information. I am convenient because I require little markup to use effectively."

// add a divider for buttons
card.divider = UIView()

// add a couple buttons
var cancelButton: FlatButton = FlatButton()
cancelButton.pulseColor = MaterialTheme.blueGrey.darken3
cancelButton.setTitle("Cancel", forState: .Normal)
cancelButton.setTitleColor(MaterialTheme.yellow.darken3, forState: .Normal)

var okButton: FlatButton = FlatButton()
okButton.pulseColor = MaterialTheme.blueGrey.darken3
okButton.setTitle("Okay", forState: .Normal)
okButton.setTitleColor(MaterialTheme.yellow.darken3, forState: .Normal)

card.buttons = [cancelButton, okButton]

view.addSubview(card)
```

### Flat Button

```swift
var button: FlatButton = FlatButton()
```

### Raised Button

```swift
var button: RaisedButton = RaisedButton()
```

### Side Navigation Controller

```swift
class AppDelegate: UIResponder, UIApplicationDelegate, SideNavDelegate {
	var window: UIWindow?
	var sideNav: SideNavController?
	private lazy var graph: Graph = Graph()


	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		sideNav = SideNavController(mainViewController: MainViewController(), leftViewController: LeftViewController(), rightViewController: RightViewController())
		sideNav!.delegate = self
		window = UIWindow(frame: UIScreen.mainScreen().bounds)
		window!.rootViewController = sideNav
		window!.makeKeyAndVisible()
		return true
	}
...
```

### License


[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)


### Contributors


* [Daniel Dahan](https://github.com/danieldahan)
* [Adam Dahan](https://github.com/adamdahan)
