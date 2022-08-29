


import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";

export default class MarketScreen {
  constructor(id_personagem: number) {
    this.id_personagem = id_personagem
  }

  private readonly id_personagem

  async handleMarketScreen(id_npc: number): Promise<void> {
    console.log(console.log(id_npc))
    this.showMercatorInformations(id_npc)
    this.listItems(id_npc)
  }

  private async showMercatorInformations (id_npc: number) {
    const merchant = await dbInstance`
      SELECT * FROM npc WHERE id = ${id_npc}
    `;
    const { nome, descricao } = merchant[0]
    console.log(`Mercador ${nome} - ${descricao}\n\n`)
  }
  private async listItems (id_npc: number) {
    const items = await dbInstance`
      SELECT * FROM npc_mercador_itens WHERE id_npc_mercador = ${id_npc}
    `
    console.log('Items disponíveis: \n')
    console.log(items)
    console.log('\n')
  }
  private async buyItem() {
    
  }

}
