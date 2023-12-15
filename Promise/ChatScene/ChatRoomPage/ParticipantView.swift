import UIKit
import SnapKit
import Then

class ParticipantView: UIView{
    let participantLabel = UILabel()
    let participantTableView = UITableView()
    
    init() {
        super.init(frame: .zero)
        
        attribute()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func attribute(){
        participantLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.text = "참여자"
        }
        
        
        
    }
    
    func layout(){
        
    }
    
}
