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
    @State private var image: UnifiedImage? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Button("Encode", action: encode)
                
                Button("Decode", action: decode)
                
                Image("sunflower")
                    .resizable()
                    .aspectRatio(9/16, contentMode: .fit)
                    .frame(maxWidth: 300)
                
                if image != nil {
                    Image(unifiedImage: image!)
                        .resizable()
                        .aspectRatio(9/16, contentMode: .fit)
                        .frame(maxWidth: 300)
                }
            }
            .padding(.horizontal)
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
            guard let image = image else {
                return
            }
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
