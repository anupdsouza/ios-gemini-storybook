//
//  APIKey.swift
//  Storybook
//
//  Created by Anup D'Souza
//

import Foundation

enum APIKey {
    // Fetch the API keys from `GenerativeAI-Info.plist`
    static var `gemini`: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "GEMINI_API_KEY") as? String else {
            fatalError("Couldn't find key 'GEMINI_API_KEY' in 'GenerativeAI-Info.plist'.")
        }
        if value.starts(with: "_") || value.isEmpty {
            fatalError(
                "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key."
            )
        }
        return value
    }
    static var openAIKey: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "OPENAI_API_KEY") as? String else {
            fatalError("Couldn't find key 'OPENAI_API_KEY' in 'GenerativeAI-Info.plist'.")
        }
        if value.isEmpty {
            fatalError(
                "Visit https://platform.openai.com/api-keys to get an API key."
            )
        }
        return value
    }
    static var openAIOrgId: String {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "OPENAI_ORG_ID") as? String else {
            fatalError("Couldn't find key 'OPENAI_ORG_ID' in 'GenerativeAI-Info.plist'.")
        }
        if value.isEmpty {
            fatalError(
                "Visit https://platform.openai.com/api-keys to see your organisation id."
            )
        }
        return value
    }
}
