# Ken Burns
<p align="center">
 <img width="100px" src="https://res.cloudinary.com/anuraghazra/image/upload/v1594908242/logo_ccswme.svg" align="center" alt="GitHub Readme Stats" />
 <h2 align="center">GitHub Readme Stats</h2>
 <p align="center">Get dynamically generated GitHub stats on your readmes!</p>
</p>
<p align="center">
  <img src="https://img.shields.io/badge/Supported%20by-Xcode%20Power%20User%20%E2%86%92-gray.svg?colorA=655BE1&colorB=4F44D6&style=for-the-badge"/>
</p>

![burns](KenBurns.gif)

A simple yet configurable Ken Burns effect using a single image looping over itself. Really draws the user’s attention, much more so than a static image.

## Usage

`KenBurns` is written in Swift, but you can use `KenBurnsImageView` from Swift or Objective-C.  Examples are in Swift 3.0:

```swift
func newKenBurnsImageView(url: URL) -> KenBurnsImageView {
    let ken = KenBurnsImageView()
    ken.fetchImage(url: url, placeholder: UIImage(named: "placeholder"))
    ken.startAnimating()
    return ken
}

func stop(ken: KenBurnsImageView) {
    ken.stopAnimating()
}

func pause(ken: KenBurnsImageView) {
    ken.pause()
}

func resume(ken: KenBurnsImageView) {
    ken.resume()
}
```

You can also initialize with a direct `UIImage` rather than a URL, and there are some paramaters you can set to configure the appearance:

```swift
func newKenBurnsImageView(image: UIImage) -> KenBurnsImageView {
    let ken = KenBurnsImageView()
    ken.setImage(image: image)
    ken.zoomIntensity = 1.5
    ken.setDuration(min: 5, max: 13)
    ken.startAnimating()
    return ken
}
```

Due to unfortunate circumstances, Calm has no direct affiliation with [Ken Burns](https://en.wikipedia.org/wiki/Ken_Burns) himself 😞

## 🌱 Technologies and Frameworks
<p>
    <!-- Swift -->
    <img src="https://img.shields.io/badge/Swift-fa7343?flat=plastic&logo=swift&logoColor=white" height="32" alt="Swift" />
    &nbsp;
    <!-- CocoaPods -->
    <img src="https://img.shields.io/badge/CocoaPods-ee3322?flat=plastic&logo=cocoapods&logoColor=white" height="32" alt="CocoaPods" />
    &nbsp;
    <!-- Xcode -->
    <img src="https://img.shields.io/badge/Xcode-147efb?flat=plastic&logo=xcode&logoColor=white" height="32" alt="Xcode" />
    &nbsp;
</p>
