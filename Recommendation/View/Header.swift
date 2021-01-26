//
//  Header.swift
//  Recommendation
//
//  Created by Zilin Zhu on 2021/1/26.
//

import SwiftUI

struct Header: View {
  var body: some View {
    Color.orange
      .ignoresSafeArea()
      .overlay(
        HStack {
          Text("TFL Recommendation")
                  .fontWeight(.semibold)
                  .foregroundColor(.white)
                  .font(.title)
                  .padding(.horizontal)
          Spacer()
        })
      .frame(maxHeight: 50)
  }
}

struct Header_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      Header()
      Spacer()
    }
    
  }
}
