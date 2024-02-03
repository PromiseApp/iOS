import RxCocoa
import RxFlow

class ChatViewModel: Stepper{
    let steps = PublishRelay<Step>()
}
