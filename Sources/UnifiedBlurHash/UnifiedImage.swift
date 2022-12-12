//
//  File.swift
//  
//
//  Created by Ian on 12/12/2022.
//

import SwiftUI

#if os(iOS)
import UIKit

public typealias UnifiedImage = UIImage

@available(macOS 10.15, iOS 13, *)
extension Image {
    init(unifiedImage: UnifiedImage) {
        self.init(uiImage: unifiedImage)
    }
}
#endif

#if os(macOS)
import AppKit

public typealias UnifiedImage = NSImage

@available(macOS 10.15, iOS 13, *)
extension Image {
    init(unifiedImage: UnifiedImage) {
        self.init(nsImage: unifiedImage)
    }
}
#endif
