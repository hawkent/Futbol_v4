
import Foundation

class Tables
{
    internal init(position: Int?, team: Tables.Team?, playedGames: Int?, form: Int?, won: Int?, draw: Int?, lost: Int?, points: Int?, goalsFor: Int?, goalsAgainst: Int?, goalDifference: Int?) {
        self.position = position
        self.team = team
        self.playedGames = playedGames
        self.form = form
        self.won = won
        self.draw = draw
        self.lost = lost
        self.points = points
        self.goalsFor = goalsFor
        self.goalsAgainst = goalsAgainst
        self.goalDifference = goalDifference
    }
    
            let position: Int?
            let team: Team?
                struct Team: Decodable, Identifiable{
                            let id: Int?
                            let name: String?
                            let crestUrl: String?
                }
            let playedGames: Int?
            let form: Int?
            let won: Int?
            let draw: Int?
            let lost: Int?
            let points: Int?
            let goalsFor: Int?
            let goalsAgainst: Int?
            let goalDifference: Int?
        


	
  
    
}
