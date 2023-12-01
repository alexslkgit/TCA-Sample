//
//  AsyncImageView.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 30.11.2023.
//

import SwiftUI
import Combine

struct AsyncImageView: View {
    
    @StateObject private var loader = ImageLoader()
    var currentUrlString: String

    let imageWidth: CGFloat = 250
    let imageHeight: CGFloat = 400
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                           .resizable()
                           .scaledToFit()
                           .padding(10)
                           .frame(width: imageWidth, height: imageHeight)
                           .background(Color.white)
                           .clipShape(RoundedRectangle(cornerRadius: 10))
                           .shadow(radius: 10)
                           .padding()
            } else {
                Text("Loading...")
                    .frame(width: imageWidth, height: imageHeight)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }.onChange(of: currentUrlString) { oldValue, newValue in
            loader.load(fromURLString: newValue)
        }
    }
}
