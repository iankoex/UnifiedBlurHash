//
//  File.swift
//  
//
//  Created by Ian on 12/12/2022.
//

import SwiftUI

#if canImport(UIKit)
import UIKit

public typealias UnifiedImage = UIImage

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Image {
    init(unifiedImage: UnifiedImage) {
        self.init(uiImage: unifiedImage)
    }
}
#endif

#if os(macOS)
import AppKit

public typealias UnifiedImage = NSImage

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public extension Image {
    init(unifiedImage: UnifiedImage) {
        self.init(nsImage: unifiedImage)
    }
}
#endif
