//
//  UnifiedBlurHash.swift
//
//
//  Created by Ian on 12/12/2022.
//
// Many Thanks to Mortenjust for https://github.com/mortenjust/Blurhash-macos.git

import SwiftUI

/// A utility struct for working with BlurHash-encoded images and operations related to encoding/decoding BlurHashes.
///
/// Provides asynchronous methods to:
/// - Generate a BlurHash string from a `UnifiedImage`.
/// - Create a `UnifiedImage` from a BlurHash string.
/// - Decode the average color from a BlurHash string.
///
public struct UnifiedBlurHash {

    /// Initializes a new instance of `UnifiedBlurHash`.
    public init() {}

    /// Generates a BlurHash string from the provided `UnifiedImage`.
    ///
    /// - Parameter unifiedImage: The `UnifiedImage` instance to encode.
    /// - Returns: An optional `String` containing the BlurHash, or `nil` if the image cannot be encoded (e.g., `unifiedImage.small` is nil).
    ///
    /// - Important: Uses `(4, 3)` as the number of components for BlurHash encoding.
    ///
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public static func getBlurHashString(from unifiedImage: UnifiedImage) async -> String? {
        unifiedImage.small?.blurHash(numberOfComponents: (4, 3))
    }

    /// Decodes a BlurHash string into a `UnifiedImage`.
    ///
    /// - Parameter blurHashString: The BlurHash string to decode.
    /// - Returns: A `UnifiedImage` created from the given BlurHash, or `nil` if decoding fails.
    ///
    /// - Note: Uses a fixed output image size of 32x32 pixels.
    ///
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public static func getUnifiedImage(from blurHashString: String) async -> UnifiedImage? {
        UnifiedImage(blurHash: blurHashString, size: .init(width: 32, height: 32))
    }

    /// Computes the average color of an image represented by a BlurHash string.
    ///
    /// - Parameter blurHashString: The BlurHash string to analyze.
    /// - Returns: A `Color` representing the average color in the decoded image.
    ///
    @available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
    public static func getAverageColor(from blurHashString: String) async -> Color {
        decodeAverageColor(blurHash: blurHashString)
    }
}
