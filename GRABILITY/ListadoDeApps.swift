//
//  ListadoDeApps.swift
//  GRABILITY
//
//  Created by Carlos Buitrago on 24/06/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit

class ListadoDeApps: UITableViewController {
    var categorias = ["negocios", "clima", "utilidades", "viaje", "deportes" ,"redes sociales" ,"referencia", "productividad", "foto y video", "noticias", "navegacion", "musica", "estilo de vida", "salud y bellesa", "juegos", "finanzas", "entretenimiento", "educacion", "Libros", "todo", "medical", "revista", "catalogo", "comidas y bebidas"]
    var top:Array<String> = Array<String>()
    var imagenes: Array<UIImage> = Array<UIImage>()
    var tipo:Int = 0
    let urls = "https://itunes.apple.com/us/rss/topfreeapplications/limit=10/genre="
    var urls2 = ""


    override func viewWillAppear(animated: Bool) {
        animateTable()
    }
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransformMakeTranslation(0, tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animateWithDuration(1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options:UIViewAnimationOptions.CurveLinear , animations: {
                cell.transform = CGAffineTransformMakeTranslation(0, 0);
                }, completion: nil)
            
            index += 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        urls2 = urls + "\(tipo)" + "/json"
        let url = NSURL(string: urls2)
        let datos:NSData? = NSData(contentsOfURL: url!)
        self.title = categorias[tipo-6000]
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
                for i in dico3{
                    let apl = i["im:name"] as! NSDictionary
                    let app = apl["label"] as! NSString as String
                    self.top.append(app)
                    let foto = i["im:image"] as! [NSDictionary]
                    var count = 0
                    for j in foto{
                        if count > 1 {
                            let foto2 = j["label"] as! NSString as String
                            let fot = NSURL(string: foto2)
                            let dat = NSData(contentsOfURL: fot!)
                            let imagen = UIImage(data:dat!)
                            self.imagenes.append(imagen!)
                        }
                        count += 1
                    }
                }
                
            }
            catch _ {
                
            }
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.top.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("celda2", forIndexPath: indexPath)
        
        // Configure the cell...
        
        cell.textLabel?.text = self.top[indexPath.row]
        cell.imageView!.image = self.imagenes[indexPath.row]
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let ip = self.tableView.indexPathForSelectedRow
        let cc = segue.destinationViewController as! ViewController
        if ip == nil{
            cc.url = urls2
            cc.po = 0
        }
        else{
            cc.url = urls2
            cc.po = ip!.row
        }
        
    }

}
