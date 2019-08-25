//
//  ContentView.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//

import SwiftUI

struct ContentView: View {
    @State private var company: Company = Company()
    @State private var haveFetchedData = false

    // Display one of 2 views depending on whwther the web data has been fetched
    // Use onAppear to fetch the data the first time this view appears

    var body: some View {
        NavigationView {
            if haveFetchedData {
                DepartmentList(company: $company)
            } else {
                LoadingView()
            }
        }
        .onAppear(perform: { self.fetchData() })
    }
}

extension ContentView {
    // Use the WebService to fetch and process the data
    // Setting the @State variables will refresh the view automatically
    func fetchData() {
        WebService().fetchSampleData { (persons) in
            self.company = Company(with: persons)
            self.haveFetchedData = true
        }
    }
}

struct LoadingView: View {
    // Placeholder view for display before there is any data
    var body: some View {
        Text("Loading…")
            .font(.largeTitle)
            .navigationBarTitle("Staff")
    }
}

struct DepartmentList: View {
    @Binding var company: Company
    @State private var activeDept: String = ""

    // This is the main table (List) view
    // It loops through the departments and shows the department title
    // The people in the department are only shown for the active department (if any)

    var body: some View {
        List {
            ForEach(company.departments) { dept in

                // enclosing the contents of a List Row in a Button means you can
                // set up a different action for different rows

                Button(action: {
                    self.activeDept = (dept.name == self.activeDept)
                        ? ""
                        : dept.name
                }) {
                    DepartmentTableRowView(departmentName: dept.name)
                }
                .listRowBackground(Color(UIColor.secondarySystemBackground))

                // if showing the people in a department, use a different button action
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
    // custom view for the department name header rows
    var departmentName: String

    var body: some View {
        Text(departmentName)
            .font(.headline)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }
}


struct PersonTableRowView: View {
    // custom view for the person rows
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        // un-comment the next line to preview in dark mode
        //  .environment(\.colorScheme, .dark)
    }
}
