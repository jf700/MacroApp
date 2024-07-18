//
//  OpenAiService.swift
//  CalorieTracker
//
//  Created by Josh Fuery on 6/7/24.
//

import Foundation

enum HTTPMethod: String{
    case post = "POST"
    case get = "GET"
    
}
enum OpenAiError: Error{
    case noFunctionCall
    case unableToConverStringIntoData
}

class OpenAiService{
    
    static let shared = OpenAiService()
    
    private init () { }
    
    private func generateURLRequest(httpMethod: HTTPMethod, message: String) throws -> URLRequest{
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw URLError(.badURL)
        }
        
        var urlRequest = URLRequest(url: url)
        
        //method
        urlRequest.httpMethod = httpMethod.rawValue
        
        //header
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(SecretFile.apiKey)", forHTTPHeaderField: "Authorization")
        
        // Body
        let systemMessage = GPTMessage(role: "system", content: "You are a macronutrient expert.")
        let userMessage = GPTMessage(role: "user", content: message)
        
        let food = GPTFunctionProperty(type: "string", description: "The food item e.g. burger")
        let fats = GPTFunctionProperty(type: "integer", description: "The amount of fats in grams of the given food item")
        let carbs = GPTFunctionProperty(type: "integer", description: "The amount of carbohydrates in grams of the given food item")
        let protein = GPTFunctionProperty(type: "integer", description: "The amount of protein in grams of the given food item")
        let params: [String: GPTFunctionProperty] = [
            "food": food,
            "fats": fats,
            "carbs": carbs,
            "protein": protein
        ]
        
        
        let functionParams = GPTFunctionParameter(type: "object", properties: params, required: ["food", "fats", "carbs", "protein"])
        let function = GPTFunction(name: "get_macronutrients", description: "Get the macros for a given food.", parameters: functionParams)
        
        let payload = GPTChatPayload(model: "gpt-3.5-turbo-0613", messages: [systemMessage, userMessage], functions: [function])
        
        let jsonData = try JSONEncoder().encode(payload)
        
        
        urlRequest.httpBody = jsonData
  
        
        return urlRequest
    }
    
    func sendPromptToChatGPT(message: String) async throws -> MacroResult {
        let urlRequest = try generateURLRequest(httpMethod: .post, message: message)
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let result = try JSONDecoder().decode(GPTResponse.self, from: data)
        
        guard let functionCall = result.choices[0].message.functionCall else{
            throw OpenAiError.noFunctionCall
        }
        
        guard let argData = functionCall.arguments.data(using: .utf8) else{
            throw OpenAiError.unableToConverStringIntoData
        }
        let macro = try JSONDecoder().decode(MacroResult.self, from: argData)
        return macro

    }
   
}
