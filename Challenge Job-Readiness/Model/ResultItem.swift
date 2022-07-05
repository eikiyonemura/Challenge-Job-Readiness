//
//  Result.swift
//  Challenge Job-Readiness
//
//  Created by Douglas Eiki Yonemura on 28/06/22.
//

struct ResultItem: Codable {
    let code: Int
    let body: Body
}

struct Body: Codable {
    let id: String
    let title: String
    let price: Double
    let secure_thumbnail: String
    let available_quantity: Int
//    let sold_quantidy: Int
    let pictures: [Pictures]
    let seller_address: Adress
}

struct Pictures: Codable {
    let secure_url: String
}

struct Adress: Codable {
    let city: City
    let state: State
}

struct City: Codable {
    let id: String
    let name: String
}

struct State: Codable {
    let id: String
    let name: String
}
