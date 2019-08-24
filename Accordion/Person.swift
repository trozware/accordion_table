//
//  Person.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//  Copyright © 2019 TrozWare. All rights reserved.
//

import Foundation

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
