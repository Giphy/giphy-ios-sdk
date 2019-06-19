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

enum IconButtonSetting: Int {
    case square
    case rounded
    case color
    case monochrome
}

enum LogoButtonSetting: Int {
    case square
    case rounded
}

enum GifButtonSetting {
    case pink
    case blue
    case monochrome
}

enum GifRoundButtonSetting {
    case pink
    case blue
    case monochrome
}

enum GifTextButtonSetting {
    case pink
    case blue
    case monochrome
}

enum ContentTypeButtonSetting {
    case pink
    case blue
    case monochrome
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

extension IconButtonSetting: Setting {
    static var title: String { return "Icon" }
    static var cellId: String { return ButtonCell.id }
    static var itemCount: Int { return 4 }
    static var itemHeight: CGFloat { return 70.0 }
    static var columns: Int { return 4 }
    var type: Setting.Type { return IconButtonSetting.self }
    var cases: [Any] { return [IconButtonSetting.square, IconButtonSetting.rounded, IconButtonSetting.color, IconButtonSetting.monochrome] }
    var string: String { return "" }
}

extension LogoButtonSetting: Setting {
    static var title: String { return "Logo" }
    static var cellId: String { return ButtonCell.id }
    static var itemCount: Int { return 2 }
    static var itemHeight: CGFloat { return 70.0 }
    static var columns: Int { return 2 }
    var type: Setting.Type { return LogoButtonSetting.self }
    var cases: [Any] { return [LogoButtonSetting.square, LogoButtonSetting.rounded] }
    var string: String { return "" }
}

extension GifButtonSetting: Setting {
    static var title: String { return "GIF - Hard Corners" }
    static var cellId: String { return ButtonCell.id }
    static var itemCount: Int { return 12 }
    static var itemHeight: CGFloat { return 70.0 }
    static var columns: Int { return 4 }
    var type: Setting.Type { return GifButtonSetting.self }
    var cases: [Any] { return [GifButtonSetting.monochrome, GifButtonSetting.blue, GifButtonSetting.pink] }
    var string: String { return "" }
}

extension GifRoundButtonSetting: Setting {
    static var title: String { return "GIF - Rounded Corners" }
    static var cellId: String { return ButtonCell.id }
    static var itemCount: Int { return 12 }
    static var itemHeight: CGFloat { return 70.0 }
    static var columns: Int { return 4 }
    var type: Setting.Type { return GifRoundButtonSetting.self }
    var cases: [Any] { return [GifRoundButtonSetting.monochrome, GifRoundButtonSetting.blue, GifRoundButtonSetting.pink] }
    var string: String { return "" }
}

extension GifTextButtonSetting: Setting {
    static var title: String { return "GIF Text" }
    static var cellId: String { return ButtonCell.id }
    static var itemCount: Int { return 3 }
    static var itemHeight: CGFloat { return 70.0 }
    static var columns: Int { return 4 }
    var type: Setting.Type { return GifTextButtonSetting.self }
    var cases: [Any] { return [GifTextButtonSetting.monochrome, GifTextButtonSetting.blue, GifTextButtonSetting.pink] }
    var string: String { return "" }
}

extension ContentTypeButtonSetting: Setting {
    static var title: String { return "Multi-Content" }
    static var cellId: String { return ButtonCell.id }
    static var itemCount: Int { return 18 }
    static var itemHeight: CGFloat { return 70.0 }
    static var columns: Int { return 3 }
    var type: Setting.Type { return ContentTypeButtonSetting.self }
    var cases: [Any] { return [ContentTypeButtonSetting.monochrome, ContentTypeButtonSetting.blue, ContentTypeButtonSetting.pink] }
    var string: String { return "" }
}
