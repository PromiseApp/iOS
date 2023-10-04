//import UIKit
//import Alamofire
//import RxSwift
//import RxCocoa
//import SnapKit
//
//struct res:Decodable{
//    let account: String
//    let id:Int
//    let nickname:String
//    let resultCode:Int
//    //let roles:[String:String]
//    var token:String
//}
//
//class TestViewController: UIViewController {
//    
//    private var provider: Provider = Provider()
//    var disposeBag = DisposeBag()
//    
//    var account: BehaviorRelay<String> = BehaviorRelay(value: "test1")
//    var password: BehaviorRelay<String> = BehaviorRelay(value: "1234")
//    var nickname: BehaviorRelay<String> = BehaviorRelay(value: "test1")
//    
//    var token = ""
//    
//    // 출력을 위한 변수
//    private var loginResponse: PublishSubject<LoginResponse> = PublishSubject()
//    
//    let button = UIButton()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(button)
//        button.setTitle("버튼", for: .normal)
//        button.snp.makeConstraints { make in
//            make.centerY.equalToSuperview()
//            make.centerX.equalToSuperview()
//            make.width.height.equalTo(150)
//        }
//        
//        button.rx.tap
//            .subscribe(onNext: { [weak self] _ in
//                self?.aa()
//            })
//            .disposed(by: disposeBag)
//        
//        //aaa()
//        bbb()
//        //ccc()
//        //fff()
//        
//    }
//    
//    
//    func aaa(){
//        let url = "http://43.201.252.19:8080/register"
//        let parameters: [String: String] = [
//            "account": "test4",
//            "password": "1234",
//            "nickname": "test4"
//        ]
//
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json",
//        ]
//
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//          .responseJSON { response in
//              if let statusCode = response.response?.statusCode {
//                  print("Status Code: \(statusCode)")
//              }
//
//              switch response.result {
//              case .success(let value):
//                  print("Response JSON: \(value)")
//              case .failure(let error):
//                  print("Error: \(error)")
//              }
//          }
//
//    }
//    
//    func bbb(){
//    
//        let url = "http://43.201.252.19:8080/login"
//        let parameters: [String: String] = [
//            "account": "test1",
//            "password": "1234",
//        ]
//
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json",
//        ]
//
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
//            .responseDecodable(of: res.self) { [self] response in
//              if let statusCode = response.response?.statusCode {
//                  print("Status Code: \(statusCode)")
//              }
//
//              switch response.result {
//              case .success(let decodedResponse):
//                  print("Decoded Response: \(decodedResponse)")
//                  print("Account: \(decodedResponse.account)")
//                  print("ID: \(decodedResponse.id)")
//                  print("Nickname: \(decodedResponse.nickname)")
//                  print("Result Code: \(decodedResponse.resultCode)")
//                  //print("Roles: \(decodedResponse.roles)")
//                  print("Token: \(decodedResponse.token)")
//                  token = decodedResponse.token
//
//              case .failure(let error):
//                  print("Error: \(error)")
//              }
//          }
//        
//    }
//    
//    func ccc(){
//        let url = "http://43.201.252.19:8080/aa/exists"
//        
//
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json",
//        ]
//
//        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
//          .responseJSON { response in
//              if let statusCode = response.response?.statusCode {
//                  print("Status Code: \(statusCode)")
//              }
//              switch response.result {
//              case .success(let value):
//                  print("Response JSON: \(value)")
//              case .failure(let error):
//                  print("Error: \(error)")
//              }
//          }
//        
//        
//        
//    }
//    
//    func fff(){
//        let loginAPI = LoginAPI.postRegister(account: account.value, password: password.value, nickname: nickname.value)
//        provider.request(loginAPI)
//            .subscribe(onNext: { [weak self] response in
//                // 로그인 성공
//                self?.loginResponse.onNext(response)
//                print(response)
//            }, onError: { error in
//                // 로그인 실패
//                print("Login failed with error: \(error)")
//            })
//            .disposed(by: disposeBag)
//    }
//    
//
//    func eee(){
//        let loginAPI = LoginAPI.postLogin(account: account.value, password: password.value)
//        provider.request(loginAPI)
//            .subscribe(onNext: { [weak self] response in
//                // 로그인 성공
//                self?.loginResponse.onNext(response)
//            }, onError: { error in
//                // 로그인 실패
//                print("Login failed with error: \(error)")
//            })
//            .disposed(by: disposeBag)
//    }
//    
//    func aa(){
//        let url = "http://43.201.252.19:8080/friend/requestList/test1"
//        print(123123213123123,token)
//
//        let headers: HTTPHeaders = [
//            "Content-Type": "application/json",
//            "Authorization": "Bearer \(token)"
//        ]
//
//        AF.request(url, method: .get, headers: headers)
//          .responseJSON { response in
//              if let statusCode = response.response?.statusCode {
//                  print("Status Code: \(statusCode)")
//              }
//              switch response.result {
//              case .success(let value):
//                  print("Response JSON: \(value)")
//              case .failure(let error):
//                  print("Error: \(error)")
//              }
//          }
//    }
//
//}
