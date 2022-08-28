import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";
import { Mapa } from "../interfaces/mapa.js";
import { Choices } from "../util/constants.js";
import { NPC, TipoNPC } from "../interfaces/npc.js";

export default class GameScreen {
  private readonly idPersonagem: number;

  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
  }

  async handleGameScreen() {
    console.clear();

    const currentMap: Mapa = (
      await dbInstance`
        SELECT M.id, M.coord_x, M.coord_y, M.descricao, M.mapa_norte, M.mapa_sul, M.mapa_leste, M.mapa_oeste, M.nome
         from mapa M 
         INNER JOIN personagens 
         p ON m.id = p.id_mapa WHERE p.id = ${this.idPersonagem}
        `
    )[0] as any;

    const charStats = (
      await dbInstance`
        SELECT P.vida_maxima, C.nome as nome_classe, P.sorte_total FROM personagens P JOIN classe C ON C.id = P.id_classe WHERE P.id = ${this.idPersonagem}
        `
    )[0] as any;

    console.log(
      `(${currentMap.coord_x}, ${currentMap.coord_y}) - ${currentMap.nome}`
    );
    console.log();
    console.log(currentMap.descricao);
    console.log(
      `Vida Máxima: ${charStats.vida_maxima}         Sorte total: ${charStats.sorte_total}         Classe: ${charStats.nome_classe}`
    );

    const npcsAtMap: NPC[] = await dbInstance`
        SELECT N.id, N.nome, N.tipo_npc, N.descricao, n.id_mapa
        FROM npc N 
        JOIN mapa M ON M.id = N.id_mapa 
        WHERE M.id = ${currentMap.id};  
        `;

    const answer = await inquirer.prompt({
      name: "gameScreen",
      type: "list",
      message: "Selecione uma ação.\n",
      choices: [
        ...this.availableChoices(npcsAtMap, currentMap),
        Choices.INVENTORY,
        Choices.QUIT,
      ],
    });

    if (answer.gameScreen === Choices.QUIT) {
      process.exit(0);
    }

    return true;
  }

  private availableChoices(npcsAtMap: NPC[], currentMap: Mapa): string[] {
    const npcActions: { [key in TipoNPC]: string } = {
      monstro: "Atacar",
      npc_missao: "Pegar missão com",
      mercador: "Negociar com",
    };

    const npcChoices = npcsAtMap.map((npc) => {
      return `${npcActions[npc.tipo_npc]} ${npc.nome}`;
    });

    let mapChoices: any = {
      ...(currentMap.mapa_norte && { mapa_leste: "Andar para o Norte" }),
      ...(currentMap.mapa_sul && { mapa_leste: "Andar para o Sul" }),
      ...(currentMap.mapa_leste && { mapa_leste: "Andar para o Leste" }),
      ...(currentMap.mapa_oeste && { mapa_leste: "Andar para o Oeste" }),
    };

    mapChoices = Object.keys(mapChoices).map(function (key) {
      return mapChoices[key];
    });

    return [...mapChoices, ...npcChoices];
  }
}
