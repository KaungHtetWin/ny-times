//
//  SearchArticleModel.swift
//  NYTimes
//
//  Created by Kaung Htet Win on 9/11/23.
//

import Foundation
// MARK: - Doc
struct Doc: Codable {
    let abstract: String?
    let webURL: String?
    let snippet, leadParagraph, printSection, printPage: String?
    let source: String?
    let multimedia: [Multimedia]?
    let headline: Headline?
    let keywords: [Keyword]?
    let pubDate: String?
    let documentType: String?
    let newsDesk, sectionName, subsectionName: String?
    let byline: Byline?
    let typeOfMaterial: String?
    let id: String?
    let wordCount: Int?
    let uri: String?

    enum CodingKeys: String, CodingKey {
        case abstract
        case webURL = "web_url"
        case snippet
        case leadParagraph = "lead_paragraph"
        case printSection = "print_section"
        case printPage = "print_page"
        case source, multimedia, headline, keywords
        case pubDate = "pub_date"
        case documentType = "document_type"
        case newsDesk = "news_desk"
        case sectionName = "section_name"
        case subsectionName = "subsection_name"
        case byline
        case typeOfMaterial = "type_of_material"
        case id = "_id"
        case wordCount = "word_count"
        case uri
    }
    
    func getImage(subtype: String = "largeHorizontal375") -> String? {
        let imageMedia = multimedia?.filter({ $0.type == .image && $0.subtype == subtype }).first
        return "https://static01.nyt.com/\(imageMedia?.url ?? "")"
    }
}

// MARK: - Byline
struct Byline: Codable {
    let original: String?
    let person: [Person]?
    let organization: String?
}

// MARK: - Person
struct Person: Codable {
    let firstname: String?
    let middlename: String?
    let lastname: String?
    let qualifier, title: String?
    let role: String?
    let organization: String?
    let rank: Int?
}

// MARK: - Headline
struct Headline: Codable {
    let main: String?
    let kicker: String?
    let contentKicker: String?
    let printHeadline: String?
    let name, seo, sub: String?

    enum CodingKeys: String, CodingKey {
        case main, kicker
        case contentKicker = "content_kicker"
        case printHeadline = "print_headline"
        case name, seo, sub
    }
}

// MARK: - Keyword
struct Keyword: Codable {
    let name: String?
    let value: String?
    let rank: Int?
    let major: String?
}

// MARK: - Multimedia
struct Multimedia: Codable {
    let rank: Int?
    let subtype: String?
    let caption, credit: String?
    let type: MediaType?
    let url: String?
    let height, width: Int?
    let legacy: Legacy?
    let subType, cropName: String?

    enum CodingKeys: String, CodingKey {
        case rank, subtype, caption, credit, type, url, height, width, legacy, subType
        case cropName = "crop_name"
    }
}

// MARK: - Legacy
struct Legacy: Codable {
    let xlarge: String?
    let xlargewidth, xlargeheight: Int?
    let thumbnail: String?
    let thumbnailwidth, thumbnailheight, widewidth, wideheight: Int?
    let wide: String?
}

// MARK: - Meta
struct Meta: Codable {
    let hits, offset, time: Int?
}
