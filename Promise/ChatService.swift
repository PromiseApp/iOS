import Foundation
import RxSwift
import RxCocoa

class ChatService {
    private let manager = SocketManager(socketURL: URL(string: "http://43.201.252.19:8080")!, config: [.log(true)])
    private let socket: SocketIOClient
    
    var messages: Observable<String> {
        return messageRelay.asObservable()
    }
    
    private let messageRelay = PublishRelay<String>()

    init() {
        self.socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) { [weak self] data, ack in
            print("Socket connected")
            self?.subscribeToMessages()
        }
        
        socket.on("subscribe") { [weak self] data, ack in
            guard let message = data[0] as? String else { return }
            self?.messageRelay.accept(message)
        }
    }

    func connect() {
        socket.connect()
    }
    
    func disconnect(){
        socket.disconnect()
    }
    
    func send(message: String) {
        socket.emit("chat", message)
    }
    private func subscribeToMessages() {
        // "/topic/messages"를 구독합니다.
        socket.emit("subscribe", "/topic/messages") // <- 이렇게 구독하는 것에 대한 로직이 필요합니다.
        // 정확한 구독 방식은 서버와의 통신 방식에 따라 다를 수 있습니다.
    }
}
