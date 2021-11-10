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

 
enum DynamicTextSetting: Int {
    case off
    case on

    static var defaultSetting: DynamicTextSetting {
        return .off
    }
}
 

extension DynamicTextSetting: Setting {
    static var title: String { return "Dynamic Text" }
    static var cellId: String { return SettingCell.id }
    static var itemCount: Int { return 1 }
    static var itemHeight: CGFloat { return 30.0 }
    static var columns: Int { return 1 }
    var type: Setting.Type { return DynamicTextSetting.self }
    var cases: [Any] { return [DynamicTextSetting.off, DynamicTextSetting.on] }
    var string: String {
        switch self {
        case .on: return "On"
        case .off: return "Off"
        }
    }
}
  
//
enum ClipsPlaybackSetting: Int {
    case inline
    case popup

    static var defaultSetting: ClipsPlaybackSetting {
        return inline
    }
}

extension ClipsPlaybackSetting: Setting {
    static var title: String { return "Clips Playback Setting" }
    static var cellId: String { return SettingCell.id }
    static var itemCount: Int { return 1 }
    static var itemHeight: CGFloat { return 30.0 }
    static var columns: Int { return 1 }
    var type: Setting.Type { return ClipsPlaybackSetting.self }
    var cases: [Any] { return [ClipsPlaybackSetting.inline, ClipsPlaybackSetting.popup] }
    var string: String {
        switch self {
        case .inline: return "Inline"
        case .popup: return "Popup"
        }
    }
}
  

extension GPHRenditionType: Setting {
    static var title: String {
        return "Grid Rendition"
    }
    
    static var cellId: String {
        return SettingCell.id
    }
    
    static var itemCount: Int {
        return 1
    }
    
    static var itemHeight: CGFloat {
        return 30.0
    }
    
    static var columns: Int {
        return 1
    }
    
    var type: Setting.Type {
        return GPHRenditionType.self
    }
    
    var cases: [Any] {
        return [GPHRenditionType.fixedWidth, GPHRenditionType.downsized, GPHRenditionType.downsizedMedium, GPHRenditionType.preview]
    }
    
    var string: String {
        switch self {
        case GPHRenditionType.fixedWidth: return "Fixed-Width"
        case GPHRenditionType.downsized: return "Downsized"
        case GPHRenditionType.downsizedMedium: return "Downsized-Medium"
        case GPHRenditionType.preview: return "Preview"
        default: return ""
        }
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
        return [GPHContentType.recents, GPHContentType.gifs, GPHContentType.clips, GPHContentType.stickers, GPHContentType.text, GPHContentType.emoji ]
    }
    var string: String { return "" }
}
 
