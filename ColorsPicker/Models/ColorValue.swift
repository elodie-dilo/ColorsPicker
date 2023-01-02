//
//  ColorValue.swift
//  ColorsPicker
//
//  Created by Skander BAHRI on 02/01/2023.
//
import SwiftUI

struct ColorValue: Identifiable, Hashable, Equatable {
    var id: UUID = .init()
    var colorCode: String
    var title: String
    var color: Color
}

var colors: [ColorValue] = [
    .init(colorCode: "ff9ff3", title: "JIGGLYPUFF", color: Color("Color1")),
    .init(colorCode: "feca57", title: "CASANDORA YELLOW", color: Color("Color2")),
    .init(colorCode: "ff6b6b", title: "PASTEL RED", color: Color("Color3")),
    .init(colorCode: "48dbfb", title: "MEGAMAN", color: Color("Color4")),
    .init(colorCode: "1dd1a1", title: "WILD CAREBBEAN", color: Color("Color5")),
    .init(colorCode: "00d2d3", title: "JADE DEST", color: Color("Color6"))
]
