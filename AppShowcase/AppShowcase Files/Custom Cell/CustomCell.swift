//
//  CustomCell.h
//  AppShowcase
//
//  Created by Partho Biswas on 16/08/2014.
//  Copyright (c) 2014 Partho Biswas. All rights reserved.
//
/*************************************************************
 * IMPORTANT NOTE:                                           *
 * This application has been designed for iOS 8 and higher,  *
 * some of the functionality of this application will NOT    *
 * work with lower versions of iOS.                          *
 *                                                           *
 * If you need any help, please send me an email:            *
 *                                                           *
 * partho.maple@gmail.com                                    *
 *************************************************************/
import UIKit
class CustomCell: UITableViewCell {

    // Name/dev labels.
    @IBOutlet var name_label: UILabel!
    @IBOutlet var dev_label: UILabel!
    // App logo image.
    @IBOutlet var logo_image: UIImageView!
    // Rating stars.
    @IBOutlet var star_1: UIImageView!
    @IBOutlet var star_2: UIImageView!
    @IBOutlet var star_3: UIImageView!
    @IBOutlet var star_4: UIImageView!
    @IBOutlet var star_5: UIImageView!
    // Image activity indictor.
    @IBOutlet var logo_active: UIActivityIndicatorView!


    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Initialization code.
        // Initialization code.
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
