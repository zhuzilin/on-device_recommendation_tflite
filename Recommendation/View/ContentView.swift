//
//  ContentView.swift
//  Recommendation
//
//  Created by Zilin Zhu on 2021/1/25.
//

import SwiftUI

struct ContentView: View {
  @State var toggles: [Bool] = [Bool](repeating: false, count: 8)
  @ObservedObject var handler: RecommendationHandler
  
  init(handler: RecommendationHandler) {
    self.handler = handler
  }
  
  var body: some View {
      VStack {
        Header()
        ScrollView {
          VStack(alignment: .leading) {
            Note(text: "Please select your favorite movies.")
            ForEach(0..<handler.favoriteMovies.count) { i in
              Toggle(isOn: $toggles[i]) {
                Text(handler.favoriteMovies[i].title)
              }
              .onChange(of: toggles[i], perform: toggleChange)
              .padding(.horizontal)
              if i != 7 {
                Divider()
              }
            }
            Note(text: "Our recommendation for you:")
            ForEach(handler.recommendMovies) { movie in
              Text("[\(movie.id)] \(movie.title)")
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
          }
        }
      }
  }
  
  func toggleChange(_ value: Bool) {
    var selectedMovies: [MovieItem] = []
    for i in 0..<toggles.count {
      if toggles[i] {
        selectedMovies.append(handler.favoriteMovies[i])
      }
    }
    handler.recommend(basedOn: selectedMovies)
  }
}

struct Note: View {
  let text: String
  var body: some View {
    Text(text)
      .foregroundColor(.gray)
      .padding(.horizontal)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    let handler: RecommendationHandler
    do {
      handler = try RecommendationHandler()
    } catch let error {
      fatalError(error.localizedDescription)
    }
    return ContentView(handler: handler)
  }
}

