//
//  APIService.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 22.11.2023.
//

import Foundation
import Combine

class APIService {
    
    func fetchAudioList() async throws -> [AudioResult] {
        guard let url = URL(string: "https://freesound.org/apiv2/search/text/?token=yocIk0HQ0y5szj8UhGrCvwhLI2C7VAIL0GyFIXyI&query=piano") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        let audioList = try decoder.decode(AudioList.self, from: data)
        return audioList.results ?? []
    }
    
    func fetchAudioDetails(audioId: Int?) async throws -> AudiofileDetails {
        guard let audioId = audioId,
              let url = URL(string: "https://freesound.org/apiv2/sounds/\(audioId)/?token=yocIk0HQ0y5szj8UhGrCvwhLI2C7VAIL0GyFIXyI") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        return try decoder.decode(AudiofileDetails.self, from: data)
    }
}
