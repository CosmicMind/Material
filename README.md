# MaterialKit

### Build Beautiful Software

* [CocoaPods (MK)](https://cocoapods.org/?q=MK)

### CocoaPods Support

MaterialKit is on CocoaPods under the name [MK](https://cocoapods.org/?q=MK).

### A Basic MaterialView

To get started, we will introduce MaterialView, a lightweight UIView Object that has flexibility in mind. Common controls have been added to make things easier. For example, let's make a circle view that has a shadow, border, and image.

![MaterialKitPreview](http://www.materialkit.io/github/img1.png)

```swift
let view1: MaterialView = MaterialView(frame: CGRectMake(0, 0, 100, 100))
view1.shape = .Circle
view1.shadowDepth = .Depth2
view1.borderWidth = .Border1
view1.image = UIImage(named: "swift")
```

### License

[AGPLv3](http://choosealicense.com/licenses/agpl-3.0/)

### Contributors

* [Daniel Dahan](https://github.com/danieldahan)
* [Adam Dahan](https://github.com/adamdahan)
* [Michael Reyder](https://github.com/mishaGK)
