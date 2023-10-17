import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ChatViewController: UIViewController {
    
    
    private let messageTextField = UITextField()
    private let sendButton = UIButton()
    private let chatTextView = UITextView()
    
    private let chatService = ChatService()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // 메시지 전송 버튼을 누르면 텍스트 필드의 메시지를 전송
        sendButton.rx.tap
            .withLatestFrom(messageTextField.rx.text.orEmpty)
            .bind { [weak self] message in
                if !message.isEmpty {
                    self?.chatService.send(message: message)
                    self?.messageTextField.text = ""  // 텍스트 필드 초기화
                }
            }
            .disposed(by: disposeBag)
        
        // 새 메시지를 받으면 TextView에 추가
        chatService.messages
            .bind { [weak self] message in
                self?.chatTextView.text.append("\(message)\n")
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chatService.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        chatService.disconnect()
    }
    
    private func setupUI() {
        // Chat TextView
        view.addSubview(chatTextView)
        chatTextView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
        
        // Message TextField
        view.addSubview(messageTextField)
        messageTextField.borderStyle = .roundedRect
        messageTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.right.equalToSuperview().offset(-70)
            make.height.equalTo(30)
        }
        
        // Send Button
        view.addSubview(sendButton)
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = .blue
        sendButton.snp.makeConstraints { make in
            make.left.equalTo(messageTextField.snp.right).offset(10)
            make.bottom.equalTo(messageTextField)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(50)
        }
    }
    
    // ... 나머지 코드
}
