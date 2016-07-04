//
//  ListadoDeApps.swift
//  GRABILITY
//
//  Created by Carlos Buitrago on 24/06/16.
//  Copyright © 2016 Carlos Buitrago. All rights reserved.
//

import UIKit
import CoreData


class ListadoDeApps: UITableViewController {
    var categorias = ["negocios", "clima", "utilidades", "viaje", "deportes" ,"redes sociales" ,"referencia", "productividad", "foto y video", "noticias", "navegación", "música", "estilo de vida", "salud y belleza", "juegos", "finanzas", "entretenimiento", "educación", "Libros", "todo", "medical", "revista", "catalogo", "comidas y bebidas"]
    var top:Array<String> = Array<String>()
    var top2:Array<String> = Array<String>()
    var descripcion:Array<String> = Array<String>()
    var categoria:Array<String> = Array<String>()
    var autor:Array<String> = Array<String>()
    var posicion: Array<Int> = Array<Int>()
    var imagenes: Array<UIImage> = Array<UIImage>()
    var imagenes2: Array<UIImage> = Array<UIImage>()
    var tipo:Int = 0
    let urls = "https://itunes.apple.com/us/rss/topfreeapplications/limit=10/genre="
    var urls2 = ""
    var contexto:NSManagedObjectContext? = nil



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
        self.contexto = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        urls2 = urls + "\(tipo)" + "/json"
        let url = NSURL(string: urls2)
        let datos:NSData? = NSData(contentsOfURL: url!)
        self.title = categorias[tipo-6000]
        if datos == nil{
           
            
            let seccionEntidad = NSEntityDescription.entityForName("Categorias", inManagedObjectContext: self.contexto!)
            let peticion = seccionEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petCategoria", substitutionVariables: ["categoria": categorias[tipo-6000]])
            do{
                let secionEntidad2 = try self.contexto?.executeFetchRequest(peticion!)
                if (secionEntidad2?.count > 0){
                    let alert = UIAlertController(title:"Error", message: "No hay conexión a Internet, se han cargado datos almacenados.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                    //datos
                    
                    let peticion2 = seccionEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petCategoria", substitutionVariables: ["categoria": categorias[tipo-6000]])
                    do{
                        let seccionesEntidadG = try self.contexto?.executeFetchRequest(peticion2!)
                        for seccionesEntidad2G in seccionesEntidadG!{
                            let imagenesEntidadG = seccionesEntidad2G.valueForKey("tiene") as! Set<NSObject>
                            for imagenesEntidad2G in imagenesEntidadG{
                                let nom = imagenesEntidad2G.valueForKey("nombre") as! String
                                self.top2.append(nom)
                                let pos = imagenesEntidad2G.valueForKey("posicion") as! String
                                self.posicion.append(Int(pos)!)
                                let img = UIImage(data: imagenesEntidad2G.valueForKey("contenido") as! NSData)
                                self.imagenes2.append(img!)
                            }
                        }
                    }
                    catch{
                        
                    }
                    for i in 0 ..< posicion.count {
                        for j in 0 ..< posicion.count {
                            if posicion[j] == i{
                                top.append(top2[j])
                                imagenes.append(imagenes2[j])
                            }
                        }
                    }
                    return
                }
                else{
                    let alert = UIAlertController(title:"Error", message: "No hay conexión a Internet.", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                    presentViewController(alert, animated: true, completion: nil)
                }
            }
            catch{
                
            }
            
        }
        else {
            let seccionEntidad = NSEntityDescription.entityForName("Categorias", inManagedObjectContext: self.contexto!)
            let peticion = seccionEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petCategoria", substitutionVariables: ["categoria": categorias[tipo-6000]])
            do{
                let secionEntidad2 = try self.contexto?.executeFetchRequest(peticion!)
                if (secionEntidad2?.count > 0){
                    
                    //datos
                    
                    let peticion2 = seccionEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petCategoria", substitutionVariables: ["categoria": categorias[tipo-6000]])
                    do{
                        let seccionesEntidadG = try self.contexto?.executeFetchRequest(peticion2!)
                        for seccionesEntidad2G in seccionesEntidadG!{
                            let imagenesEntidadG = seccionesEntidad2G.valueForKey("tiene") as! Set<NSObject>
                            for imagenesEntidad2G in imagenesEntidadG{
                                let nom = imagenesEntidad2G.valueForKey("nombre") as! String
                                self.top2.append(nom)
                                let pos = imagenesEntidad2G.valueForKey("posicion") as! String
                                self.posicion.append(Int(pos)!)
                                let img = UIImage(data: imagenesEntidad2G.valueForKey("contenido") as! NSData)
                                self.imagenes2.append(img!)
                            }
                        }
                    }
                    catch{
                        
                    }
                    for i in 0 ..< posicion.count {
                        for j in 0 ..< posicion.count {
                            if posicion[j] == i{
                                top.append(top2[j])
                                imagenes.append(imagenes2[j])
                            }
                        }
                    }
                    return
                }
            }
            catch{
                
            }
 
            let nuevaSeccionEntidad = NSEntityDescription.insertNewObjectForEntityForName("Categorias", inManagedObjectContext: self.contexto!)
            nuevaSeccionEntidad.setValue(categorias[tipo-6000], forKey: "categoria")
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(datos!, options: NSJSONReadingOptions.MutableLeaves)
                let dico1 = json as! NSDictionary
                let dico2 = dico1["feed"] as! NSDictionary
                let dico3 = dico2["entry"] as! [NSDictionary]
                for i in dico3{
                    let apl = i["im:name"] as! NSDictionary
                    let app = apl["label"] as! NSString as String
                    self.top.append(app)
                    let desc = i["summary"] as! NSDictionary
                    let desc2 = desc["label"] as! NSString as String
                    self.descripcion.append(desc2)
                    let cat = i["category"] as! NSDictionary
                    let cat2 = cat["attributes"] as! NSDictionary
                    let cat3 = cat2["label"] as! NSString as String
                    self.categoria.append(cat3)
                    let aut = i["im:artist"] as! NSDictionary
                    let aut2 = aut["label"] as! NSString as String
                    self.autor.append(aut2)
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
            nuevaSeccionEntidad.setValue(crearAplicacionesEntidad(top,descripcion: descripcion,categoria: categoria,autor: autor,imagenes: imagenes).nombre, forKey: "tiene")
            nuevaSeccionEntidad.setValue(crearAplicacionesEntidad(top,descripcion: descripcion,categoria: categoria,autor: autor,imagenes: imagenes).posicion, forKey: "tiene")
            nuevaSeccionEntidad.setValue(crearAplicacionesEntidad(top,descripcion: descripcion,categoria: categoria,autor: autor,imagenes: imagenes).categoria, forKey: "tiene")
        }
    }
    
    func crearAplicacionesEntidad(nombres:[String],descripcion:[String],categoria:[String],autor:[String],imagenes:[UIImage])-> (nombre : Set<NSObject>, posicion: Set<NSObject>, imagen: Set<NSObject>, categoria: Set<NSObject>) {
        var entidades = Set<NSObject>()
        var entidades2 = Set<NSObject>()
        var entidades3 = Set<NSObject>()
        var entidades4 = Set<NSObject>()
        var entidades5 = Set<NSObject>()
        var entidades6 = Set<NSObject>()
        var cont = 0
        for nombre in nombres {
            let imagenEntidad = NSEntityDescription.insertNewObjectForEntityForName("Aplicaciones", inManagedObjectContext: self.contexto!)
            imagenEntidad.setValue(nombre, forKey: "nombre")
            entidades.insert(imagenEntidad)
            imagenEntidad.setValue("\(cont)", forKey: "posicion")
            entidades2.insert(imagenEntidad)
            imagenEntidad.setValue(UIImagePNGRepresentation(imagenes[cont]), forKey: "contenido")
            entidades3.insert(imagenEntidad)
            imagenEntidad.setValue(descripcion[cont], forKey: "descripcion")
            entidades4.insert(imagenEntidad)
            imagenEntidad.setValue(categoria[cont], forKey: "categoria")
            entidades5.insert(imagenEntidad)
            imagenEntidad.setValue(autor[cont], forKey: "autor")
            entidades6.insert(imagenEntidad)
            cont += 1
        }
        let resultado = (entidades,entidades2,entidades3,entidades4)
        return resultado
    }
    /*
    func crearImagenesEntidad(imagenes:[UIImage])-> Set<NSObject> {
        var entidades = Set<NSObject>()
        for imagen in imagenes {
            let imagenEntidad = NSEntityDescription.insertNewObjectForEntityForName("Aplicaciones", inManagedObjectContext: self.contexto!)
            imagenEntidad.setValue(UIImagePNGRepresentation(imagen), forKey: "contenido")
            entidades.insert(imagenEntidad)
        }
        return entidades
    }
 */

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
        if posicion.count == 0{
            let seccionEntidad = NSEntityDescription.entityForName("Categorias", inManagedObjectContext: self.contexto!)
            let peticion2 = seccionEntidad?.managedObjectModel.fetchRequestFromTemplateWithName("petCategoria", substitutionVariables: ["categoria": categorias[tipo-6000]])
            do{
                let seccionesEntidadG = try self.contexto?.executeFetchRequest(peticion2!)
                for seccionesEntidad2G in seccionesEntidadG!{
                    let imagenesEntidadG = seccionesEntidad2G.valueForKey("tiene") as! Set<NSObject>
                    for imagenesEntidad2G in imagenesEntidadG{
                        let pos = imagenesEntidad2G.valueForKey("posicion") as! String
                        self.posicion.append(Int(pos)!)
                    }
                }
            }
            catch{
                
            }
        }
        if ip == nil{
            cc.url = urls2
            cc.po = 0
        }
        else{
            cc.url = urls2
            cc.po = ip!.row
            cc.posicion = posicion
            cc.tipo = tipo
        }
        
    }

}
