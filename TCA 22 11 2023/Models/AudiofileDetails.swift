//
//  AudiofileDetails.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 29.11.2023.
//

import Foundation

struct AudiofileDetails: Codable {
    var id: Int?
    var url: String?
    var name: String?
    var tags: [String]?
    var description: String?
    var created: String?
    var license: String?
    var type: String?
    var channels, filesize, bitrate, bitdepth: Int?
    var duration: Double?
    var samplerate: Int?
    var username: String?
    var pack: String?
    var download, bookmark: String?
    var previews: Previews?
    var images: Images?
    var numDownloads, numRatings: Int?
    var avgRating: Float?
    var rate, comments: String?
    var numComments: Int?
    var comment, similarSounds: String?
    var analysis: String?
    var analysisFrames: String?
    var analysisStats: String?
    var isExplicit: Bool?

    enum CodingKeys: String, CodingKey {
        case id, url, name, tags, description, created, license, type, channels, filesize, bitrate, bitdepth, duration, samplerate, username, pack
        case download, bookmark, previews, images
        case numDownloads = "num_downloads"
        case avgRating = "avg_rating"
        case numRatings = "num_ratings"
        case rate, comments
        case numComments = "num_comments"
        case comment
        case similarSounds = "similar_sounds"
        case analysis
        case analysisFrames = "analysis_frames"
        case analysisStats = "analysis_stats"
        case isExplicit = "is_explicit"
    }
}

// MARK: - Images
struct Images: Codable {
    var waveformM, waveformL: String?
    var spectralM, spectralL: String?
    var waveformBWM, waveformBWL: String?
    var spectralBWM, spectralBWL: String?

    enum CodingKeys: String, CodingKey {
        case waveformM = "waveform_m"
        case waveformL = "waveform_l"
        case spectralM = "spectral_m"
        case spectralL = "spectral_l"
        case waveformBWM = "waveform_bw_m"
        case waveformBWL = "waveform_bw_l"
        case spectralBWM = "spectral_bw_m"
        case spectralBWL = "spectral_bw_l"
    }
}

// MARK: - Previews
struct Previews: Codable {
    var previewHqMp3: String?
    var previewHqOgg: String?
    var previewLqMp3: String?
    var previewLqOgg: String?

    enum CodingKeys: String, CodingKey {
        case previewHqMp3 = "preview-hq-mp3"
        case previewHqOgg = "preview-hq-ogg"
        case previewLqMp3 = "preview-lq-mp3"
        case previewLqOgg = "preview-lq-ogg"
    }
}
