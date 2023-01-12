
import Foundation
import UIKit

class EquipoDetalles: UIViewController
{
    private var matches: [Matches] = []
    private var loc: [String] = []
    private var visi: [String] = []
    private var fecha: [String] = []

    @IBOutlet weak var tabla: UITableView!
    @IBOutlet weak var name: UILabel!
    

    
    
    var esteEquipo : Controlador.Table!
    
    override func viewDidLoad()	{
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        
        name.text =  (esteEquipo.team?.name)!
     
        /*
        let url = URL(string: (esteEquipo.team?.crestUrl)!)
        let data = try? Data(contentsOf: url!)
        image.image = UIImage(data: (data)!)
        */
        readFile2()
        
	}
//---------------------------------------------------------------------------------------------

struct JSONData2: Decodable {
        let competition: Competition
        let matches: [Matches]
}
    struct Competition: Decodable {
      let id: Int?
      let area: Area?
        struct Area: Decodable{
            let id: Int?
            let name: String?
        }
      let name: String?
      let code: String?
      let plan : String?
      let lastUpdated: String?
    }
    struct Matches: Decodable {
            let id: Int?
            let season: Season?
                struct Season: Decodable{
                    let id: Int?
                    let startDate: String?
                    let endDate: String?
                    let currentMatchday: Int?
                }
            let utcDate: String?
            let status: String?
            let matchday: Int?
            let stage: String?
            let group: Int?
            let lastUpdated: String?
//            let odds: Odds?
                struct Odds: Decodable{
                    let msg: String?
                }
        let score: Score
                struct Score: Decodable{
                    let winner: String?
                    let duration: String?
                    let fullTime: FullTime?
                        struct  FullTime: Decodable {
                            let homeTeam: Int?
                            let awayTeam: Int?
                        }
                    let halfTime: HalfTime?
                        struct  HalfTime: Decodable{
                            let homeTeam: Int?
                            let awayTeam: Int?
                        }
                    let extraTime: ExtraTime?
                        struct ExtraTime: Decodable{
                            let homeTeam: Int?
                            let awayTeam: Int?
                        }
                    let penalties: Penalties?
                        struct Penalties: Decodable{
                            let homeTeam: Int?
                            let awayTeam: Int?
                        }
            }
            let homeTeam: HomeTeam?
                struct HomeTeam: Decodable{
                    let id: Int?
                    let name: String?
                }
            let awayTeam: AwayTeam?
                struct AwayTeam: Decodable{
                    let  id: Int?
                    let name: String?
                }
//            let referees: [Referees]
                struct Referees: Decodable{    //array
                        let id: Int?
                        let name: String?
                        let role: String?
                        let nationality: String?
                    }
    }
   
//---------------------------------------------------------------------------------------------
    public func readFile2() {
        let url = URL(string: "https://api.football-data.org/v2/competitions/PD/matches")
 
        guard let requestUrl = url else { fatalError() }
        
        var request = URLRequest(url: requestUrl)
        request.addValue("ca85682defbf4b57992b9eb3abdef8ce", forHTTPHeaderField: "X-Auth-Token")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
                         
            if let error = error {
                print("Error took place \(error)")
                return
            }
            guard let data = data else {return}
            do{

                if let jsonData = try? JSONDecoder().decode(JSONData2.self, from: data){
                    self.matches = jsonData.matches
//                    print("🔥",matches)
                    
                    for match in matches {
                        if(match.homeTeam?.name == self.esteEquipo.team?.name || match.awayTeam?.name == self.esteEquipo.team?.name){
                            loc.append(String((match.homeTeam?.name)!))
                                visi.append(String((match.awayTeam?.name)!))
                                fecha.append(String(match.utcDate!))
                                }
                    }
                }
            }
        }
        task.resume()
}
    
}
extension EquipoDetalles: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 37
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let tableViewCe = tabla.dequeueReusableCell(withIdentifier: "cell" ,for: indexPath)
      
//        Metemos delay para que de tiempo a cargar el array desde el json y tenga valores
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {

            let thisTeam = self.matches[indexPath.row]

            let local = self.loc[indexPath.row]
            let visita = self.visi[indexPath.row]
            let fech = self.fecha[indexPath.row]
          
            
//            tableViewCe.textLabel?.text = local + " x " + visita + " " + fech

        }
    
        return tableViewCe
    }
    
}
