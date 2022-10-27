// Created by Florian Schweizer on 27.10.22

import SwiftUI

enum NavigationPage: Codable, Hashable {
    case person(name: String)
    case plant(name: String)
}

// Credit: https://nilcoalescing.com/blog/SaveCustomCodableTypesInAppStorageOrSceneStorage/
extension [NavigationPage]: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
            let result = try? JSONDecoder().decode([NavigationPage].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
            let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct ContentView: View {
    @AppStorage("navigationPath") var navigationPath: [NavigationPage] = []
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List {
                NavigationLink("Flo", value: NavigationPage.person(name: "Flo"))
                NavigationLink("Tree", value: NavigationPage.plant(name: "Tree"))
            }
            .navigationDestination(for: NavigationPage.self) { page in
                switch page {
                    case .person(let name):
                        Text("Person: \(name)")
                        
                    case .plant(let name):
                        Text("Plant: \(name)")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
