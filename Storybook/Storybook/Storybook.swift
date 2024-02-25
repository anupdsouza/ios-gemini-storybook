//
//  Storybook.swift
//  Storybook
//
//  Created by Anup D'Souza on 21/02/24.
//

import Foundation

struct Storybook: Identifiable, Decodable, Equatable {
    private(set) var id = UUID().uuidString
    var title: String
    var moral: String
    var coverImage: String?
    var story: [String]
    var favorite: Bool = false
}

struct Story: Decodable {
    var title: String
    var moral: String
    var story: [String]
}
