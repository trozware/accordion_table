//
//  ContentView.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//  Copyright © 2019 TrozWare. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var persons: [Person] = []
    @State private var haveFetched = false

    var body: some View {
        NavigationView {
            VStack(spacing: 30.0) {
                if persons.count == 0 {
                    Text("Loading…")
                        .font(.headline)
                }

                List(persons) { person in
                    Button(action: {
                        self.toggleSignIn(for: person)
                    }) {
                        HStack {
                            Text(person.name.first)
                            Text(person.name.last)
                            Spacer()
                            Image(systemName: person.hasSignedIn ? "person.fill" : "circle")
                                .font(.title)
                        }
                    }
                }

            }
            .navigationBarTitle("Staff")
            .onAppear(perform: { self.fetchData() })
        }
    }

    func fetchData() {
        // not sure if this is needed, but want to make sure the
        // web service is not called every time the view refreshs
        if haveFetched { return }
        haveFetched = true

        WebService().fetchSampleData { (persons) in
            self.persons = persons
        }
    }

    func toggleSignIn(for personToChange: Person) {
        let index = persons.firstIndex() { person in
            person.id == personToChange.id
        }

        if let personIndex = index {
            persons[personIndex].hasSignedIn.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
