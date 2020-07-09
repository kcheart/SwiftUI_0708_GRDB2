//
//  ContentView.swift
//  SwiftUI_0708_GRDB2
//
//  Created by Kevin Chen on 2020/7/8.
//  Copyright © 2020 Kevin Chen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var projects: [Project] { ContentView.getData() }
    @State var needRefresh: Bool = false
    
    var body: some View {
        VStack{
            HStack {
                Button("New", action: {
                    self.addRecord()
                })
                Spacer()
                Button("Refresh", action: {
                    self.needRefresh.toggle()
                    })
            }.padding()
            List(projects, id: \.id){ item in
                Text(item.name)
            }.background(self.needRefresh ? Color.red : Color.yellow)
        }
    }
    
    func addRecord() {
        do {
            try dbQueue.write { db in
                var project = Project(
                    name: "Getting started with GRDB",
                    description: "A blog post",
                    due: Date().addingTimeInterval(24 * 60 * 60),
                    isDraft: false
                )
                
                try! project.insert(db)
                
                print(project)
            }
        } catch {
            print("\(error)")
        }
    }
    
    static func getData() -> [Project] {
        var projects: [Project] = []
        do {
            try dbQueue.read { db in
                projects = try Project.fetchAll(db)
                
                print(projects)
            }
        } catch {
            print("\(error)")
        }
        return projects
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
