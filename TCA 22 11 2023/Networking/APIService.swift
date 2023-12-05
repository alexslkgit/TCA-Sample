//
//  APIService.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 22.11.2023.
//

import Foundation
import Alamofire
import Combine

class APIService {
    
    func fetchAudioList() async throws -> [AudioResult] {
        let url = "https://freesound.org/apiv2/search/text/?token=yocIk0HQ0y5szj8UhGrCvwhLI2C7VAIL0GyFIXyI&query=piano"
        
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(url).responseDecodable(of: AudioList.self) { response in
                switch response.result {
                case .success(let audioResponse):
                    continuation.resume(returning: audioResponse.results ?? [])
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    func fetchAudioDetails(audioId: Int?, completion: @escaping (Result<AudiofileDetails, Error>) -> Void) {
        guard let audioId else { return }
        let url = "https://freesound.org/apiv2/sounds/\(audioId)/?token=yocIk0HQ0y5szj8UhGrCvwhLI2C7VAIL0GyFIXyI"
        AF.request(url).responseDecodable(of: AudiofileDetails.self) { response in
            switch response.result {
            case .success(let sections):
                completion(.success(sections))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

// With closures:


//    func fetchAudioList(completion: @escaping (Result<[AudioResult], Error>) -> Void) {
//        let url = "https://freesound.org/apiv2/search/text/?token=yocIk0HQ0y5szj8UhGrCvwhLI2C7VAIL0GyFIXyI&query=piano"
//
//        AF.request(url).responseDecodable(of: AudioList.self) { response in
//            switch response.result {
//            case .success(let audioResponse):
//                completion(.success(audioResponse.results ?? []))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
