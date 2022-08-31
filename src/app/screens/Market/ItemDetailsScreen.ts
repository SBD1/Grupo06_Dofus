import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../../connection/database.js";
import { INFINTE } from "../../util/constants.js";

export default class ItemDatailScreen {
  constructor(id_personagem: number) {
    this.id_personagem = id_personagem
  }
  private readonly id_personagem

  async handleItemDetailsScreen(id_item: number): Promise<void> {
    console.clear();
    await this.showItemDetails(id_item)
    const answer = await inquirer.prompt({
        name: "marktScreen",
        type: "list",
        loop: false,
        pageSize: INFINTE,
        message: "Selecione o item que deseja visualizar\n",
        choices: ['comprar', 'voltar', 'sair'],
      });

    await this.handleChoices(answer);
  }

  private async handleChoices(answer: string) {
    if (answer === 'Sair') {
      return
    }
  }

  private async showItemDetails(item_id: number) {
    const item = await dbInstance`SELECT * FROM item WHERE id = ${item_id}`
    console.log(item)
  }

  private async buyItem(item_id: number) {

  }
}



