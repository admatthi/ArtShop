//
//  ExploreViewController.swift
//  Bottles
//
//  Created by Alek Matthiessen on 6/24/20.
//  Copyright © 2020 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseDatabase
import Kingfisher
import Kingfisher
import Photos
import FBSDKCoreKit


var bookindex = Int()
               var selectedauthor = String()
               var selectedtitle = String()
               var selectedurl = String()
               var selectedbookid = String()
               var selectedamazonurl = String()
               var selecteddescription = String()
               var selectedduration = Int()
        

var selectedgenre = String()
var selectedindex = Int()

var wishlistids = [String]()
var counter = Int()
var musictimer : Timer?
var updater : CADisplayLink?
var player : AVPlayer?
var referrer = String()
var selectedauthorimage = String()
var uid = String()
var ref : DatabaseReference?
var refer = String()

class ExploreViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var titleCollectionView: UICollectionView!
    var counter = 0
      //
    @IBOutlet weak var genreCollectionView: UICollectionView!
    var books: [Book] = [] {
          didSet {
              
              self.titleCollectionView.reloadData()

              
          }
      }
    
    var genres = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
          
          genres.removeAll()
          genres.append("Most Popular")
          genres.append("New")
          genres.append("Natural")
          genres.append("Vivid")
          genres.append("Bright")
          genres.append("High Contrast")
          genres.append("Detail")
          genres.append("Matte")
        
        selectedgenre = "Most Popular"


        
        if selectedgenre == "" || selectedgenre == "None" {
            
            selectedgenre = "Selfie"
            
            selectedindex = genres.firstIndex(of: selectedgenre)!
            
            genreCollectionView.reloadData()
            
        } else {
            
            print(selectedindex)
            
            selectedindex = genres.firstIndex(of: selectedgenre)!
            
            genreCollectionView.reloadData()
            
        }
        
        queryforids { () -> Void in
                 
             }

        // Do any additional setup after loading the view.
    }
    
    func queryforids(completed: @escaping (() -> Void) ) {
        
        titleCollectionView.alpha = 0
        
        var functioncounter = 0
        
        
        
        ref?.child("Art").child(selectedgenre).observeSingleEvent(of: .value, with: { (snapshot) in
            
            var value = snapshot.value as? NSDictionary
            
            print (value)
            
            if let snapDict = snapshot.value as? [String: AnyObject] {
                
                let genre = Genre(withJSON: snapDict)
                
                if let newbooks = genre.books {
                    
                    self.books = newbooks
                    
                    self.books = self.books.sorted(by: { $0.popularity ?? 0  > $1.popularity ?? 0 })
                    
                }
                
                //                                for each in snapDict {
                //
                //                                    functioncounter += 1
                //
                //                                    let ids = each.key
                //
                //                                    seemoreids.append(ids)
                //
                //
                //                                    if functioncounter == snapDict.count {
                //
                //                                        self.updateaudiostructure()
                //
                //                                    }
                //                                }
                
            }
            
        })
    }
    
    var genreindex = Int()
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            refer = "On Tap Discover"
            
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
            self.view.endEditing(true)
            titleCollectionView.isUserInteractionEnabled = true
            

            
            if collectionView.tag == 1 {
                
                selectedindex = indexPath.row
                
                genreCollectionView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: true)
                
                collectionView.alpha = 0
                
                selectedgenre = genres[indexPath.row]
                
                
                genreindex = indexPath.row
                
                queryforids { () -> Void in
                    
                }
                
                logCategoryPressed(referrer: referrer)
                
                            titleCollectionView.scrollToItem(at: indexPath, at: .top, animated: false)
    //            addstaticbooks()
                

                genreCollectionView.reloadData()
                
            } else {
                
                let book = self.book(atIndexPath: indexPath)
                
                //print("CELL ITEM===>", book ?? [])
                

                
                
                bookindex = indexPath.row
                selectedauthor = book?.author ?? ""
                selectedtitle = book?.title ?? ""
                selectedbookid = book?.bookID ?? ""
                selectedgenre = book?.genre ?? ""

                
                
                logUsePressed(referrer: referrer)

                    self.performSegue(withIdentifier: "ExploreToDetail", sender: self)

                
                
            }
            
            
            
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case self.genreCollectionView:
            return genres.count
        case self.titleCollectionView:
            return books.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView {
        // Genre collection
        case self.genreCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Categories", for: indexPath) as! CategoryCollectionViewCel
            
            collectionView.alpha = 1
            cell.titlelabel.text = genres[indexPath.row]
            //            cell.titlelabel.sizeToFit()
            
            //            cell.selectedimage.layer.cornerRadius = 5.0
            //            cell.selectedimage.layer.masksToBounds = true
            
            
            
            
            genreCollectionView.alpha = 1
            
            if selectedindex == 0 {
                
                if indexPath.row == 0 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
            }
            
            if selectedindex == 1 {
                
                if indexPath.row == 1 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 2 {
                
                if indexPath.row == 2 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 3 {
                
                if indexPath.row == 3 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 4 {
                
                if indexPath.row == 4 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
            }
            
            if selectedindex == 5 {
                
                if indexPath.row == 5 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 6 {
                
                if indexPath.row == 6 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 7 {
                
                if indexPath.row == 7 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            if selectedindex == 8 {
                
                if indexPath.row == 8 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 9 {
                
                if indexPath.row == 9 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 10 {
                
                if indexPath.row == 10 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 11 {
                
                if indexPath.row == 11 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 12 {
                
                if indexPath.row == 12 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 13 {
                
                if indexPath.row == 13 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 14 {
                
                if indexPath.row == 14 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 15 {
                
                if indexPath.row == 15 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 16 {
                
                if indexPath.row == 16 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 17 {
                
                if indexPath.row == 17 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 18 {
                
                if indexPath.row == 18 {
                    
                    cell.titlelabel.alpha = 1
                    cell.selectedimage.alpha = 1
                    
                } else {
                    
                    cell.titlelabel.alpha = 0.25
                    cell.selectedimage.alpha = 0
                    
                }
                
            }
            
            
            if selectedindex == 1000 {
                
                cell.titlelabel.alpha = 0.25
                cell.selectedimage.alpha = 0
            }
            
            return cell
            
        case self.titleCollectionView:
            let book = self.book(atIndexPath: indexPath)
            titleCollectionView.alpha = 1
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Books", for: indexPath) as! TitleCollectionViewCell
            //
            //            if book?.bookID == "Title" {
            //
            //                return cell
            //
            //            } else {
            

            
            let name = book?.inspiredby
            
            if (name?.contains(":"))! {
                
                var namestring = name?.components(separatedBy: ":")
                
                cell.titlelabel.text = namestring![0]
                
            } else {
                
                cell.titlelabel.text = name
                
            }
            
            //                    cell.tapup.tag = indexPath.row
            //
            //                    cell.tapup.addTarget(self, action: #selector(DiscoverViewController.tapWishlist), for: .touchUpInside)
            
            if let imageURLString = book?.after, let imageUrl = URL(string: imageURLString) {
                
                cell.titleImage.kf.setImage(with: imageUrl)
                
                
                
                cell.titleImage.layer.cornerRadius = 10.0
                cell.titleImage.clipsToBounds = true
                cell.titleImage.alpha = 1
                
                
                
                
                //                    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
                //                    let blurEffectView = UIVisualEffectView(effect: blurEffect)
                //                    blurEffectView.frame = cell.titleback.bounds
                //                    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                //                    cell.titleback.addSubview(blurEffectView)
                
                
            }
            
            let isWished = Bool()
            
            if wishlistids.contains(book!.bookID) {
                
                
            } else {
                
            }
            
            cell.layer.cornerRadius = 10.0
            cell.layer.masksToBounds = true
            
            cell.titlelabel.alpha = 1
            cell.titlelabel.alpha = 1
            
            if book?.views != nil {
                
                cell.viewslabel.text = book?.views
                
                
            } else {
                
                cell.viewslabel.text = "1.3M uses"
                
            }
            
            
            logFilterViewed(referrer: referrer)
            
            
            return cell
            
            //            }
            
        default:
            
            return UICollectionViewCell()
        }
        
    }
    
    
    func logUsePressed(referrer : String) {
          AppEvents.logEvent(AppEvents.Name(rawValue: "use pressed"), parameters: ["referrer" : referrer, "bookID" : selectedbookid, "genre" : selectedgenre])
      }
    
    func logCategoryPressed(referrer : String) {
        AppEvents.logEvent(AppEvents.Name(rawValue: "category pressed"), parameters: ["referrer" : referrer, "genre" : selectedgenre])
    }
    
    func logFilterViewed(referrer : String) {
        AppEvents.logEvent(AppEvents.Name(rawValue: "filter viewed"), parameters: ["referrer" : referrer, "bookID" : selectedbookid, "genre" : selectedgenre])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ExploreViewController {
          func book(atIndex index: Int) -> Book? {
              if index > books.count - 1 {
                  return nil
              }

              return books[index]
          }

          func book(atIndexPath indexPath: IndexPath) -> Book? {
              return self.book(atIndex: indexPath.row)
          }
      }
