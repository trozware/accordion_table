//
//  WebService.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//  Copyright © 2019 TrozWare. All rights reserved.
//

import Foundation

// I used next.json-generator.com to generate a fake set of data
// This WebService downloads it and parses it into an array of Person objects

// It would ne neat to work out how to ue Combine to publish this data to a subscriber

struct WebService {
    func fetchSampleData(callback: @escaping  ([Person]) -> Void) {
        let webAddress = "https://next.json-generator.com/api/json/get/Nk-d9dtVw"
        guard let url = URL(string: webAddress) else {
            fatalError("Invalid web address")
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
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
    }
}
