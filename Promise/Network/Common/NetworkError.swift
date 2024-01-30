import Moya
import Foundation

enum CustomError: Error {
    case noUserError
    case mappingError
}

protocol ErrorHandler {
    func handle(error: Error) -> (Int, String)
}

class NetworkErrorHandler: ErrorHandler {
    func handle(error: Error) -> (Int, String) {
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                if (400...499).contains(response.statusCode) {
                    switch response.statusCode {
                    case 401:
                        return (401, "인증에 실패했습니다.")
                    case 402:
                        return (402, "결제가 필요합니다.")
                    case 400:
                        return (400, "참가되지 않았거나 채팅방이 존재하지 않습니다.")
                    case 404:
                        return (404, "계정이 존재하지 않습니다.")
                    case 409:
                        return (409, "계정 또는 닉네임이 중복됩니다.")
                    case 420:
                        return (420, "로그인 실패: 아이디가 존재하지 않습니다.")
                    case 421:
                        return (421, "로그인 실패: 비밀번호가 일치하지 않습니다.")
                    case 422:
                        return (422, "친구 추가 실패: 해당 닉네임이 존재하지 않습니다.")
                    case 423:
                        return (423, "친구 추가 실패: 이미 요청이 보내졌거나 받아졌습니다.")
                    case 424:
                        return (424, "친구 추가 요청 수락 실패")
                    case 425:
                        return (425, "친구 추가 요청 거절 실패")
                    case 426:
                        return (426, "약속 초대 불가능")
                    case 427:
                        return (427, "약속 탈퇴 실패")
                    case 428:
                        return (428, "약속 삭제 실패")
                    case 430:
                        return (430, "약속 단건 조회 실패")
                    default:
                        return (response.statusCode, "클라이언트 에러입니다.")
                    }
                } else if (500...599).contains(response.statusCode) {
                    return (response.statusCode, "서버 에러입니다.")
                }
            case .underlying(let nsError as NSError, _):
                if nsError.domain == NSURLErrorDomain {
                    switch nsError.code {
                    case NSURLErrorNotConnectedToInternet:
                        return (nsError.code, "인터넷 연결이 없습니다.")
                    case NSURLErrorTimedOut:
                        return (nsError.code, "요청 시간이 초과되었습니다.")
                    case NSURLErrorCannotFindHost, NSURLErrorCannotConnectToHost:
                        return (nsError.code, "서버에 연결할 수 없습니다.")
                    default:
                        return (nsError.code, "네트워크 에러가 발생했습니다.")
                    }
                }
            default:
                return (0, "알 수 없는 에러가 발생했습니다.")
            }
        } else if let customError = error as? CustomError {
            switch customError {
            case .noUserError:
                return (1000, "사용자가 존재하지 않습니다.")
            case .mappingError:
                return (1001, "매핑 에러가 발생했습니다.")
            }
        }
        
        return (0, "알 수 없는 에러가 발생했습니다.")
    }
}
