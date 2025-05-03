//
//  TestUtilities.swift
//  UnifiedBlurHash
//
//  Created by ian on 03/05/2025.
//

import Foundation
import UnifiedBlurHash

#if canImport(UIKit)
import UIKit

extension Bundle {
    func image(forResource name: String) -> UnifiedImage? {
//        guard let path = self.path(forResource: name, ofType: nil) else {
//            return nil
//        }
        return UIImage(named: name, in: self, compatibleWith: nil)
    }
}
#endif
