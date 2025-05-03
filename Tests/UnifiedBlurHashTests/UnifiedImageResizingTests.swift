//
//  UnifiedImageResizingTests.swift
//  UnifiedBlurHash
//
//  Created by ian on 03/05/2025.
//


import Testing
@testable import UnifiedBlurHash
import Foundation
import SwiftUI

@Suite("UnifiedImage Resizing Tests")
class UnifiedImageResizingTests {

    @Test("Resizing an image to 32x32 produces the expected size")
    func testResizingTo32x32() {
        // Create an example image with a known size
        guard let originalImage = Bundle.module.image(forResource: "sunflower") else {
            #expect(Bool(false), "Test image not found in bundle")
            return
        }

        // Resize the image to 32x32
        let resizedImage = originalImage.resized(to: CGSize(width: 32, height: 32))
        
        #expect(resizedImage?.size.width == 32)
        #expect(resizedImage?.size.height == 32)
    }

    @Test("Resizing returns nil for invalid image")
    func testResizingInvalidImage() {
        let invalidImage: UnifiedImage? = nil
        
        let resizedImage = invalidImage?.resized(to: CGSize(width: 32, height: 32))
        
        #expect(resizedImage == nil)
    }

    @Test("Resizing an image produces a non-nil result")
    func testResizingValidImage() {
        // Create a valid image from a system image
        guard let originalImage = Bundle.module.image(forResource: "sunflower") else {
            #expect(Bool(false), "Test image not found in bundle")
            return
        }

        // Resize the image
        let resizedImage = originalImage.resized(to: CGSize(width: 64, height: 64))
        
        #expect(resizedImage != nil)
        #expect(resizedImage?.size.width == 64)
        #expect(resizedImage?.size.height == 64)
    }

    @Test("Small property returns 32x32 resized image")
    func testSmallProperty() {
        // Create an example image with a known size
        guard let originalImage = Bundle.module.image(forResource: "sunflower") else {
            #expect(Bool(false), "Test image not found in bundle")
            return
        }

        // Use the `small` property to resize the image
        let smallImage = originalImage.small
        
        #expect(smallImage?.size.width == 32)
        #expect(smallImage?.size.height == 32)
    }
}
