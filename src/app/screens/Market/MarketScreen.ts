import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../../connection/database.js";
import { INFINTE } from "../../util/constants.js";
import ItemListScreen from "./ItemListScreen.js";

export default class MarketScreen {
  constructor(id_personagem: number) {
    this.id_personagem = id_personagem
    this.ItemListScreen = new ItemListScreen(this.id_personagem);
  }
  private id_npc: any
  private readonly id_personagem
  private readonly ItemListScreen: ItemListScreen;

  async handleMarketScreen(id_npc: number): Promise<void> {
    console.clear();
    this.id_npc = id_npc
    await this.showMercatorInformations(id_npc)
    const answer = await inquirer.prompt({
      name: "marketOptions",
      type: "list",
      loop: false,
      pageSize: INFINTE,
      message: "Selecione uma ação.\n",
      choices: [
        'Ver itens', 'Sair da loja'
      ],
    });
    await this.handleChoices(answer.marketOptions);
  }

  private async handleChoices(answer: string) {
    if (answer === 'Sair da loja') {
      return
    }
    if (answer === 'Ver itens') {
      await this.ItemListScreen.handleItemListScreen(this.id_npc)
    }
    
  }

  private async showMercatorInformations (id_npc: number) {
    const merchant = await dbInstance`
      SELECT * FROM npc WHERE id = ${id_npc}
    `;
    const { nome, descricao } = merchant[0]
    console.log(`Mercador ${nome} - ${descricao}\n\n`)
  }
}
