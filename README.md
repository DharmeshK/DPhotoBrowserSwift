# DPhotoBrowserSwift

[![CI Status](https://img.shields.io/travis/DK/DPhotoBrowserSwift.svg?style=flat)](https://travis-ci.org/DK/DPhotoBrowserSwift)
[![Version](https://img.shields.io/cocoapods/v/DPhotoBrowserSwift.svg?style=flat)](https://cocoapods.org/pods/DPhotoBrowserSwift)
[![License](https://img.shields.io/cocoapods/l/DPhotoBrowserSwift.svg?style=flat)](https://cocoapods.org/pods/DPhotoBrowserSwift)
[![Platform](https://img.shields.io/cocoapods/p/DPhotoBrowserSwift.svg?style=flat)](https://cocoapods.org/pods/DPhotoBrowserSwift)

## Example

## A simple iOS photo and video browser with optional grid view, captions and selections.

This is a Swift port of the original Objective-C work of Michael Waterfall.
https://github.com/mwaterfall/MWPhotoBrowser

DPhotoBrowserSwift can display one or more images or videos by providing either `UIImage` objects, `PHAsset` objects, web images/videos or local files. The photo browser handles the downloading and caching of photos from the web seamlessly. Photos can be zoomed and panned, and optional (customisable) captions can be displayed.

The browser can also be used to allow the user to select one or more photos using either the grid or main image view.

Works on iOS 11+. All strings are localisable so they can be used in apps that support multiple languages.



## Usage

DPhotoBrowserSwift is designed to be presented within a navigation controller. Simply set the delegate (which must conform to `PhotoBrowserDelegate`) and implement the 2 required delegate methods to provide the photo browser with the data in the form of `DPhoto` objects. You can create an `DPhoto` object by providing a `UIImage` object, `PHAsset` object, or a URL containing the path to a file, an image online.

`DPhoto` objects handle caching, file management, downloading of web images, and various optimisations for you. If however you would like to use your own data model to represent photos you can simply ensure your model conforms to the `DPhoto` protocol. You can then handle the management of caching, downloads, etc, yourself.

## Requirements

## Installation

DPhotoBrowserSwift is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'DPhotoBrowserSwift'
```

## Author

DK, jdbtechs@gmail.com

## License

DPhotoBrowserSwift is available under the MIT license. See the LICENSE file for more info.
