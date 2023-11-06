//
//  NetworkService.swift
//  DriveMusic
//
//  Created by Quasar on 01.11.2023.
//

import UIKit
import Alamofire

class NetworkService {

    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
        let urlAF = "https://itunes.apple.com/search?"
        let parameters = ["term":"\(searchText)",
                          "limit":"100",
                          "media": "music"]

        AF.request(urlAF, method: .get, parameters: parameters, encoding: URLEncoding.default).responseData {  (dataResponse) in
            if let error = dataResponse.error {
                print("Error received requestiong data: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = dataResponse.data else { return }

            let decoder = JSONDecoder()
            do {
                let objects = try decoder.decode(SearchResponse.self, from: data)
                print("objects: ", objects)
                completion(objects)


            } catch let jsonError {
                print("Failed to decode JSON", jsonError)
                completion(nil)

            }
            let someString = String(data: data, encoding: .utf8)
            print(someString ?? "")

        }
    }
}
