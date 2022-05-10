//
//  ContentView.swift
//  NewsNow
//
//  Created by Вячеслав Квашнин on 10.05.2022.
//

import SwiftUI

struct ContentView: View {
    @State private var news: [News] = []
    
    var body: some View {
        VStack {
            List(news.first?.articles ?? []) { article in
                Text(article.author ?? "")
                Text(article.title ?? "")
            }
        }.onAppear {
            Api().fetchNews { news in
                self.news.append(news)
                print(news)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class Api {
    func fetchNews(completion: @escaping (News) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=keyword&apiKey=f84617d6f65c41239470517b484e9596") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let result = try! JSONDecoder().decode(News.self, from: data!)
            completion(result)
        }.resume()
    }
}

struct News: Codable, Identifiable {
    let id = UUID()
    let articles: [Articles]
}

struct Articles: Codable, Identifiable {
    let id = UUID()
    let author: String?
    let title: String?
}
