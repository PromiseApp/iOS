import UIKit
import Alamofire
import RxSwift
import RxCocoa
import SnapKit

struct res:Decodable{
    let account: String
    let id:Int
    let nickname:String
    let resultCode:Int
    //let roles:[String:String]
    var token:String
}

class TestViewController: UIViewController {
    
    private var provider: Provider = Provider()
    var disposeBag = DisposeBag()
    
    var account: BehaviorRelay<String> = BehaviorRelay(value: "test1")
    var password: BehaviorRelay<String> = BehaviorRelay(value: "1234")
    var nickname: BehaviorRelay<String> = BehaviorRelay(value: "test1")
    
    var token = ""
    
    // 출력을 위한 변수
    private var loginResponse: PublishSubject<LoginResponse> = PublishSubject()
    
    let button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        login()
        
        view.addSubview(button)
        button.setTitle("버튼", for: .normal)
        button.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
        }
        
        button.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.zz()
            })
            .disposed(by: disposeBag)
        
        //aaa()
        //ccc()
        //fff()
        
    }
    
    
    
    func zz(){
        
        let parameters: [String: String] = [
            "startDateTime": "2023-09-11 00:00:00",
            "endDateTime": "2023-09-25 23:59:59",
        ]
        let token = UserManager.shared.userModel.token
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token ?? "")"
        ]
        
        AF.request("http://43.201.252.19:8080/promise/getPromiseList", method: .get, parameters: parameters, headers: headers).responseJSON { response in
            print(UserManager.shared.userModel.token)
            switch response.result {
            case .success(let value):
                print(value)
            case .failure(let error):
                print(error)
            }
        }
        
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
                    
                    UserManager.shared.userModel.token = decodedResponse.token
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        
    }
}
