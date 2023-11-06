//
//  SearchResponse.swift
//  DriveMusic
//
//  Created by Quasar on 28.10.2023.
//

import Foundation

struct SearchResponse: Codable {
    let resultCount: Int
    let results: [Track]
}

struct Track: Codable {
    let trackName: String
    let collectionName: String?
    let artistName: String
    let artworkUrl100: String?
    let previewUrl: String?
}
