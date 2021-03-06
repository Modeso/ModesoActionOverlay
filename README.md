# ModesoActionOverlay
<p align="center">
  <img src="https://media.licdn.com/mpr/mpr/shrink_200_200/AAEAAQAAAAAAAAZsAAAAJDM2NTU0MDA1LTA3YmEtNGUyMC05YmZjLTIxMDNlZWZlM2ZkMQ.png">
</p>

[![Build Status](https://img.shields.io/travis/rust-lang/rust.svg)](https://img.shields.io/travis/rust-lang/rust.svg)
[![CocoaPods Compatible](https://img.shields.io/badge/Pod-compatible-4BC51D.svg
)](https://cocoapods.org
)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/badge/Platform-iOS-d3d3d3.svg)]()
[![Twitter](https://img.shields.io/badge/twitter-@modeso_ch-0B0032.svg?style=flat)](http://twitter.com/AlamofireSF)

ModesoActionOverlay is a "more options" button library written in Swift. It opens an overlay view with dynamic number of action buttons (1 to 5 buttons) with transition animation depending on [Anton Aheichanka](https://dribbble.com/madebyanton)'s [design](https://dribbble.com/shots/1977070-Profile-Screen-Animation).

![](https://github.com/Modeso/ModesoActionOverlay/blob/master/ModesoActionOverlay_1.gif)

![](https://github.com/Modeso/ModesoActionOverlay/blob/master/ModesoActionOverlay_2.gif)
![](https://github.com/Modeso/ModesoActionOverlay/blob/master/ModesoActionOverlay_3.gif)

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
- [Communication](#communication)
- [Credits](#credits)
- [License](#license)

## Requirements

- iOS 8.0+
- Xcode 8.1+
- Swift 3.0+


## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

To integrate ModesoActionOverlay into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'ModesoActionOverlay', :git => 'https://github.com/Modeso/ModesoActionOverlay.git'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ModesoActionOverlay into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Modeso/ModesoActionOverlay" "master"
```

Run `carthage update --platform iOS` to build the framework and drag the built `ModesoActionOverlay.framework` into your Xcode project.

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate ModesoActionOverlay into your project manually.
> Simply download zip folder and unarchieve it, drag the directory `Sources/` into your project navigation and that's it.
---

## Usage

### Xib file

<img src="https://github.com/Modeso/ModesoActionOverlay/blob/master/Xib.png" alt="Xib">

- Add your action button.
- Change the class of the added button to `ActionButton`
- Set target view via outlet `targetView` 

### Code

In your `ViewController.swift` class import `ModesoActionOverlay`
```swift
import ModesoActionOverlay
```
Add an outlet of your added button in your `ViewController.swift` class
```swift
@IBOutlet weak var actionButton: ActionButton!
```
Define a new OverlayTransition instance.
```swift
var overlayTransition: OverlayTransition!
```
Assign it in `viewDidLoad` method
```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        transition = ModesoOverlayTransition()
    }
```
Then, set necessary parameters for `actionButton`
```swift
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        actionButton.parentViewController = self
        actionButton.targetView = yourTargetView
        actionButton.overlayViewDelegate = self
        actionButton.overlayButtonsNumber = 3
        actionButton.overlayButtonsIds = [1, 2, 3]
        actionButton.overlayButtonsImages = ["camera-icon", "share-icon", "cloud-icon"]
        actionButton.closeButtonIcon = "delete-icon"
        actionButton.duration = 0.5
        actionButton.transition = transition
    }
```
> `parentViewController`: The view controller which contains your action button and responsible for presenting the modal view controller which contains the options buttons.<br>
> `targetView`: Your overlayed view.<br>
> `overlayViewDelegate`: OverlayViewDelegate handle showin action button after dismissing the modal view controller by calling **showActionButton()** method and handle actions of options buttons by calling **buttonClicked(id: Int)** method.<br>
> `overlayButtonsNumber`: The number of the options buttons inside the modal view controller **1 to 5 buttons**.<br>
> `overlayButtonsIds`: Array of integers represents the id of each button.<br>
> `overlayButtonsImages`: Array of strings represents buttons icons' names.<br>
> `duration`: Repesent the animation duration.<br>
> `transition`: ModesoOverlayTransition isntance which contains all transition methods 

Then, you can also handle UIViewControllerTransitioningDelegate methods
if needed.
```swift
//MARK:- UIViewControllerTransitioningDelegate methods
extension ViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return transition
    }
}
```
> `startingPoint`: The point which transition animation will start from.
> `overlayViewColor`: Color of the overlay view.

Finally, handle OverlayViewDelegate methods

```swift
//MARK:- OverlayViewDelegate methods
extension ViewController: OverlayViewDelegate {
    func showActionButton() {
        actionButton.showActionButton()
    }
    func buttonClicked(id: Int) {
        print("buttonID\(id)")
    }
}
```

## Communication

- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Credits

ModesoActionOverlay is owned and maintained by [Modeso](http://modeso.ch). You can follow them on Twitter at [@modeso_ch](https://twitter.com/modeso_ch) for project updates and releases.

## License

ModesoActionOverlay is released under the MIT license. See LICENSE for details.
