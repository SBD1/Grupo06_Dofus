


import chalk from "chalk";
import inquirer from "inquirer";
import gradient from "gradient-string";
import chalkAnimation from "chalk-animation";
import figlet from "figlet";
import dbInstance from "../connection/database.js";

export default class InventoryScreen {
  constructor(id_personagem: number) {
    this.id_personagem = id_personagem
  }

  private readonly id_personagem

  async handleInventoryScreen(): Promise<void> {
    console.log('meu inventário')
    this.listBackpackItems()
  }

  private async listBackpackItems () {
    const items = await dbInstance`
      SELECT * FROM mochila WHERE id_personagem = ${this.id_personagem}
    `
    console.log('Items Mochila: \n')
    console.log(items)
    console.log('\n')
  }
}
