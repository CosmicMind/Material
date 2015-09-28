# MaterialKit

### CocoaPods Support

MaterialKit is on CocoaPods under the name [MK](https://cocoapods.org/?q=MK).

### Basic MaterialView

To get started, we will introduce MaterialView, a lightweight UIView Object that has flexibility in mind. Common controls have been added to make things easier. For example, let's make a circle view that has a shadow, border, and image.

![MaterialKitPreview](http://www.materialkit.io/github/img1.png)

```swift
let v: MaterialView = MaterialView(frame: CGRectMake(0, 0, 100, 100))
v.shape = .Circle
v.shadowDepth = .Depth2
v.borderWidth = .Border1
v.image = UIImage(named: "swift")
```

### Animated MaterialPulseView

Let's expand on the basic MaterialView and use an animated MaterialPulseView. In this example, we will make the shape a square with some rounded corners, and change the color of the border.

![MaterialKitPreview](http://www.materialkit.io/github/img2.gif)

```swift
let v: MaterialPulseView = MaterialPulseView(frame: CGRectMake(0, 0, 100, 100))
v.shape = .Square
v.shadowDepth = .Depth2
v.borderWidth = .Border3
v.borderColor = MaterialColor.red.darken1
v.cornerRadius = .Radius1
v.image = UIImage(named: "swift")
```

### License

[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)

### Contributors

* [Daniel Dahan](https://github.com/danieldahan)
* [Adam Dahan](https://github.com/adamdahan)
* [Michael Reyder](https://github.com/mishaGK)
