//
//  XKTableViewController.swift
//  xkcdProject
//
//  Created by brendan kerr on 10/28/16.
//  Copyright © 2016 b3k3r. All rights reserved.
//

import UIKit

struct JSONData {
    
    var title: String
    var imageSource: String
    var displayingImage: Bool = false
    
}

extension JSONData {
    init?(imageDictionary: [String: AnyObject]) {
        guard let t = imageDictionary["title"] as? String, var imgsrc = imageDictionary["img"] as? String else {
            return nil
        }
        
        title = t
        imgsrc.insert("s", at: imgsrc.index(imgsrc.startIndex, offsetBy: 4))
        print("SECURE IMAGE: \(imgsrc)")
        imageSource = imgsrc
    }
}


class XKTableViewController: UITableViewController {

    let imageCellReuse = "imageCell"
    let titleCellReuse = "titleCell"
    let webService: WebService = WebService()
    var images: [JSONData] = Array()
    var imagesAdded: Int = 0
    var imageCache = NSCache<NSString, NSData>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.register(XKImageTableViewCell.self, forCellReuseIdentifier: imageCellReuse)
        //tableView.register(XKTitleTableViewCell.self, forCellReuseIdentifier: titleCellReuse)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadTenImages()
        
    }
    
    func loadTenImages() {
        
        for index in 1...10 {
            webService.imageJSON(forImage: index) { data in
                if let valid = data {
                    self.images.append(valid)
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at:
                        [IndexPath(row: self.images.count-1, section: 0)]
                        , with: .automatic)
                    self.tableView.endUpdates()
                    
                }
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return images.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        let cellData = images[indexPath.row]
        if cellData.displayingImage {
            let imageCell = tableView.dequeueReusableCell(withIdentifier: imageCellReuse, for: indexPath) as! XKImageTableViewCell
            
            
            if let cellImageData = imageCache.object(forKey: cellData.title as NSString) as? Data {
                let image = UIImage(data: cellImageData)
                imageCell.xkcdImage.image = image
            } else {
                
                //Did this becuase when the image is being loaded for the first time there was a split
                //second where the last image loaded was being shown.  Dr. Shehab explained dequed cells
                //and i believe becuase of the nature of dequeing cells this is the reason why.
                imageCell.xkcdImage.image = nil
                
                webService.fetchImage(fromURL: cellData.imageSource) { data in
                    imageCell.xkcdImage.image = UIImage(data: data)
                    self.imageCache.setObject(data as NSData, forKey: cellData.title as NSString)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
            cell = imageCell
        } else {
            let titleCell = tableView.dequeueReusableCell(withIdentifier: titleCellReuse, for: indexPath) as! XKTitleTableViewCell
            titleCell.imageTitle.text = cellData.title
            cell = titleCell
        }

        print("CELLIMAGESIZE: \(cell.imageView?.frame)")
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
        let currentDisplaySetting = images[indexPath.row].displayingImage
        images[indexPath.row].displayingImage = !currentDisplaySetting
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if images[indexPath.row].displayingImage == true {
            return 150
        }
        return 44
    }
    
    

}




import Alamofire


final class WebService {
    
    var currentImagejsonURL: String!
    var imageCount: Int {
        didSet {
            currentImagejsonURL = "https://xkcd.com/\(imageCount)/info.0.json"
        }
    }
    
    init() {
        imageCount = 0
    }
    
    func imageJSON(forImage count: Int, Completion complete: @escaping (JSONData?) -> ()) {
        imageCount = count
        
        Alamofire.request(currentImagejsonURL, method: .get).responseJSON { response in
            
            let imagejson = response.result.value
            complete(JSONData(imageDictionary: imagejson as! [String : AnyObject]))
        }
    }
    
    func fetchImage(fromURL url: String, Completion complete: @escaping (Data) -> ()) {
        
        Alamofire.request(url).responseData { response in
            let imageData = response.result.value! as Data
            complete(imageData)
        }
    }
    
}


