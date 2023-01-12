//  prueba
import UIKit

class Controlador: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    private var competitionData: [Competition] = []
    private var standingsData: [Standings] = []
    private var seasonData: [Season] = []
    private var tables: [Table] = []
    @IBOutlet weak var tableview: UITableView!
    
    
    override func viewDidLoad() {
        readFile()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.crearArrayTable()
        }
            super.viewDidLoad()
    }

    public func readFile() {
        let url = URL(string: "https://api.football-data.org/v2/competitions/2014/standings?standing")
 
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

                if let jsonData = try? JSONDecoder().decode(JSONData.self, from: data){
                    self.standingsData = jsonData.standings

                }
            }
        }
        task.resume()
}

    func crearArrayTable(){
        for standingsDatum in standingsData {
            tables = (standingsDatum.table)!

        }
        print("⚽️⚽️⚽️⚽️⚽️ ",tables)
    }
    
    struct JSONData: Decodable {
        let competition: Competition
        let season: Season
        let standings: [Standings]
}

// SON DEL TIPO DEL QUE VIENE EN EL JSO
//----------------------------------------------------------------------------------------------

    struct Standings: Decodable {
        let stage: String?
        let type: String?
        let group: String?
        let table: [Table]?
        
    }
    struct Table: Decodable {
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
    struct Season: Decodable {
        let id: Int?
        let startDate: String?
        let endDate: String?
        let currentMatchday: Int?
        let winner: String?
    }
    
//------------------------------------------------------------------------------------------------
	@IBOutlet weak var shapeTableView: UITableView!

    @IBOutlet weak var tabla: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
        return 20
        

	}
	
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
		let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as! Fila
      
//        Metemos delay para que de tiempo a cargar el array desde el json y tenga valores
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

            let thisTeam = self.tables[indexPath.row]
            tableViewCell.posicion.text = String(thisTeam.position!)
            tableViewCell.equipo.text = (thisTeam.team?.name)!
            tableViewCell.puntos.text = String(thisTeam.points!)
            tableViewCell.victorias.text = String(thisTeam.won!)
            tableViewCell.empates.text = String(thisTeam.draw!)
            tableViewCell.derrotas.text = String(thisTeam.lost!)
          /*
            let url = URL(string: (thisTeam.team?.crestUrl) as! String)
            let data = try? Data(contentsOf: url!)
            tableViewCell.imgEquipo.image = UIImage(data: (data)!)
            */

            if let url = URL(string: (thisTeam.team?.crestUrl)!) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                  // Error handling...
                    guard data != nil else { return }
                    let data = try? Data(contentsOf: url)
                  DispatchQueue.main.async {
                      
                      tableViewCell.imgEquipo.image = UIImage(data: (data)!)
                  }
                }.resume()
              }
            


        }
            
		return tableViewCell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
		self.performSegue(withIdentifier: "detailSegue", sender: self)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?){
		if(segue.identifier == "detailSegue")
		{
			let indexPath = self.shapeTableView.indexPathForSelectedRow!
			
			let tableViewDetail = segue.destination as? EquipoDetalles
			
			let selectedShape = tables[indexPath.row]
			
            tableViewDetail!.esteEquipo = selectedShape
			
			self.shapeTableView.deselectRow(at: indexPath, animated: true)
		}
	}

}

