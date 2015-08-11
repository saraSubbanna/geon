import Foundation
import UIKit

class DraggableViewBackground: UIView, DraggableViewDelegate, UISearchBarDelegate, UIPickerViewDelegate {
    var storeNames: [String]!
    var storeNamesStorage: [String]!

    var MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 386
    let CARD_WIDTH: CGFloat = 290
    
    var cardsLoadedIndex: Int!
    var loadedCards: [DraggableView?]!
    var menuButton: UIButton!
    var messageButton: UIButton!
    var passButton: UIButton!
    var searchBar: UISearchBar!
    var filters_radius: UIButton!
    var filters_locations : UIButton!
    var vc = ViewController()
    
    var restaurant: [String]!
    var fastFood: [String]!
    var pet: [String]!
    var art: [String]!
    var sports: [String]!
    var media: [String]!
    var clothing: [String]!
    var other: [String]!
    
    
    var refreshed = false
    var flag = 0
    
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        super.layoutSubviews()
        self.setupView()
        storeNames = []
        
        // all types
        loadedCards = []
        cardsLoadedIndex = 0
        self.loadCards()
        searchBar.delegate = self
        
        var updateTimer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "repeat", userInfo: nil, repeats: true)
    }
    
    
    func repeat(){
        if(loadedCards.count<=0){
            self.loadCards()
            if (refreshed == true){
                for var i=0; i<flag; i++ {
                    swipeLeft()
                }
                refreshed = false
            }
        }
        
    }
    
    
    func setupView() -> Void {
        self.backgroundColor = UIColor(red: 0.92, green: 0.93, blue: 0.95, alpha: 1)
        passButton = UIButton(frame: CGRectMake(self.frame.size.width/2-(59/2), self.frame.size.height/2 + CARD_HEIGHT/2 + 30, 59, 59))
        passButton.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
        passButton.addTarget(self, action: "swipeLeft", forControlEvents: UIControlEvents.TouchUpInside)
        
        searchBar = UISearchBar(frame: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/12))
        searchBar.showsCancelButton = true
        
        
        
        
        filters_radius = UIButton(frame: CGRectMake(self.frame.size.width/2-59/2 + 50, self.frame.size.height/12, 59, self.frame.size.height/12))
        filters_radius.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
        filters_radius.addTarget(self, action: "pressed_radius", forControlEvents: UIControlEvents.TouchUpInside)
        
        filters_locations = UIButton(frame: CGRectMake(self.frame.size.width/2-59/2 - 50, self.frame.size.height/12, 59, self.frame.size.height/12))
        filters_locations.setImage(UIImage(named: "xButton"), forState: UIControlState.Normal)
        filters_locations.addTarget(self, action: "pressed_locations", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(passButton)
        self.addSubview(searchBar)
        self.addSubview(filters_radius)
        self.addSubview(filters_locations)
        
    }
    
    func pressed_radius(){
        vc.pressed_radius(self)
    }
    
    func pressed_locations()
    {
        vc.pressed_locations(self)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
    }
    
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        var index = find(storeNames, searchBar.text)
        var curIndex = find(storeNames, loadedCards[0]!.information.text!)
        if(index != nil){
            flag = index!
            var i=curIndex
            while(storeNames[i!] != storeNames[index!]){
                swipeLeft()
                if(i==storeNames.count-1){
                    i=0
                    refreshed = true
                }
                else{
                    i = i!+1
                }
            }
        }
    }
    
    func createDraggableViewWithDataAtIndex(index: NSInteger) -> DraggableView {
        var draggableView = DraggableView(frame: CGRectMake((self.frame.size.width - CARD_WIDTH)/2, (self.frame.size.height - CARD_HEIGHT)/2 + 20.0, CARD_WIDTH, CARD_HEIGHT))
        draggableView.information.text = storeNames[index]
        draggableView.delegate = self
        return draggableView
    }
    
    func loadCards() {
        if storeNames.count > 0 {
            let numLoadedCardsCap = storeNames.count > MAX_BUFFER_SIZE ? storeNames.count : MAX_BUFFER_SIZE
            for var i = 0; i < storeNames.count; i++ {
                var newCard: DraggableView = self.createDraggableViewWithDataAtIndex(i)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            for var i = 0; i < loadedCards.count; i++ {
                if i > 0 {
                    self.insertSubview(loadedCards[i]!, belowSubview: loadedCards[i - 1]!)
                } else {
                    self.addSubview(loadedCards[i]!)
                }
                cardsLoadedIndex = cardsLoadedIndex + 1
            }
        }
    }
    
    func cardSwipedLeft(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        
        if cardsLoadedIndex < storeNames.count {
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1]!, belowSubview: loadedCards[MAX_BUFFER_SIZE - 2]!)
        }
        
        
    }
    
    func cardSwipedRight(card: UIView) -> Void {
        loadedCards.removeAtIndex(0)
        
        if cardsLoadedIndex < loadedCards.count {
            cardsLoadedIndex = cardsLoadedIndex + 1
            self.insertSubview(loadedCards[MAX_BUFFER_SIZE - 1]!, belowSubview: loadedCards[MAX_BUFFER_SIZE - 2]!)
        }
        
    }
    
    func swipeRight() -> Void {
        
        if loadedCards.count <= 0 {
            return
        }
        var dragView: DraggableView = loadedCards[0]!
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.rightClickAction()
    }
    
    func swipeLeft() -> Void {
        
        if loadedCards.count <= 0 {
            return
        }
        var dragView: DraggableView = loadedCards[0]!
        dragView.overlayView.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        UIView.animateWithDuration(0.2, animations: {
            () -> Void in
            dragView.overlayView.alpha = 1
        })
        dragView.leftClickAction()
    }
}