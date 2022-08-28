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

    const characterMaxHp = (
      await dbInstance`
        SELECT vida_maxima FROM personagens WHERE id = ${this.idPersonagem}
        `
    )[0] as any;

    console.log(
      `(${currentMap.coord_x}, ${currentMap.coord_y}) - ${currentMap.nome}`
    );
    console.log();
    console.log(currentMap.descricao);
    console.log(`Vida Máxima: ${characterMaxHp.vida_maxima}`);

    const npcsAtMap: NPC[] = await dbInstance`
        SELECT N.id, N.nome, N.tipo_npc, N.descricao, M.id_mapa
        FROM npc N 
        JOIN mapa M ON M.id = N.id_mapa 
        WHERE M.id = ${currentMap.id};  
        `;

    const answer = await inquirer.prompt({
      name: "gameScreen",
      type: "list",
      message: "Selecione uma ação.\n",
      choices: [...this.availableActions(npcsAtMap), Choices.INVENTORY, Choices.QUIT],
    });

    if (answer.gameScreen === Choices.QUIT) {
      process.exit(0);
    }

    return true;
  }

  private availableActions(npcsAtMap: NPC[]): string[] {
    const npcActions: { [key in TipoNPC]: string } = {
      monstro: "Atacar",
      npc_missao: "Pegar missão com",
      mercador: "Negociar com",
    };

    return npcsAtMap.map((npc) => {
      return `${npcActions[npc.tipo_npc]} ${npc.nome}`;
    });
  }
}
