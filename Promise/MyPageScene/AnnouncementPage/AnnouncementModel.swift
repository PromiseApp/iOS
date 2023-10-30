
struct AnnouncementHeader {
    let title: String
    let date: String
    let announcementContent: AnnouncementCell
    var isExpanded: Bool = false
}

struct AnnouncementCell {
    let content: String
}
