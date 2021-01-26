//
//  RecommendationApp.swift
//  Recommendation
//
//  Created by Zilin Zhu on 2021/1/25.
//

import SwiftUI

@main
struct RecommendationApp: App {
  var body: some Scene {
    let handler: RecommendationHandler
    do {
      handler = try RecommendationHandler()
    } catch let error {
      fatalError(error.localizedDescription)
    }
    return WindowGroup {
      ContentView(handler: handler)
    }
  }
}
