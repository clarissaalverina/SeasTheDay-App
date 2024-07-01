//
//  CalendarTest.swift
//  TodolistTest
//
//  Created by Vincent Senjaya on 24/06/24.
//

import SwiftUI
import SwiftData

struct CalendarTest: View {
    let days = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    @State var selectedMonth = 0
    @State var selectedDate = Date()
    @Binding var selectedDay : Date
    @Query var tasks: [Task]
    
    
    var body: some View {
        
        VStack(spacing: 20){
            HStack{
                Spacer()
                Button{
                    withAnimation{
                        selectedMonth -= 1
                        selectedDay = Date.distantPast
                    }
                } label: {
                    Image(systemName: "lessthan")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 28)
                        .foregroundColor(.gray)
                }
                Spacer()
                Text(selectedDate.monthAndYear()).font(.title2)
                Spacer()
                Button{
                    withAnimation{
                        selectedMonth += 1
                        selectedDay = Date.distantPast
                    }
                } label: {
                    Image(systemName: "greaterthan")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 28)
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            
            Divider()
            HStack{
                ForEach(days, id: \.self) { day in
                    Text(day).font(.system(size: 12, weight: .medium)).frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 20) {
                ForEach(fetchDates()) { value in
                        ZStack{
                            if value.day != -1 {
                                Text("\(value.day)").foregroundStyle(selectedDay.string() == value.date.string() ? .primary : .secondary)
                                    .fontWeight(selectedDay.string() == value.date.string() ? .bold : .none)
                                    .background{
                                        ZStack{
                                            if selectedDay.string() == value.date.string(){
                                                Circle().frame(width: 48, height: 48).foregroundColor(Color(hex: 0x4CB4A7))
                                            }
                                            ForEach(tasks){ task in
                                                if task.date.string() == value.date.string(){
                                                    Circle().frame(width: 48, height: 48).foregroundColor(selectedDay.string() == value.date.string() ? Color(hex: 0x4CB4A7) : Color(hex: 0x4CB4A7).opacity(0.5))
                                                }
                                            }
                                        }
                                    }.onTapGesture {
                                        selectedDay = value.date
                                    }
                            } else {
                                Text("")
                            }
                        }
                        .frame(width: 32, height: 32)
                }
            }
        }.onChange(of: selectedMonth) { _ in
            selectedDate = fetchSelectedMonth()
        }
    }
    
    func fetchDates() -> [CalendarDate] {
        let calendar = Calendar.current
           let currentMonth = fetchSelectedMonth()
           
           // Get the range of days in the selected month
           guard let range = calendar.range(of: .day, in: .month, for: currentMonth) else {
               return []
           }
           
           // Get the first date of the selected month
           guard let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth)) else {
               return []
           }
           
           var dates = [CalendarDate]()
           
           // Add padding for the first week
           let firstDayOfWeek = calendar.component(.weekday, from: firstOfMonth)
           for _ in 0..<(firstDayOfWeek - 1) {
               dates.append(CalendarDate(day: -1, date: Date()))
           }
           
           // Add all days of the current month
           for day in range {
               if let date = calendar.date(byAdding: .day, value: day - 1, to: firstOfMonth) {
                   dates.append(CalendarDate(day: day, date: date))
               }
           }
           
           return dates
    }
    func fetchSelectedMonth() -> Date{
        let calendar = Calendar.current
        
        let month = calendar.date(byAdding: .month, value: selectedMonth,  to: Date())
        
        return month!
    }
}

struct CalendarDate : Identifiable{
    let id = UUID()
    var day: Int
    var date: Date
}

extension Date{
    func monthAndYear() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return formatter.string(from: self)
    }
    func datesOfMonth() -> [Date] {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: self)
        
        var startDateComponents = DateComponents()
        startDateComponents.year = currentYear
        startDateComponents.month = currentMonth
        startDateComponents.day = 1
        let startDate = calendar.date(from: startDateComponents)!
        
        var endDateComponents = DateComponents()
        endDateComponents.month = 1
        startDateComponents.day = -1
        let endDate = calendar.date(byAdding: endDateComponents, to: startDate)!
        
        var dates: [Date] = []
        var currentDate = startDate
        
        while currentDate <= endDate{
            dates.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        return dates
    }
    
    func string() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
}

//#Preview {
//    CalendarTest()
//}
