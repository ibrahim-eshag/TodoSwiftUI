//
//  ContentView.swift
//  TodoSwiftUI
//
//  Created by Amged on 4/6/22.
//

import SwiftUI

// MARK: - Todo Struct
struct Todo: Identifiable {
    let id = UUID()
    let category: String
    let name: String
}

struct ContentView: View {
    
    // MARK: - Properties
   @State private var todos = [
      Todo(category: "bed.double", name: "Sleep"),
      Todo(category: "chevron.left.forwardslash.chevron.right", name: "code the Restfull APIs for my billion dollars App"),
      Todo(category: "mouth.fill", name: "Eat"),
      Todo(category: "f.circle", name: "Finish the UI design in Figam"),
      Todo(category: "bed.double", name: "Sleep"),
      Todo(category: "gobackward", name: "Repeat"),
   ]
    @State private var showAddTodoView = false
    
    
    var body: some View {
     
        NavigationView {
           
                List{
                    ForEach(todos){ todo in
                        NavigationLink(destination: {
                            VStack{
                                Text(todo.name)
                                Image(systemName: todo.category).resizable().frame(width: 200, height: 200).scaledToFit()
                            }
                        }){
                            HStack {
                                Image(systemName: todo.category).frame(width: 50, height: 50)
                                Text(todo.name)
                            }
                        }
                    }
                    // allow deletion of items
                    .onDelete { indexSet in
                        todos.remove(atOffsets: indexSet)
                    }
                    // allow re-arranging of items
                    .onMove { indices, newOffset in
                        todos.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
                .navigationBarTitle("Todo Items")
                .navigationBarItems(leading: Button(action: {
                   
                    self.showAddTodoView.toggle()
                }, label: {
                    Text("Add")
                }).sheet(isPresented: $showAddTodoView ){
                    AddTodoView(showAddTodoView: self.$showAddTodoView, todos: self.$todos)
                }, trailing: EditButton())
           
        }
    }
    
    // MARK: - Methods
    func addTodo() {
        todos.append(Todo(category: "sleep", name: "New Item \(todos.count + 1)"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


    // MARK: - Add Todo item view
struct AddTodoView: View {
    
    @Binding var showAddTodoView: Bool
    
    @State private var name: String = ""
    @State private var selectedCategory = 0
    
    var categoryTypes = ["sleep","f.circle", "bed.double"]
    @Binding var todos: [Todo]
    
    var body: some View {
        VStack {
            Text("Add Todo View")
            TextField("To Do name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .border(Color.black)
                .padding()
            
            Text("Select Category")
            Picker("", selection: $selectedCategory){
                ForEach(0..<categoryTypes.count){
                    Text(self.categoryTypes[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
        }.padding()
        
        Button(action: {
            self.showAddTodoView = false // toggle the showAddTodoView from this view
            
            // append new item to the orignial todos
            todos.append(Todo(category: categoryTypes[selectedCategory], name:name ))
            
        }) {
            Text("Done")
        }
    }
    
}
