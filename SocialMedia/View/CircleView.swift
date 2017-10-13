//
//  CircleView.swift
//  SocialMedia
//
//  Created by Joseph  Ishak on 10/11/17.
//  Copyright © 2017 Joseph  Ishak. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }

}
