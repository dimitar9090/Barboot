import SwiftUI

struct DiceGameView: View {
    @State private var diceOne = Int.random(in: 1...6)
    @State private var diceTwo = Int.random(in: 1...6)
    @State private var diceThree = Int.random(in: 1...6)
    @State private var rolling = false
    @State private var currentPoints = 0
    @State private var totalPoints = 0
    @State private var lastRollPoints = 0
    @State private var lostPoints = 0
    @State private var holdDiceOne = false
    @State private var holdDiceTwo = false
    @State private var holdDiceThree = false
    @State private var resetAfterZeroPoints = false
    @State private var tokens = 10
    @State private var gameOver = false
    
    @State private var playerName = ""
    @State private var showLeaderboard = false
    @State private var leaderboard: [PlayerScore] = []

    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()

            VStack {
                HStack {
                    Text("Барбут")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.blue, Color.purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: 3)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.yellow.opacity(1))
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                        )
                    Menu {
                        Text("1 = 100")
                        Text("5 = 50")
                        Text("1+1+1 = 1000")
                        Text("2+2+2 = 200")
                        Text("3+3+3 = 300")
                        Text("4+4+4 = 400")
                        Text("5+5+5 = 500")
                        Text("6+6+6 = 000")
                        Text("1+2+3 = 200")
                        Text("2+3+4 = 200")
                        Text("3+4+5 = 200")
                        Text("4+5+6 = 200")
                        
                        } label: {
                        Image(systemName: "info.square.fill")
                                .font(.largeTitle)
                        .foregroundColor(.black)
                        }
                        .padding(.leading, 20)
                    
                }
                Spacer()
                HStack(spacing: 20) {
                    HStack(spacing: 5) {
                        Image(systemName: "star.square.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        Text("\(currentPoints)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: 3)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "star.square.on.square.fill")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        Text("\(totalPoints)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: 3)
                    
                    HStack(spacing: 5) {
                        Image(systemName: "star.circle")
                            .font(.title2)
                            .foregroundColor(.yellow)
                        Text("\(tokens)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color.red],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: 3)
                }
                .background(Color.white.opacity(0.2))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                Spacer()
                if gameOver {
                    Text("Game Over")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()
                    Text("Общ брой точки: \(totalPoints)")
                        .font(.title)
                        .padding()
                    
                    TextField("Вашето име", text: $playerName)
                        .font(.title)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    HStack {
                        Button("Запази резултата") {
                            if !playerName.isEmpty {
                                saveScore()
                            }
                            resetGame()
                        }
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        
                        Button("Пропусни") {
                            resetGame()
                        }
                        .font(.title)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    
                    
                } else {
                    HStack(spacing: 5.0) {
                        DiceView(number: diceOne, rolling: $rolling, held: holdDiceOne)
                        DiceView(number: diceTwo, rolling: $rolling, held: holdDiceTwo)
                        DiceView(number: diceThree, rolling: $rolling, held: holdDiceThree)
                    }
                    Spacer()
                    if tokens > 0 {
                        Button(action: {
                            if resetAfterZeroPoints {
                                resetAfterZeroPoints = false
                            }
                            rollDice()
                        }) {
                            Text(rolling ? "Въртене..." : "Хвърли заровете")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                .padding()
                                .background(rolling ? Color.blue : Color.orange)
                                .cornerRadius(10)
                                .disabled(rolling)
                        }
                        Button("Запази точките") {
                            savePoints()
                        }
                        .font(.largeTitle)
                        .disabled(rolling || currentPoints == 0)
                    }
                }
                Spacer()
                
                HStack {
                    Button("Класация") {
                        showLeaderboard = true
                        }
                        .font(.title)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                                    
                    Button("Нова игра") {
                        resetGame()
                        }
                        .font(.title)
                        .padding()
                        .background(Color.brown)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    }
                
            }
        }
        .sheet(isPresented: $showLeaderboard) {
            LeaderboardView(leaderboard: leaderboard)
        }
        .onAppear {
            loadLeaderboard()
        }
    }
    
    func rollDice() {
        rolling = true
        let times = Int.random(in: 10...15)
        var currentCount = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.15, repeats: true) { timer in
            if !self.holdDiceOne {
                self.diceOne = Int.random(in: 1...6)
            }
            if !self.holdDiceTwo {
                self.diceTwo = Int.random(in: 1...6)
            }
            if !self.holdDiceThree {
                self.diceThree = Int.random(in: 1...6)
            }
            
            currentCount += 1
            if currentCount == times {
                timer.invalidate()
                self.rolling = false
                calculatePoints()
            }
        }
    }
    
    func calculatePoints() {
        let diceResults = [diceOne, diceTwo, diceThree].sorted()
        lastRollPoints = 0
        
        if !holdDiceOne && !holdDiceTwo && !holdDiceThree {
            if diceResults == [1, 1, 1] {
                lastRollPoints = 1000
            } else if diceResults == [2, 2, 2] {
                lastRollPoints = 200
            } else if diceResults == [3, 3, 3] {
                lastRollPoints = 300
            } else if diceResults == [4, 4, 4] {
                lastRollPoints = 400
            } else if diceResults == [5, 5, 5] {
                lastRollPoints = 500
            } else if diceResults == [6, 6, 6] {
                currentPoints = 0
                resetAfterZeroPoints = true
                tokens -= 1 // Губим 1 токен
                if tokens <= 0 {
                    gameOver = true
                }
                return
            } else if diceResults == [1, 2, 3] || diceResults == [2, 3, 4] || diceResults == [3, 4, 5] || diceResults == [4, 5, 6] {
                lastRollPoints = 200
            }
        }

        if lastRollPoints == 0 {
            var newHoldDiceOne = false
            var newHoldDiceTwo = false
            var newHoldDiceThree = false
            
            if !holdDiceOne {
                lastRollPoints += calculatePointsForDice(diceOne)
                newHoldDiceOne = isWinningDice(diceOne)
            }
            
            if !holdDiceTwo {
                lastRollPoints += calculatePointsForDice(diceTwo)
                newHoldDiceTwo = isWinningDice(diceTwo)
            }
            
            if !holdDiceThree {
                lastRollPoints += calculatePointsForDice(diceThree)
                newHoldDiceThree = isWinningDice(diceThree)
            }
            
            currentPoints += lastRollPoints
            
            holdDiceOne = newHoldDiceOne || holdDiceOne
            holdDiceTwo = newHoldDiceTwo || holdDiceTwo
            holdDiceThree = newHoldDiceThree || holdDiceThree
            
            if holdDiceOne && holdDiceTwo && holdDiceThree {
                holdDiceOne = false
                holdDiceTwo = false
                holdDiceThree = false
            }
            
            if lastRollPoints == 0 {
                currentPoints = 0
                holdDiceOne = false
                holdDiceTwo = false
                holdDiceThree = false
                resetAfterZeroPoints = true
                tokens -= 1 // Губим 1 токен
                if tokens <= 0 {
                    gameOver = true
                }
            }
        } else {
            currentPoints += lastRollPoints
        }
    }
    
    func calculatePointsForDice(_ number: Int) -> Int {
        switch number {
        case 1:
            return 100
        case 5:
            return 50
        default:
            return 0
        }
    }
    
    func isWinningDice(_ number: Int) -> Bool {
        return number == 1 || number == 5
    }

    func savePoints() {
        if currentPoints > 0 {
            totalPoints += currentPoints
            lostPoints = totalPoints
            tokens -= 1 // Губим 1 токен
            if tokens <= 0 {
                gameOver = true
            }
        }
        currentPoints = 0
        holdDiceOne = false
        holdDiceTwo = false
        holdDiceThree = false
    }
    
    func saveScore() {
        let newScore = PlayerScore(name: playerName, score: totalPoints)
        leaderboard.append(newScore)
        leaderboard.sort { $0.score > $1.score } // Подреждане на класацията по точки
        saveLeaderboard()
    }
    
    func saveLeaderboard() {
        if let encoded = try? JSONEncoder().encode(leaderboard) {
            UserDefaults.standard.set(encoded, forKey: "Leaderboard")
        }
    }
    
    func loadLeaderboard() {
        if let savedData = UserDefaults.standard.data(forKey: "Leaderboard"),
           let decoded = try? JSONDecoder().decode([PlayerScore].self, from: savedData) {
            leaderboard = decoded
        }
    }
    
    func resetGame() {
        diceOne = Int.random(in: 1...6)
        diceTwo = Int.random(in: 1...6)
        diceThree = Int.random(in: 1...6)
        currentPoints = 0
        totalPoints = 0
        lastRollPoints = 0
        lostPoints = 0
        holdDiceOne = false
        holdDiceTwo = false
        holdDiceThree = false
        resetAfterZeroPoints = false
        tokens = 10 // Възстановяване на токените
        gameOver = false
        playerName = "" // Изчистване на името на играча
    }
}

struct DiceView: View {
    let number: Int
    @Binding var rolling: Bool
    var held: Bool
    
    var body: some View {
        Image(systemName: "die.face.\(number).fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .rotationEffect(.degrees(rolling && !held ? 360 : 0))
            .animation(rolling && !held ? Animation.linear(duration: 0.15).repeatForever(autoreverses: false) : .default, value: rolling)
            .opacity(held ? 0.5 : 1.0)
            .padding()
        
    }
}
struct PlayerScore: Identifiable, Codable {
    var id = UUID()
    let name: String
    let score: Int
}

struct LeaderboardView: View {
    let leaderboard: [PlayerScore]
    
    var body: some View {
        VStack {
            Text("Класация")
                .font(.largeTitle)
                .padding()
                .foregroundColor(.white) // Променете цвета на текста, ако е необходимо
            
            List(leaderboard) { score in
                HStack {
                    Text(score.name)
                    Spacer()
                    Text("\(score.score) точки")
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color.clear) // Позволява цветът на родителския VStack да се вижда през списъка
        }
        .background(Color.blue) // Задайте желания цвят за фона на целия екран
        .ignoresSafeArea() // Уверете се, че цветът на фона запълва целия екран
    }
}

struct DiceGameView_Previews: PreviewProvider {
    static var previews: some View {
        DiceGameView()
    }
}
