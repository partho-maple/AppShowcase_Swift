//
//  ViewController.h
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
class ViewController: UIViewController {
    
    // Buttons.
    @IBAction func open_gallery() {
        let gallery: UIStoryboard = UIStoryboard(name: "AppShowcase", bundle: nil)
        let view = gallery.instantiateInitialViewController()
        self.presentViewController(view!, animated: true, completion: { _ in })
    }
    
    /// BUTTONS ///
    /// VIEW DID LOAD ///
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Do any additional setup after loading the view, typically from a nib.
    }
    /// OTHER METHODS ///
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        // Dispose of any resources that can be recreated.
    }
}

