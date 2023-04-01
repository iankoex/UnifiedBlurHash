# UnifiedBlurHash

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fiankoex%2FUnifiedBlurHash%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/iankoex/UnifiedBlurHash)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fiankoex%2FUnifiedBlurHash%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/iankoex/UnifiedBlurHash)

Extensions of `UIImage` and `NSImage` to encode and decode blur hashes, based on [Wolt's Implementation](https://github.com/woltapp/blurhash) for Swift (iOS).

Based on [Mortenjust's Implementation](https://github.com/mortenjust/Blurhash-macos.git) for macOS

Screenshot

![Screenshot](https://user-images.githubusercontent.com/30172987/207150953-d1177cad-da76-40a8-bfdc-4c05f47ce5a0.png)

# About [BlurHash](http://blurha.sh)

BlurHash is a compact representation of a placeholder for an image.

Learn More from the [BlurHash Repo](https://github.com/woltapp/blurhash.git)

### Why would you want this?

Does your designer cry every time you load their beautifully designed screen, and it is full of empty boxes because all the
images have not loaded yet? Does your database engineer cry when you want to solve this by trying to cram little thumbnail
images into your data to show as placeholders?

BlurHash will solve your problems! How? Like this:

![WhyBlurHash](https://user-images.githubusercontent.com/30172987/207242393-5446ece1-7d55-412f-92b6-0a7c4cf36860.png)


You can also see nice examples and try it out yourself at [blurha.sh](http://blurha.sh/)!
Learn More from the [BlurHash Repo](https://github.com/woltapp/blurhash.git)

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

# SwiftUI Examples

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

or 

```swift 

import SwiftUI
import UnifiedBlurHash

struct ContentView: View {
    var blurHash: String = "LVN^Odxa?WNa-;WB£,WBs;baR*af"

    var body: some View {
        Image(blurHash: blurHash)?
            .resizable()
    }
}

```
Under the hood `UnifiedImage` is just `UIImage` or `NSImage` depending on the platform.

# License
Run Wild
