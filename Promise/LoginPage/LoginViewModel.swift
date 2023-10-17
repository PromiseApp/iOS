import RxSwift
import RxCocoa
import Alamofire
import RxAlamofire
import RxFlow

class LoginViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let firstIsChecked = PublishRelay<Bool>()
    let secondIsChecked = BehaviorRelay(value: false)
    
    let loginButtonTapped = PublishRelay<Void>()
    let loginPossible = PublishRelay<Void>()
    
    let signupButtonTapped = PublishRelay<Void>()
    let findPwButtonTapped = PublishRelay<Void>()
    
    init(){
        loginButtonTapped
            .subscribe(onNext: {
                //self.login()
                self.steps.accept(AppStep.tabBar)
            })
            .disposed(by: disposeBag)
        
        signupButtonTapped
            .subscribe(onNext: {
                self.steps.accept(AppStep.signup)
            })
            .disposed(by: disposeBag)
        
        findPwButtonTapped
            .subscribe(onNext: {
                self.steps.accept(AppStep.findPw)
            })
            .disposed(by: disposeBag)
        
    }
    
    func login(){
    
        let url = "http://43.201.252.19:8080/login"
        let parameters: [String: String] = [
            "account": "pjs@gmail.com",
            "password": "1234",
        ]

        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: UserModel.self) { [self] response in
              if let statusCode = response.response?.statusCode {
                  print("Status Code: \(statusCode)")
              }

              switch response.result {
              case .success(let decodedResponse):
                  print("Decoded Response: \(decodedResponse)")
                  print("Account: \(decodedResponse.account)")
                  print("ID: \(decodedResponse.id)")
                  print("Nickname: \(decodedResponse.nickname)")
                  //print("Roles: \(decodedResponse.roles)")
                  print("Token: \(decodedResponse.token)")
                  UserManager.shared.userModel.token = decodedResponse.token
                  loginPossible.accept(())
              case .failure(let error):
                  print("Error: \(error)")
              }
          }
        
    }
}
