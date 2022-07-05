//
//  Content.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 27/06/22.
//

struct Content: Codable {
    let content: [Item]
}

struct Item: Codable {
    let id: String
    let position: Int
    let type: String
}
