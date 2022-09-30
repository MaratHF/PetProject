//
//  StatisticsViewController.swift
//  PetProject
//
//  Created by MAC  on 01.07.2022.
//

import UIKit
import Charts

enum WeekDayName: String {
    case sunday = "Вс"
    case monday = "Пн"
    case tuesday = "Вт"
    case wednesday = "Ср"
    case thursday = "Чт"
    case friday = "Пт"
    case saturday = "Сб"
}

enum MonthName: String {
    case january = "Янв"
    case february = "Фев"
    case march = "Март"
    case april = "Апр"
    case may = "Май"
    case june = "Июнь"
    case july = "Июль"
    case august = "Авг"
    case september = "Сент"
    case october = "Окт"
    case november = "Нояб"
    case december = "Дек"
}

class StatisticsViewController: UIViewController {

    private let items = ["7 дн",  "30 дн", "6 мес", "1 год"]
    
    private var segmentedControl: UISegmentedControl!
    private var average: UILabel!
    private var averageNum: UILabel!
    private var total: UILabel!
    private var totalNum: UILabel!
    private var barChart: BarChartView!
    
//    private let sleepDays = Array(SleepData().sleepDays.reversed())
    private var sleepDays = StorageManager.shared.fetchSleepDays()

    private var axisFormatDelegate: AxisValueFormatter!
    
    private var currentSleepDays: [SleepDay] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        axisFormatDelegate = self
        
        currentSleepDays = getElementsForDisplay(inNumber: 7, inArray: sleepDays)
        
        barChart = BarChartView(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.size.width,
            height: view.frame.size.width * 0.8
        ))
        setupChart()
        setupSubviews()
        setConstraints()
        setupTextForLabel()
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18)], for: .normal)
        
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(self, action: #selector(segmentedAction(sender:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sleepDays = StorageManager.shared.fetchSleepDays()
        currentSleepDays = getElementsForDisplay(inNumber: 7, inArray: sleepDays)
        setupChart()
        setupTextForLabel()
    }
    
    @objc private func segmentedAction(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            currentSleepDays = getElementsForDisplay(inNumber: 7, inArray: sleepDays)
        case 1:
            currentSleepDays = getElementsForDisplay(inNumber: 30, inArray: sleepDays)
        case 2:
            currentSleepDays = getElementsForDisplay(inNumber: 180, inArray: sleepDays)
        default:
            currentSleepDays = getElementsForDisplay(inNumber: 365, inArray: sleepDays)
        }
        setupTextForLabel()
        setupChart()
    }
    
    private func setupSubviews() {
        segmentedControl = UISegmentedControl(items: items)
        view.addSubview(segmentedControl)
        
        average = UILabel()
        average.text = "В среднем"
        average.font = UIFont.systemFont(ofSize: 25)
        average.textColor = .white
        average.adjustsFontSizeToFitWidth = true
        view.addSubview(average)
        
        total = UILabel()
        total.text = "Всего"
        total.font = UIFont.systemFont(ofSize: 25)
        total.textColor = .white
        total.adjustsFontSizeToFitWidth = true
        view.addSubview(total)
        
        averageNum = UILabel()
        averageNum.font = UIFont.systemFont(ofSize: 25)
        averageNum.textColor = .white
        averageNum.adjustsFontSizeToFitWidth = true
        view.addSubview(averageNum)
        
        totalNum = UILabel()
        totalNum.font = UIFont.systemFont(ofSize: 26)
        totalNum.textColor = .white
        totalNum.adjustsFontSizeToFitWidth = true
        view.addSubview(totalNum)

        view.addSubview(barChart)
    }
    
    private func setConstraints() {
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        average.translatesAutoresizingMaskIntoConstraints = false
        total.translatesAutoresizingMaskIntoConstraints = false
        averageNum.translatesAutoresizingMaskIntoConstraints = false
        totalNum.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            average.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 50),
            average.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            average.widthAnchor.constraint(equalToConstant: view.frame.size.width/3.3),
            total.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 50),
            total.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30 - view.frame.size.width/2.8),
            total.widthAnchor.constraint(equalToConstant: view.frame.size.width/6),
            averageNum.topAnchor.constraint(equalTo: average.bottomAnchor, constant: 1),
            averageNum.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            averageNum.widthAnchor.constraint(equalToConstant: view.frame.size.width/3.2),
            totalNum.topAnchor.constraint(equalTo: total.bottomAnchor, constant: 1),
            totalNum.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            totalNum.widthAnchor.constraint(equalToConstant: view.frame.size.width/2.8)
        ])

        barChart.center = CGPoint(x: view.frame.size.width / 2, y: view.frame.size.height * 0.58)
    }
    
    private func setupChart() {
        let marker = PillMarker(
            color: .red,
            font: UIFont.systemFont(ofSize: 15),
            textColor: .white,
            x: 20,
            y: 2,
            width: barChart.frame.size.width - 40
        )
        barChart.marker = marker
        
        barChart.setScaleEnabled(false)
        barChart.pinchZoomEnabled = false
        barChart.dragEnabled = true
        
        var entries: [BarChartDataEntry] = []
        
        if currentSleepDays.count < 31 {
            for x in 0..<currentSleepDays.count {
                entries.append(BarChartDataEntry(
                    x: Double(x),
                    y: currentSleepDays[x].relativeValueOfHours
                ))
            }
        } else if currentSleepDays.count == 180 {
            var sleepDaysInSixMonths: [SleepDay] = []
            var lastIndex = currentSleepDays.count - 1
            
            for _ in 0..<12 {
                let array: [SleepDay] = Array(currentSleepDays[(lastIndex - 14)...lastIndex])
                
                var averageTime = 0.0
                var dayCount = 0.0
                for item in array {
                    averageTime += item.relativeValueOfHours
                    if item.relativeValueOfHours != 0 {
                        dayCount += 1
                    }
                }
                
                if dayCount != 0.0 { averageTime = averageTime / dayCount }
                
                sleepDaysInSixMonths.append(SleepDay(
                    date: array.last?.date ?? Date(),
                    hour: Int(averageTime),
                    minute: Int(round((averageTime - Double(Int(averageTime))) * 60))
                ))
                lastIndex -= 15
            }
            
            sleepDaysInSixMonths.reverse()
            
            currentSleepDays = sleepDaysInSixMonths
            
            for x in 0..<currentSleepDays.count {
                entries.append(BarChartDataEntry(
                    x: Double(x),
                    y: currentSleepDays[x].relativeValueOfHours
                ))
            }
        } else if currentSleepDays.count == 365 {
            var sleepDaysInOneYear: [SleepDay] = []
            var lastIndex = currentSleepDays.count - 1
            
            for _ in 0..<12 {
                let array: [SleepDay] = Array(currentSleepDays[(lastIndex - 29)...lastIndex])
                
                var averageTime = 0.0
                var dayCount = 0.0
                for item in array {
                    averageTime += item.relativeValueOfHours
                    if item.relativeValueOfHours != 0 {
                        dayCount += 1
                    }
                }
                
                if dayCount != 0.0 { averageTime = averageTime / dayCount }
                
                sleepDaysInOneYear.append(SleepDay(
                    date: array.last?.date ?? Date(),
                    hour: Int(averageTime),
                    minute: Int(round((averageTime - Double(Int(averageTime))) * 60))
                ))
                lastIndex -= 30
            }
            
            sleepDaysInOneYear.reverse()
            
            currentSleepDays = sleepDaysInOneYear
            
            for x in 0..<currentSleepDays.count {
                entries.append(BarChartDataEntry(
                    x: Double(x),
                    y: currentSleepDays[x].relativeValueOfHours
                ))
            }
        }
        
        
        let xAxis = barChart.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.labelPosition = .bottom
        xAxis.valueFormatter = axisFormatDelegate
        xAxis.labelTextColor = .white
        
        let leftYAxis = barChart.leftYAxisRenderer
        leftYAxis.axis.labelTextColor = .white
        let rightYAxis = barChart.rightYAxisRenderer
        rightYAxis.axis.labelTextColor = .white
        
        barChart.animate(yAxisDuration: 0.5)
        
        let legend = barChart.legend
        legend.enabled = false
        
        let set = BarChartDataSet(entries: entries)
        set.colors = [#colorLiteral(red: 0.07103329152, green: 0.2764123976, blue: 0.3522424996, alpha: 1)]
        set.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set)
        
        barChart.data = data
    }
    
    private func getCurrentDayName(value: Int) -> String {
        var todayName = ""
        let weekday = Calendar.current.component(.weekday, from: currentSleepDays[value].date)
        switch weekday {
        case 1:
            todayName = WeekDayName.sunday.rawValue
        case 2:
            todayName = WeekDayName.monday.rawValue
        case 3:
            todayName = WeekDayName.tuesday.rawValue
        case 4:
            todayName = WeekDayName.wednesday.rawValue
        case 5:
            todayName = WeekDayName.thursday.rawValue
        case 6:
            todayName = WeekDayName.friday.rawValue
        case 7:
            todayName = WeekDayName.saturday.rawValue
        default:
            break
        }
        return todayName
    }
    
    private func getCurrentMonthName(value: Int) -> String {
        var currentMonthName = ""
        let month = Calendar.current.component(.month, from: currentSleepDays[value].date)
        switch month {
        case 1:
            currentMonthName = MonthName.january.rawValue
        case 2:
            currentMonthName = MonthName.february.rawValue
        case 3:
            currentMonthName = MonthName.march.rawValue
        case 4:
            currentMonthName = MonthName.april.rawValue
        case 5:
            currentMonthName = MonthName.may.rawValue
        case 6:
            currentMonthName = MonthName.june.rawValue
        case 7:
            currentMonthName = MonthName.june.rawValue
        case 8:
            currentMonthName = MonthName.august.rawValue
        case 9:
            currentMonthName = MonthName.september.rawValue
        case 10:
            currentMonthName = MonthName.october.rawValue
        case 11:
            currentMonthName = MonthName.november.rawValue
        case 12:
            currentMonthName = MonthName.december.rawValue
        default:
            break
        }
        return currentMonthName
    }
    
    private func setupTextForLabel() {
        var totalValue = 0.0
        var count = 0
        currentSleepDays.forEach { sleepDay in
            if sleepDay.relativeValueOfHours != 0 {
                totalValue += sleepDay.relativeValueOfHours
                count += 1
            }
        }
        
        var averageValue = 0.0
        if count != 0 { averageValue = totalValue / Double(count) }
    
        averageNum.text = "\(Int(averageValue)) ч \( Int((averageValue - Double(Int(averageValue))) * 60) ) мин"
        totalNum.text = "\(Int(totalValue)) ч \( Int((totalValue - Double(Int(totalValue))) * 60) ) мин"
    }
    
    private func getElementsForDisplay(inNumber number: Int, inArray arraySleepDays: [SleepDay]) -> [SleepDay] {
        var finalArray: [SleepDay] = []
        if arraySleepDays.count < number {
            var array: [SleepDay] = []
            var n = 1.0
            
            for _ in 0..<number - arraySleepDays.count {
                array.append(SleepDay(date: (arraySleepDays.first?.date ?? Date()) - (86400 * n), hour: 0, minute: 0))
                n += 1
            }
            array.reverse()
            finalArray = array + arraySleepDays
        } else {
            let lastIndex = arraySleepDays.count - 1
            finalArray = Array(arraySleepDays[(lastIndex - number + 1)...lastIndex])
        }
        return finalArray
    }
}

extension StatisticsViewController: AxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMM"
        
        if currentSleepDays.count == 7 {
            return getCurrentDayName(value: Int(value))
        } else if currentSleepDays.count == 30 {
            return dateFormatter.string(from: currentSleepDays[Int(value)].date)
        } else if Date().timeIntervalSince1970 - currentSleepDays.first!.date.timeIntervalSince1970 < 180*86400 {
            return dateFormatter.string(from: currentSleepDays[Int(value)].date)
        } else {
            return getCurrentMonthName(value: Int(value))
        }
    }
}

