//
//  UnifiedImage+Encode.swift
//
//
//  Created by Ian on 12/12/2022.
//

#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif

extension UnifiedImage {
    /// Returns a blur has String. Use on background thread as it can take a few seconds. X, Y components between 3 and 10 work best.
    public func blurHash(numberOfComponents components: (Int, Int)) -> String? {
        // Pre-calculate values that are used multiple times
        let width = Int(round(size.width))
        let height = Int(round(size.height))
        let size = CGSize(width: width, height: height)

        // Create context with optimized parameters
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }

        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -size.height)

#if os(macOS)
        let prior = NSGraphicsContext.current
        NSGraphicsContext.current = NSGraphicsContext(cgContext: context, flipped: true)
        draw(in: CGRect(origin: .zero, size: size))
        NSGraphicsContext.current = prior
#elseif os(iOS)
        UIGraphicsPushContext(context)
        draw(at: .zero)
        UIGraphicsPopContext()
#endif

        guard let cgImage = context.makeImage(),
              let dataProvider = cgImage.dataProvider,
              let data = dataProvider.data,
              let pixels = CFDataGetBytePtr(data) else {
            return nil
        }

        let bytesPerRow = cgImage.bytesPerRow
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let pi = Float.pi

        // Pre-calculate component counts
        let componentX = components.0
        let componentY = components.1
        let totalComponents = componentX * componentY

        // Pre-allocate and reserve capacity for arrays
        var factors = [(Float, Float, Float)]()
        factors.reserveCapacity(totalComponents)

        // Pre-calculate width/height as Float to avoid repeated conversions
        let floatWidth = Float(width)
        let floatHeight = Float(height)

        // Calculate factors with optimized loops
        for y in 0..<componentY {
            for x in 0..<componentX {
                let normalisation: Float = (x == 0 && y == 0) ? 1 : 2
                let factor = multiplyBasisFunction(
                    pixels: pixels,
                    width: width,
                    height: height,
                    bytesPerRow: bytesPerRow,
                    bytesPerPixel: bytesPerPixel,
                    pixelOffset: 0
                ) { px, py in
                    normalisation * cos(pi * Float(x) * px / floatWidth) * cos(pi * Float(y) * py / floatHeight)
                }
                factors.append(factor)
            }
        }

        let dc = factors[0]
        let ac = Array(factors[1..<totalComponents])

        var hash = ""
        hash.reserveCapacity(4 + 2 * ac.count) // Pre-allocate approximate capacity

        // Size flag calculation
        let sizeFlag = (componentX - 1) + (componentY - 1) * 9
        hash.append(sizeFlag.encode83(length: 1))

        let maximumValue: Float
        if !ac.isEmpty {
            // Optimized maximum value calculation
            var maxVal: Float = 0
            for factor in ac {
                maxVal = max(maxVal, abs(factor.0), abs(factor.1), abs(factor.2))
            }
            let quantisedMaximumValue = Int(max(0, min(82, floor(maxVal * 166 - 0.5))))
            maximumValue = Float(quantisedMaximumValue + 1) / 166
            hash.append(quantisedMaximumValue.encode83(length: 1))
        } else {
            maximumValue = 1
            hash.append("0")
        }

        hash.append(encodeDC(dc).encode83(length: 4))

        // Optimized AC component encoding
        for factor in ac {
            hash.append(encodeAC(factor, maximumValue: maximumValue).encode83(length: 2))
        }

        return hash
    }

    private func multiplyBasisFunction(
        pixels: UnsafePointer<UInt8>,
        width: Int,
        height: Int,
        bytesPerRow: Int,
        bytesPerPixel: Int,
        pixelOffset: Int,
        basisFunction: (Float, Float) -> Float
    ) -> (Float, Float, Float) {
        var r: Float = 0
        var g: Float = 0
        var b: Float = 0

        let height = height
        let width = width
        let bytesPerRow = bytesPerRow
        let bytesPerPixel = bytesPerPixel

        // Optimized pixel iteration
        for y in 0..<height {
            var pixelIndex = y * bytesPerRow
            let yFloat = Float(y)

            for x in 0..<width {
                let xFloat = Float(x)
                let basis = basisFunction(xFloat, yFloat)

                // Direct pixel access with bounds checking removed for performance
                // (safe as long as the parameters are correct)
                r += basis * Math.sRGBToLinear(pixels[pixelIndex])
                g += basis * Math.sRGBToLinear(pixels[pixelIndex + 1])
                b += basis * Math.sRGBToLinear(pixels[pixelIndex + 2])

                pixelIndex += bytesPerPixel
            }
        }

        let scale = 1 / Float(width * height)
        return (r * scale, g * scale, b * scale)
    }
}

// MARK: - Optimized Helper Functions

@inline(__always)
private func encodeDC(_ value: (Float, Float, Float)) -> Int {
    let roundedR = Math.linearTosRGB(value.0)
    let roundedG = Math.linearTosRGB(value.1)
    let roundedB = Math.linearTosRGB(value.2)
    return (roundedR << 16) + (roundedG << 8) + roundedB
}

@inline(__always)
private func encodeAC(_ value: (Float, Float, Float), maximumValue: Float) -> Int {
    let quantR = Int(max(0, min(18, floor(Math.signPow(value.0 / maximumValue, 0.5) * 9 + 9.5))))
    let quantG = Int(max(0, min(18, floor(Math.signPow(value.1 / maximumValue, 0.5) * 9 + 9.5))))
    let quantB = Int(max(0, min(18, floor(Math.signPow(value.2 / maximumValue, 0.5) * 9 + 9.5))))

    return quantR * 361 + quantG * 19 + quantB // 19*19 = 361
}

extension BinaryInteger {
    func encode83(length: Int) -> String {
        var result = ""
        result.reserveCapacity(length)
        var value = Int(self)

        for _ in 1...length {
            let digit = value % 83
            value /= 83
            result.append(Math.encodeCharacters[digit])
        }

        return String(result.reversed())
    }
}
