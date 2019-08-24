//
//  Company.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//  Copyright © 2019 TrozWare. All rights reserved.
//

import Foundation

struct Company {
    var departments: [Department] = []

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

struct Department: Identifiable {
    let id = UUID()
    let name: String
    var persons: [Person]
}

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
