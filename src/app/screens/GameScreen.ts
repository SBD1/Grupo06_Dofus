import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";
import { Mapa } from "../interfaces/mapa.js";
import { Choices, INFINTE } from "../util/constants.js";
import { NPC, TipoNPC } from "../interfaces/npc.js";
import BattleScreen from "./BattleScreen.js";

type AvailableChoicesType = {
  npcChoices: {
    [key: string]: {
      choice: string;
      npc_id: NPC["id"];
      tipo_npc: NPC["tipo_npc"];
    };
  };
  mapChoices: {
    [key: string]: {
      choice: string;
      mapa_id: Mapa["id"];
    };
  };
};
export default class GameScreen {
  private readonly idPersonagem: number;
  private readonly WALK_SOUTH: string = "Andar Para o Sul";
  private readonly WALK_EAST: string = "Andar Para o Leste";
  private readonly WALK_WEST: string = "Andar Para o Oeste";
  private readonly WALK_NORTH: string = "Andar Para o Norte";
  private readonly BattleScreen: BattleScreen;
  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
    this.BattleScreen = new BattleScreen(idPersonagem);
  }

  async handleGameScreen() {
    console.clear();
    console.log();

    const currentMap: Mapa = (
      await dbInstance`
        SELECT M.id, M.coord_x, M.coord_y, M.descricao, M.mapa_norte, M.mapa_sul, M.mapa_leste, M.mapa_oeste, M.nome
         from mapa M 
         INNER JOIN personagens 
         p ON m.id = p.id_mapa WHERE p.id = ${this.idPersonagem}
        `
    )[0] as any;

    const charInfo = (
      await dbInstance`
        SELECT P.vida_maxima, C.nome as nome_classe, P.sorte_total, P.moedas FROM personagens P JOIN classe C ON C.id = P.id_classe WHERE P.id = ${this.idPersonagem}
        `
    )[0] as any;

    console.log(
      `(${currentMap.coord_x}, ${currentMap.coord_y}) - ${currentMap.nome}`
    );
    console.log();
    console.log(currentMap.descricao);
    console.log(
      `Moedas: ${charInfo.moedas}         Vida Máxima: ${charInfo.vida_maxima}         Sorte total: ${charInfo.sorte_total}         Classe: ${charInfo.nome_classe}`
    );

    const npcsAtMap: NPC[] = await dbInstance`
        SELECT N.id, N.nome, N.tipo_npc, N.descricao, n.id_mapa
        FROM npc N 
        JOIN mapa M ON M.id = N.id_mapa 
        WHERE M.id = ${currentMap.id};  
        `;

    const availableChoices: AvailableChoicesType = this.availableChoices(
      npcsAtMap,
      currentMap
    );

    const answer = await inquirer.prompt({
      name: "gameScreen",
      type: "list",
      loop: false,
      pageSize: INFINTE,
      message: "Selecione uma ação.\n",
      choices: [
        ...Object.keys(availableChoices.mapChoices),
        ...Object.keys(availableChoices.npcChoices),
        Choices.INVENTORY,
        Choices.QUIT,
      ],
    });

    await this.handleChoices(answer.gameScreen, availableChoices);
  }

  private async handleChoices(
    answer: string,
    availableChoices: AvailableChoicesType
  ): Promise<void> {
    if (answer === Choices.QUIT) process.exit(0);
    if (answer === Choices.INVENTORY) process.exit(0); // TODO inventory

    if (availableChoices.mapChoices[answer]) {
      await dbInstance`
      UPDATE personagens SET id_mapa = ${availableChoices.mapChoices[answer].mapa_id} WHERE id = ${this.idPersonagem}
      `;
    }

    if (availableChoices.npcChoices[answer]) {
      await this.BattleScreen.handleBattleScreen(
        availableChoices.npcChoices[answer].npc_id
      );
    }
  }

  private availableChoices(
    npcsAtMap: NPC[],
    currentMap: Mapa
  ): AvailableChoicesType {
    const npcActions: { [key in TipoNPC]: string } = {
      monstro: "Atacar",
      npc_missao: "Pegar missão com",
      mercador: "Negociar com",
    };
    let npcChoices: any = {};

    npcsAtMap.forEach((npc) => {
      let choice: string = `${npcActions[npc.tipo_npc]} ${npc.nome}`;
      npcChoices[choice] = { npc_id: npc.id, choice, tipo_npc: npc.tipo_npc };
    });

    let mapChoices: any = {
      ...(currentMap.mapa_norte &&
        (() => {
          const obj: any = {};
          obj[this.WALK_NORTH] = {
            choice: this.WALK_NORTH,
            mapa_id: currentMap.mapa_norte,
          };
          return obj;
        })()),
      ...(currentMap.mapa_leste &&
        (() => {
          const obj: any = {};
          obj[this.WALK_EAST] = {
            choice: this.WALK_EAST,
            mapa_id: currentMap.mapa_leste,
          };
          return obj;
        })()),
      ...(currentMap.mapa_oeste &&
        (() => {
          const obj: any = {};
          obj[this.WALK_WEST] = {
            choice: this.WALK_EAST,
            mapa_id: currentMap.mapa_oeste,
          };
          return obj;
        })()),
      ...(currentMap.mapa_sul &&
        (() => {
          const obj: any = {};
          obj[this.WALK_SOUTH] = {
            choice: this.WALK_SOUTH,
            mapa_id: currentMap.mapa_sul,
          };
          return obj;
        })()),
    };

    return { mapChoices, npcChoices };
  }
}
