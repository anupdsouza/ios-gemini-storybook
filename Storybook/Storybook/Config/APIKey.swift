//
//  APIKey.swift
//  Storybook
//
//  Created by Anup D'Souza
//

import Foundation

enum APIKey {
    // Fetch the API keys from `GenerativeAI-Info.plist`
    static var gemini: String {
        configValue(key: "GEMINI_API_KEY",
                    setupErrorMessage: "Follow the instructions at https://ai.google.dev/tutorials/setup to get an API key.")
    }

    static var openAIKey: String {
        configValue(key: "OPENAI_API_KEY",
                    setupErrorMessage: "Visit https://platform.openai.com/api-keys to get an API key.")
    }
    
    static var openAIOrgId: String {
        configValue(key: "OPENAI_ORG_ID",
                    setupErrorMessage: "Visit https://platform.openai.com/api-keys to see your organisation id.")
    }

    static private var configDict: NSDictionary? {
        guard let filePath = Bundle.main.path(forResource: "GenerativeAI-Info", ofType: "plist")
        else {
            fatalError("Couldn't find file 'GenerativeAI-Info.plist'.")
        }
        return NSDictionary(contentsOfFile: filePath)
    }

    static private func configValue(key: String, setupErrorMessage: String) -> String {
        guard let value = configDict?.object(forKey: key) as? String else {
            fatalError("Couldn't find key: \(key) in 'GenerativeAI-Info.plist'.")
        }
        if value.starts(with: "_") || value.isEmpty {
            fatalError(setupErrorMessage)
        }
        return value
    }
}
