//
//  RecommendationClient.swift
//  Recommendation
//
//  Created by Zilin Zhu on 2021/1/25.
//

import Foundation
import TensorFlowLite

class RecommendationHandler: ObservableObject {
    var allMovies: [MovieItem] = []
    
    var favoriteMovies: ArraySlice<MovieItem> {
        if allMovies.count < 8 {
            return allMovies[...]
        } else {
            return allMovies[..<8]
        }
    }
    
    var recommendMovies: [MovieItem] = []

    var candidates: [Int32: MovieItem] = [:]
    let config: Config
    var tflite: Interpreter? = nil

    struct Result: CustomStringConvertible {
        let id: Int
        let item: MovieItem
        let confidence: Float
        
        var description: String {
            return String(format: "[%d] confidence: %.3f, item: %s", id, confidence, "\(item)")
        }
    }

    init(config: Config = Config()) {
        self.config = config
        load()
    }
    
    func load() {
        loadModel()
        loadCandidateList()
    }

    func loadModel() {
        if let modelPath = Bundle.main.path(forResource: config.modelPath, ofType: "tflite") {
            var options = Interpreter.Options()
            options.threadCount = 1
            do {
                tflite = try Interpreter(modelPath: modelPath, options: options)
            } catch let error {
                print(error)
            }
        }
    }

    func loadCandidateList() {
        if let collections: [MovieItem] = loadMovieList(config.movieListPath) {
            allMovies = collections
            for item in collections {
                candidates[item.id] = item
            }
        }
    }
    
    func recommend(basedOn selectedMovies: [MovieItem]) {
        if selectedMovies.isEmpty {
            recommendMovies = []
            return
        }
        let inputs = preprocess(for: selectedMovies)
        do {
            let inputData = Data(copyingBufferOf: inputs)
            print(inputData)
            try tflite!.copy(inputData, toInputAt: 0)
        } catch let error {
            print(error)
        }
    }
    
    func preprocess(for movies: [MovieItem]) -> [Int32] {
        var results: [Int32] = [Int32](repeating: config.pad, count: config.inputLength)
        for i in 0..<movies.count {
            results[i] = movies[i].id
        }
        return results
    }
}
