//
//  ContentView.swift
//  final
//
//  Created by Jason on 3/19/21.
//

import SwiftUI

struct ContentView: View {
    @State var drops: [UUID: Raindrop] = [:]
    let step: Double = 2
    let a: CGFloat = 10.0
    @State var t: CGFloat = 0.0
    
    class Raindrop{
        let id: UUID
        let t0: CGFloat
        var x: CGFloat
        var y: CGFloat
        
        init(x: CGFloat, y: CGFloat, t: CGFloat){
            id = UUID.init()
            self.x = x
            self.y = 0
            self.t0 = t
        }
    }
    
    var body: some View{
        let timer = Timer.publish(every: step, on: .main, in: .common).autoconnect()
        let test: [CGFloat] = [0, 100, 200, 300]
        
        VStack{
            GeometryReader{ geometry in
                ZStack{
                    ForEach(Array(drops.keys), id:\.self){
                        drop in
                        if let d = drops[drop]{
                            Rectangle().foregroundColor(.blue).frame(width: 90, height: 90).offset(x: d.x, y: d.y).animation(.linear(duration:step))
                        }
                    }
                }.onReceive(timer) { _ in
                    t += CGFloat(step)
                    let x = test.randomElement()
                    let r = Raindrop(x:x!, y:0, t:t)
                    drops[r.id] = r
                    for drop in drops{
                        let dt = t-drop.value.t0
                        drop.value.y += 0.5*a*dt*dt
                        if drop.value.y > geometry.size.height{
                            drops.removeValue(forKey: drop.key)
                        }
                }
            }
                
            }
            Text("There are currently \(drops.count) raindrops")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
