//
//  ContentView.swift
//  Assignment Notebook 2
//
//  Created by Srishti Kamra  on 1/31/23.
//


import SwiftUI

struct ContentView: View {
    @ObservedObject var assignmentList = Assignment()
    @State private var showingAddItem = false
    @State private var showingSettings = false
    @State var mode: EditMode = .inactive
    var body: some View {
        NavigationView {
            //background image
            Image("studying")
                .resizable()
                .ignoresSafeArea()
                .frame(width: 399, height: 790, alignment: .center)
           
                .overlay(
                    List {
                        ForEach(assignmentList.assignment) { item in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(item.subject)
                                        .foregroundColor(subjectColor(color: item.subject))
                                        .font(.headline)
                                    Text(item.homework)
                                }
                                Spacer()
                                Text(mode.isEditing ? "" : "\(item.dueDate, style: .date)")
                            }
                        }
                        .onMove(perform: { indices, newOffset in
                            assignmentList.assignment.move(fromOffsets: indices, toOffset: newOffset)
                        })
                        .onDelete(perform: { indexSet in
                            assignmentList.assignment.remove(atOffsets: indexSet)
                        })
                    }
                    .navigationBarTitle("Assignment Notebook", displayMode: .inline)
               
                    .fullScreenCover(isPresented: $showingAddItem, content: {
                        AddItem(assignments: assignmentList)
                    })
                    .navigationBarItems(
                        leading:
                            EditButton(),
                        trailing:
                        Button(action: {
                            showingAddItem = true
                        }) {
                            Image(systemName: "plus.app")
                        .imageScale(.large)
                        })
                   
                    .environment(\.editMode, $mode)
                )
        }
        .preferredColorScheme(.light)
    }
    
    //color codes subjects like Notability
    func subjectColor (color : String) -> Color {
        switch color {
        case "Math":
            return .blue
        case "Science":
            return .green
        case "English":
            return .purple
        case "World Language":
            return .orange
        case "History":
            return .yellow
        case "PE":
            return .gray
        case "Mobile Apps":
            return .red
        case "College Apps":
            return .indigo
        default:
            return .black
        }
    }
    
   // Makes background clear in order to see the background 
    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
    }
}
struct AssignmentItem: Identifiable, Codable {
    var id = UUID()
    var subject = String()
    var homework = String()
    var dueDate = Date()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
