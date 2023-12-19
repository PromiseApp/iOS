import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class ParticipantView: UIView{
    let disposeBag = DisposeBag()
    let participantViewModel: ParticipantViewModel
    
    let participantLabel = UILabel()
    let subView = UIView()
    let participantTableView = UITableView()
    
    init(participantViewModel: ParticipantViewModel) {
        self.participantViewModel = participantViewModel
        super.init(frame: .zero)
        bind()
        attribute()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(){
        participantViewModel.participantDriver
            .drive(participantTableView.rx.items(cellIdentifier: "ParticipantTableViewCell", cellType: ParticipantTableViewCell.self)) { row, friend, cell in
                cell.configure(with: friend)
            }
            .disposed(by: disposeBag)
        
    }
    
    func attribute(){
        self.backgroundColor = .white
        self.layer.cornerRadius = 8
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        
        participantLabel.do{
            $0.font = UIFont(name: "Pretendard-Medium", size: 13*Constants.standartFont)
            $0.text = "참여자"
        }
        
        participantTableView.do{
            $0.separatorStyle = .none
            $0.register(ParticipantTableViewCell.self, forCellReuseIdentifier: "ParticipantTableViewCell")
            $0.rowHeight = 40*Constants.standardHeight
        }
        
        subView.do{
            $0.backgroundColor = UIColor(named: "greyFive")
        }
        
    }
    
    func layout(){
        [participantLabel,subView,participantTableView]
            .forEach{ self.addSubview($0)}
        
        participantLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.top.equalToSuperview().offset(12*Constants.standardHeight)
        }
        
        subView.snp.makeConstraints { make in
            make.height.equalTo(70*Constants.standardHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        participantTableView.snp.makeConstraints { make in
            make.top.equalTo(participantLabel.snp.bottom).offset(4*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(subView.snp.top)
        }
        
    }
    
}
