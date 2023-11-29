//
//  AudioList.swift
//  TCA 22 11 2023
//
//  Created by Slobodianiuk Oleksandr on 22.11.2023.
//

import Foundation

struct AudioList: Codable {
    var count: Int?
    var previous: String?
    var next: String?
    var results: [AudioResult]?
}

struct AudioResult: Codable, Identifiable {
    var id: Int
    var name: String?
    var tags: [String]?
    var license: String?
    var username: String?
}
