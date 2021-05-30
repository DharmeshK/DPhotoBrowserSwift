//
//  Photo.swift
//  DPhotoBrowserSwift
//
//  Created by DK on 30/05/21.
//  Original obj-c created by Michael Waterfall 2013
//
//

import Foundation
import UIKit

extension Notification.Name {
    static let DPhoto_LOADING_DID_END_NOTIFICATION  = Notification.Name("DPhoto_LOADING_DID_END_NOTIFICATION")
    static let DPhoto_PROGRESS_NOTIFICATION  = Notification.Name("DPhoto_PROGRESS_NOTIFICATION")
}



public protocol Photo: AnyObject {
    var underlyingImage: UIImage? { get }

    // Called when the browser has determined the underlying images is not
    // already loaded into memory but needs it.
    func loadUnderlyingImageAndNotify()

    // Fetch the image data from a source and notify when complete.
    // You must load the image asyncronously (and decompress it for better performance).
    // It is recommended that you use SDWebImageDecoder to perform the decompression.
    // See DPhoto object for an example implementation.
    // When the underlying UIImage is loaded (or failed to load) you should post the following
    // notification:
    // NotificationCenter.default.postNotificationName(DPhoto_LOADING_DID_END_NOTIFICATION
    //                                                     object: self)
    func performLoadUnderlyingImageAndNotify()

    // This is called when the photo browser has determined the photo data
    // is no longer needed or there are low memory conditions
    // You should release any underlying (possibly large and decompressed) image data
    // as long as the image can be re-loaded (from cache, file, or URL)
    func unloadUnderlyingImage()

    // If photo is empty, in which case, don't show loading error icons
    var emptyImage: Bool { get }

    // Video
    var isVideo: Bool { get }
    func setVideoURL(url: URL?)
    func getVideoURL(completion: @escaping (URL?) -> ())

    // Return a caption string to be displayed over the image
    // Return nil to display no caption
    var caption: String { get }

    // Cancel any background loading of image data
    func cancelAnyLoading()
    
    func equals(photo: Photo) -> Bool
}
