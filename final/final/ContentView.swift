//
//  ContentView.swift
//  Test
//
//  Created by user191611 on 3/19/21.
//

import SwiftUI


import SwiftUI

struct ContentView: View {
    @State var drops: [UUID: Block] = [:]
    let step: Double = 2.0
    let a: CGFloat = 20.0
    @State var turret1 = "+"
    @State var turret2 = "+"
    @State var turret3 = "+"
    @State var turret4 = "+"
    @State var t: CGFloat = 0.0
    @State var lanes: [CGFloat] = [0, 100, 200, 300]
    @State var picked: CGFloat = 666
    @State var picked2: CGFloat = 666
    @State var laneElements = [Int](repeating: 0, count: 4)
    
    class Block{
        let id: UUID
        let t0: CGFloat
        var x: CGFloat
        var y: CGFloat
        var stopped = false
        
        init(x: CGFloat, y: CGFloat, t: CGFloat){
            id = UUID.init()
            self.x = x
            self.y = 0
            self.t0 = t
        }
    }
    
    var body: some View{
        let timer = Timer.publish(every: step, on: .main, in: .common).autoconnect()
        
        VStack(spacing: 0){
            GeometryReader{ geometry in
                ZStack{
                    ForEach(Array(drops.keys), id:\.self){
                        drop in
                        if let d = drops[drop]{
                            Rectangle().border(Color.black)
                                .foregroundColor(.red)
                                .frame(width: 90, height: 90)
                                .offset(x: d.x, y: d.y)
                                .animation(.linear(duration:step))
                        }
                    }
                }.onReceive(timer) { _ in
                    
                    t += CGFloat(step)
                    var x = lanes.randomElement()
                    
                    
                    while picked == x || x == picked2{
                        x = lanes.randomElement()
                    }
                    
                    let r = Block(x:x!, y:0, t:t)
                    drops[r.id] = r
                    for drop in drops{
                        if(drop.value.stopped == false){
                            let dt = t-drop.value.t0
                            drop.value.y += 0.5*a*dt*dt
                            if drop.value.y > geometry.size.height - CGFloat(laneElements[Int(drop.value.x / 100)] * 90){
                                drop.value.stopped = true
                                drop.value.y = geometry.size.height - CGFloat(laneElements[Int(drop.value.x / 100)] * 90)
                                laneElements[Int(drop.value.x / 100)] += 1
                            }
                        }
                    }
                    if laneElements[0] > 0 {
                        turret1 = "-"
                    }
                    if laneElements[1] > 0 {
                        turret2 = "-"
                    }
                    if laneElements[2] > 0 {
                        turret3 = "-"
                    }
                    if laneElements[3] > 0 {
                        turret4 = "-"
                    }
                    picked2 = picked
                    picked = x!
                    
                }
                
            }.border(Color.black)
            HStack(spacing: 10) {
                Button(action: placeTurret1) {
                    Text(turret1).foregroundColor(Color.black)
                }.frame(width: 90, height: 90)
                .border(Color.black, width: 5)
                Button(action: placeTurret2) {
                    Text(turret2).foregroundColor(Color.black)
                }.frame(width: 90, height: 90)
                .border(Color.black, width: 5)
                Button(action: placeTurret3) {
                    Text(turret3).foregroundColor(Color.black)
                }.frame(width: 90, height: 90)
                .border(Color.black, width: 5)
                Button(action: placeTurret4) {
                    Text(turret4).foregroundColor(Color.black)
                }.frame(width: 90, height: 90)
                .border(Color.black, width: 5)
            }.frame(width: 390, height: 90).border(Color.black)
            
            Text("1st row has elements: \(laneElements[0])")
        }
    }
    func placeTurret1() {
        if laneElements[0] < 1 {
            turret1 = "Turret"
        }
    }
    func placeTurret2() {
        if laneElements[1] < 1 {
            turret2 = "Turret"
        }
    }
    func placeTurret3() {
        if laneElements[2] < 1 {
            turret3 = "Turret"
        }
    }
    func placeTurret4() {
        if laneElements[3] < 1 {
            turret4 = "Turret"
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 12")
    }
}
