import Foundation
import RxCocoa
import RxSwift

class MainViewModel{
    let yearAndMonth: BehaviorSubject<(year: Int, month: Int)> = BehaviorSubject(value: (Calendar.current.component(.year, from: Date()), Calendar.current.component(.month, from: Date())))

}
