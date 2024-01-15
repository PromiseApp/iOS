import Foundation
import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

class SelectMemberResultViewController: UIViewController {
    var disposeBag = DisposeBag()
    var selectMemberResultViewModel: SelectMemberResultViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    lazy var tableView = UITableView()
        
    init(selectMemberResultViewModel: SelectMemberResultViewModel) {
        self.selectMemberResultViewModel = selectMemberResultViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        attribute()
        layout()
    }
   
    
    
    private func bind(){
        
        leftButton.rx.tap
            .bind(to: selectMemberResultViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        selectMemberResultViewModel.resultMemberDriver
            .drive(tableView.rx.items(cellIdentifier: "SelectMemberResultTableViewCell", cellType: SelectMemberResultTableViewCell.self)) { row, friend, cell in
                cell.configure(with: friend)
                
                cell.failButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        cell.failButton.backgroundColor = UIColor(named: "prStrong")
                        cell.successButton.layer.borderWidth = 1
                        cell.successButton.layer.borderColor = UIColor(named: "line")?.cgColor
                        cell.successButton.backgroundColor = .white
                        let nickname = cell.nameLabel.text
                        self?.selectMemberResultViewModel.failButtonTapped.accept(nickname ?? "")
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.successButton.rx.tap
                    .subscribe(onNext: { [weak self] in
                        cell.successButton.backgroundColor = UIColor(named: "prStrong")
                        cell.failButton.layer.borderWidth = 1
                        cell.failButton.layer.borderColor = UIColor(named: "line")?.cgColor
                        cell.failButton.backgroundColor = .white
                        let nickname = cell.nameLabel.text
                        self?.selectMemberResultViewModel.successButtonTapped.accept(nickname ?? "")
                    })
                    .disposed(by: cell.disposeBag)
                
            }
            .disposed(by: disposeBag)
        
        selectMemberResultViewModel.requestSuccessRelay
            .subscribe(onNext: { [weak self] nickname in
                guard let self = self else { return }
                self.selectMemberResultViewModel.allFriends.removeAll { $0.name == nickname }
                self.selectMemberResultViewModel.resultMemberRelay.accept(self.selectMemberResultViewModel.allFriends)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "친구 선택"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        tableView.do{
            $0.separatorStyle = .none
            $0.rowHeight = 48*Constants.standardHeight
            $0.register(SelectMemberResultTableViewCell.self, forCellReuseIdentifier: "SelectMemberResultTableViewCell")
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,tableView]
            .forEach{ view.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(56*Constants.standardHeight)
        }
        
        leftButton.snp.makeConstraints { make in
            make.width.height.equalTo(24*Constants.standardHeight)
            make.leading.equalToSuperview().offset(12*Constants.standardWidth)
            make.centerY.equalTo(titleLabel)
        }
        
        separateView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(1*Constants.standardHeight)
            make.leading.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(12*Constants.standardHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        
    }
    
}
