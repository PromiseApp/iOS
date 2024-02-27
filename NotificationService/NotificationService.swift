import UserNotifications
import UIKit
import Intents
import Kingfisher

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else { return }

        var avatar = INImage(imageData: UIImage(named: "user")!.pngData()!)
        if let imageUrlString = request.content.userInfo["imageUrl"] as? String, let url = URL(string: imageUrlString) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let value):
                    let image = value.image
                    if let imageData = image.pngData() {
                        avatar = INImage(imageData: imageData)
                    }
                    let senderPerson = INPerson(
                        personHandle: INPersonHandle(value: "unique-sender-id-2", type: .unknown),
                        nameComponents: nil,
                        displayName: request.content.userInfo["nickname"] as? String,
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
                case .failure(let error):
                    print(error)
                }
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
