//
//  FileUtil.swift
//  Recommendation
//
//  Created by Zilin Zhu on 2021/1/25.
//

import Foundation

func loadMovieList(_ candidateListPath: String) -> [MovieItem] {
  if let path = Bundle.main.path(forResource: candidateListPath, ofType: "json") {
    do {
      let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
      let jsonResult = try JSONSerialization.jsonObject(with: data, options: [])
      var allMovies: [MovieItem] = []
      if let movies = jsonResult as? [[String: Any]] {
        for movie in movies {
          let id: Int32 = movie["id"] as! Int32
          let title: String = movie["title"] as! String
          let genres: [String] = movie["genres"] as! [String]
          let count: Int = movie["count"] as! Int
          allMovies.append(MovieItem(id: id, title: title, genres: genres, count: count))
        }
      }
      return allMovies
    } catch {
      fatalError("Couldn't code json file \(candidateListPath).json")
    }
  } else {
    fatalError()
  }
}
