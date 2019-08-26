//
//  Company.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//

import Foundation

// I used next.json-generator.com to generate a fake set of data and saved it in the bundle for testing.
// The structs mirror the structure of the JSON data.

struct Company: Codable {
    var departments: [Department] = []

    // There is probably an easier way to do this, but I am looping through the departments
    // and finding the matching person in one of the departments.
    // Since this is a fake data model, I am not too concerned about optimizatations
    mutating func toggleSignIn(for personToChange: Person) {
        for (deptIndex, dept) in departments.enumerated() {
            let index = dept.persons.firstIndex() { person in
                person.id == personToChange.id
            }

            if let personIndex = index {
                departments[deptIndex].persons[personIndex].hasSignedIn.toggle()
                return
            }
        }
    }
}

extension Company {
    // Read in the sample data for testing the display
    static func demoCompany() -> Company {
        guard let jsonUrl = Bundle.main.url(forResource: "CompanyData", withExtension: "json") else {
            fatalError("Missing CompanyData.json file.")
        }

        do {
            let data = try Data(contentsOf: jsonUrl)
            let company = try JSONDecoder().decode(Company.self, from: data)
            return company
        } catch {
            print(error)
            fatalError("Unable to load CompanyData.json file.")
        }
    }
}

// Department and Person are Identifiable so they can be looped through in the List

struct Department: Codable, Identifiable {
    let id = UUID()
    let name: String
    var persons: [Person]
}

struct Person: Codable, Identifiable {
    let id: UUID
    let name: PersonName
    let department: String
    var hasSignedIn: Bool
}

struct PersonName: Codable {
    let first: String
    let last: String
}
