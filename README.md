[![Swift Version][swift-image]][swift-url]
[![codecov](https://codecov.io/github/KaungHtetWin/ny-times/graph/badge.svg?token=63Z33NUZ1A)](https://codecov.io/github/KaungHtetWin/ny-times)
![main](https://github.com/github/docs/actions/workflows/main.yml/badge.svg?branch=main)
# NYTimes
<br />
<p align="center">
  <p align="center">
    The most popular articles on NYTimes.com based on views.
  </p>
</p>

### Features

- [x] Home
    - User able to seet list the most popular articles (Most Viewed by Section & Time Period)
        User able to search for articles by a search term/text string.
- [x] Detail page
    - Show the article


### Technical Specification

The app is written and built with this following hardware and sofware specification

- XCode Version : Version 15.0 (15A240d)
- macOS Version: macOS Sonoma 14.0 (23A344)
- Swift Version: 5
- Minium iOS Version : 13.0

The app is written in UIKit and VIP Clean architecture.
Use **UICollectionViewCompositionalLayout** for data visualisation.

## Third-party libraries

### Kingfisher (https://github.com/onevcat/Kingfisher)
Used for downloading and caching images. In the app, it is used to show the images of the articles.

### Reference

https://clean-swift.com/

https://developer.nytimes.com/docs


[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
