import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";
import { NPC } from "../interfaces/npc.js";
import { Quest } from "../interfaces/quest.js";
import PressToContinuePrompt, {
  KeyDescriptor,
} from "inquirer-press-to-continue";
import { Item } from "../interfaces/item.js";
import { Choices } from "../util/constants.js";
inquirer.registerPrompt("press-to-continue", PressToContinuePrompt);

export class QuestScreen {
  private readonly idPersonagem: number;

  constructor(idPersonagem: number) {
    this.idPersonagem = idPersonagem;
  }

  public async handleQuestScreen(id_npc: NPC["id"]) {
    console.clear();
    console.log();
    console.log();

    const npc: NPC = (
      await dbInstance`SELECT * FROM npc WHERE id = ${id_npc}`
    )[0] as any;

    let currentQuest: Quest = (
      await dbInstance`
    SELECT * FROM missao WHERE id_npc_missao = ${id_npc} AND id = (
      SELECT M.id_missao_desbloqueada FROM personagens P 
       LEFT JOIN missao M ON M.id = P.id_ultima_missao
      WHERE P.id = ${this.idPersonagem}
    );`
    )[0] as any;

    console.log(npc.nome);
    console.log();
    console.log(npc.descricao);
    console.log();
    if (!currentQuest?.id) {
      const firstQuest = (
        await dbInstance`SELECT id_ultima_missao FROM personagens WHERE id = ${this.idPersonagem}`
      )[0] as any;

      if (!firstQuest.id_ultima_missao) {
        currentQuest = (
          await dbInstance`
        SELECT * FROM missao WHERE id_npc_missao = ${id_npc} AND id = 1;`
        )[0] as any;
      } else {
        console.log("Você já terminou todas as missões.");
        console.log();

        await inquirer.prompt<{ key: KeyDescriptor }>({
          name: "key",
          type: "press-to-continue",
          anyKey: true,
          pressToContinueMessage: "Pressione qualquer tecla para continuar...",
        } as any);

        return;
      }
    }

    const rewardItem: Item = (
      await dbInstance`SELECT nome FROM item WHERE id = ${currentQuest.id_item_recompensa}`
    )[0] as any;

    console.clear();
    console.log();
    console.log();
    console.log("Descrição da missão:");
    console.log(currentQuest.descricao);
    console.log(
      `Recompensa da missão: ${currentQuest.moedas} moedas e x1 ${rewardItem?.nome}`
    );

    console.log();

    const answer = await inquirer.prompt({
      name: "questScreen",
      type: "list",
      loop: false,
      pageSize: 2,
      message: "Selecione uma ação.\n",
      choices: ["Já consegui o item", Choices.RETURN],
    });

    if (answer.questScreen === Choices.RETURN) return;

    const hasItem: { id?: number } = (
      await dbInstance`
      SELECT I.id FROM instancia_item I
        LEFT JOIN mochila M ON M.id_instancia_item = I.id 
      WHERE I.id_item = ${currentQuest.id_item_missao} AND M.id_personagem = ${this.idPersonagem} LIMIT 1;`
    )[0] as any;

    if (!hasItem?.id) {
      console.clear();
      console.log();
      console.log(
        chalk.red("Você não tem o item necessário para completar a missão")
      );
      console.log();

      await inquirer.prompt<{ key: KeyDescriptor }>({
        name: "key",
        type: "press-to-continue",
        anyKey: true,
        pressToContinueMessage: "Pressione qualquer tecla para continuar...",
      } as any);

      return;
    }

    await dbInstance.unsafe(`
    START TRANSACTION ISOLATION LEVEL REPEATABLE READ;
    DO
    $$
      DECLARE
        _id_instancia_item INTEGER;
      BEGIN
        INSERT INTO instancia_item (id_item) VALUES (${currentQuest.id_item_recompensa});
        SELECT currval(pg_get_serial_sequence('instancia_item','id')) INTO _id_instancia_item;
        INSERT INTO mochila (id_personagem, id_instancia_item) VALUES (${this.idPersonagem}, _id_instancia_item);
        
        UPDATE personagens SET moedas = moedas + ${currentQuest.moedas};
        UPDATE personagens SET id_ultima_missao = ${currentQuest.id};

        DELETE FROM mochila WHERE id_instancia_item = ${hasItem.id} AND id_personagem = ${this.idPersonagem};
        DELETE FROM instancia_item WHERE id = ${hasItem.id};
      END;  
    $$;
    COMMIT;
    `);

    console.clear();

    console.log();
    console.log();
    await inquirer.prompt<{ key: KeyDescriptor }>({
      name: "key",
      type: "press-to-continue",
      anyKey: true,
      pressToContinueMessage: `Missão concluida, você recebeu ${currentQuest.moedas} moedas e x1 ${rewardItem?.nome}. \nPressione qualquer tecla para continuar...`,
    } as any);
  }
}
