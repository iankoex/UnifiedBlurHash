//
//  File.swift
//  
//
//  Created by Ian on 12/12/2022.
//
import SwiftUI

public extension UnifiedImage {
    var small: UnifiedImage? {
        resized(to: CGSize(width: 32, height: 32))
    }
}

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit

public extension UnifiedImage {

    func resized(to newSize: NSSize) -> UnifiedImage? {
        let image = NSImage(size: newSize)
        image.lockFocus()
        let context = NSGraphicsContext.current
        context?.imageInterpolation = .high
        draw(
            in: NSRect(origin: .zero, size: newSize),
            from: NSRect(origin: .zero, size: size),
            operation: .copy,
            fraction: 1
        )
        image.unlockFocus()
        return image
    }
}

#endif

#if canImport(UIKit) && !os(watchOS)
import UIKit
import Foundation

public extension UnifiedImage {
    
    func resized(to newSize: CGSize) -> UnifiedImage? {
        let renderer = UIGraphicsImageRenderer(size: newSize)

        let image = renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: newSize))
        }
        return image
    }
}

#elseif os(watchOS)

import UIKit
import Foundation

public extension UnifiedImage {
    
    func resized(to newSize: CGSize) -> UnifiedImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: newSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

#endif
