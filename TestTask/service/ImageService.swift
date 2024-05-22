//
//  ImageService.swift
//  TestTask
//
//  Created by  Pavel Nepogodin on 21.05.24.
//

import Foundation

protocol ImageServiceProtocol {
    func loadImage(for url: URL, complition: @escaping (Data) -> Void)
    func fetchImages(
        page: Int,
        complition: @escaping ([ApiImageModel]) -> Void
    )
}

class ImageService: ImageServiceProtocol {
    func loadImage(for url: URL, complition: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, respnse, error) in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                complition(data)

                print("You get image from \(url)")
            }
        }.resume()
    }
    
    func fetchImages(page: Int, complition: @escaping ([ApiImageModel]) -> Void) {
        let address = "https://jsonplaceholder.typicode.com/photos/?albumId=\(page)"
        if let url = URL(string: address) {
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error {
                    print("Error: \(error)")
                } else if
                    let response = response as? HTTPURLResponse,
                    let data {
                    print("Status Code: \(response.statusCode)")
                    do {
                        let decoder = JSONDecoder()
                        let picInfo = try decoder.decode(
                            [ApiImageModel].self,
                            from: data
                        )
                        complition(picInfo)
                    } catch {
                        print(error)
                    }
                }
            }.resume()
        }
    }

}
