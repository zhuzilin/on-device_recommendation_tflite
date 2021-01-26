// Copyright 2021 The TensorFlow Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

struct MovieItem: Identifiable, CustomStringConvertible, Equatable {
    static let JOINER = " | "
    static let DELIMITER_REGEX = "[|]"
    
    let id: Int32
    let title: String
    let genres: [String]
    let count: Int
    
    var description: String {
        "Id: \(id), title: \(title), count: \(count)"
    }
    
    static func ==(lhs: MovieItem, rhs: MovieItem) -> Bool {
        return lhs.id == rhs.id
    }
}

