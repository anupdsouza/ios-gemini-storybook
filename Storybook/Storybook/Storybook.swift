//
//  Storybook.swift
//  Storybook
//
//  Created by Anup D'Souza on 21/02/24.
//

import Foundation
import UIKit

struct Storybook: Identifiable, Equatable {
    private(set) var id = UUID().uuidString
    var title: String
    var moral: String
    var story: [String]
    var images: [UIImage] = []
}

struct Story: Decodable {
    var title: String
    var moral: String
    var story: [String]
    var imagePrompts: [String]
}
