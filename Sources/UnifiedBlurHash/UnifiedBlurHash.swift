/*
 Many Thanks to Mortenjust for https://github.com/mortenjust/Blurhash-macos.git
 */

public struct UnifiedBlurHash {
    public private(set) var text = "Hello, World!"

    public init() {
    }

    @available(macOS 10.15, iOS 13, *)
    public static func getBlurHashString(from unifiedImage: UnifiedImage) async -> String? {
        unifiedImage.small?.blurHash(numberOfComponents: (4,3))
    }

    @available(macOS 10.15, iOS 13, *)
    public static func getUnifiedImage(from blurHashString: String) async -> UnifiedImage? {
        UnifiedImage(blurHash: blurHashString, size: .init(width: 32, height: 32))
    }
}
