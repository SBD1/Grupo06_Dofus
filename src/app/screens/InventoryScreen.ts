


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
        SELECT I.id, I.nome, I.tipo_item, I.descricao, I.valor_moedas, count(I.id) as qnt FROM item I
        INNER JOIN instancia_item J ON I.id = J.id_item
        INNER JOIN mochila M ON M.id_instancia_item = J.id
        INNER JOIN personagens P ON p.id = M.id_personagem
        WHERE P.id = ${this.id_personagem} 
        GROUP BY I.id
    `
    console.log('Items Mochila: \n')
    items.forEach((item, index) => {
        console.log(`Nome: ${item.nome}`)
        console.log(`Descrição: ${item.descricao}`)
        console.log(`Tipo: ${item.tipo}`)
        console.log(`Quantidade: ${item.qnt}`)
        console.log(`Valor: ${item.valor}\n`)
    })
    console.log('\n')
  }
}
