//
//  AppShowcaseView.h
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
import QuartzCore
import StoreKit
// Replace 'parthobiswas' with your developer name. make sure your
// developer name is typed like the above with no spaces or capital letters.
let DEV_NAME = "parthobiswas"

class AppShowcaseView: UITableViewController, SKStoreProductViewControllerDelegate {
    
    // TableView - show the logo, labels, etc...
    @IBOutlet weak var app_table: UITableView!
    // JSON parsing - data storage.
    var response_data: NSMutableData?
    // App list data - name, icon,
    // dev name, ratings and ids.
    var app_names: [AnyObject] = []
    var dev_names: [AnyObject] = []
    var app_icons: [AnyObject] = []
    var app_ids: [AnyObject] = []
    var app_ratings: [AnyObject] = []
    // How many apps need to be shown?
    // (Automatically processed).
    var result_count: Int = 0
    // Pull to refresh indicator.
    @IBOutlet weak var pull_indicator: UIRefreshControl!
    
    // Close view method.
    func close() {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    // Data load/reload method.
    
    func refresh() {
        // Start loading indicators.
        self.update_indicators(true)
        // Setup the JSON url and download the data on request.
        let link: String = "https://itunes.apple.com/search?term=\(DEV_NAME)&country=us&entity=software"
        let the_request: NSURLRequest = NSURLRequest(URL: NSURL(string: link)!)
        NSURLConnection(request: the_request, delegate: self)!
//        if the_connection != nil {
            response_data = NSMutableData()
//        }
    }
    // Indicator methods.
    
    func update_indicators(state: Bool) {
        // Start or stop the indicators depending
        // on the passed in loading state.
        if state == true {
            // Start the loading indicators.
            pull_indicator.beginRefreshing()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        else if state == false {
            // Stop the loading indicators.
            pull_indicator.endRefreshing()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
    }
    // Alert methods.
    
    func display_alert(alert_title: String, message: String) {
        // Display the info alert.
        let alert: UIAlertController = UIAlertController(title: alert_title, message: message, preferredStyle: .Alert)
        // Create the alert actions.
        let dismiss: UIAlertAction = UIAlertAction(title: "Dismiss", style: .Default, handler: {(action: UIAlertAction) -> Void in
        })
        // Add the action and present the alert.
        alert.addAction(dismiss)
        self.presentViewController(alert, animated: true, completion: { _ in })
    }
    // App logos will be cached to memory.
    var cached_images: NSMutableDictionary?
    
    /// VIEW DID LOAD ///
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.app_table.registerClass(CustomCell.self, forCellReuseIdentifier: "Cell")
        self.app_table.registerNib(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        // Do any additional setup after loading the view.
        // Link the pull to refresh to the refresh method.
        pull_indicator.addTarget(self, action: #selector(self.refresh), forControlEvents: .ValueChanged)
        // Set the pull to refresh indicator info text.
        var attributes: [String : AnyObject] = [String : AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.whiteColor()
        let title: NSAttributedString = NSAttributedString(string: "Pull to Refresh", attributes: attributes)
        pull_indicator.attributedTitle = NSAttributedString(attributedString: title)
        // Initilise the app logo image cache.
        self.cached_images = NSMutableDictionary()
        // Create the 'Done' button.
        let right_button: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(self.close))
        // Set the button colour.
        right_button.tintColor = UIColor.whiteColor()
        // Set the 'Done' button as the right
        // button on the navigation controller.
        self.navigationItem.rightBarButtonItem = right_button
        // Set the table view indicator colour.
        app_table.indicatorStyle = .White
        // Start loading the data.
        self.refresh()
    }
    /// CLOSE VIEW METHOD ///
    /// DATA LOAD/RELOAD METHOD ///
    /// INDICATOR METHODS ///
    /// ALERT METHODS ///
    /// CONNECTION DELEGATE METHODS ///
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError?) {
        // Stop loading indicators.
        self.update_indicators(false)
        // Get the error message.
        let error_msg: String = "Failed: \(error!.description)"
        // Display the error alert.
        self.display_alert("Error!", message: error_msg)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        response_data!.length = 0
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        response_data!.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        // Parse the downloaded JSON data.
//        var error: NSError? = nil
        var dict: NSDictionary = NSDictionary()
        dict = try! NSJSONSerialization.JSONObjectWithData(response_data!, options: NSJSONReadingOptions.MutableLeaves) as! [NSObject : AnyObject]
        // Store how many apps need to be loaded.
        result_count = dict["resultCount"] as! Int
        // Store the app data - name, icon, etc...
        app_names = dict.objectForKey("results")?.valueForKey("trackName") as! [AnyObject]
        app_names = dict.objectForKey("results")?.valueForKey("sellerName") as! [AnyObject]
        app_names = dict.objectForKey("results")?.valueForKey("artworkUrl512") as! [AnyObject]
        app_names = dict.objectForKey("results")?.valueForKey("trackId") as! [AnyObject]
        app_names = dict.objectForKey("results")?.valueForKey("averageUserRating") as! [AnyObject]
        
        // Stop loading indicators.
        self.update_indicators(false)
        // Data is now saved locally so lets
        // load it into the app table view.
        app_table.reloadData()
    }
    /// UITABLEVIEW METHODS ///
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Start loading indicators.
        self.update_indicators(true)
        // Get the selected cell App ID.
        let app_id: String = "\(app_ids[indexPath.row])"
        // Setup the store view controller.
        let store_view: SKStoreProductViewController = SKStoreProductViewController()
        store_view.delegate = self
        // Run the store view controller.
        store_view.loadProductWithParameters([SKStoreProductParameterITunesItemIdentifier: app_id], completionBlock: {(result: Bool, error: NSError?) -> Void in
            // Check if an error has occured otherwise
            // display the store view controller.
            if error != nil {
                // Hide the table view cell selection.
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
                // Stop loading indicators.
                self.update_indicators(false)
                // Display the error alert.
                self.display_alert("Error", message: "\(error!.description)")
            }
            else {
                // Display the store view controller.
                self.presentViewController(store_view, animated: true, completion: {() -> Void in
                    // Hide the table view cell selection.
                    tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    // Stop loading indicators.
                    self.update_indicators(false)
                })
            }
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Delegate call back for cell at index path.
        let CellIdentifier: String = "Cell"
        
        let cell = self.app_table.dequeueReusableCellWithIdentifier(CellIdentifier, forIndexPath: indexPath) as! CustomCell
        
        
//        if cell == nil {
//            var nib = NSBundle.mainBundle().loadNibNamed("CustomCell", owner: self, options: nil)
//            cell = nib[0] as! CustomCell
//        }
        // Set the intial image state
        // to display no picture.
        cell.logo_image.image = nil
        // Set the labels - name, info, etc...
        cell.name_label.text = "\(app_names[indexPath.row])"
        cell.dev_label.text = "\(dev_names[indexPath.row])"
        // Set the rating stars to the correct number
        // and then show the stars.
        var rating: Int
        if !(app_ratings[indexPath.row] is NSNull) {
            // Get the app rating number.
            rating = Int(app_ratings[indexPath.row] as! String)!
            // Show the appropriate number of star
            // images depending on the user rating.
            for loop in 0...rating {
                switch loop {
                case 1:
                    cell.star_1.alpha = 1.0
                case 2:
                    cell.star_2.alpha = 1.0
                case 3:
                    cell.star_3.alpha = 1.0
                case 4:
                    cell.star_4.alpha = 1.0
                case 5:
                    cell.star_5.alpha = 1.0
                default:
                    break
                }
            }
        }
        // Set the app logo in the imageview. We will also be caching
        // the images in asynchronously so that there is no image
        // flickering issues and so the UITableView uns smoothly
        // while being scrolled.
//        var identifier: String? = "Cell\(Int(indexPath.row))"
        let identifier: String? = "Cell" + String(indexPath.row)
        if (self.cached_images?.objectForKey(identifier!)) != nil {
            cell.logo_image.image = self.cached_images?.valueForKey(identifier!) as? UIImage
        }
        else {
            // Download the app image in a background thread.
            let downloadQueue: dispatch_queue_t = dispatch_queue_create("image downloader", nil)
            dispatch_async(downloadQueue, {() -> Void in
                // Get the app icon image url.
                let image_url: NSURL = NSURL(string: "\(self.app_icons[indexPath.row])")!
                // Download the image data.
                let data: NSData = NSData(contentsOfURL: image_url)!
                // Perform the UI updates on the main thread.
                dispatch_async(dispatch_get_main_queue(), {() -> Void in
                    // Set the image in the image view.
                    let image: UIImage = UIImage(data: data)!
                    cell.logo_image.image = image
                    // Save the image to cache.
                    self.cached_images![identifier!] = image
                    cell.logo_image.image = self.cached_images![identifier!] as? UIImage
                    // Content has been loaded into the cell, so stop
                    // the activity indicator from spinning.
                    cell.logo_active.stopAnimating()
                })
            })
        }
        // Apply image boarder effects. It looks
        // much nicer with rounded corners. You can
        // also apply other effect too if you wish.
        cell.logo_image.layer.cornerRadius = 16.0
        // Set the background colour.
        cell.backgroundColor = UIColor.clearColor()
        // Set the cell selected background colour.
        let background_view: UIView = UIView(frame: cell.frame)
        background_view.backgroundColor = UIColor(white: 1.0, alpha: 0.2)
        cell.selectedBackgroundView = background_view
        // Set the content restraints. Keep things in place
        // otherwise the image/labels dont seem to appear in
        // the correct position on the cell.
        cell.logo_image.clipsToBounds = true
        cell.name_label.clipsToBounds = true
        cell.dev_label.clipsToBounds = true
        cell.star_1.clipsToBounds = true
        cell.star_2.clipsToBounds = true
        cell.star_3.clipsToBounds = true
        cell.star_4.clipsToBounds = true
        cell.star_5.clipsToBounds = true
        cell.logo_active.clipsToBounds = true
        cell.contentView.clipsToBounds = false
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 116
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result_count
    }
    /// STORE VIEW METHODS ///
    
    func productViewControllerDidFinish(viewController: SKStoreProductViewController) {
        self.dismissViewControllerAnimated(true, completion: { _ in })
    }
    /// OTHER METHODS ///
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
