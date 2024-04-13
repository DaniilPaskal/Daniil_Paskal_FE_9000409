//
//  News.swift
//  Daniil_Paskal_FE_9000409
//
//  Created by user237236 on 4/10/24.
//

import Foundation

// News structs for decoding data
struct News: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

struct Article: Codable {
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String
}

struct Source: Codable {
    let id: String?
    let name: String
}
