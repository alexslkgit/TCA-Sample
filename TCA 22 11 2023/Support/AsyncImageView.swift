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
    @State private var currentUrlString: String

    let imageWidth: CGFloat = 250
    let imageHeight: CGFloat = 400
    

    init(urlString: String) {
        _currentUrlString = State(initialValue: urlString)
    }
    
    var body: some View {
        Group {
            if let image = loader.image {
                Image(uiImage: image)
                           .resizable()
                           .scaledToFit()
                           .padding(10)
                           .frame(width: imageWidth, height: imageHeight) // Фіксовані розміри рамки
                           .background(Color.white) // Тло для зображення
                           .clipShape(RoundedRectangle(cornerRadius: 10)) // Скруглення країв тла
                           .shadow(radius: 10) // Тінь застосовується до тла
                           .padding() // Додавання відступів навколо рамки з тінню
            } else {
                // Плейсхолдер або індикатор завантаження
                Text("Завантаження...")
                    .frame(width: imageWidth, height: imageHeight)
                    .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .onReceive(Just(currentUrlString)) { newUrlString in
            loader.load(fromURLString: newUrlString)
        }
    }
}
