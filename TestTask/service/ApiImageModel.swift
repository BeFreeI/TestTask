//
//  ImageModel.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 21.05.24.
//

import Foundation

struct ApiImageModel: Decodable, Hashable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String

    static func == (lhs: ApiImageModel, rhs: ApiImageModel) -> Bool {
        return lhs.id == rhs.id && lhs.albumId == rhs.albumId
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
