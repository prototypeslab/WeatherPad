import UIKit
import Foundation
import WeatherKit
import CoreLocation

extension Bundle {

    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }

    var bundleId: String {
        return bundleIdentifier!
    }

    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }

    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }

}
class CollectionViewCell : UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet var temperature: UILabel!
    
    @IBOutlet var hour: UILabel!
    
    
}

class ViewController: UIViewController, UICollectionViewDataSource,CLLocationManagerDelegate
{

    let reuseIdentifier = "collectionViewCellId"
    
    @IBOutlet var currentWeatherSymbol: UIImageView!
    
    @IBOutlet var currentWeatherTemperature: UILabel!
    
    @IBOutlet var currentWeatherCondition: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet var amLabel: UILabel!
    
    @IBOutlet var tomorrowLabel: UILabel!
    
    @IBOutlet var afterTomorrowLabel: UILabel!
    
    @IBOutlet weak var tomorrowUIView: UIView!
    
    @IBOutlet weak var afterTomorrowUIView: UIView!
    
    @IBOutlet weak var tomorrowHour: UILabel!
    @IBOutlet weak var tomorrowImageView: UIImageView!
    @IBOutlet weak var tomorrowTemperature: UILabel!

    @IBOutlet weak var afterTomorrowHour: UILabel!
    @IBOutlet weak var afterTomorrowImageView: UIImageView!
    @IBOutlet weak var afterTomorrowTemperature: UILabel!

    @IBOutlet weak var dateLabel: UILabel!
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
 
        let weather = hourlyWeather[indexPath.row]
    
       
        let temperature = "\(Int(weather.temperature.converted(to: .fahrenheit).value))"
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"  // 'h' is for 12-hour format, 'a' is for AM/PM
        let date = formatter.string(from: weather.date)
        var imageIcon =  UIImage(systemName: "\(weather.symbolName).fill")?.withRenderingMode(.alwaysOriginal)
        if((imageIcon) != nil)
        {
            imageIcon =  UIImage(systemName: "\(weather.symbolName).fill")?.withRenderingMode(.alwaysOriginal)
        }
        else {
            imageIcon =  UIImage(systemName: "\(weather.symbolName)")?.withRenderingMode(.alwaysOriginal)
        }
            
        cell.imageView.image = imageIcon
        cell.hour.text = "\(date)"
        cell.temperature.text = "\(temperature)°F"
        
        Log.e("time: \(date)  temperature:\(temperature) icon:\(weather.symbolName) ")
        
        cell.hour.textColor = .cyan
        cell.temperature.textColor = .cyan
        
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.borderWidth = 2
        cell.contentView.layer.borderColor = UIColor.cyan.cgColor
        
        return cell
    }

    @IBOutlet var digit1: UIView!
    @IBOutlet var digit2: UIView!
    @IBOutlet var digit3: UIView!
    @IBOutlet var digit4: UIView!

    var didSetupConstraints = false
    let headerViewController = HeaderViewController()

    var unselectedTextAttributes: [NSAttributedString.Key: Any] = [
        .font : UIFont.systemFont(ofSize: 20),
        .foregroundColor : UIColor.darkGray
    ]
    var selectedTextAttributes: [NSAttributedString.Key: Any] = [
        .font : UIFont.systemFont(ofSize: 20),
        .foregroundColor : UIColor.white
    ]
    let versionLabel=UILabel()
    let updateLabel=UILabel()
    var testButton = UIButton(type: .custom)
    var optionsButton = UIButton(type: .custom)
   
    let segmentVC1 = SGSevenSegmentViewController()
    let segmentVC2 = SGSevenSegmentViewController()
    let segmentVC3 = SGSevenSegmentViewController()
    let segmentVC4 = SGSevenSegmentViewController()
    
    
    var clockTimer = ClockTimer()
    var currentTimeLabel = UITextField()
    var currentAmPmLabel = UITextField()
    var timer: Timer? = nil
    var timer2: Timer? = nil

    var locationManager: CLLocationManager!
    var location: CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    var locationLoaded = true
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location0 = locations.first {
            location = location0
            if(locationLoaded == true)
            {
                getLocation()
                locationLoaded = false
            }
           
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation()
        case .denied, .restricted:
            manager.stopUpdatingLocation()
            print("Location access denied/restricted")
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        @unknown default:
            print("Unknown authorization status")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        #if targetEnvironment(simulator)
        manager.stopUpdatingLocation()
        guard locationLoaded else { return }
        let defaultLocation = CLLocation(latitude: 40.7128, longitude: -74.0060)
        print("Simulator location unavailable; using New York City.")
        locationManager(manager, didUpdateLocations: [defaultLocation])
        #else
        print("Failed to find user's location: \(error.localizedDescription)")
        #endif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        view.backgroundColor = .black


        versionLabel.numberOfLines = 0
        versionLabel.lineBreakMode = .byClipping
        versionLabel.textColor = .gray
        versionLabel.font = UIFont.systemFont(ofSize: 12.0)
        versionLabel.text = "\(Bundle.main.appName) v \(Bundle.main.versionNumber) (Build \(Bundle.main.buildNumber))"
        self.view.addSubview(versionLabel)
        var updateDate=""
        updateDate="Never Update"
        updateLabel.numberOfLines = 0
        updateLabel.lineBreakMode = .byClipping
        updateLabel.textColor = .gray
        updateLabel.font = UIFont.systemFont(ofSize: 12.0)
        updateLabel.text = "Last Update Date: \(updateDate)"
 
        
        segmentVC1.view.frame = CGRect(x: 0, y: 0, width: 170, height: 300)
        segmentVC2.view.frame = CGRect(x: 0, y: 0, width: 170, height: 300)
        segmentVC3.view.frame = CGRect(x: 0, y: 0, width: 170, height: 300)
        segmentVC4.view.frame = CGRect(x: 0, y: 0, width: 170, height: 300)
        
        digit1.addSubview(segmentVC1.view)
        digit2.addSubview(segmentVC2.view)
        digit3.addSubview(segmentVC3.view)
        digit4.addSubview(segmentVC4.view)
        
        segmentVC1.display(value: 0)
        segmentVC2.display(value: 0)
        segmentVC3.display(value: 0)
        segmentVC4.display(value: 0)

        segmentVC1.color = .cyan
        segmentVC2.color = .cyan
        segmentVC3.color = .cyan
        segmentVC4.color = .cyan

        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateStrings), userInfo: nil, repeats: true)
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateLocation), userInfo: nil, repeats: true)

        
        tomorrowUIView.backgroundColor = .cyan
        afterTomorrowUIView.backgroundColor = .cyan
        
        let tomorrowPath = UIBezierPath(roundedRect: tomorrowUIView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 5, height: 5))
        
        let tomorrowMask = CAShapeLayer()
        tomorrowMask.path = tomorrowPath.cgPath
        tomorrowUIView.layer.mask = tomorrowMask
        tomorrowUIView.backgroundColor = .clear
        tomorrowUIView.layer.borderColor = UIColor.cyan.cgColor
        tomorrowUIView.layer.borderWidth = 2
        
        let afterTomorrowPath = UIBezierPath(roundedRect: afterTomorrowUIView.bounds,
                                byRoundingCorners: [.topLeft, .topRight],
                                cornerRadii: CGSize(width: 5, height: 5))
        
        let afterTomorrowMask = CAShapeLayer()
        afterTomorrowMask.path = afterTomorrowPath.cgPath
        afterTomorrowUIView.layer.mask = afterTomorrowMask
        afterTomorrowUIView.backgroundColor = .clear
        afterTomorrowUIView.layer.borderColor = UIColor.cyan.cgColor
        afterTomorrowUIView.layer.borderWidth = 2
        
        view.setNeedsUpdateConstraints()

    }
    override func updateViewConstraints() {
        
        if (!didSetupConstraints) {
            
            versionLabel.snp.makeConstraints { make in
                make.top.equalTo(view).inset(5)
                make.trailing.equalTo(view).inset(150)
            }
            
            currentWeatherSymbol.snp.makeConstraints { make in
                make.top.equalTo(view).inset(95)
                make.trailing.equalTo(view).inset(200)
                make.height.equalTo(102)
                make.width.equalTo(180)
            }
            currentWeatherTemperature.snp.makeConstraints { make in
                make.top.equalTo(view).inset(180)
                make.trailing.equalTo(view).inset(120)
                make.height.equalTo(190)
                make.width.equalTo(300)
            }
            currentWeatherCondition.snp.makeConstraints { make in
                make.top.equalTo(view).inset(349)
                make.trailing.equalTo(view).inset(100)
                make.height.equalTo(90)
                make.width.equalTo(280)
            }
            
            tomorrowUIView.snp.makeConstraints { make in
                make.top.equalTo(collectionView).inset(200)
                make.right.equalTo(collectionView).inset(180)
                make.height.equalTo(156)
                make.width.equalTo(130)
            }
            afterTomorrowUIView.snp.makeConstraints { make in
                make.top.equalTo(collectionView).inset(200)
                make.right.equalTo(collectionView).inset(40)
                make.height.equalTo(156)
                make.width.equalTo(130)
            }

            
            amLabel.snp.makeConstraints { make in
                make.bottom.equalTo(digit4)
                make.left.equalTo(digit4).inset(175)
                make.height.equalTo(63)
                make.width.equalTo(100)
            }
            
            dateLabel.snp.makeConstraints { make in
                make.top.equalTo(collectionView).inset(300)
                make.left.equalTo(collectionView).inset(120)
                make.height.equalTo(90)
                make.width.equalTo(700)
            }
            
            /*
            headerViewController.view.snp.makeConstraints { make in
                make.top.equalTo(view).inset(44)
                make.leading.equalTo(view).inset(10)
                make.trailing.equalTo(view).inset(10)
                make.height.equalTo(70)
            }
            segmentedControl.snp.makeConstraints { make in
                make.top.equalTo(headerViewController.view).inset(5)
                make.leading.equalTo(headerViewController.view)
                make.trailing.equalTo(headerViewController.view)
                make.height.equalTo(64)
            }
            
            pageView.snp.makeConstraints { make in
                make.top.equalTo(view).inset(120)
                make.leading.equalTo(view).inset(10)
                make.trailing.equalTo(view).inset(10)
                make.height.equalTo(200)
            }

            
            
            optionsButton.snp.makeConstraints { make in
                make.bottom.equalTo(view).inset(10)
                make.leading.equalTo(view).inset(10)
                make.width.equalTo(64)
                make.height.equalTo(64)
            }
            */
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }

    @objc func updateLocation() {
        getLocation()
    }

    func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    
    var militaryFormat = false
    
    
    @objc func updateStrings() {
 
        let formatterDate = DateFormatter()
        formatterDate.dateFormat = "h:mm"// "EEEE, MMM d, yyyy"
        let dateFormatterAmPm = DateFormatter()
        dateFormatterAmPm.dateFormat = "a"
        
        let amOrPmString = dateFormatterAmPm.string(from: Date())
        
        amLabel.text = amOrPmString


        var digit1value = 0
        var digit2value = 0
        var digit3value = 0
        var digit4value = 0

        
        let now = Date()

        let calendar = Calendar.current

        let components = calendar.dateComponents([.hour, .minute], from: now)

        var hour = 12
        var minute = 60
        
        hour = components.hour!
        minute = components.minute!
        if hour > 12 {
                hour -= 12
            } else if hour == 0 {
                hour = 12
            }
            
       

        
        
        segmentVC1.aSegment.state = true
        segmentVC1.bSegment.state = true
        segmentVC1.cSegment.state = true
        segmentVC1.dSegment.state = true
        segmentVC1.eSegment.state = true
        segmentVC1.fSegment.state = true
        segmentVC1.gSegment.state = true
        segmentVC1.view.isHidden = false
        if(hour > 9)
        {
            digit1value = 1
            digit2value = hour - 10
        }
        else
        {
            digit1value = 0
            digit2value = hour
            segmentVC1.aSegment.state = false
            segmentVC1.bSegment.state = false
            segmentVC1.cSegment.state = false
            segmentVC1.dSegment.state = false
            segmentVC1.eSegment.state = false
            segmentVC1.fSegment.state = false
            segmentVC1.gSegment.state = false
            segmentVC1.view.isHidden = true
        }
        
        segmentVC3.aSegment.state = true
        segmentVC3.bSegment.state = true
        segmentVC3.cSegment.state = true
        segmentVC3.dSegment.state = true
        segmentVC3.eSegment.state = true
        segmentVC3.fSegment.state = true
        segmentVC3.gSegment.state = true
        if(minute > 49)
        {
            digit3value = 5
            digit4value = minute - 50
        }
        else if(minute > 39)
        {
            digit3value = 4
            digit4value = minute - 40
        }
        else if(minute > 29)
        {
            digit3value = 3
            digit4value = minute - 30
        }
        else if(minute > 19)
        {
            digit3value = 2
            digit4value = minute - 20
        }
        else if(minute > 9)
        {
            digit3value = 1
            digit4value = minute - 10
        }
        else
        {
            digit3value = 0
            digit4value = minute
            segmentVC3.aSegment.state = false
            segmentVC3.bSegment.state = false
            segmentVC3.cSegment.state = false
            segmentVC3.dSegment.state = false
            segmentVC3.eSegment.state = false
            segmentVC3.fSegment.state = false
            segmentVC3.gSegment.state = false
        }
        segmentVC1.display(value: digit1value)
        segmentVC2.display(value: digit2value)
        segmentVC3.display(value: digit3value)
        segmentVC4.display(value: digit4value)
        

        
        let formatterTime = DateFormatter()
        formatterTime.dateStyle = .none
        formatterTime.timeStyle = .medium
        formatterDate.dateFormat = "EEEE, MMM d, yyyy"
        

        let dateString = formatterDate.string(from: now)
        

        dateLabel.text = dateString
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    @objc func testButtonTapped(sender : UIButton) {
        Log.w("testButtonTapped")
       }
    
    @objc func optionsButtonTapped(sender : UIButton) {
        Log.w("optionsButtonTapped")


       }
    public var hourlyWeather: [HourWeather] = []
    
    public  var hourlyWeatherAll: [HourWeather] = []
    
    func UTCToLocal(UTCDate: Date) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MMM-dd hh:mm:ss"
        let localDateString = dateFormatter.string(from: UTCDate)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MMM-dd hh:mm:ss"
        dateFormatter2.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        let localDate = dateFormatter2.date(from: localDateString)
        return localDate!
    }
    public private(set) var dailyWeather: [DayWeather] = []
    
    
    private func string(from day: Int) -> String {
        switch (day) {
        case 1:
            return "Monday"
        case 2:
            return "Tuesday"
        case 3:
            return "Wednesday"
        case 4:
            return "Thursday"
        case 5:
            return "Friday"
        case 6:
            return "Saturday"
        case 7:
            return "Sunday"
        default:
            return "Unavailable"
        }
    }
    
    private func getLocation() {
 
        WeatherManager.shared.getWeather(for: location) { [self] in
                
            
            
            
            DispatchQueue.main.async { [self] in

                 let dailyWeather = WeatherManager.shared.dailyWeather
                var index=0
                for weather in dailyWeather {
                    
                    let weekDay = Calendar.current.component(.weekday, from: weather.date)

                    let temperatureTomorrowMin = "\(Int(weather.lowTemperature.converted(to: .fahrenheit).value))°"
                    let temperatureTomorrowMax = "\(Int(weather.highTemperature.converted(to: .fahrenheit).value))°"
                   
                    
                  
                    Log.e("\(index) \(weather.date) :\(string(from: weekDay)) \(temperatureTomorrowMin)/\(temperatureTomorrowMax) , \(weather.condition)")

                    if(index==0)
                    {
                        tomorrowHour.text="\(string(from: weekDay))"
                        tomorrowImageView.image = UIImage(systemName: "\(weather.symbolName).fill")?.withRenderingMode(.alwaysOriginal)
                        tomorrowTemperature.text="\(temperatureTomorrowMin)/\(temperatureTomorrowMax)"
                    }
                    if(index==1)
                    {
                        afterTomorrowHour.text="\(string(from: weekDay))"
                        afterTomorrowImageView.image = UIImage(systemName: "\(weather.symbolName).fill")?.withRenderingMode(.alwaysOriginal)
                        afterTomorrowTemperature.text="\(temperatureTomorrowMin)/\(temperatureTomorrowMax)"

                    }
                    index += 1
                }
                }
            
            DispatchQueue.main.async { [self] in

                guard let currentWeather = WeatherManager.shared.currentWeather else { return }
                    Log.e("\(currentWeather.date)  currentWeather: \(currentWeather.condition),\(currentWeather.temperature),\(currentWeather.symbolName)")
                    currentWeatherSymbol.image = UIImage(systemName: "\(currentWeather.symbolName).fill")?.withRenderingMode(.alwaysOriginal)
                 
                currentWeatherCondition.text = currentWeather.condition.rawValue
                let temperature = "\(Int(currentWeather.temperature.converted(to: .fahrenheit).value))°"
                currentWeatherTemperature.text = temperature
                }

            
            hourlyWeatherAll = WeatherManager.shared.hourlyWeather

            var index = 0
            self.hourlyWeather.removeAll()
            for weather in self.hourlyWeatherAll {
                
                let date1 = Date()// Current date and time
                let date2 = weather.date
                var temp=0

                switch date1.compare(date2) {
                case .orderedDescending:
                    temp=0
                case .orderedSame:
                    temp=0
                case .orderedAscending:
                    
                    if(index < 13)
                    {
                        self.hourlyWeather.append(weather)
                    }
                    index += 1
                }

                if(temp==0)
                {
                temp=1
                }
                
                
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            }
    }
    

}

extension UIViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }

        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
