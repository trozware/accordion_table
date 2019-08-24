//
//  WebService.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//  Copyright © 2019 TrozWare. All rights reserved.
//

import Foundation

struct WebService {

    func fetchSampleData(callback: @escaping  ([Person]) -> Void) {
        let webAddress = "https://next.json-generator.com/api/json/get/Nk-d9dtVw"
        guard let url = URL(string: webAddress) else {
            fatalError("Invalid web address")
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                callback([])
                return
            }

            guard let data = data else {
                print("No data, or not decoded")
                callback([])
                return
            }

            do {
                let persons = try JSONDecoder().decode(Array<Person>.self, from: data)
                callback(persons)
            } catch {
                print(error)
                callback([])
            }
        }
        task.resume()
//            .map { (data, response) in data }
//            .decode(type: Array<Person>.self, decoder: JSONDecoder())
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
    }
    
}
