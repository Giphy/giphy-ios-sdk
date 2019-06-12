//
//  GPHSettable.swift
//  Example
//
//  Created by Chris Maier on 3/12/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import GiphyUISDK

protocol Setting {
    var string: String { get }
    static var title: String { get }
    static var cases: [Setting] { get }
    var type: Setting.Type { get }
    var selectedIndex: Int { get }
}

enum ConfirmationScreenSetting: Int {
    case off
    case on
    
    static var defaultSetting: ConfirmationScreenSetting {
        return .off
    }
}

extension GPHTheme: Setting {
    static var cases: [Setting] { return [GPHTheme.light, GPHTheme.dark] }
    static var title: String { return "Theme" }
    var string: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    var type: Setting.Type { return GPHTheme.self }
    var selectedIndex: Int { return type.cases.firstIndex(where: { $0 as? GPHTheme == self }) ?? 0 }
}

extension ConfirmationScreenSetting: Setting {
    static var cases: [Setting] { return [ConfirmationScreenSetting.off, ConfirmationScreenSetting.on] }
    static var title: String { return "Confirmation Screen" }
    var string: String {
        switch self {
        case .on: return "On"
        case .off: return "Off"
        }
    }
    var type: Setting.Type { return ConfirmationScreenSetting.self }
    var selectedIndex: Int {
        return type.cases.firstIndex(where: { $0 as? ConfirmationScreenSetting == self}) ?? 0
    }
}

extension GPHGridLayout: Setting {
    static var cases: [Setting] { return [GPHGridLayout.waterfall, GPHGridLayout.carousel] }
    static var title: String { return "Layout" }
    var string: String {
        switch self {
        case .waterfall: return "Waterfall"
        case .carousel: return "Carousel"
        }
    }
    var type: Setting.Type { return GPHGridLayout.self }
    var selectedIndex: Int {
        return type.cases.firstIndex(where: { $0 as? GPHGridLayout == self }) ?? 0
    }
}

