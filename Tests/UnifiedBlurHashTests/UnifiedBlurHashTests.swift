//
//  UnifiedBlurHashTests.swift
//  UnifiedBlurHash
//
//  Created by ian on 3/9/25.
//

import Testing
@testable import UnifiedBlurHash
import Foundation
import SwiftUI

@Suite("UnifiedBlurHash Functionality Tests")
class UnifiedBlurHashTests {

    @Test("Decode valid blur hash string into UnifiedImage")
    func testDecodeValidBlurHash() async {
        let blurHash = "LWC?S~x]Sjof~Wx]X9oe?btRofax" // Valid placeholder BlurHash
        let image = await UnifiedBlurHash.getUnifiedImage(from: blurHash)

        #expect(image != nil)
        #expect(image?.size.width == 32)
        #expect(image?.size.height == 32)
    }

    @Test("Get blur hash string from a valid UnifiedImage")
    func testEncodeUnifiedImageToBlurHash() async {
        guard let image = Bundle.module.image(forResource: "sunflower") else {
            #expect(Bool(false), "Test image not found in bundle")
            return
        }
        let hash = await UnifiedBlurHash.getBlurHashString(from: image)
        #expect(hash == "LWC?S~x]Sjof~Wx]X9oe?btRofax")
        #expect(hash != nil && hash!.count >= 6)
    }

    @Test("Get average color from valid BlurHash string")
    func testAverageColorFromBlurHash() async {
        let blurHash = "LWC?S~x]Sjof~Wx]X9oe?btRofax"
        let color = await UnifiedBlurHash.getAverageColor(from: blurHash)

        // You can’t compare Color directly, but we can at least ensure it's not black or clear.
        let components = color.description.lowercased()
        #expect(!components.contains("clear"))
    }

    @Test("Fail to decode invalid blur hash string")
    func testInvalidBlurHashDecoding() async {
        let invalidHash = "LWC" // Too short to be valid
        let image = await UnifiedBlurHash.getUnifiedImage(from: invalidHash)
        #expect(image == nil)
    }
}
