//
//  Config.swift
//  Recommendation
//
//  Created by Zilin Zhu on 2021/1/25.
//

import Foundation

let DEFAULT_MODEL_PATH: String = "model_history10_top100"
let DEFAULT_MOVIE_LIST_PATH: String = "sorted_movie_vocab"
let DEFAULT_INPUT_LENGTH: Int = 10
let DEFAULT_OUTPUT_LENGTH: Int = 100
let DEFAULT_TOP_K: Int = 10
let PAD_ID: Int32 = 0
let DEFAULT_FAVORITE_LIST_SIZE: Int = 8

struct Config {
  // TF Lite model path.
  var modelPath: String = DEFAULT_MODEL_PATH
  // Number of input ids from the model.
  var inputLength: Int = DEFAULT_INPUT_LENGTH
  // Number of output length from the model.
  var outputLength: Int = DEFAULT_OUTPUT_LENGTH
  // Number of max results to show in the UI.
  var topK: Int = DEFAULT_TOP_K
  // Path to the movie list.
  var movieListPath: String = DEFAULT_MOVIE_LIST_PATH

  // Id for padding.
  var pad: Int32 = PAD_ID;

  // The number of favorite movies for users to choose from.
  var favoriteListSize: Int = DEFAULT_FAVORITE_LIST_SIZE
}
