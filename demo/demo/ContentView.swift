//
//  ContentView.swift
//  demo
//
//  Created by Ian on 02/07/2023.
//

import SwiftUI
import UnifiedBlurHash

struct ContentView: View {
    @State private var imageString = "LWC$.Wx]Sjof~Wx]X9oe?btRofax"
    @State private var imageDecodedFromBlurHashString: UnifiedImage? = nil
    @State private var averageColorFromBlurHashString: Color?

    var body: some View {
        List {
            Section(content: {
                Button("Encode", action: encode)

                Button("Decode", action: decode)
            })

            Section(content: {
                Image("sunflower")
                    .resizable()
                    .aspectRatio(9/16, contentMode: .fit)
                    .frame(maxWidth: 300)
            }, header: {
                Text("Original Image")
            })

            Section(content: {
                if let imageDecodedFromBlurHashString {
                    Image(unifiedImage: imageDecodedFromBlurHashString)
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fit)
                        .frame(maxWidth: 300)
                }
            }, header: {
                Text("Image Decoded From BlurHash String")
            })

            Section(content: {
                averageColorFromBlurHashString?.frame(width: 300, height: 300)
            }, header: {
                Text("Average Color From BlurHash String")
            })
        }
    }
    
    private func encode() {
        Task {
            // https://www.pexels.com/photo/person-holding-yellow-sunflower-1624076/
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
            self.averageColorFromBlurHashString = await UnifiedBlurHash.getAverageColor(from: imageString)
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self.imageDecodedFromBlurHashString = image
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
