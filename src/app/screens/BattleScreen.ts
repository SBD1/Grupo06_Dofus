import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";
import { Magias } from "../interfaces/magias.js";

export default class BattleScreen {
  private readonly idPersonagem: number;
  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
  }

  async handleBattleScreen(idNPC: number) {
    console.clear();

    const battleStats: {
      dano: number;
      nome_arma: string;
      sorte_total: string;
      vida_maxima: string;
    } = (
      await dbInstance`
      SELECT A.dano, I.nome AS nome_arma, P.sorte_total, P.vida_maxima FROM personagens P 
        JOIN instancia_item J ON P.id_arma = J.id
        JOIN item I ON I.id = J.id_item
        JOIN arma A ON A.id_item = I.id
        WHERE P.id = ${this.idPersonagem}`
    )[0] as any;

    const monsterStats: {
      moedas: number;
      vida_maxima: number;
      dano: number;
      id_item_recompensa: number;
      nome: string;
      descricao: string;
    } = (
      await dbInstance`
    SELECT M.moedas, M.vida_maxima, M.dano, M.id_item_recompensa, N.nome, N.descricao FROM monstro M 
      JOIN npc N ON N.id = M.id_npc_monstro 
      WHERE id_npc_monstro = ${idNPC};
    `
    )[0] as any;

    const skillsStats: Omit<Magias, "id" | "id_classe">[] = await dbInstance`
      SELECT magias.nome, magias.descricao, magias.dano, magias.cura FROM magias 
        INNER JOIN classe ON magias.classe_id = classe.id
        WHERE classe.id = 
        (SELECT id_classe FROM personagens 
        INNER JOIN classe ON personagens.id_classe = classe.id
        WHERE personagens.id = ${this.idPersonagem});`;

    console.log({ battleStats, monsterStats, skillsStats });
  }
}
