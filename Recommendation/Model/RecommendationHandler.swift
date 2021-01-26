//
//  RecommendationHandler.swift
//  Recommendation
//
//  Created by Zilin Zhu on 2021/1/25.
//

import Foundation
import TensorFlowLite

// Handles
class RecommendationHandler: ObservableObject {
  @Published var recommendMovies: [MovieItem] = []

  var allMovies: [MovieItem] = []
  private var lastSelectedMovies: [MovieItem] = []
  var favoriteMovies: ArraySlice<MovieItem> {
    return allMovies[..<config.favoriteListSize]
  }

  var candidates: [Int32: MovieItem] = [:]
  let config: Config
  let interpreter: Interpreter

  init(
    config: Config = Config(),
    threadCount: Int = 1
  ) throws {
    self.config = config

    allMovies = loadMovieList(config.movieListPath)
    for item in allMovies {
      candidates[item.id] = item
    }

    // Construct the path to the model file.
    guard
      let modelPath = Bundle.main.path(
        forResource: config.modelPath,
        ofType: "tflite") else {
      fatalError("Failed to load the model file: \(config.modelPath)")
    }
    
    // Specify the options for the `Interpreter`.
    var options = Interpreter.Options()
    options.threadCount = threadCount

    interpreter = try Interpreter(modelPath: modelPath, options: options)
    try interpreter.allocateTensors()
    
    // Get allocated input `Tensors`s.
    let inputIdsTensor: Tensor
    
    inputIdsTensor = try interpreter.input(at: 0)
    
    // Get allocated output `Tensor`s.
    let outputIdsTensor: Tensor
    let outputScoresTensor: Tensor
    
    outputIdsTensor = try interpreter.output(at: 0)
    outputScoresTensor = try interpreter.output(at: 1)
    
    // Check if input and output `Tensor`s are in the expected formats.
    guard
      inputIdsTensor.shape.dimensions == [config.inputLength]
    else {
      fatalError("Unexpected model: Input Tensor shape")
    }
    
    guard
      outputIdsTensor.shape.dimensions == [config.outputLength]
        && outputScoresTensor.shape.dimensions == [config.outputLength]
    else {
      fatalError("Unexpected model: Output Tensor shape")
    }
  }

  func recommend(basedOn selectedMovies: [MovieItem]) {
    if selectedMovies.isEmpty {
      if !recommendMovies.isEmpty {
        recommendMovies = []
      }
      lastSelectedMovies = []
      return
    }
    if selectedMovies == lastSelectedMovies {
      return
    }
    lastSelectedMovies = selectedMovies
    
    // MARK: - Preprocessing
    let inputIds = preprocess(for: selectedMovies)
    
    // Convert input arrays to `Data` type.
    let inputIdsData = Data(copyingBufferOf: inputIds)

    // MARK: - Inferencing
    // let inferenceStartTime = Date()

    let outputIdsTensor: Tensor
    let outputScoresTensor: Tensor
    do {
      // Assign input `Data` to the `interpreter`.
      try interpreter.copy(inputIdsData, toInputAt: 0)
      
      // Run inference by invoking the `interpreter`
      try interpreter.invoke()
      
      // Get the output `Tenor` to process the inference results.
      outputIdsTensor = try interpreter.output(at: 0)
      outputScoresTensor = try interpreter.output(at: 1)
    } catch let error {
      print(error)
      return
    }
    
    // let inferenceTime = Date().timeIntervalSince(inferenceStartTime) * 1000
    
    // MARK: - Postprocessing
    recommendMovies = postprocessing(
        ids: outputIdsTensor.data.toArray(type: Int32.self),
        confidences: outputScoresTensor.data.toArray(type: Float.self))
  }
  
  // MARK: - Private functions
  
  /// Given a list of movie items, preprocess to get tflite input.
  private func preprocess(for movies: [MovieItem]) -> [Int32] {
    var inputIds: [Int32] = [Int32](repeating: config.pad, count: config.inputLength)
    for i in 0..<movies.count {
      inputIds[i] = movies[i].id
    }
    return inputIds
  }
  
  /// Get the top k movie recommendation with `ids`
  private func postprocessing(ids: [Int32], confidences: [Float]) -> [MovieItem] {
    var results: [MovieItem] = []
    for i in 0..<ids.count {
      let id = ids[i]
      if let movie = candidates[id] {
        results.append(movie)
        if results.count == config.topK {
          break
        }
      }
    }
    return results
  }
}
