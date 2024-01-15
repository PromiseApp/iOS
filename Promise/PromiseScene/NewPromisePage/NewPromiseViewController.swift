import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Then
import SnapKit

class NewPromiseViewController: UIViewController {
    let disposeBag = DisposeBag()
    var newPromiseViewModel: NewPromiseViewModel
    
    let titleLabel = UILabel()
    let leftButton = UIButton()
    let separateView = UIView()
    let refreshControl = UIRefreshControl()
    lazy var newPromiseListTableView = UITableView()
    let absenceButton = UIButton()
    let participationButton = UIButton()
    
    init(newPromiseViewModel: NewPromiseViewModel) {
        self.newPromiseViewModel = newPromiseViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: Notification.Name("newPromiseNotificationRead"), object: nil)
        bind()
        attribute()
        layout()
    }
    
    private func bind(){
        
        leftButton.rx.tap
            .bind(to: newPromiseViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        absenceButton.rx.tap
            .bind(to: newPromiseViewModel.absenceButtonTapped)
            .disposed(by: disposeBag)
        
        participationButton.rx.tap
            .bind(to: newPromiseViewModel.participationButtonTapped)
            .disposed(by: disposeBag)
        
        newPromiseListTableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<NewPromiseSectionModel>(
            configureCell: { [weak self] (dataSource, tableView, indexPath, newPromiseView) -> UITableViewCell in
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewPromiseTableViewCell", for: indexPath) as! NewPromiseTableViewCell
                cell.configure(data: newPromiseView)

                return cell
            }
        )
        
        newPromiseViewModel.newPromiseDriver
            .map { promises in
                promises.map { NewPromiseSectionModel(model: $0, items: $0.isExpanded ? $0.newPromises : []) }
            }
            .drive(newPromiseListTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        newPromiseListTableView.rx.itemSelected
            .bind(to: newPromiseViewModel.cellSelected)
            .disposed(by: disposeBag)
        
        newPromiseListTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.absenceButton.isEnabled = true
                self?.absenceButton.alpha = 1
                self?.participationButton.isEnabled = true
                self?.participationButton.alpha = 1
            })
            .disposed(by: disposeBag)
        
        newPromiseViewModel.requestSuccessRelay
            .subscribe(onNext: { [weak self] selectedID in
                guard let self = self else { return }
                for index in self.newPromiseViewModel.newPromiseList.indices {
                    self.newPromiseViewModel.newPromiseList[index].newPromises.removeAll { $0.id == selectedID }
                }
                self.newPromiseViewModel.newPromiseRelay.accept(self.newPromiseViewModel.newPromiseList)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in
                self?.newPromiseViewModel.loadNewPromiseList()
            })
            .disposed(by: disposeBag)
        
        newPromiseViewModel.dataLoading
            .bind(onNext: { [weak self] loading in
                if(loading){
                    self?.refreshControl.endRefreshing()
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func attribute(){
        view.backgroundColor = .white
        
        titleLabel.do{
            $0.text = "새로운 약속"
            $0.font = UIFont(name: "Pretendard-SemiBold", size: 20*Constants.standartFont)
        }
        
        leftButton.do{
            $0.setImage(UIImage(named: "left"), for: .normal)
        }
        
        separateView.do{
            $0.backgroundColor = UIColor(named: "line")
        }
        
        newPromiseListTableView.do{
            $0.separatorStyle = .singleLine
            $0.register(NewPromiseTableViewCell.self, forCellReuseIdentifier: "NewPromiseTableViewCell")
            $0.register(PromiseHeaderCell.self, forHeaderFooterViewReuseIdentifier: "PromiseHeaderCell")
            $0.sectionHeaderTopPadding = 0
            $0.refreshControl = refreshControl
        }
        
        absenceButton.do{
            $0.setTitle("불참", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font =  UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prLight")
            $0.isEnabled = false
            $0.alpha = 0.3
        }
        
        participationButton.do{
            $0.setTitle("참여", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font =  UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
            $0.isEnabled = false
            $0.alpha = 0.3
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,absenceButton,participationButton,newPromiseListTableView]
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
        
        absenceButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(48*Constants.standardWidth)
            make.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        participationButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(48*Constants.standardWidth)
            make.leading.equalTo(absenceButton.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        newPromiseListTableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom)
            make.bottom.equalTo(participationButton.snp.top)
        }
        
    }
    
}
typealias NewPromiseSectionModel = SectionModel<NewPromiseHeader, NewPromiseCell>
extension NewPromiseViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PromiseHeaderCell") as! PromiseHeaderCell
        let promise = newPromiseViewModel.newPromiseRelay.value[section]
        header.configure(date: promise.date, isExpanded: promise.isExpanded)
        
        header.direButton.rx.tap
            .bind { [weak self] in
                self?.newPromiseViewModel.toggleSectionExpansion(at: section)
            }
            .disposed(by: header.disposeBag)
        
        return header
    }
}
