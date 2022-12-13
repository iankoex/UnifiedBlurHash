//
//  File.swift
//  
//
//  Created by Ian on 13/12/2022.
//

import SwiftUI

@available(macOS 10.15, iOS 13, *)
public extension Image {
    init?(blurHash: String, size: CGSize = CGSize(width: 32, height: 32), punch: Float = 1) {
        let unifiedImg = UnifiedImage(blurHash: blurHash, size: size, punch: punch)
        guard let unifiedImg = unifiedImg else {
            return nil
        }
        self.init(unifiedImage: unifiedImg)
    }
}
