//
//  Company.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//

import Foundation

// I used next.json-generator.com to generate a fake set of data
// The WebService downloads it and parses it into an array of Person objects
// Company is initialized with this array and splits into into an array of Departments

struct Company {
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
    // The custom init is in an extension so that the default init still works.

    init(with persons: [Person]) {
        let deptNames = Array(Set(persons.map { $0.department })).sorted()
        let departments = deptNames.map { deptName -> Department in
            let deptPersons = persons
                .filter { $0.department == deptName }
                .sorted { a, b in
                    return (a.name.last + a.name.first) < (b.name.last + b.name.first)
            }
            return Department(name: deptName, persons: deptPersons)
        }

        self.departments = departments
    }
}

// Department and Person are Identifiable so they can be looped through in the List

struct Department: Identifiable {
    let id = UUID()
    let name: String
    var persons: [Person]
}

// These 2 structs mirror the structure of the JSON data
struct Person: Decodable, Identifiable {
    let id: UUID
    let name: PersonName
    let department: String
    var hasSignedIn: Bool
}

struct PersonName: Decodable {
    let first: String
    let last: String
}
