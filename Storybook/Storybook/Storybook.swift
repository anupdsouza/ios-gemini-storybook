//
//  Storybook.swift
//  Storybook
//
//  Created by Anup D'Souza on 21/02/24.
//

import Foundation

struct Storybook: Identifiable, Equatable {
    private(set) var id: UUID = .init()
    var title: String
    var coverImage: String
    var story: [String]
    var favorite: Bool
}
