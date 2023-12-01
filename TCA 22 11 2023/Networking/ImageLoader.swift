//
//  ImageLoader.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 30.11.2023.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?

    func load(fromURLString urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        cancellable?.cancel()

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in self?.image = $0 }
    }

    deinit {
        cancellable?.cancel()
    }
}
