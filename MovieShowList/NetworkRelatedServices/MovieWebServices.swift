//
//  MovieWebServices.swift
//  MovieShowList
//
//  Created by Macbook Pro on 6/3/23.
//

import UIKit

class MovieWebServices {
    static let shared = MovieWebServices()
    let API_KEY = "139a42a64413eecc49f5e7925bdb3c1c"
    
    enum endpoints{
        static let base = "https://api.themoviedb.org/3/"
        static let posterBaseURL = "https://image.tmdb.org/t/p/w200"
        
        case getMovieList
        
        var string_value: String{
            switch self {
            case .getMovieList:
                return endpoints.base + "search/movie"
            }
        }
        
        var url: URL{
            return URL(string: string_value) ?? URL(string: "")!
        }
    }
    
    // MARK: - Functions
    
    func getMovieList(page: Int, queryWord: String, completion: @escaping(_ movieList: MovieList?, _ error: String?)-> Void){
        if Utility.isConnectedToNetwork(){
            guard var urlComponents = URLComponents(string: endpoints.getMovieList.url.absoluteString) else {return}
            urlComponents.queryItems = [
                URLQueryItem(name: "api_key", value: API_KEY),
                URLQueryItem(name: "query", value: queryWord),
                URLQueryItem(name: "page", value: "\(page)"),
            ]
            guard let url = urlComponents.url else {return}
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    let error = error?.localizedDescription ?? "not found"
                    print("🔴 error in parsing Data: ", error)
                    completion(nil, error)
                    return
                }
                guard let data = data else { return}
                do {
                    let parsedMovieList = try JSONDecoder().decode(MovieList.self, from: data)
                    completion(parsedMovieList, nil)
                    
                } catch {
                    print("🔴 error in decoding Data: ", error)
                    completion(nil, error.localizedDescription)
                    return
                }
            }.resume()
        }else{
            completion(nil, "No Network")
        }
    }
}
