import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../../connection/database.js";
import { INFINTE } from "../../util/constants.js";
import ItemDetailsScreen from "./ItemDetailsScreen.js";

export default class ItemListScreen {
  constructor(id_personagem: number) {
    this.id_personagem = id_personagem
    this.ItemDetailsScreen = new ItemDetailsScreen(this.id_personagem);
  }
  private readonly ItemDetailsScreen: ItemDetailsScreen;
  private readonly id_personagem

  async handleItemListScreen(id_npc: number): Promise<void> {
    console.clear();

    const items = await dbInstance`
      SELECT I.id, I.nome, count(I.id) as qnt FROM item I
      INNER JOIN instancia_item J ON I.id = J.id_item
      INNER JOIN npc_mercador_itens M ON M.id_instancia_item = J.id
        INNER JOIN npc P ON p.id = M.id_npc_mercador
      WHERE P.id = ${id_npc}
      GROUP BY I.id
    `
    const answer = await inquirer.prompt({
      name: "itemDetailOptions",
      type: "list",
      loop: false,
      pageSize: INFINTE,
      message: "Selecione o item que deseja visualizar\n",
      choices: [...items.map((item) => item.nome), 'Sair', 'Teste'],
    });
    await this.handleChoices(answer.itemDetailOptions, items);
  }

  private async handleChoices(answer: string, items: any[]) {
    if (answer === 'Sair') {
      return
    }
    if ('Teste' === answer) {
      await this.ItemDetailsScreen.handleItemDetailsScreen(6)
    }
    // items.forEach(async (item) => {
    //   if (item.nome === answer) {
    //     await this.ItemDetailsScreen.handleItemDetailsScreen(item.id)
    //   }
    // })
  }
}



