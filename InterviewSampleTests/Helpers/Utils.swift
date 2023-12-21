import Foundation

func objectFromJson<T: Decodable>(path: String, decoder: JSONDecoder) throws -> T {
    let bundle = Bundle(for: SearchMediaServiceTests.self)
    guard let path = bundle.path(forResource: path, ofType: "json") else {
        throw Errors.fileIsMissing
    }
    
    let data = try String(contentsOfFile: path).data(using: .utf8)
    guard let unwrappedData = data else {
        throw Errors.dataIsMissingOrInIncorrectFormat
    }
    
    let result = try decoder.decode(T.self, from: unwrappedData)
    
    return result
}

func dataFromJsonFile(path: String) throws -> Data {
    let bundle = Bundle(for: SearchMediaServiceTests.self)
    guard let path = bundle.path(forResource: path, ofType: "json") else {
        throw Errors.fileIsMissing
    }
    
    let data = try String(contentsOfFile: path).data(using: .utf8)
    guard let unwrappedData = data else {
        throw Errors.dataIsMissingOrInIncorrectFormat
    }
    
    return unwrappedData
}

