import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";
import { Mapa } from "../interfaces/mapa.js";
import { Choices } from "../util/constants.js";

export default class GameScreen {
    private readonly idPersonagem: number

    constructor(idPersonagem: number){
        this.idPersonagem = idPersonagem
    }


    async handleGameScreen() {
        console.clear()

        const currentMap: Mapa = (await dbInstance`
        SELECT M.id, M.coord_x, M.coord_y, M.descricao, M.mapa_norte, M.mapa_sul, M.mapa_leste, M.mapa_oeste, M.nome
         from mapa M 
         INNER JOIN personagens 
         p ON m.id = p.id_mapa WHERE p.id = ${this.idPersonagem}
        `)[0] as any;


        // prints map info
        console.log(`(${currentMap.coord_x}, ${currentMap.coord_y}) - ${currentMap.nome}`)
        console.log()
        console.log(currentMap.descricao)

        const answer = await inquirer.prompt({
            name: "gameScreen",
            type: "list",
            message: "Selecione uma ação.\n",
            choices: [Choices.INVENTORY, Choices.QUIT],
          });

          if(answer.gameScreen === Choices.QUIT){
            process.exit(0);
          }

        // const mapNpcs: Mapa = (await dbInstance`
        // SELECT M.id, M.coord_x, M.coord_y, M.descricao, M.mapa_norte, M.mapa_sul, M.mapa_leste, M.mapa_oeste, M.nome
        //  from mapa M 
        //  INNER JOIN personagens 
        //  p ON m.id = p.id_mapa WHERE p.id = ${this.idPersonagem}
        // `)[0] as any;      

        return true
    }

 
}
