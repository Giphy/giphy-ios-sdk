//
//  SettingSection.swift
//  Example
//
//  Created by Jonny Mclaughlin on 6/11/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import GiphyUISDK

protocol Setting {
    static var title: String { get }
    static var cellId: String { get }
    static var itemCount: Int { get }
    static var itemHeight: CGFloat { get }
    static var columns: Int { get }
    var type: Setting.Type { get }
    var cases: [Any] { get }
    var string: String { get }
}

enum ConfirmationScreenSetting: Int {
    case off
    case on

    static var defaultSetting: ConfirmationScreenSetting {
        return .off
    }
}

enum ContentTypeSetting: Int {
    case multiple
    case single
}

extension GPHTheme: Setting {
    static var title: String { return "Theme" }
    static var cellId: String { return SettingCell.id }
    static var itemCount: Int { return 1 }
    static var itemHeight: CGFloat { return 30.0 }
    static var columns: Int { return 1 }
    var type: Setting.Type { return GPHTheme.self }
    var cases:[Any] { return [GPHTheme.light, GPHTheme.dark] }
    var string: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .automatic:
            return "Dark"
        @unknown default:
            return "Dark"
        }
    }
}

extension GPHGridLayout: Setting {
    static var title: String { return "Layout" }
    static var cellId: String { return SettingCell.id }
    static var itemCount: Int { return 1 }
    static var itemHeight: CGFloat { return 30.0 }
    static var columns: Int { return 1 }
    var type: Setting.Type { return GPHGridLayout.self }
    var cases: [Any] { return [GPHGridLayout.waterfall, GPHGridLayout.carousel] }
    var string: String {
        switch self {
        case .waterfall: return "Waterfall"
        case .carousel: return "Carousel"
        }
    }
}

extension ConfirmationScreenSetting: Setting {
    static var title: String { return "Confirmation Screen" }
    static var cellId: String { return SettingCell.id }
    static var itemCount: Int { return 1 }
    static var itemHeight: CGFloat { return 30.0 }
    static var columns: Int { return 1 }
    var type: Setting.Type { return ConfirmationScreenSetting.self }
    var cases: [Any] { return [ConfirmationScreenSetting.off, ConfirmationScreenSetting.on] }
    var string: String {
        switch self {
        case .on: return "On"
        case .off: return "Off"
        }
    }
}

extension ContentTypeSetting: Setting {
    static var title: String { return "Content Types" }
    static var cellId: String { return ContentTypeSettingCell.id }
    static var itemCount: Int { return 1 }
    static var itemHeight: CGFloat { return 32.0 }
    static var columns: Int { return 1 }
    var type: Setting.Type { return ContentTypeSetting.self }
    var cases: [Any] {
        if self == .single {
            return [GPHContentType.gifs, GPHContentType.stickers, GPHContentType.text]
        }
        return [GPHContentType.gifs, GPHContentType.stickers, GPHContentType.text, GPHContentType.emoji]
    }
    var string: String { return "" }
}
 
