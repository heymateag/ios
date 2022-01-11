//
//  SettingsModel.swift
//  TelegramSample
//
//  Created by Heymate on 13/09/21.
//

import UIKit

struct RowItem {
    var isExpanded = false
    let imageName:String
    let title:String
    let items:[SettingsItem]
}

struct SettingsItem {
    let title:String
}
