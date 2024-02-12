import UserNotifications
import UIKit
import Intents


class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else { return }
        
        // imageUrl이 있는지 확인
//        if let imageUrlString = request.content.userInfo["imageUrl"] as? String, let imageUrl = URL(string: imageUrlString) {
//            // 이미지 다운로드 및 첨부
//            downloadAndAttachImage(from: imageUrl, to: bestAttemptContent)
//        } else {
//            // imageUrl이 없을 경우 기본 이미지 설정
//            bestAttemptContent.attachments = [createAttachmentForDefaultImage()]
//            contentHandler(bestAttemptContent)
//        }
        
        let avatar = INImage(imageData: UIImage(named: "user")!.pngData()!)
        let senderPerson = INPerson(
            personHandle: INPersonHandle(value: "unique-sender-id-2", type: .unknown),
            nameComponents: nil,
            displayName: "Sender name",
            image: avatar,
            contactIdentifier: nil,
            customIdentifier: nil,
            isMe: false,
            suggestionType: .none
        )

        let mePerson = INPerson(
            personHandle: INPersonHandle(value: "unique-me-id-2", type: .unknown),
            nameComponents: nil,
            displayName: nil,
            image: nil,
            contactIdentifier: nil,
            customIdentifier: nil,
            isMe: true,
            suggestionType: .none
        )
        let intent = INSendMessageIntent(recipients: [mePerson],
                                         outgoingMessageType: .outgoingMessageText,
                                         content: "Message content",
                                         speakableGroupName: nil,
                                         conversationIdentifier: "unique-conversation-id-1",
                                         serviceName: nil,
                                         sender: senderPerson,
                                         attachments: nil)

        intent.setImage(avatar, forParameterNamed: \.sender)
        // intent.setImage(avatar, forParameterNamed: \.speakableGroupName) // 그룹

        // interaction
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.direction = .incoming
        interaction.donate { error in
            if let error = error {
                print(error)
                return
            }
            
            do {
                // 이전 notification에 intent를 더해주고, 노티 띄우기
                let updatedContent = try request.content.updating(from: intent)
                contentHandler(updatedContent)
            } catch {
                print(error)
            }
        }
    }
    
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let bestAttemptContent = bestAttemptContent, let contentHandler = contentHandler {
            contentHandler(bestAttemptContent)
        }
    }
}
