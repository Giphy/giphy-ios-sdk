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

extension GPHThemeType: Setting {
    static var title: String { return "Theme" }
    static var cellId: String { return SettingCell.id }
    static var itemCount: Int { return 1 }
    static var itemHeight: CGFloat { return 30.0 }
    static var columns: Int { return 1 }
    var type: Setting.Type { return GPHThemeType.self }
    var cases:[Any] { return [GPHThemeType.light, GPHThemeType.dark, GPHThemeType.lightBlur, GPHThemeType.darkBlur] }
    var string: String {
        switch self {
        case GPHThemeType.light: return "Light"
        case GPHThemeType.dark: return "Dark"
        case GPHThemeType.automatic: return "Automatic"
        case GPHThemeType.lightBlur: return "Light Blur"
        case GPHThemeType.darkBlur: return "Dark Blur"
        @unknown default: return "Light"
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
        return [GPHContentType.gifs, GPHContentType.stickers, GPHContentType.text, GPHContentType.emoji, GPHContentType.recents]
    }
    var string: String { return "" }
}
 
