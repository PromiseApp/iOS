import RxAlamofire
import Foundation
import RxSwift

class Provider {
//    func request<T: Requestable & Responsable>(_ endPoint: T) -> Observable<T.ResponseType> {
//        let url = endPoint.baseURL.appendingPathComponent(endPoint.path)
//        
//        return RxAlamofire.requestJSON(endPoint.method, url, parameters: endPoint.parameters, headers: endPoint.headers)
//            .map { (response, value) -> T.ResponseType in
//                guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else {
//                    throw NSError(domain: "", code: -1, userInfo: nil)
//                }
//                return try JSONDecoder().decode(T.responseType.self, from: data)
//            }
//    }
}

