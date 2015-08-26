![MaterialKit](http://materialkit.io/MaterialKitLogo.png)

# Build Beautiful Software

* [CocoaPods (MK)](https://cocoapods.org/?q=MK)

### CocoaPods Support
MaterialKit is now on CocoaPods under the name [MK](https://cocoapods.org/?q=MK).

### A Floating Action Button

```swift
var button: FabButton = FabButton()
```

### A Flat Button

```swift
var button: FlatButton = FlatButton()
```

### A Raised Button

```swift
var button: RaisedButton = RaisedButton()
```

### A Side Navigation Controller

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


[Daniel Dahan](https://github.com/danieldahan)
[Adam Dahan](https://github.com/adamdahan)
