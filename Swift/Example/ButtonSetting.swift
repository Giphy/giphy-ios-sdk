//
//  ButtonSetting.swift
//  Example
//
//  Created by Jonny Mclaughlin on 6/11/19.
//  Copyright © 2019 GIPHY. All rights reserved.
//

import GiphyUISDK

protocol ButtonSetting {
    func buttons(theme: GPHTheme) -> [UIButton]
}

extension IconButtonSetting: ButtonSetting {
    func buttons(theme: GPHTheme) -> [UIButton] {
        guard let items = self.cases as? [IconButtonSetting] else { return [] }
        return items.map({
            let button = GPHGiphyButton()
            switch $0 {
            case .square: button.style = .iconSquare
            case .rounded: button.style = .iconSquareRounded
            case .color: button.style = .iconColor
            case .monochrome: button.style = (theme == .dark ? .iconWhite : .iconBlack)
            }
            return button
        })
    }
}

extension LogoButtonSetting: ButtonSetting {
    func buttons(theme: GPHTheme) -> [UIButton] {
        guard let items = self.cases as? [LogoButtonSetting] else { return [] }
        return items.map({
            let button = GPHGiphyButton()
            switch $0 {
            case .square: button.style = .logo
            case .rounded: button.style = .logoRounded
            }
            return button
        })
    }
}

extension GifButtonSetting: ButtonSetting {
    func buttons(theme: GPHTheme) -> [UIButton] {
        guard let items = self.cases as? [GifButtonSetting] else { return [] }
        let styles: [GPHGifButtonStyle] = [.rectangle, .rectangleOutline, .square, .squareOutline]
        let colors: [GPHGifButtonColor] = items.map({
            switch $0 {
            case .pink: return .pink
            case .blue: return .blue
            case .monochrome: return theme == .dark ? .white : .black
            }
        })
        var buttons: [UIButton] = []
        for color in colors {
            for style in styles {
                let button = GPHGifButton()
                button.color = color
                button.style = style
                buttons.append(button)
            }
        }
        return buttons
    }
}

extension GifRoundButtonSetting: ButtonSetting {
    func buttons(theme: GPHTheme) -> [UIButton] {
        guard let items = self.cases as? [GifRoundButtonSetting] else { return [] }
        let styles: [GPHGifButtonStyle] = [.rectangleRounded, .rectangleOutlineRounded, .squareRounded, .squareOutlineRounded]
        let colors: [GPHGifButtonColor] = items.map({
            switch $0 {
            case .pink: return .pink
            case .blue: return .blue
            case .monochrome: return theme == .dark ? .white : .black
            }
        })
        var buttons: [UIButton] = []
        for color in colors {
            for style in styles {
                let button = GPHGifButton()
                button.color = color
                button.style = style
                buttons.append(button)
            }
        }
        return buttons
    }
}

extension GifTextButtonSetting: ButtonSetting {
    func buttons(theme: GPHTheme) -> [UIButton] {
        guard let items = self.cases as? [GifTextButtonSetting] else { return [] }
        return items.map({
            let button = GPHGifButton()
            button.style = .text
            switch $0 {
            case .pink: button.color = .pink
            case .blue: button.color = .blue
            case .monochrome: button.color = (theme == .dark ? .white : .black)
            }
            return button
        })
    }
}

extension ContentTypeButtonSetting: ButtonSetting {
    func buttons(theme: GPHTheme) -> [UIButton] {
        guard let items = self.cases as? [ContentTypeButtonSetting] else { return [] }
        let outlineStyles: [GPHContentTypeButtonStyle] = [.stickersOutline, .emojiOutline, .textOutline]
        let solidStyles: [GPHContentTypeButtonStyle] = [.stickers, .emoji, .text]
        let colors: [GPHGifButtonColor] = items.map({
            switch $0 {
            case .pink: return .pink
            case .blue: return .blue
            case .monochrome: return theme == .dark ? .white : .black
            }
        })
        var buttons: [UIButton] = []
        for color in colors {
            for style in outlineStyles {
                let button = GPHContentTypeButton()
                button.style = style
                button.color = color
                buttons.append(button)
            }
        }
        
        for color in colors {
            for style in solidStyles {
                let button = GPHContentTypeButton()
                button.style = style
                button.color = color
                buttons.append(button)
            }
        }
        return buttons
    }
}
