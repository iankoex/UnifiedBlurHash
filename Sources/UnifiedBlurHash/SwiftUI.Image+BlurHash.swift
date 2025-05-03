//
//  SwiftUI.Image+BlurHash.swift
//
//
//  Created by Ian on 13/12/2022.
//

import SwiftUI

/// A convenience initializer for creating a SwiftUI `Image` from a [BlurHash](https://blurha.sh/) string.
///
/// This initializer attempts to decode a BlurHash string into an image of a specified size and with a punch factor for contrast enhancement.
///
/// - Parameters:
///   - blurHash: A non-empty `String` containing the BlurHash to decode. The string should conform to the BlurHash specification.
///   - size: A `CGSize` specifying the desired dimensions of the resulting image. Defaults to 32x32 pixels if not specified.
///   - punch: A `Float` used to adjust the contrast of the decoded image. Values greater than 1.0 increase contrast. Default is 1.
///
/// - Returns: An optional `Image`. Returns `nil` if the BlurHash string is invalid or decoding fails.
///
/// - Important:
///   - This initializer is *failable* and will return `nil` if decoding the BlurHash string does not result in a valid image.
///   - Ensure the `blurHash` string is valid and not empty to avoid a `nil` result.
///
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Image {
    /// Initializes an `Image` from a BlurHash string.
    ///
    /// If the decoding process fails or returns an invalid image, the initializer returns `nil`.
    ///
    /// - Parameters:
    ///   - blurHash: The BlurHash-encoded string.
    ///   - size: The desired output image size. Default is 32x32.
    ///   - punch: A contrast adjustment factor. Default is 1.
    init?(blurHash: String, size: CGSize = CGSize(width: 32, height: 32), punch: Float = 1) {
        let unifiedImg = UnifiedImage(blurHash: blurHash, size: size, punch: punch)
        guard let unifiedImg = unifiedImg else {
            return nil
        }
        self.init(unifiedImage: unifiedImg)
    }
}
