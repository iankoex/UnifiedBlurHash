# UnifiedBlurHash

Extensions of `UIImage` and `NSImage` to encode and decode blur hashes, based on [Wolt's Implementation](https://github.com/woltapp/blurhash) for Swift (iOS).

Based on [Mortenjust's Implementation](https://github.com/mortenjust/Blurhash-macos.git) for macOS

# Usage
There are two ways you can use this package:
1. Using Async Helpers
```swift
// Encoding
let blurHashStr = await UnifiedBlurHash.getBlurHashString(from: image)

// Decoding
let image = await UnifiedBlurHash.getUnifiedImage(from: imageString)

```

2. Using Methods Directly

```swift

// scale down for performance then encode
let blurHashStr = unifiedImage.small?.blurHash(numberOfComponents: (4,4))
    
// Decoding. Use small size and resize in UI for performance
let image = UnifiedImage(blurHash: blurHashString, size: .init(width: 32, height: 32))
    
```

# SwiftUI Example

```swift 

import SwiftUI
import UnifiedBlurHash

struct ContentView: View {
    @State private var imageString = "LVN^Odxa?WNa-;WB£,WBs;baR*af"
    @State private var image: UnifiedImage? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            
            Button("Encode", action: encode)

            Button("Decode", action: decode)

            if image != nil {
                Image(unifiedImage: image!)
                    .resizable()
            }
        }
        .padding(.horizontal)
    }

    private func encode() {
        Task {
            let image = UnifiedImage(named: "sunflower")
            guard let image = image else {
                return
            }
            let str = await UnifiedBlurHash.getBlurHashString(from: image)
            guard let str = str else {
                return
            }
            DispatchQueue.main.async {
                self.imageString = str
            }
        }
    }

    private func decode() {
        Task {
            let image = await UnifiedBlurHash.getUnifiedImage(from: imageString)
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}


```
Under the hood `UnifiedImage` is just `UIImage` or `NSImage` depending on the platform.

# License
Run Wild
