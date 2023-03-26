//
//  ApiService.swift
//  Dall-E
//
//  Created by MaCanMichis on 3/26/23.
//

import UIKit

struct Response: Decodable{
    let data: [ImageURL]
}

struct ImageURL: Decodable {
    let url: String
}
enum APIError: Error{
    case unableToCreateImageURL
    case unableToConverteDataIntoImage
    case unableToCreateURLforURLRequest
}
class APIService{
    let apiKey = "Paste your api key here"
    
    
    func fetchImageForPrompt(_ prompt: String) async throws -> UIImage{
        let fetchImageURL = "https://api.openai.com/v1/images/generations"
    let urlRequest = try createURLRequestfor(httpMethod: "POST", url: fetchImageURL, prompt: prompt)
        let (data,response) = try await URLSession.shared.data(for: URL)
        let decoder = JSONDecoder()
        let results = try decoder.decode(Response.self, from: data)
    
    let imageURL = results.data[0].url
    guard let imageURL = URL(string: imageURL) else{
    throw APIError.unableToCreateImageURL
    }
    
    let (imageData, imageResponse) = try await URLSession.shared.data(for: imageURL)
    
    guard let image = UIImage(data:imageData) else {
    throw APIError.unableToConverteDataIntoImage
    }
    return image
    }
    
    private func createURLRequestfor(httpMethod: String, url: String, prompt:String) throws -> URLRequest{
        guard let url = URL(string: url) else {
            throw APIError.unableToCreateURLforURLRequest
        }
        
        var urlRequest = URLRequest(url: url)
        
        //Method
        urlRequest.httpMethod = httpMethod
        
        //Headers
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //Body
        let jsonBody: [String:Any] = [
            "prompt": "\(prompt)",
            "n": 1,
            "size": "1024x1024"
         ]
        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: jsonBody)
        
        return urlRequest
    }
    
}
