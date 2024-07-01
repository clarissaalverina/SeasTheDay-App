import SwiftUI
import SwiftData
import Foundation


struct SheetViewCustom: View {
    @State private var showSheet: Bool = false
    @State private var showModal: Bool = false
    @AppStorage("currentExp") private var currentExp = 0
    @AppStorage("currentLevel") private var currentLevel = 1
    @AppStorage("completedTask") private var completedTask = 0
   
    @State private var currentDetent: PresentationDetent = .height(300)
    @Query(filter: #Predicate<Task> { task in
        task.isCompleted == false
    }) private var previewTasks : [Task]
    
    @Query(filter: #Predicate<Task> { task in
        task.isCompleted == true
    }) private var checkedTasks : [Task]
    
    @State var progress: Double = 0.0
    @State var maxTaps = 10
    
    @State var moveToTop = false
    @State var isFloating = false
    @State var returnToInitial = false
    @State var backgroundOffset: CGFloat = 0
    @State var componentFloating = false
    
    @State private var height: CGFloat = 300
    @State private var width: CGFloat = 360
    @State private var dragOffset: CGFloat = 0
    @State private var startingX: CGFloat = 196.5
    @State private var startingY: CGFloat = 380
    @State private var location: CGPoint = CGPoint(x: 196.5, y: 500)
    @State var treasureOpen = false
    
    var body: some View {
        NavigationView{
            GeometryReader { geometry in
                ZStack{
                    ZStack{
                        VStack {
                            HStack {
                                NavigationLink(destination: ProfileView(currentExp: $currentExp, currentLevel: $currentLevel, completedTask: $completedTask).navigationBarHidden(true)) {
                                    HStack {
                                        Text("Lvl. \(currentLevel)")
                                            .frame(height: 30)
                                            .fontWeight(.semibold)
                                            .font(.system(size: 16))
                                        ProgressBarView(maxTaps: $maxTaps, progress: $progress)
                                    }
                                    Spacer()
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .clipShape(Circle())
                                }.padding(.horizontal, 15).background(.regularMaterial).cornerRadius(15)
                            }
                            .frame(width: 360,height: 50) // Adjust height as needed
                            .padding(10)
                            .cornerRadius(15)
                        }.padding(.bottom, 400).foregroundColor(.primary)
                        
                        
                        VStack{
                            ZStack {
                                Capsule().frame(width: 70, height: 8)
                                    .padding(.top, 8)
                                    .foregroundColor(.gray)
                                
                            }
                            if showSheet && height > 779 {
                                if showModal {
                                    CustomDialog(isActive: $showModal, title: "YEEEAYY", message: "Treasure", buttonTitle: "OK", treasureOpen: $treasureOpen).padding(.bottom, 250)
                                }
                                ContentView(currentExp: $currentExp, currentLevel: $currentLevel, completedTask: $completedTask, maxTaps: $maxTaps, progress: $progress, moveToTop: $moveToTop, isFloating: $isFloating, returnToInitial: $returnToInitial, backgroundOffset: $backgroundOffset, componentFloating: $componentFloating, showModal: $showModal).padding(16).padding(.bottom, 8)
                                    .transition(.scale)
                            }
                            else {
                                ShrunkViewCustom(previewTasks: previewTasks, currentExp: $currentExp, currentLevel: $currentLevel, completedTask: $completedTask, maxTaps: $maxTaps, progress: $progress, moveToTop: $moveToTop, isFloating: $isFloating, returnToInitial: $returnToInitial, backgroundOffset: $backgroundOffset, componentFloating: $componentFloating, treasureOpen: $treasureOpen)
                            }
                        }
                
                        .ignoresSafeArea()
                        .frame(maxWidth: width)
                        .background(Color(.white))
                        .cornerRadius(30)
                        .ignoresSafeArea()
                        .position(location)
                        .frame(height: max(300, min(height+dragOffset, height+dragOffset)))
                        //                    .frame(width: max(360, min(500, width)))
                        .gesture(
                            DragGesture()
                                .onChanged { gesture in
                                    dragOffset = -(gesture.translation.height)
                                }
                                .onEnded { gesture in
                                    let newHeight = height + gesture.translation.height
                                    withAnimation {
                                        if dragOffset > 50 {
                                            height = 780
                                            width = 600
                                            showSheet = true
                                            
                                            //                                        location = CGPoint(x: 200, y: 234)
                                            location = CGPoint(x:startingX, y:540)
                                        } else {
                                            height = 300
                                            width = 360
                                            location = CGPoint(x: startingX, y: 500)
                                            showSheet = false
                                            
                                        }
                                    }
                                    dragOffset = 0
                                    
                                }
                        )
                        .animation(.spring())
                    }
                }
                .frame(width: 393, height: 600)
                .edgesIgnoringSafeArea(.all)
                
            }.background(WaterView(moveToTop: $moveToTop, isFloating: $isFloating, returnToInitial: $returnToInitial, backgroundOffset: $backgroundOffset, componentFloating: $componentFloating, treasureOpen: $treasureOpen))
        }.background(Color.white)
    }
    
    var simpleDrag: some Gesture {
        DragGesture()
            .onChanged{ value in
                self.location = value.location
            }
    }
    
}



struct ShrunkViewCustom: View {
    var previewTasks: [Task]
    @Binding var currentExp : Int
    @Binding var currentLevel : Int
    @Binding var completedTask : Int
    @Binding var maxTaps : Int
    @Binding var progress : Double
    @Environment(\.modelContext) var modelContext
    @Binding var moveToTop: Bool
    @Binding var isFloating: Bool
    @Binding var returnToInitial: Bool
    @Binding var backgroundOffset: CGFloat
    @Binding var componentFloating: Bool
    @State private var path = [Task]()
    @State private var showModal : Bool = false
    @Binding var treasureOpen: Bool
    
    var body: some View {
        if showModal {
            CustomDialog(isActive: $showModal, title: "YEEEAYY", message: "treasure", buttonTitle: "OK", treasureOpen: $treasureOpen).padding(.bottom, 250)
        }
        NavigationStack{
            ZStack {
                List{
                    ForEach(previewTasks){task in
                        TaskRowView(task: task, currentExp: $currentExp, currentLevel: $currentLevel, completedTask: $completedTask, maxTaps: $maxTaps, progress: $progress, moveToTop: $moveToTop, isFloating: $isFloating, returnToInitial: $returnToInitial, backgroundOffset: $backgroundOffset, componentFloating: $componentFloating, showModal:  $showModal)
                    }
                }
                Button(action: {
                    addTask()
                }, label: {
                    ZStack {
                        Circle().foregroundColor(Color(hex: 0x00463D)).frame(width: 60, height: 60)
                        Image(systemName: "plus")
                            .resizable()
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 20, height: 20)
                            .clipShape(Circle())
                    }
                })
                .position(x: 300, y: 200)
                
            }
        }
    }
    func addTask(){
        let task = Task()
        modelContext.insert(task)
        path = [task]
    }
}
       
       func checkPreviewTask(previewTasks: [Task]) -> String {
           if previewTasks.isEmpty{
               return "Good Job!"
           } else {
               return "Finish Them!"
           }
       }
        



struct MiniView: View {
    var body: some View {
        
        VStack {
            Text("Mini View")
                .font(.largeTitle)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
            Spacer()
            
        }
        .background(Color.green)
        .cornerRadius(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SheetViewCustom()
    }
}
