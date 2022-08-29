


import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";

export default class MarketScreen {
  

  private async showMercatorInformations () {
    const merchant = await dbInstance`
      SELECT * FROM npc WHERE id = ${this.merchant_id}
    `;
    
    console.log(merchant)
  }
  private async showItems () {

  }

  private async buyItem() {
    
  }


}
