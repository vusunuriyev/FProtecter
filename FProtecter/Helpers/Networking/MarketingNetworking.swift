//
//  MarketingNetworking.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 17.05.24.
//

import Foundation

final class MarketingNetworking {
    static let shared = MarketingNetworking()
    
    func getMarketingImage(completion: @escaping (DataResponse) -> Void) {

        // This will be printed before the tasks are completed
        print("Waiting for tasks to complete...")
        let urlString = "https://api.easygetapp.com/api/market/public/marketing-ads"
        guard let url = URL(string: urlString) else { return }

        let body: [String: [String]] = [
            "marketingNames": ["encryptedalbum"]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else {return}
            if let error = error {
                print("Error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data,
                   let parsedJSON = self.parseJSON(with: data) {
                    completion(parsedJSON)
                }
            } else {
                print("Error: Invalid response")
            }
        }
        dataTask.resume()
    }

    func getSplashImage(completion: @escaping (DataResponse?) -> Void) {
        let urlString = "https://api.easygetapp.com/api/market/public/marketing-splash-ads"
        guard let url = URL(string: urlString) else { return }

        let body: [String: [String]] = [
            "marketingNames": ["encryptedalbum"]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else {return}
            if let error = error {
                print("Error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print(httpResponse)
                if let data = data,
                   let parsedJSON = self.parseJSON(with: data) {
                    completion(parsedJSON)
                } else {
                    completion(nil)
                }
            } else {
                print("Error: Invalid response")
            }
        }
        dataTask.resume()
    }

    func getMarketingVideo(completion: @escaping (DataResponse) -> Void) {
        let urlString = "https://api.easygetapp.com/api/market/public/marketing-videos"
        guard let url = URL(string: urlString) else { return }

        let body: [String: [String]] = [
            "marketingNames": ["encryptedalbum"]
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self else {return}
            if let error = error {
                print("Error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data,
                   let parsedJSON = self.parseJSON(with: data) {
                    completion(parsedJSON)
                }
            } else {
                print("Error: Invalid response")
            }
        }
        dataTask.resume()
    }
    
    func parseJSON(with data: Data) -> DataResponse? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(APIResponse.self, from: data)
            print(decodedData)
            if let data = decodedData.data,
               !data.isEmpty {
                print(data)
                return data[0]
            }
            return nil
        } catch {
            print(String(describing: error))
            return nil
        }
    }

}

struct APIResponse: Codable {
    
    let data: [DataResponse]?
    
    enum CodingKeys: CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent([DataResponse].self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(self.data, forKey: .data)
    }
}

struct DataResponse: Codable {
    let url: String
    let fileLink: String
    
    enum CodingKeys: CodingKey {
        case url
        case fileLink
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(String.self, forKey: .url)
        self.fileLink = try container.decode(String.self, forKey: .fileLink)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.url, forKey: .url)
        try container.encode(self.fileLink, forKey: .fileLink)
    }
}
