import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";
import { Magias } from "../interfaces/magias.js";
import { INFINTE } from "../util/constants.js";
import PressToContinuePrompt, {
  KeyDescriptor,
} from "inquirer-press-to-continue";
inquirer.registerPrompt("press-to-continue", PressToContinuePrompt);

type BattleInfoType = {
  battleStats: {
    dano: number;
    nome_arma: string;
    sorte_total: number;
    vida_maxima: number;
  };
  monsterStats: {
    moedas: number;
    vida_maxima: number;
    dano: number;
    id_item_recompensa: number;
    nome: string;
    descricao: string;
  };
  skills: Omit<Magias, "id" | "id_classe">[];
  battleOver: boolean;
  currentHp: number;
  currentMonsterHp: number;
};

export default class BattleScreen {
  private readonly idPersonagem: number;
  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
  }

  async handleBattleScreen(idNPC: number): Promise<void> {
    const battleStats: {
      dano: number;
      nome_arma: string;
      sorte_total: number;
      vida_maxima: number;
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
      SELECT M.moedas, M.vida_maxima, M.dano, M.id_item_recompensa, N.nome, N.descricao, I.nome as nome_item FROM monstro M 
      JOIN npc N ON N.id = M.id_npc_monstro 
      JOIN item I ON i.id = M.id_item_recompensa
      WHERE id_npc_monstro = ${idNPC};
    `
    )[0] as any;

    const skills: Omit<Magias, "id" | "id_classe">[] = await dbInstance`
      SELECT magias.nome, magias.descricao, magias.dano, magias.cura FROM magias 
        INNER JOIN classe ON magias.classe_id = classe.id
        WHERE classe.id = 
        (SELECT id_classe FROM personagens 
        INNER JOIN classe ON personagens.id_classe = classe.id
        WHERE personagens.id = ${this.idPersonagem});`;

    const battleInfo: BattleInfoType = {
      battleStats,
      monsterStats,
      skills,
      currentHp: battleStats.vida_maxima,
      currentMonsterHp: monsterStats.vida_maxima,
      battleOver: false,
    };

    while (!battleInfo.battleOver) {
      await this.battleTurn(battleInfo);
    }
  }

  private async battleTurn(battleInfo: BattleInfoType): Promise<void> {
    console.clear();
    console.log();
    const { battleStats, skills, monsterStats } = battleInfo;

    console.log(
      chalk.red(
        `Vida de ${monsterStats.nome}: ${battleInfo.currentMonsterHp} / ${monsterStats.vida_maxima}`
      )
    );
    console.log(chalk.red(monsterStats.descricao));
    console.log();

    console.log(
      chalk.green(
        `Sua vida: ${battleInfo.currentHp} / ${battleStats.vida_maxima}`
      )
    );
    console.log();
    console.log();

    const answer = await inquirer.prompt({
      name: "battleScreen",
      type: "list",
      loop: false,
      message: "Escolha uma magia.\n",
      choices: [...skills.map((skill) => skill.nome)],
    });

    console.log();
    console.log();
    console.log();

    skills.forEach((skill) => {
      if (answer.battleScreen === skill.nome) {
        let damage = skill.dano + battleStats.sorte_total + battleStats.dano;
        let heal = skill.cura + battleStats.sorte_total;
        battleInfo.currentHp += heal;
        battleInfo.currentMonsterHp -= damage;

        if (battleInfo.currentHp > battleStats.vida_maxima) {
          battleInfo.currentHp = battleStats.vida_maxima;
        }

        console.log(`Você lança ${skill.nome}. ${skill.descricao}`);
        console.log(`Dano: ${damage}   Cura: ${heal}`);
        console.log(
          "---------------------------------------------------------------------------------------------------"
        );

        battleInfo.currentHp -= monsterStats.dano;

        console.log(
          `${monsterStats.nome} te ataca, causando ${monsterStats.dano} de dano.`
        );
      }
    });

    if (battleInfo.currentMonsterHp <= 0) {
      console.clear();
      console.log();
      console.log(`Você matou ${monsterStats.nome}`);
      console.log(
        `Você recebeu ${monsterStats.moedas} moedas e x1 ${monsterStats.id_item_recompensa}`
      );
      battleInfo.battleOver = true;
    } else if (battleInfo.currentHp <= 0) {
      console.clear;
      console.log("Você morreu! Você perde todos seus itens e moedas.");

      battleInfo.battleOver = true;
    }
    console.log();
    console.log();

    await inquirer.prompt<{ key: KeyDescriptor }>({
      name: "key",
      type: "press-to-continue",
      anyKey: true,
      pressToContinueMessage: "Pressione qualquer tecla para continuar...",
    } as any);
  }
}
