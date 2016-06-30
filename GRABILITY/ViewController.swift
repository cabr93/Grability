//
//  ViewController.swift
//  GRABILITY
//
//  Created by Carlos Buitrago on 24/06/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    @IBOutlet weak var icono: UIImageView!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var autor: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var descripcion: UITextView!
    @IBOutlet weak var des: UILabel!
    
    @IBOutlet weak var eje: NSLayoutConstraint!


    
    
    var url = ""
    var po = 0

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        eje.constant -= view.bounds.width
        nombre.alpha = 0.0

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
 
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.eje.constant += self.view.bounds.width
            self.nombre.alpha = 1.0
            self.view.layoutIfNeeded()
            }, completion: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let ur = NSURL(string: url)
        let datos:NSData? = NSData(contentsOfURL: ur!)
        if datos == nil{
            let alert = UIAlertController(title:"Error", message: "No hay conexion a Internet", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        else {
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                let dico2 = dico1["feed"] as! NSDictionary
                let dico3 = dico2["entry"] as! [NSDictionary]
                var c = 0
                for i in dico3{
                    if c == po{
                        let apl = i["im:name"] as! NSDictionary
                        let app = apl["label"] as! NSString as String
                        var j = ""
                        let characters = Array(app.characters)
                        var cont = 0
                        var flag = true
                        for i in characters{
                            if i == "-"{
                                break
                            }
                            if cont > 35 && flag{
                                if i == " "{
                                    j = j + " \n"
                                    flag = false
                                }
                            }
                            cont++
                            j = j + "\(i)"
                        }
                        nombre.text = j
                        let foto = i["im:image"] as! [NSDictionary]
                        for j in foto{
                            let foto2 = j["label"] as! NSString as String
                            let fot = NSURL(string: foto2)
                            let dat = NSData(contentsOfURL: fot!)
                            icono.image = UIImage(data:dat!)
                        }
                        let aut = i["im:artist"] as! NSDictionary
                        let aut2 = aut["label"] as! NSString as String
                        
                        var j2 = ""
                        let characters2 = Array(aut2.characters)
                        var cont2 = 0
                        var flag2 = true
                        for i2 in characters2{
                            if i2 == "-"{
                                break
                            }
                            if cont2 > 10 && flag2{
                                if i2 == " "{
                                    j2 = j2 + " \n"
                                    flag2 = false
                                }
                            }
                            cont2++
                            j2 = j2 + "\(i2)"
                        }
                        
                        
                        autor.text = "  by " + j2
                        let cat = i["category"] as! NSDictionary
                        let cat2 = cat["attributes"] as! NSDictionary
                        let cat3 = cat2["label"] as! NSString as String
                        categoria.text =  "  " + cat3
                        let des = i["summary"] as! NSDictionary
                        let des2 = des["label"] as! NSString as String
                        descripcion.text = des2
                    }
                    c += 1
                }
                
            }
            catch _ {
                
            }
            icono.layer.cornerRadius = 10
            
        
        }
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

