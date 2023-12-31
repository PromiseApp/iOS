import RxSwift
import RealmSwift
import RxCocoa
import RxFlow

class WithdrawPopupViewModel: Stepper{
    let disposeBag = DisposeBag()
    let steps = PublishRelay<Step>()
    
    let authService: AuthService
    
    let nicknameTextRelay = PublishRelay<String>()
    
    let cancelButtonTapped = PublishRelay<Void>()
    let okButtonTapped = PublishRelay<Void>()
    
    init(authService: AuthService) {
        self.authService = authService
        
        cancelButtonTapped
            .subscribe(onNext: { [weak self] in
                self?.steps.accept(MyPageStep.dismissView)
            })
            .disposed(by: disposeBag)
        
        okButtonTapped
            .flatMapLatest { [weak self] () -> Observable<Void> in
                guard let self = self else { return Observable.empty() }

                return self.authService.withdraw()
                    .asObservable()
                    .map{_ in Void()}
                    .catch { [weak self] error in
                        print("authService.withdraw",error)
                        self?.steps.accept(MyPageStep.networkErrorPopup)
                        return Observable.empty()
                    }

            }
            .subscribe(onNext: { [weak self] in
                do {
                    let realm = try Realm()
                    try realm.write {
                        realm.deleteAll()
                    }
                } catch {
                    print("Error clearing Realm data: \(error)")
                }
                self?.steps.accept(MyPageStep.dismissView)
                self?.steps.accept(MyPageStep.logoutCompleted)
            })
            .disposed(by: disposeBag)
        
    }
}
