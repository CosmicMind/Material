![MaterialKit](http://www.materialkit.io/MK/MaterialKit.png)

# Welcome to MaterialKit

MaterialKit is built as an animation and graphics framework. A major goal in the design of MaterialKit is to allow the creativity of others to easily be expressed. The following README is written to get you started, and is by no means a complete tutorial on all that is possible. Examples may be found in the Examples directory that go beyond the README documentation.

### CocoaPods Support

MaterialKit is on CocoaPods under the name [MK](https://cocoapods.org/?q=MK).

### MaterialLayer

MaterialLayer is a lightweight CAShapeLayer used throughout MaterialKit. It is designed to easily take shape, depth, and animations. Below is an example demonstrating the ease of adding shape and depth to MaterialLayer.

![MaterialKitMaterialLayer](http://www.materialkit.io/MK/MaterialKitMaterialLayer.gif)

```swift
let materialLayer: MaterialLayer = MaterialLayer(frame: CGRectMake(132, 132, 150, 150))
materialLayer.shape = .Circle
materialLayer.shadowDepth = .Depth2
materialLayer.image = UIImage(named: "BluePattern")
```

### MaterialView

MaterialView is the base UIView class used throughout MaterialKit. Like MaterialLayer, it is designed to easily take shape, depth, and animations. The major difference is that MaterialView has all the added features of the UIView class.

### MaterialPulseView

MaterialPulseView is

### NavigationBarView

One of Material Design's greatest additions to UI is the NavigationBarView. In the Examples folder, you can checkout some code to get you started with this wonderful component.

![MaterialKitNavigationBarView](http://www.materialkit.io/MK/MaterialKitNavigationBarView.gif)

### CardView

Right out of the box to a fully customized configuration, CardView always stands out. Take a look at a few examples in action and find more in the Examples directory.

![MaterialKitCardView](http://www.materialkit.io/MK/MaterialKitCardView.gif)

Easily remove the pulse animation and add a background image for an entirely new feel.

![MaterialKitCardViewFavorite](http://www.materialkit.io/MK/MaterialKitCardViewFavorite.gif)

Adjust the alignment of the UI elements to create different configurations of the CardView.

![MaterialKitCardViewDataDriven](http://www.materialkit.io/MK/MaterialKitCardViewDataDriven.gif)

CardViews are so flexible they create entirely new components by removing all but certain elements. For example, bellow is a button bar by only setting the button values of the CardView.

![MaterialKitCardViewButtonBar](http://www.materialkit.io/MK/MaterialKitCardViewButtonBar.gif)

### ImageCardView

Bold and attractive, ImageCardView is the next step from a CardView. In the Examples folder you will find examples using the ImageCardView. Below are some animations to give you an idea of the possibilities the ImageCardView has to offer.

![MaterialKitImageCardView](http://www.materialkit.io/MK/MaterialKitImageCardView.gif)

Remove elements, such as the details to create a fresh look for your images.

![MaterialKitImageCardViewBackgroundImage](http://www.materialkit.io/MK/MaterialKitImageCardViewBackgroundImage.gif)

### FlatButton

A FlatButton is the best place to start when introducing MaterialKit buttons. It is simple, clean, and very effective. Below is an example of a FlatButton in action.

![MaterialKitFlatButton](http://www.materialkit.io/MK/MaterialKitFlatButton.gif)

### RaisedButton

A RaisedButton is sure to get attention. Take a look at the following animation example.

![MaterialKitRaisedButton](http://www.materialkit.io/MK/MaterialKitRaisedButton.gif)

### FabButton

A FabButton is essential to Material Design's overall look. Below showcases its beauty.

![MaterialKitFabButton](http://www.materialkit.io/MK/MaterialKitFabButton.gif)

### License

[AGPL-3.0](http://choosealicense.com/licenses/agpl-3.0/)
