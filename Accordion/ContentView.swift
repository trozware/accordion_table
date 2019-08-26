//
//  ContentView.swift
//  Accordion
//
//  Created by Sarah Reichelt on 24/08/2019.
//

import SwiftUI

struct ContentView: View {
    @State var company: Company = Company.demoCompany()

    var body: some View {
        NavigationView {
            DepartmentList(company: $company)
                .navigationBarTitle("Staff")
        }
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
                // set up and action for it, with different actions for different rows

                Button(action: { self.headerTapAction(for: dept.name) }) {
                    HeaderRowView(departmentName: dept.name)
                }
                .listRowBackground(Color(UIColor.secondarySystemBackground))

                if (dept.name == self.activeDept) {
                    ForEach(dept.persons) { person in
                        Button(action: { self.rowTapAction(for: person) }) {
                            DataRowView(person: person)
                        }
                    }
                }
            }
        }
    }

    func headerTapAction(for deptName: String) {
        if deptName == self.activeDept {
            // this header was already active so close all
            activeDept = ""
        } else {
            activeDept = deptName
        }
    }

    func rowTapAction(for person: Person) {
        self.company.toggleSignIn(for: person)
    }
}

struct HeaderRowView: View {
    // custom view for the department name header rows
    var departmentName: String

    var body: some View {
        Text(departmentName)
            .font(.headline)
            .foregroundColor(Color(UIColor.secondaryLabel))
    }
}

struct DataRowView: View {
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
