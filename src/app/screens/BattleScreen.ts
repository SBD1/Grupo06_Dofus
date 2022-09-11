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
    nome_item_recompensa?: string;
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

  public async handleBattleScreen(idNPC: number): Promise<void> {
    const battleStats: BattleInfoType["battleStats"] = (
      await dbInstance`
      SELECT A.dano, I.nome AS nome_arma, P.sorte_total, P.vida_maxima FROM personagens P 
        LEFT JOIN instancia_item J ON P.id_arma = J.id
        LEFT JOIN item I ON I.id = J.id_item
        LEFT JOIN arma A ON A.id_item = I.id
        WHERE P.id = ${this.idPersonagem};`
    )[0] as any;

    const monsterStats: BattleInfoType["monsterStats"] = (
      await dbInstance`
      SELECT M.moedas, M.vida_maxima, M.dano, M.id_item_recompensa, N.nome, N.descricao, I.nome as nome_item_recompensa FROM monstro M 
      JOIN npc N ON N.id = M.id_npc_monstro 
      LEFT JOIN item I ON i.id = M.id_item_recompensa
      WHERE id_npc_monstro = ${idNPC};
    `
    )[0] as any;

    const skills: BattleInfoType["skills"] = await dbInstance`
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
      let drops: string = `Você recebeu ${monsterStats.moedas} moedas `;
      monsterStats.nome_item_recompensa
        ? (drops += `e x1 ${monsterStats.nome_item_recompensa}`)
        : null;

      console.log(drops);

      if (monsterStats?.id_item_recompensa) {
        await dbInstance.unsafe(`
        START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
        DO
        $$
          DECLARE
            id_instancia_item INTEGER;
          BEGIN
            INSERT INTO instancia_item (id_item) VALUES (${monsterStats.id_item_recompensa});
            SELECT currval(pg_get_serial_sequence('instancia_item','id')) INTO id_instancia_item;
            INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, id_instancia_item);
            UPDATE personagens SET moedas = moedas + ${monsterStats.moedas};
          END;  
        $$;
        COMMIT;
        `);
      } else {
        await dbInstance`
          UPDATE personagens SET moedas = moedas + ${monsterStats.moedas};
        `;
      }

      battleInfo.battleOver = true;
    } else if (battleInfo.currentHp <= 0) {
      battleInfo.battleOver = true;

      await dbInstance.unsafe(`
        START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
          DELETE FROM mochila WHERE id_personagem = ${this.idPersonagem};
          UPDATE personagens SET id_mapa = 1 WHERE id = ${this.idPersonagem};
          UPDATE personagens SET moedas = 0  WHERE id = ${this.idPersonagem};
        COMMIT;
        `);

      console.clear();
      console.log();
      console.log();
      console.log("Você morreu! Você perde todas suas moedas e itens.");
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
