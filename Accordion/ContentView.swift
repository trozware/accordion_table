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
    @State private var company: Company = Company()
    @State private var haveFetched = false

    var body: some View {
        NavigationView {
            if company.departments.count == 0 {
                LoadingView()
            } else {
                DepartmentList(company: $company)
            }
        }
        .onAppear(perform: { self.fetchData() })
    }

    func fetchData() {
        // not sure if this is needed, but want to make sure the
        // web service is not called every time the view refreshs
        if haveFetched { return }
        haveFetched = true

        WebService().fetchSampleData { (persons) in
            self.company = Company(with: persons)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct DepartmentList: View {
    @Binding var company: Company

    var body: some View {
        List {
            ForEach(company.departments) { dept in
                Section(header: Text(dept.name)) {
                    ForEach(dept.persons) { person in
                        Button(action: { self.toggleSignIn(for: person) }) {
                            TableRowView(person: person)
                        }
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Staff")
    }

    func toggleSignIn(for personToChange: Person) {
        company.toggleSignIn(for: personToChange)
    }
}

struct TableRowView: View {
    var person: Person

    var body: some View {
        HStack {
            Text(person.name.first)
            Text(person.name.last)
            Spacer()
            if person.hasSignedIn {
                Image(systemName: "person.fill")
                    .font(.title)
            }
        }
        .foregroundColor(.primary)
    }
}

struct LoadingView: View {
    var body: some View {
        Text("Loading…")
            .font(.largeTitle)
            .navigationBarTitle("Staff")
    }
}
