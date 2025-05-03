//
//  UnifiedImage.swift
//
//
//  Created by Ian on 12/12/2022.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

/// A typealias representing a platform-independent image.
///
/// On iOS, tvOS, and watchOS, this maps to `UIImage`.
public typealias UnifiedImage = UIImage

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Image {
    /// Initializes a SwiftUI `Image` from a `UnifiedImage`.
    ///
    /// - Parameter unifiedImage: A `UIImage` to be wrapped in a SwiftUI `Image`.
    init(unifiedImage: UnifiedImage) {
        self.init(uiImage: unifiedImage)
    }
}
#endif

#if os(macOS)
import AppKit

/// A typealias representing a platform-independent image.
///
/// On macOS, this maps to `NSImage`.
public typealias UnifiedImage = NSImage

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Image {
    /// Initializes a SwiftUI `Image` from a `UnifiedImage`.
    ///
    /// - Parameter unifiedImage: An `NSImage` to be wrapped in a SwiftUI `Image`.
    init(unifiedImage: UnifiedImage) {
        self.init(nsImage: unifiedImage)
    }
}
#endif
