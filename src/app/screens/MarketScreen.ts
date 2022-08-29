


import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";

export default class MarketScreen {
  constructor(merchant_id: number) {
    this.merchant_id = merchant_id
  }

  private readonly merchant_id

  private async showMercatorInformations () {
    const merchant = await dbInstance`
      SELECT * FROM npc WHERE id = ${this.merchant_id}
    `;

    console.log(merchant)
  }
  private async showItems () {
    const items = await dbInstance`
      SLECT * FROM npc_mercador_itens WHERE id_npc_mercador = ${this.merchant_id}
    `
    console.log(items)

  }
  private async buyItem() {
    
  }


}
