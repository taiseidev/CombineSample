//
//  WebAPIView.swift
//  CombineSample
//
//  Created by 大西　泰生 on 2023/07/02.
//

import SwiftUI

struct WebAPIView: View {
    @StateObject private var viewModel = WebAPIViewModel()
    
    var body: some View {
        VStack {
            Text("ジョーク")
            Text(viewModel.joke)
            Button(action: viewModel.fetchJoke) {
                Text("ジョークを取得")
            }
        }
    }
}

struct WebAPIView_Previews: PreviewProvider {
    static var previews: some View {
        WebAPIView()
    }
}
