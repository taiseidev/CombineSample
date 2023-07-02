//
//  WebAPIViewModel.swift
//  CombineSample
//
//  Created by 大西　泰生 on 2023/07/02.
//

import Foundation
import Combine

class WebAPIViewModel: ObservableObject {
    // jokeというString型のメンバ変数を定義
    // @Publishedをつけることによって、変数の値が変更されるたびにViewに通知してくれる。
    @Published var joke: String = "デフォルト値"
    // 購読をキャンセルする場合に使用する
    private var cancellables: [AnyCancellable] = []
    
    init() {
        print("ViewModelのインスタンスが作成されました")
        fetchJoke()
    }
    
    // ViewModelのインスタンスが破棄される際に発火
    deinit {
        print("ViewModelが破棄されました")
        // Publisherの購読をキャンセルするAnyCancellableの配列から一つずつ取り出し、
        // cancel()メソッドを使って購読をキャンセルする
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    // ジョークを取得する
    func fetchJoke() {
        // guard節で適切なurlの場合はurl変数に格納。適切なurlでない場合はelseブロックを実行
        guard let url = URL(string: "https://icanhazdadjoke.com/") else {
            print("適切なurlではありません")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        // HTTPヘッダにリクエスト情報を追加
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTaskPublisher(for: urlRequest)
            .tryMap { (data: Data, _: URLResponse) in return data}
            .decode(type: JokeResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Finished..")
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: { [ weak self] response in
                self?.joke = response.joke
            })
            .store(in: &cancellables)
    }
}
