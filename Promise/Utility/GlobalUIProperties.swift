import Foundation

class GlobalUIProperties {
    static let shared = GlobalUIProperties()

    private init() {} // 외부에서 인스턴스 생성 방지

    var tabBarHeight: CGFloat = 0
}
