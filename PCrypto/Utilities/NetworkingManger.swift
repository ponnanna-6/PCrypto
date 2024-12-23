import Combine
//
//  NetworkingManger.swift
//  PCrypto
//
//  Created by Logycent on 23/12/2024.
//
import Foundation

class NetworkingManger {
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap({ try handleURLResponse(output: $0) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output)
        throws -> Data
    {
        guard let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300
        else {
            throw URLError(.badServerResponse)
        }
        return output.data
    }

    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
