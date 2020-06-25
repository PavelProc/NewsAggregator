
import Foundation
import CoreData

class CoreDataManager: NSObject {
    
    //MARK: - Singleton
    static let shared = CoreDataManager()
    
    //MARK: - Get
    var news: [NewsDataBase] {
        get {
            if let news = try? context.fetch(NewsDataBase.fetchRequest()) as? [NewsDataBase]{
                return news
            } else {
                return []
            }
        }
        set {
            
        }
        
    }
    
    var sites: [Site] {
        get {
            if let newsURLS = try? context.fetch(Site.fetchRequest()) as? [Site]{
                return newsURLS
            } else {
                return []
            }
        }
    }
    
    var timings: [TimerDataBase] {
        get {
            if let timings = try? context.fetch(TimerDataBase.fetchRequest()) as? [TimerDataBase]{
                return timings
            } else {
                return []
            }
        }
    }
    
    func addTiming(seconds: Double) {
        let timerDataBase = TimerDataBase(context: context)
        timerDataBase.seconds = seconds
        saveContext()
    }
    
    //MARK: - Add
    func addNews(news: News, site: Site) {
        let newsCoreData = NewsDataBase(context: context)
        newsCoreData.date = news.date
        newsCoreData.link = news.link
        newsCoreData.title = news.title
        newsCoreData.descriptionNews = news.description
        newsCoreData.imageURL = news.image
        newsCoreData.siteRelation = site
        saveContext()
    }
    
    func addURL(url: String ){
        let site = Site(context: context)
        site.url = url
        site.isActive = true
        saveContext()
    }
    
    
    //MARK: - Delete
    func deleteURL(site: Site) {
        context.delete(site)
        saveContext()
    }
    
    //MARK: - Edit
    func editNews(news: NewsDataBase) {
        saveContext()
    }
    
    
    func editURL(site: Site){
        saveContext()
    }
    
    //MARK: - Core data
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
