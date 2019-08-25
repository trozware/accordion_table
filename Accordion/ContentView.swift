//
//  ContentView.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//  Copyright © 2019 TrozWare. All rights reserved.
//

import SwiftUI

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

struct DepartmentList: View {
    @Binding var company: Company
    @State private var activeDept: String = ""

    var body: some View {
        List {
            ForEach(company.departments) { dept in

                Button(action: {
                    self.activeDept = (dept.name == self.activeDept)
                        ? ""
                        : dept.name
                }) {
                    DepartmentTableRowView(departmentName: dept.name)
                }
                .listRowBackground(Color(UIColor.secondarySystemBackground))

                if (dept.name == self.activeDept) {
                    ForEach(dept.persons) { person in
                        Button(action: {
                            self.company.toggleSignIn(for: person)
                        }) {
                            PersonTableRowView(person: person)
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Staff")
    }

}

struct DepartmentTableRowView: View {
    var departmentName: String

    var body: some View {
        Text(departmentName)
            .font(.headline)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }
}


struct PersonTableRowView: View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            // un-comment the next line to preview in dark mode
            //  .environment(\.colorScheme, .dark)
    }
}
