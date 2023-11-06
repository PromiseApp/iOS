//
//  SelectMemberResultViewController.swift
//  Promise
//
//  Created by 박중선 on 2023/11/06.
//

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
    let cancelButton = UIButton()
    let nextButton = UIButton()
        
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
        
        cancelButton.rx.tap
            .bind(to: selectMemberResultViewModel.leftButtonTapped)
            .disposed(by: disposeBag)
        
        nextButton.rx.tap
            .bind(to: selectMemberResultViewModel.nextButtonTapped)
            .disposed(by: disposeBag)
        
        selectMemberResultViewModel.resultMemberDriver
            .drive(tableView.rx.items(cellIdentifier: "SelectMemberResultTableViewCell", cellType: SelectMemberResultTableViewCell.self)) { row, friend, cell in
                cell.configure(with: friend)
                
                cell.failButton.rx.tap
                    .subscribe(onNext: {
                        cell.failButton.backgroundColor = UIColor(named: "prStrong")
                        cell.successButton.layer.borderWidth = 1
                        cell.successButton.layer.borderColor = UIColor(named: "line")?.cgColor
                        cell.successButton.backgroundColor = .white
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.successButton.rx.tap
                    .subscribe(onNext: {
                        cell.successButton.backgroundColor = UIColor(named: "prStrong")
                        cell.failButton.layer.borderWidth = 1
                        cell.failButton.layer.borderColor = UIColor(named: "line")?.cgColor
                        cell.failButton.backgroundColor = .white
                    })
                    .disposed(by: cell.disposeBag)
                
            }
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
        
        cancelButton.do{
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.titleLabel?.font =  UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prLight")
        }
        
        nextButton.do{
            $0.setTitle("완료", for: .normal)
            $0.setTitleColor(UIColor.black, for: .normal)
            $0.titleLabel?.font =  UIFont(name: "Pretendard-Medium", size: 16*Constants.standartFont)
            $0.backgroundColor = UIColor(named: "prStrong")
        }
        
    }
    
    private func layout(){
        [titleLabel,leftButton,separateView,cancelButton,nextButton,tableView]
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
        
        cancelButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(48*Constants.standardWidth)
            make.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        nextButton.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(48*Constants.standardWidth)
            make.leading.equalTo(cancelButton.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.leading.equalToSuperview()
            make.top.equalTo(separateView.snp.bottom)
            make.bottom.equalTo(nextButton.snp.top)
        }
        
        
    }
    
}




//#if DEBUG
//import SwiftUI
//struct Preview: UIViewControllerRepresentable {
//
//    // 여기 ViewController를 변경해주세요
//    func makeUIViewController(context: Context) -> UIViewController {
//        EmailAuthViewController(emailAuthViewModel: EmailAuthViewModel())
//    }
//
//    func updateUIViewController(_ uiView: UIViewController,context: Context) {
//    }
//}
//
//struct ViewController_PreviewProvider: PreviewProvider {
//    static var previews: some View {
//        Preview()
//            .edgesIgnoringSafeArea(.all)
//            .previewDisplayName("Preview")
//            .previewDevice(PreviewDevice(rawValue: "iPhone 13 Pro Max"))
//
//        Preview()
//            .edgesIgnoringSafeArea(.all)
//            .previewDisplayName("Preview")
//            .previewDevice(PreviewDevice(rawValue: "iPhoneX"))
//
//    }
//}
//#endif
